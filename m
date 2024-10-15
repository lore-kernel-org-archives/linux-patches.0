Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FDD1D5ABD;
	Tue, 15 Oct 2024 13:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997909; cv=none; b=iuuJAi+V1q4GAcr/uhIhsvTD0PSn4HkmNUdDVT3n3Y3dVIG6hDPMwAw0MvLqjFrq/ZFi7pSehxc3jRWWxkB3b/ovAf7lLmja1Hj8+r81XseefrXdBYh5cyT/mtHVnNud+n88mYBUSCZT61ld0cFlr2RFNAZHoe/I1dKSAiidnXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997909; c=relaxed/simple;
	bh=tvxpft84pT8W9DyZOcZJ/5LIHoXSH5+eFF8R5f/r/80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9z4/LINxiJwZIGxQetFoBzy22JoWPk1qqcG2pvvs32sA2Gvii+fdSbtNbbeymwUGjQRyvohw9s8DuGbnFp4OaXladoi+W1Tbgq9SYJybrX3vaSizyB1S3g89tz6P8+JKaLKUD4uJGJAYGKqU3i8PyyNZsRHxCPLtC8QsT9rUcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmk1D53C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmk1D53C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5C9C4CEC6;
	Tue, 15 Oct 2024 13:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997909;
	bh=tvxpft84pT8W9DyZOcZJ/5LIHoXSH5+eFF8R5f/r/80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmk1D53CQeGpIMo+PuruyFJ5McOwza0dnTevk/q6JCJZffPc94iCtmmfRcerOkoMJ
	 8/rHMJ8A4aDtAQAOZjsYfWHU+9KdSVKhOpkwRJZgQhSc/PU34ctixBkwjI3lHH0nxV
	 1ExRYI1Jmo/NIb9G6fn7BTaIoB3GF1pLZnJNAX5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 323/518] ALSA: hdsp: Break infinite MIDI input flush loop
Date: Tue, 15 Oct 2024 14:43:47 +0200
Message-ID: <20241015123929.446172755@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9543474245004..f592eb7a5d1be 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -1303,8 +1303,10 @@ static int snd_hdsp_midi_output_possible (struct hdsp *hdsp, int id)
 
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
index 51c3c6a08a1c5..04f9d92af46c1 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -1839,8 +1839,10 @@ static inline int snd_hdspm_midi_output_possible (struct hdspm *hdspm, int id)
 
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



