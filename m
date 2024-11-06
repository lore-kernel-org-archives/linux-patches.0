Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F36E1E1A25;
	Wed,  6 Nov 2024 13:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898379; cv=none; b=J4D7S6z7DZzBApgTSbj8TpXXHmCfSogsgA0wNIt7ZEzVWtGwR2bNsicYibmsCUVNDocOB1iOTEIJ2Wket8gWMyVD+dxzXruPGKjxx8nHQ6N8BIxTTx3FeXX1OuaBl77tqYxzBGo2hQvcy0knm22zXPbSlLGhVZe9DKNUZxCMK4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898379; c=relaxed/simple;
	bh=MDKdxhE3wbSpKLu/IsQnZVQptUM6cdhlStcbXyWTp7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiqcgtEV4xwFeuLSggu7bduMXfrN9a3zgcD7JKSwwCinXbMATQJxw1wyRsN50kd391JZsyk8CSEW3O6R6OTN91NGDnelz05iRVNF9skcz1p5gphraAvvHZNbza3UxkkmqJDymVCG+aZdVIIbRE8esEawTxPYHyUZIAkGn+VEYwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4UJYt9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4UJYt9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78680C4CECD;
	Wed,  6 Nov 2024 13:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898378;
	bh=MDKdxhE3wbSpKLu/IsQnZVQptUM6cdhlStcbXyWTp7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4UJYt9/SwLFhTzxY8z++3fr92NWdP5fjzNLe9EXZt3YC55vrKjYVcrBOtuSbEQPD
	 d3AJVlEcko2dXXw/nh4nRZaDCVZGB04pv71SZYb4Seo4ddF/j33SreroijPU2KsrgC
	 3CTRJZKrGGb9Q892Hh90nQ6mA49RNpDw9RoA7NX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 217/462] ALSA: hdsp: Break infinite MIDI input flush loop
Date: Wed,  6 Nov 2024 13:01:50 +0100
Message-ID: <20241106120336.880401924@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c7b3e76ea2d26..87ada0c01f84d 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -1308,8 +1308,10 @@ static int snd_hdsp_midi_output_possible (struct hdsp *hdsp, int id)
 
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
index e34f07c9ff470..f5c7a214e17bc 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -1835,8 +1835,10 @@ static inline int snd_hdspm_midi_output_possible (struct hdspm *hdspm, int id)
 
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



