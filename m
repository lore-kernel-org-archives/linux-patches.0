Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39613C3F4C;
	Thu, 30 Jul 2026 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423144; cv=none; b=KCfOepJU2mIkWEcNvw4HEGJ1+YcnlzpZrsTerT1XibLmvsD6AE6dwvED+n4C69R7mHNUxp4z7ObtXOFWQZU9dOjQ3rVtghAOruA1X9wLzJMExGzptRyIyQK5kc37wYttzHW5aPfIFwqVe/o1sEqDjlVDZbUCJ0mohXEAeR1eelI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423144; c=relaxed/simple;
	bh=RHI8IC9N0ll1vWJoUFYw5PfR60c0hwDJpKM8uM11IUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6WHyHKne7daLmbJheo+5z4+VOwy6kKzex8leUJxrbe4D+eeNdriA3T5Vk9pfte7VOqz/r1sQDIRdC2fxJKB6NpvrUXyDeaSnES3XBnwF0WVqhRPbI08WIjodtsVQfkJ3eUaxBQSYWvHBTj54uOlldDGZV0N4n3IgoUVjf5YyL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABEYZqIz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABEYZqIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140B91F00A3D;
	Thu, 30 Jul 2026 14:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423142;
	bh=oLk0LmA6mopx9/RJhPYNNhQ8y/7Yqv4X51lNa5VDKXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ABEYZqIzf42+dWf22rgQqe4pW1bOB/TUgyQpSOXemlK5zgg/RFzkgyNKgsIyS0DtI
	 UeuTxow7oo+EOLUJ+Lrun6CCVxsor/cAfgx1hcQ2fR/6UEp/x5pVA6g8+7Ab+caOyJ
	 TpA0ScheD+DzEAJv83hNRHIBoQkfke/DMwZaNt4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 680/744] mac802154: llsec: reject frames shorter than the authentication tag
Date: Thu, 30 Jul 2026 16:15:53 +0200
Message-ID: <20260730141458.718054492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -891,6 +891,11 @@ llsec_do_decrypt_auth(struct sk_buff *sk
 	data = skb_mac_header(skb) + skb->mac_len;
 	datalen = skb_tail_pointer(skb) - data;
 
+	if (datalen < authlen) {
+		kfree_sensitive(req);
+		return -EBADMSG;
+	}
+
 	sg_init_one(&sg, skb_mac_header(skb), assoclen + datalen);
 
 	if (!(hdr->sec.level & IEEE802154_SCF_SECLEVEL_ENC)) {


