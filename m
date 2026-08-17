Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144F8429CEE;
	Mon, 17 Aug 2026 14:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975883; cv=none; b=qCABrRaVQ5OdHbiHanz680fK8tBUZT8HeKep0Tcmwiuz9+/SJMgh4ePGLJ2gRKEKqIQ1F0pHwVgCRr8BtIy1xuxWUGLOPq6l3oIk9DIYG5w2RuMA+ij/MPYzYy0p/h+fnRig/2h55Fj+rSuWfTBZX7FF7zIw0+6P3f0Wud0EyXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975883; c=relaxed/simple;
	bh=NQo31SXfjcnxObkW+BdhPRJ4TnU2EnNCIoCI+ArGiI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVJcRO6lVU5v16lN7YtkUm9XW5AIpNDITGFvUWOksYt9BA8xGJU6m4e8+T5aASWBi/J+qQTu8NElm2ek9eSP1TP81qRP6PY1Cf/DoygidUJyXYIR3vwVGvb6ukD5tjhckHpVFlPtW5anVIdbXjvF24QPPmDwrQc87MtYstwXU64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCYTdOFR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCYTdOFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE7F1F00A3A;
	Mon, 17 Aug 2026 14:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975882;
	bh=CLHeoDqH7uzG3LPGdd8R7EXC2PUJ1OXLumsfq5IwtAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCYTdOFRKChvLElxvDtMx2FUAmRIBuoqYADLIO50f2jd+A853B5Vz9/dejs4mI5eL
	 ByXZukbnt0f7My1Nq4gEUYUpvJ5Bq/BbVyQyYTVcNgfFQcKQtKqHE03W5F8qCqKXB7
	 AHUCK/pfSgP46MpqCzOiMe76gblTbHyKrlU/m+wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 180/389] mac802154: llsec: reject frames shorter than the authentication tag
Date: Mon, 17 Aug 2026 15:30:19 +0200
Message-ID: <20260817132546.206515332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


