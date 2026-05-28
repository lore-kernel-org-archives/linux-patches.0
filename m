Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1781F259CBD;
	Thu, 28 May 2026 20:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000564; cv=none; b=aMd79KYVfajN/kS2ooz2fK/fJLBI8AxwdQOlB8dRJBULtwE9BoOlyfM/nSQA4Z9DZsiSHwBqZr1x794u5w6CnRukOhENpHL4X83rDd6tylXvPYz174Ky0zWg96cfkMBBJMnhiQlq4ljpvbgX4BSvnknpFTxJFOF470a7mJ9IyqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000564; c=relaxed/simple;
	bh=sTelWjp1wmr/HbYFq308F9Tdw6poBIBO75Ykz7uWKG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BNxmBXcc/ICspMPFiYz74ry9LiMAi0TsJJgRRLI9TWPW0jm8kZgRqRQKzLJLCQPZeR+YE+4k17w72dKXQAn+KdZMqseQZwHL3T4NM9HWQKysDAFiGmWs1wv3n42W0m+IpCZI1so8zeVYPGk7Z+Tx2sBtHlrUXzwXPiq47OvFM44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRRQ8GAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRRQ8GAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BC91F000E9;
	Thu, 28 May 2026 20:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000563;
	bh=7EAmWStN/wsimZL0kA2bVDxu2rlgA99K8HH8jPsPDpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRRQ8GADh6dQpJYu+hfiMh7EnWDD32X8h6xHXRjuZmBt68PRe6njjO6cmVUKkWP6L
	 sXkVr5t7QciGbWiSL0yQhO6OMGJ1bL6FfcCA8J8mj+rjC7H0wSvmO0hvKIoLMZZ8SL
	 QFAjoOUuFSsT8y9clRxe8wrUfP546O20d7BH9X7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 052/272] ALSA: ua101: Reject too-short USB descriptors
Date: Thu, 28 May 2026 21:47:06 +0200
Message-ID: <20260528194630.842462079@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit b59d5c51bb328a60749b4dd5fe7e649bfb4089b4 upstream.

find_format_descriptor() walks the class-specific interface extras by
advancing with bLength. It rejects descriptors that extend past the
remaining buffer, but it does not reject descriptor lengths smaller than
a USB descriptor header.

Reject too-short descriptors before using bLength to advance the local
scan. This keeps the UA-101 parser robust against malformed descriptor
data and matches the usual USB descriptor walking rules.

Fixes: 63978ab3e3e9 ("sound: add Edirol UA-101 support")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260519-alsa-ua101-desc-len-v1-1-4307d1a5e054@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/misc/ua101.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -914,8 +914,9 @@ find_format_descriptor(struct usb_interf
 		struct uac_format_type_i_discrete_descriptor *desc;
 
 		desc = (struct uac_format_type_i_discrete_descriptor *)extra;
-		if (desc->bLength > extralen) {
-			dev_err(&interface->dev, "descriptor overflow\n");
+		if (desc->bLength < sizeof(struct usb_descriptor_header) ||
+		    desc->bLength > extralen) {
+			dev_err(&interface->dev, "invalid descriptor length\n");
 			return NULL;
 		}
 		if (desc->bLength == UAC_FORMAT_TYPE_I_DISCRETE_DESC_SIZE(1) &&


