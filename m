Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F3B341AC7;
	Sat, 30 May 2026 17:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163665; cv=none; b=DZDDDoWRHn7M5eKBUjmpaHAs/kzAzVKGeYuSNMACxKfT9J5IUAkMzySjTHtFEH+zz8xnqO6x/ocq29EzFSNgFTbW0R0Hi8mF3X7N6JC631WG6BK6k6HVPK5TKe9FcYHqceBm8Vtrj/zONVZ0vqnp+BN9kj1B5+94zYq0pYaVoAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163665; c=relaxed/simple;
	bh=6EY1Np2MMWwsHG4DuKEuF+TXoxYXTXicuPXm8nDLx/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=crHYVF8/DfgFmaYGQ6DW5NW6UFxdnSqTnl2uqVGHMZXXcsWVQ1OJIQNdYdfemg/ftt1RFfYVkHGJNHoKRqk7wENvoSxYz6U3qiYwqCwWzW8N9vBMXDZ/fwYxdBkCtbIvDgs9tg3I/nZ4NMfXcHDF9mDEOeh0kGNvwi5sjD3ATPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRFcPVR6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRFcPVR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226181F00898;
	Sat, 30 May 2026 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163664;
	bh=sQ72OfCeN9rQV+VsBiDN6i73vKB2EBKZU8aR3ZZatMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRFcPVR6Gwqik7aUrdAuipMuIE66PXqmLb8GvKVoKGq/fsHVyFHmeBqf8yGEpXzZY
	 HrBWOSO4EKitRY1dVVRp3TsMvypbulWRQTIGB6oQv/23FijlEBpBeNEuMSxXIWoLtd
	 v7k9cEWXJWa7mEAl+lG/WCNiVIJzH8xJ1OEl40Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 296/776] ALSA: usb-audio: Fix UAC3 cluster descriptor size check
Date: Sat, 30 May 2026 18:00:10 +0200
Message-ID: <20260530160248.212153571@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


