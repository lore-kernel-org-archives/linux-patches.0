Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FB91B85CD;
	Mon, 14 Oct 2024 15:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919024; cv=none; b=QlEfN7BvXkeo/ae7ToijJ/hEX2alB3S1BoFqBVE8GMxJAdSrWY+1f7JCzmUrAykszwHYeQ+1xHFOnDFfTjJasEBwDaqGjsLsaJACLwAndJzxn0ReiWwkp6jnYEZPh08thgnJYzWb2ljWCJNBZyL3PMOa2/795Sa6RoRBF3i16kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919024; c=relaxed/simple;
	bh=oEGoIeYIjqVmLAwElNoceQ76iH+kMGMhkGWj5VK8Q2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMqr+pJHitfVLd+k5glEAL/ugkDXbWm4/xOJYVMFpmvSZshZjtzORYXYqgns0jUUTtT03c+y4ipqjKBSX2bJ6UWmk3n2vw1d6lLg7DtttbzH04wrrxgc6+WARTYU2A0/S7Pbog18KoakRAso3CmnrRjBVWsgKgtqFU6TsVHGmLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dqx5iAYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dqx5iAYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE20DC4CEC3;
	Mon, 14 Oct 2024 15:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919024;
	bh=oEGoIeYIjqVmLAwElNoceQ76iH+kMGMhkGWj5VK8Q2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dqx5iAYu6yw6LVh5yaO1tR2Zsezw1bCdEsQpiu5a1sdP8WRlidKw67/EZObA96FXC
	 cPGtzziqbz/berJw2swP3SrSKernfIRA1r/CzwHUaAfV2GjCwDfWIyhsbjNakj5W7/
	 DOfS6vHMxz9mOtbiDdHBisrke9JsxwS1fNsroFww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 463/798] ALSA: hdsp: Break infinite MIDI input flush loop
Date: Mon, 14 Oct 2024 16:16:57 +0200
Message-ID: <20241014141236.167052307@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 65add92c88aa6..cd7bf4d7ca082 100644
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
index fa1812e7a49dc..247f5c52fb090 100644
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



