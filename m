Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070F92E8E0B;
	Tue, 15 Jul 2025 13:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587535; cv=none; b=ShGE1kO8cIZOClK9Ou85ymj5ylioCtJX5CUrHSBN2227AAvcubaAbaHQxfgxcmtXmEnwImO8Rkh+ZjGa/38vezvc7F8VrSWto7e+oWKVtrwU9SY468X1w8BUuaJBagSTznijUgN6p6J3oxi83aPKVUzXeY39UB2Qx5a/kDRxDd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587535; c=relaxed/simple;
	bh=74qlOFxB3G4g7ixtqmdP+BRZ1O76eDmcfm/kCt0Lz8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxM9aBJarnxAmL35EzsG6hzv/XAqzGC0Ho1+QOtpiR3LOhNdX+rHmnjYg7nefp8RyzhfaTWJrUk4dGubnCG7MmM2xG5Bwz6T8x8X3IO8GQUVkZwUACvkAhCoahQgz1M4I3UXnYcP/yyBYqGoB0v7YqgZtC0pIVMTSW5DgSsG6OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfyS0LRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfyS0LRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D143C4CEE3;
	Tue, 15 Jul 2025 13:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587534;
	bh=74qlOFxB3G4g7ixtqmdP+BRZ1O76eDmcfm/kCt0Lz8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfyS0LREyUrjmTWsLXWOTYmOlys2i0SXMDoVVsHGxQQijtn4h6yCcnxpj3cyrm058
	 wfTY0oq+R8BWuOrbfLvIV128S9UeBCdVCnNBUGGKcF1lEuxUf+QLhj18BBFdsTumiI
	 1MdNUyouWF7wiDT/5fcyqNXRlyuBcwanl/9NVMz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngjun Lee <yjjuny.lee@samsung.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/208] ALSA: usb-audio: Fix out-of-bounds read in snd_usb_get_audioformat_uac3()
Date: Tue, 15 Jul 2025 15:12:37 +0200
Message-ID: <20250715130812.879260982@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0c77f244e5d66..d6d3ce9e96373 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -983,6 +983,8 @@ snd_usb_get_audioformat_uac3(struct snd_usb_audio *chip,
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



