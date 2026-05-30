Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4E72690D5;
	Sat, 30 May 2026 17:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160440; cv=none; b=loJ8Uq8sZ8GNE9d+T117QOW0+W1ZsxGQXGBDa+OVwktPHuioh9K4KwOdS+KFzReqNZrRAFws+DwDfy0FTRRIHhjL4uT5Qm82KIcDPbNcPz2etpcomXDUocutSWYojzkm80ffcMrsxuHbKhcfKhLI4lMio1NC57U+TX1cxP9i//Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160440; c=relaxed/simple;
	bh=wp7bdUiFS6nYoGb76N6WBuH7ZME1E0d8XPNOWoRnM9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LG5r2vG3LzJJD3mGpilrSEDjsyzOLeJ1QmkEXULiC2lj2DKV3kGbIIDvbkSa77hh7IeYFdcar+G///QY/ztcIxtv26Wnv55XFRCwCK9GppuosAzwfyRh3FtahKdUjTQvNHvmWoLTbPDve6Tz98OUAVisEj5kUEXebpETRJ+Pzfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDN6/CUN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDN6/CUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784871F00893;
	Sat, 30 May 2026 17:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160439;
	bh=quMG6SxYZyzQKTBAGimLw8Ifyu2Ga7CjbfoihZ0QglU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDN6/CUNBDxH0oAM+L+Rk8t2pClXcSlKWwxskNP8ZNDZah8Tp7ZC972G8qhSPdP8H
	 v2GzP1Isk68Wmrlub38Gz5wrfvL663DhIK1P8Xt5ITsT9Sejb3nIGa/imd72SKEm3c
	 j4K/0XPu0l385hGjADNepzFPatHBIWkhHxdB25KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 308/969] ALSA: usb-audio: Fix UAC3 cluster descriptor size check
Date: Sat, 30 May 2026 17:57:12 +0200
Message-ID: <20260530160308.930480735@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 26265dd69da32d88a88d21987853cec899d9e21f upstream.

The UAC3 cluster descriptor length check in
snd_usb_get_audioformat_uac3()was added to
make sure that the buffer is large enough for
a struct uac3_cluster_header_descriptor before the
returned data is cast and used.

However, the check uses sizeof(cluster), where cluster
is a pointer, not the size of the descriptor header.
This makes the validation depend on the architecture
pointer size and does not match the intended object size.

Check against sizeof(*cluster) instead.

Fixes: fb4e2a6e8f28 ("ALSA: usb-audio: Fix out-of-bounds read in snd_usb_get_audioformat_uac3()")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260424-alsa-usb-uac3-cluster-size-v1-1-99a5808898a3@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/stream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -993,7 +993,7 @@ snd_usb_get_audioformat_uac3(struct snd_
 	 * and request Cluster Descriptor
 	 */
 	wLength = le16_to_cpu(hc_header.wLength);
-	if (wLength < sizeof(cluster))
+	if (wLength < sizeof(*cluster))
 		return NULL;
 	cluster = kzalloc(wLength, GFP_KERNEL);
 	if (!cluster)


