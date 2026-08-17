Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46B52E8DEC;
	Mon, 17 Aug 2026 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979583; cv=none; b=syhxora8smTxXuLQ9Kw1w4svKBa/JliLTfwGlaF8Mia5m3Zx+QW6QjIuDjiTkv7eXaGOqdrGTQcmjtwyriKfDrHwddcjE0MPBjqN1qifSK2mL2GDxxE1/VNpD0Hqsz1EHGb9Z3xchLaQEWP5eK9uXBkIiiin+94dFcMEIHKnN/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979583; c=relaxed/simple;
	bh=NvKDEch764BE+n3u8ytSY1+0yje8c3t5DMDYl6xy460=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQEnY37+eIo9bKHkAHF9K60Ekc3b1MGQbu4BuAqc7EREnAQXvng8aHKaIo5UdH0G/RcLXi/bEZ36QMrF+PBMmKxZ+a9YCkXir85ZeXTYtZIAF3nQ/CJ68nf+JVPKyjmFTREaqU++M8h7JQl4G7qf7tvhM6srOFutDUBWApqJ+iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yx1zVPND; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yx1zVPND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AC41F000E9;
	Mon, 17 Aug 2026 15:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979582;
	bh=SVPv/SwaBlKRfh7PSSkIx58kGHFBiptN6dnZ6bWzEKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yx1zVPNDFvq4trPqOXF+jS9A1dJIM7BxTM14RaH0PF24J5PwysKE19hzCvaBgE7pL
	 ENekMGI+3aaJS/+uK7WnsbzfZ4pxfvLC9/O+qizHtoVN5QfalTGtAW82P3qTaBneRW
	 f/ISe+1LQCbiYREVoZ82b92TQnGwP1vcLxr9tmjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 274/609] mac802154: llsec: reject frames shorter than the authentication tag
Date: Mon, 17 Aug 2026 15:29:30 +0200
Message-ID: <20260817132553.313982946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit fd3a3f28ed60c6af4b2a39933b151d6b27842c3b upstream.

llsec_do_decrypt_auth() computes the associated-data length for the
AEAD request as

	assoclen += datalen - authlen;

where datalen is the number of bytes after the MAC header and authlen
(4, 8 or 16) is the length of the authentication tag. Nothing verifies
that the frame actually carries at least authlen payload bytes. A
secured frame whose payload is shorter than the tag makes
datalen - authlen negative; assoclen is then passed to
aead_request_set_ad() as an unsigned value close to 4 GiB, so
crypto_aead_decrypt() walks far off the end of the scatterlist that
only spans the real frame.

The frame is fully attacker-controlled and reaches this path from any
IEEE 802.15.4 peer in radio range. Reject frames whose payload is
shorter than the authentication tag before the subtraction.

Dynamically reproduced on a KASAN kernel as a general-protection-fault
in the AEAD scatterwalk, and the fix confirmed.

Fixes: 4c14a2fb5d14 ("mac802154: add llsec decryption method")
Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Link: https://patch.msgid.link/20260716193423.32498-1-doruk@0sec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac802154/llsec.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/mac802154/llsec.c
+++ b/net/mac802154/llsec.c
@@ -888,6 +888,11 @@ llsec_do_decrypt_auth(struct sk_buff *sk
 	data = skb_mac_header(skb) + skb->mac_len;
 	datalen = skb_tail_pointer(skb) - data;
 
+	if (datalen < authlen) {
+		kfree_sensitive(req);
+		return -EBADMSG;
+	}
+
 	sg_init_one(&sg, skb_mac_header(skb), assoclen + datalen);
 
 	if (!(hdr->sec.level & IEEE802154_SCF_SECLEVEL_ENC)) {


