Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54793F075D;
	Mon, 17 Aug 2026 14:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975423; cv=none; b=kN8MCq43DuOt8Jjh5beqwA5J0SGMdLE3YTxYjY7xOEgtHNMMRfLzm6/Vej4rBdPFecPRdzxf9NdRPR+JU35kP+FaiaBxQDtm99BRqnwT4M6w62vqUi1giP5L8ZNZiiPsKGG6UfwsKv4hJEl4kS9Xb/lSB+X1aTVtpZdjjHAJy9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975423; c=relaxed/simple;
	bh=E+fk+AlH9P8LNrNP/EcKzQXpjpBLcPqZ6qbOytTbjpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbN+ZTejM9WkSsYymhjVg13vZIzcqyy1sjs0FE8LdINYsN4Kc76D+P/TDRWrInleD24i/u1uvQ0ucxaJNrdsv97Xe6U3VbLCLM2hFEZvZ0Ns3a0NfUs2bNPmVENLlZDyLCUk4b8Bu00I6JWwvJhTI+fSlQzDL8UhTMPsYN1hF3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUdS460e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUdS460e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8B71F000E9;
	Mon, 17 Aug 2026 14:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975421;
	bh=kWNWLdMvOYafu/Mboa/WdQ0GXk1HSeZP25lTa/kbBtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wUdS460eaErhcjs+n4oVbmxlKDTh0ok3BoGwOZVHthJ0dbICKWo6rq5L5V8sDOm7v
	 WBYCA6Cd7eUpIYX36JjQ+nBG4WtylgB8U5rtGd0607LMaVu7j8GnMxW+i/775kMJSc
	 mBvlAHz17MnrbgMdGd2jzGvxiHAv9vDgBL475lvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/389] macsec: dont read an unset MAC header in macsec_encrypt()
Date: Mon, 17 Aug 2026 15:27:22 +0200
Message-ID: <20260817132538.952347955@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit f5089008f90c0a7c5520dff3934e0af00adf322d upstream.

macsec_encrypt() reads the Ethernet header via eth_hdr(skb)
(skb->head + skb->mac_header) to memmove() the 12 source/destination MAC
bytes forward and make room for the SecTAG.

On the AF_PACKET SOCK_RAW + PACKET_QDISC_BYPASS transmit path the skb
reaches the macsec ndo_start_xmit() with the MAC header unset, so
eth_hdr(skb) resolves to skb->head + (u16)~0 and the read is out of
bounds: a 12-byte heap over-read that is also emitted on the wire as the
frame's outer source/destination MAC. KASAN reports a slab-out-of-bounds
read in macsec_start_xmit() on 6.0; on current mainline a CONFIG_DEBUG_NET
build flags it as an unset mac header in skb_mac_header().

On the TX path the L2 header is at skb->data, so use skb_eth_hdr(), added
by commit 96cc4b69581d ("macvlan: do not assume mac_header is set in
macvlan_broadcast()") for exactly this purpose.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260703083634.2035145-1-4ncienth@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index d19b5b1c1aca11..d07dba76940a9d 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -666,7 +666,7 @@ static struct sk_buff *macsec_encrypt(struct sk_buff *skb,
 	}
 
 	unprotected_len = skb->len;
-	eth = eth_hdr(skb);
+	eth = skb_eth_hdr(skb);
 	sci_present = send_sci(secy);
 	hh = skb_push(skb, macsec_extra_len(sci_present));
 	memmove(hh, eth, 2 * ETH_ALEN);
-- 
2.53.0



