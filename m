Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC19538759A;
	Tue, 10 Mar 2026 11:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141916; cv=none; b=aXlmEeArhoOp88FsErnGO7AHItX2BuOTT/KR7zVmDu5Hq4DZ2bCrj3atOrdaxFsZ4wuKlziWA9+LI5o9ewekuX7WbZHsJYNbbNIapNP7L5VlOD8I5M5HwLM/R6mstOjSW6kAUX0/x5djblfC99RjjZxl7t3UvyFMIKcL7v0Fs2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141916; c=relaxed/simple;
	bh=bOeFJNsdHbF8fvLvjsUwo0tBKOUO+JEoCLyN5h9ZEv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLU7ENn8jfgDP0bTusj5LPYVoPK76Mnp2A9vAeEs3PiGR7mFCjxrTQlNyCqdv6wj3Mt2E452hjwmRs90TIh0Bs2S22n9/PTZlwZjgqkz0HltjSHyUVOcE/25Xk+UpmaxBEV8ESf6KyQftBbk+YQmqwgfg0PwI/qAsOPH3Mwviuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=POQxDmld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="POQxDmld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4759CC2BC86;
	Tue, 10 Mar 2026 11:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141916;
	bh=bOeFJNsdHbF8fvLvjsUwo0tBKOUO+JEoCLyN5h9ZEv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POQxDmldTqJ8IViZRN2RxSKmR9ebxYiUW/fCTq2UJnov0PUwBub18PK9oqUb6wJy9
	 GUNs2Y6hXtP9J3WpACDn+BZZHg1rXQCNv9nfXMU6jbIzML8LlFMHP50DK9l8HPoYdJ
	 ANv/RK0UvW3axY4RTP/rF3KnDOWhdodX4iqwYnZxgcnq2v8cZK3D3Fq344/SSM/T4v
	 9Z6USAfQyUsJvFmZJYFvs8WwaTbFlIT+rFPcB8CPKrQCMahFv5L6dC1wdb/6DwV86l
	 +6xbApvVgtkfHPubsQsDo1qryyeG+RAi2bm5qUEx59Wzse6bMs+7OUS79KsAntPKne
	 lv5r5rCmZ6Z/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 040/314] ALSA: usb-audio: Cap the packet size pre-calculations
Date: Tue, 10 Mar 2026 07:14:59 -0400
Message-ID: <8908beca8b2e6a75ad1bcfc46d59777e6ae4e626.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7fe8dec3f628e9779f1631576f8e693370050348 ]

We calculate the possible packet sizes beforehand for adaptive and
synchronous endpoints, but we didn't take care of the max frame size
for those pre-calculated values.  When a device or a bus limits the
packet size, a high sample rate or a high number of channels may lead
to the packet sizes that are larger than the given limit, which
results in an error from the USB core at submitting URBs.

As a simple workaround, just add the sanity checks of pre-calculated
packet sizes to have the upper boundary of ep->maxframesize.

Fixes: f0bd62b64016 ("ALSA: usb-audio: Improve frames size computation")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221076
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260225085233.316306-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 3ac1fbec6327e..173edce027d7b 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1374,6 +1374,9 @@ int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
 		return -EINVAL;
 	}
 
+	ep->packsize[0] = min(ep->packsize[0], ep->maxframesize);
+	ep->packsize[1] = min(ep->packsize[1], ep->maxframesize);
+
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;
 	ep->freqshift = INT_MIN;
-- 
2.51.0

