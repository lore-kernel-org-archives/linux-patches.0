Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB9C3FBB46;
	Fri, 15 May 2026 16:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861101; cv=none; b=iq1twV52OlWsnIOLl/bagGIFXwrQrY+xC8Y1+tO1y6NGHnYkuhQ5Brg/F39o02CGmjd5Fotjnk3lKybhkT8KiuTqioIjL1LyQY0kC/iAebwZbXLmWgT/evalsLFszearaluOj3G1e76BHeD6fWuFVD5njGEt6ZwjS7dQIdHZe0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861101; c=relaxed/simple;
	bh=FOcCGAl/PChcoXZOZmfbL+EQ+l/K3Q8VbIN9V3f6eLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H/CU+8aY5503UbUpBgPn1VnyeCxOtGb+q27HXoH7WLTZoACE0WKzMfPm5EdCZUqyv2e56BsEdoGlsnMX97EylbLMnGfJq/yyXIzUE3mArAOkmgXGNo3aM2VGk7CMRSxVxUIMAXnc9wDXTgJ9yBbVYjIP/LBqf4IvmdBhEsiy5wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xv0snRJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xv0snRJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21402C2BCB3;
	Fri, 15 May 2026 16:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861101;
	bh=FOcCGAl/PChcoXZOZmfbL+EQ+l/K3Q8VbIN9V3f6eLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xv0snRJd0+kfwhoL2Hihl0VyuMXiy2cCP1+J2RXJ11g7iHVBOMjZfO/W9E0AsX9hT
	 a54F9wvafh2ixvYKrL3fXquUg+3CBLLW8Rj4jyiUyk5RNAcT9g8pl1dYXofAUd0n4S
	 HiDdurSK8Knqs74a7W1YLVr1TFIYVdWSBkwy3yMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 197/474] ALSA: usb-audio: Fix UAC3 cluster descriptor size check
Date: Fri, 15 May 2026 17:45:06 +0200
Message-ID: <20260515154719.281997742@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


