Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039D5183CB8;
	Tue,  8 Oct 2024 12:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391653; cv=none; b=cnvWUPI9EDxRneQwzROQk9qpTWxkrJZSt/aV5gOIi8xiTBYBptHUh90AXCfC9XFdgCGyKozseufjiZWej3lbZk/FLgjAJ14U0wOB6IdIsmeab8OSOtfLHaXovwSGNHUssjI3SSi3vIANAsRXqOl1KhCDDnedOjGdG1TthadFKcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391653; c=relaxed/simple;
	bh=mQbgBMbYAWFIVABc6JkLAIBqopHHEcRBiFSIhplp+5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olxVz0sg0wxxOwwZpwuAehb6iQc97bAfU4WvI9CWBuKCuKqPgA9sJEolT7OPG7n14k2AcnJXy+TMM1wKcDpRFzfnUI03q93farQ9itTxO+s2jtQaoeR3e/AXk+QmjeI3qq6XgkdlvzgD8FiSGpU2WTlmj6edBfk7aiYCPy9SH1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzp20hQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzp20hQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60155C4CEC7;
	Tue,  8 Oct 2024 12:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391652;
	bh=mQbgBMbYAWFIVABc6JkLAIBqopHHEcRBiFSIhplp+5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzp20hQzSNob8sfvu9LNrCAN96x2Ge/InAbHstqfhtAclOwxl2LbxyJjtf4l0Dt0L
	 P/uu0cKPuhjSIrzB+qgMns2Kg0+owQ4gbSkDCltFkLD0asyT33FzpJ5WDJN/11Te5h
	 WRF1eNXlnbF4ByOIfrUNhX9x8eFvXX3legQFvZR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 183/558] ALSA: hdsp: Break infinite MIDI input flush loop
Date: Tue,  8 Oct 2024 14:03:33 +0200
Message-ID: <20241008115709.554753519@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c01f3815453e2d5f699ccd8c8c1f93a5b8669e59 ]

The current MIDI input flush on HDSP and HDSPM drivers relies on the
hardware reporting the right value.  If the hardware doesn't give the
proper value but returns -1, it may be stuck at an infinite loop.

Add a counter and break if the loop is unexpectedly too long.

Link: https://patch.msgid.link/20240808091513.31380-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/rme9652/hdsp.c  | 6 ++++--
 sound/pci/rme9652/hdspm.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index e7d1b43471a29..713ca262a0e97 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -1298,8 +1298,10 @@ static int snd_hdsp_midi_output_possible (struct hdsp *hdsp, int id)
 
 static void snd_hdsp_flush_midi_input (struct hdsp *hdsp, int id)
 {
-	while (snd_hdsp_midi_input_available (hdsp, id))
-		snd_hdsp_midi_read_byte (hdsp, id);
+	int count = 256;
+
+	while (snd_hdsp_midi_input_available(hdsp, id) && --count)
+		snd_hdsp_midi_read_byte(hdsp, id);
 }
 
 static int snd_hdsp_midi_output_write (struct hdsp_midi *hmidi)
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 267c7848974ae..74215f57f4fc9 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -1838,8 +1838,10 @@ static inline int snd_hdspm_midi_output_possible (struct hdspm *hdspm, int id)
 
 static void snd_hdspm_flush_midi_input(struct hdspm *hdspm, int id)
 {
-	while (snd_hdspm_midi_input_available (hdspm, id))
-		snd_hdspm_midi_read_byte (hdspm, id);
+	int count = 256;
+
+	while (snd_hdspm_midi_input_available(hdspm, id) && --count)
+		snd_hdspm_midi_read_byte(hdspm, id);
 }
 
 static int snd_hdspm_midi_output_write (struct hdspm_midi *hmidi)
-- 
2.43.0



