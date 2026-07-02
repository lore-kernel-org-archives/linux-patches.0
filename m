Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA1719049B;
	Thu,  2 Jul 2026 16:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011014; cv=none; b=YISTH6O80TF1fXaHR7Rh7NcQ0jw6GojyA0hzM2VF/uOOtSnTxax8BtHLqpLhPnh6TO20O9+qcgLTR4dajgVJeALcFeJBDE3fXXcFJ/YgDkfjISa+NBct6EAw2xlaJlOQdjFpNJE2B1HexTEAvwnNYapj+QQrrPcwr0LWLBksYKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011014; c=relaxed/simple;
	bh=A3uKLQpxihQRlVOXa/SpILv5C2PutjZguQX1pSIcxm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CT+EbMTomMKfx2JegC+yu+5Is1jo+QbZd9RklHlAfY6FkI4m9Vty01NZYIhkfOevWjf9TZgfvEClWzubta32jJs7Uogfa6ygk037CZNu39gdesTsAhDeutAs+xckL7y4U7hR9J1MTGFR9qCDvxY+nmUjmL+o4rRgKnJEE+Qtbdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6OpQE0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6OpQE0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C411F000E9;
	Thu,  2 Jul 2026 16:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011012;
	bh=ILGshaMeIM/1z1ll4243cc69o0eIfBIYXRenAJYaanc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6OpQE0kwgwZzJcPPLKyOU2mGTpjhDprBDNTi2VcMUe6Oru4KUH1tFtRTEjXjxDPj
	 sim+G4dClLXtuZC6GOAfANeVnSOQHo8u9nfAJteraAG8mnix+HV3bPIs3u5DtZktqQ
	 7/E8wfY8tSWt/qXYPRc1WsJak7oj4DeeHF4It7dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 6.6 122/175] mac802154: llsec: add skb_cow_data() before in-place crypto
Date: Thu,  2 Jul 2026 18:20:23 +0200
Message-ID: <20260702155118.322609654@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit 84a04eb5b210643bd67aab81ff805d32f62aa865 upstream.

llsec_do_encrypt_unauth(), llsec_do_encrypt_auth(),
llsec_do_decrypt_unauth(), and llsec_do_decrypt_auth() all perform
in-place cryptographic transformations on skb data.  They build a
scatterlist with sg_init_one() pointing into the skb's linear data area
and then pass the same scatterlist as both src and dst to the crypto API
(e.g. crypto_skcipher_encrypt/decrypt, crypto_aead_encrypt/decrypt).

On the RX path, __ieee802154_rx_handle_packet() clones the received skb
before handing it to each subscriber via ieee802154_subif_frame().  The
cloned skb shares the same underlying data buffer via reference
counting.  When llsec_do_decrypt() subsequently modifies this shared
buffer in place, it corrupts data that other clones -- potentially
belonging to other sockets or subsystems -- still reference.

On the TX path, similar data sharing can occur when an skb's head has
been cloned (skb_cloned() returns true).

The fix is to call skb_cow_data() before performing any in-place crypto
operation.  skb_cow_data() ensures that the skb's data area is not
shared: if the skb head is cloned or the data spans multiple fragments,
it copies the data into a private buffer that can be safely modified in
place.  This is the same pattern used by:

  - ESP (net/ipv4/esp4.c, net/ipv6/esp6.c)
  - MACsec (drivers/net/macsec.c)
  - WireGuard (drivers/net/wireguard/receive.c)
  - TIPC (net/tipc/crypto.c)

Without this guard, in-place crypto on shared skb data leads to:
  - Silent data corruption of other skb clones
  - Use-after-free when the crypto API scatterwalk writes through a
    page that has already been freed by another clone's kfree_skb()
  - Kernel crashes under concurrent 802.15.4 traffic with security
    enabled (KASAN/KMSAN reports slab-use-after-free)

Found by 0sec (https://0sec.ai) using automated source analysis.

Fixes: 4c14a2fb5d14 ("mac802154: add llsec decryption method")
Fixes: 03556e4d0dbb ("mac802154: add llsec encryption method")
Cc: stable@vger.kernel.org
Reported-by: Doruk Tan Ozturk <doruk@0sec.ai>
Closes: https://lore.kernel.org/linux-wpan/20260525161806.96158-1-doruk@0sec.ai/
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Closes: <link to your mail on lore>
Link: https://lore.kernel.org/20260526183726.56100-1-doruk@0sec.ai
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac802154/llsec.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/net/mac802154/llsec.c
+++ b/net/mac802154/llsec.c
@@ -710,6 +710,7 @@ int mac802154_llsec_encrypt(struct mac80
 {
 	struct ieee802154_hdr hdr;
 	int rc, authlen, hlen;
+	struct sk_buff *trailer;
 	struct mac802154_llsec_key *key;
 	u32 frame_ctr;
 
@@ -769,6 +770,12 @@ int mac802154_llsec_encrypt(struct mac80
 	skb->mac_len = ieee802154_hdr_push(skb, &hdr);
 	skb_reset_mac_header(skb);
 
+	rc = skb_cow_data(skb, 0, &trailer);
+	if (rc < 0) {
+		llsec_key_put(key);
+		return rc;
+	}
+
 	rc = llsec_do_encrypt(skb, sec, &hdr, key);
 	llsec_key_put(key);
 
@@ -908,6 +915,13 @@ llsec_do_decrypt(struct sk_buff *skb, co
 		 const struct ieee802154_hdr *hdr,
 		 struct mac802154_llsec_key *key, __le64 dev_addr)
 {
+	struct sk_buff *trailer;
+	int err;
+
+	err = skb_cow_data(skb, 0, &trailer);
+	if (err < 0)
+		return err;
+
 	if (hdr->sec.level == IEEE802154_SCF_SECLEVEL_ENC)
 		return llsec_do_decrypt_unauth(skb, sec, hdr, key, dev_addr);
 	else


