Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DFD2E041E;
	Tue, 15 Jul 2025 13:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586446; cv=none; b=s1qOdpmK10gPmAEzia3v1jfm2dg2OJ6oTfT84pSIWXhwnM1/Qin3mrAgqaPJ3HCB3eKJ4KpAPGd6xj+jb4bcSMPYTdlGOmb4nj1X1GzUh7JJcc0hYk5sWMHFv/OHa9COBlaXaxnfehe5oaWxk74s34aVtKkViy8t9gTpciDDRYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586446; c=relaxed/simple;
	bh=DQrYxRDIBfTNDkapwrswo7zl8TFrRiRX0slQ1cn9MEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTafz4uL94B93KgndMUDiFUqQ/doB5xQZcJUq4mxT3soWFJTS6xYH/DNcqr3ZMBYbDxkXhsMsKNjdtngqw8gVrZSHOMGC33xLTX7ZVsjhZLvVfYRo2kRWQNv3oAsquzRE7dtzcP6mQjouRih0BnMT/NObc8G40OpNK2e2WsOEG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1J7Omy30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1J7Omy30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E9EC4CEE3;
	Tue, 15 Jul 2025 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586446;
	bh=DQrYxRDIBfTNDkapwrswo7zl8TFrRiRX0slQ1cn9MEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1J7Omy30ziHnQ07M/ILLRDKR3imQ6Qj3WXHiE6ID0DKtGE6++NbQK89WYBngt2eTb
	 Af500Lj1bkjcGal4CGwOnYrEc7DRm5QdUAl9/CWVxEerA7y+AcAKes1uPO1MrR+9ff
	 rbS7jAwiop0aO5y4TginPNSoNEQwSJ+yoQUAgWyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngjun Lee <yjjuny.lee@samsung.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/148] ALSA: usb-audio: Fix out-of-bounds read in snd_usb_get_audioformat_uac3()
Date: Tue, 15 Jul 2025 15:12:39 +0200
Message-ID: <20250715130801.799865829@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Youngjun Lee <yjjuny.lee@samsung.com>

[ Upstream commit fb4e2a6e8f28a3c0ad382e363aeb9cd822007b8a ]

In snd_usb_get_audioformat_uac3(), the length value returned from
snd_usb_ctl_msg() is used directly for memory allocation without
validation. This length is controlled by the USB device.

The allocated buffer is cast to a uac3_cluster_header_descriptor
and its fields are accessed without verifying that the buffer
is large enough. If the device returns a smaller than expected
length, this leads to an out-of-bounds read.

Add a length check to ensure the buffer is large enough for
uac3_cluster_header_descriptor.

Signed-off-by: Youngjun Lee <yjjuny.lee@samsung.com>
Fixes: 9a2fe9b801f5 ("ALSA: usb: initial USB Audio Device Class 3.0 support")
Link: https://patch.msgid.link/20250623-uac3-oob-fix-v1-1-527303eaf40a@samsung.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/stream.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 1c4ff57993240..d698b609fe524 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -979,6 +979,8 @@ snd_usb_get_audioformat_uac3(struct snd_usb_audio *chip,
 	 * and request Cluster Descriptor
 	 */
 	wLength = le16_to_cpu(hc_header.wLength);
+	if (wLength < sizeof(cluster))
+		return NULL;
 	cluster = kzalloc(wLength, GFP_KERNEL);
 	if (!cluster)
 		return ERR_PTR(-ENOMEM);
-- 
2.39.5



