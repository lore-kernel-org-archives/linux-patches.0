Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429793C0A09;
	Tue, 12 May 2026 17:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608340; cv=none; b=b7fZAfDNlNmf0c2ZyD2G9DCiSilFhyuRS2QD0abWOkiEKHJqzZMWpHvEkijbay5WFhsDTUd7Vj7yblsG5YV1poWdWY+ZB6MLNTNpeQWT+7C/22bd5Y0LkEKhUqrwrZOo/62ZIRxfQRx79R220Lo3LYSFjoCdxDCX+JCkTN0UPVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608340; c=relaxed/simple;
	bh=gkWK83ab4V4ePLypwQGE42zUWq6g0VkkVTlOi9glO48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pLFDuT834VTeKg1sTUwsorMG6YRD2NmmOySMVp4kk8XKw/iJ5G1R1L+NBdYN7ChXS+hQ3f/jeGbHRoHf/CypegkXlUaj4agUevMIx3TzmIPI6ZMWgO2zMOpZpV2CKYm87tY1suDxvaz+0vAwIBrGVwqMx9UjqOR3Uz7j9471Ri4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M07+o+Fo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M07+o+Fo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE9AC2BCC7;
	Tue, 12 May 2026 17:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608340;
	bh=gkWK83ab4V4ePLypwQGE42zUWq6g0VkkVTlOi9glO48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M07+o+FomiNuQ8FVX2Yfm5FdqufI2r36dchxKZSEoNW6sPf5oYKFyD/Y299fnPKUn
	 yd7phaIwAERygv71ievgN49+6a4nnXVq2w/XqdEIGcpH+AqaEKksALiJ6oGCpnn3GZ
	 dX4FQAOKwZST4247JD4YYFNsu0HhGX9EzWf8B6hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 042/270] ALSA: usb-audio: Fix UAC3 cluster descriptor size check
Date: Tue, 12 May 2026 19:37:23 +0200
Message-ID: <20260512173939.340131844@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -999,7 +999,7 @@ snd_usb_get_audioformat_uac3(struct snd_
 	 * and request Cluster Descriptor
 	 */
 	wLength = le16_to_cpu(hc_header.wLength);
-	if (wLength < sizeof(cluster))
+	if (wLength < sizeof(*cluster))
 		return NULL;
 	cluster = kzalloc(wLength, GFP_KERNEL);
 	if (!cluster)


