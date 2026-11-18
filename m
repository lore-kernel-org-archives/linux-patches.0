Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027524;
	b=e7QIAkLZ3BeAoDMunHO1zMmJjRoI8yifW0Bp3sIIyHash+zcf01DSHYO/KfK5pl1KOD8
	 2KgFTIVe8bFCQ5lM5SHOz9b35D4ByhjX9e6acC7rrvm14h+50oiTiNN5hjU+vLYoXMnMf
	 hg0d4tqafQc6bO59CJUJUGIqe1lagrZVuwXHx5RBD0E7H0dfoahH4npVSlEoqZm3SyuOf
	 5YrAO6Uqd8Wzplehwk0qGqFOLjbxPI8PqR7EQ5gahOue8gmwSI0k3ul96KuF/+DPTs1XT
	 ibfxd8mCccZWitjmlggGXQQl4QEHbAdgj2bw3a2Hsaqj+7qjyraSMbjOmT6GqTsgQKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cCjE0Ps0KrhDPbRX3MrUenvCaw3j57oIxcbn61Xf61U=;
	b=sjH+55MkMsZ6pbDPQxEzi6O7Yat0996p7wbJ6hEzrJ2rZoZqNtUcoPqALD6D3f0olCKZ
	 I++aNJ8q42QmQgyn64rVZKDASHs63E4eeSJNQX5Os41cjRHhOQpRVTVtSW5hUj4/kjkkU
	 Yq39Zbidwt8u+dMQLToUoMDZyjSarWy8qJ/XxUEZy/VdXxFPRU+OtWvrSWueGtS+I/NA2
	 m8bH3fyQTBuAhcpU1ZiaDFAt9o+Hgg4cB8QJlYiU1R0PfS05aAyfyIjG3QRzq4HK6e4mE
	 6+vMRPkoBhM2QObFI1lretIHLmiNiB7lDGJUrDJc8mXhryTEJA1xyuN+7xNfrcCkuwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0u9QH6TN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B10606A332;
	Wed, 18 Nov 2026 18:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0u9QH6TN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FB01F000CD;
	Wed, 18 Nov 2026 18:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027524;
	bh=cCjE0Ps0KrhDPbRX3MrUenvCaw3j57oIxcbn61Xf61U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0u9QH6TN05PqoyeL66/z77xEqPskCHzR3wl+9SZucxOea+Xaa9jeNM+CeASwkQnMj
	 BjX4QgWSUnNAjSBEu2L4ev+VU1LJv03GE5KXj435ESpcDwZapkJEmm5BO2ORP46NBi
	 MN1P0OKtDNzLC1NcxA7xMPu2SVlnqnssvntlfMPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1818/2151] net: bcmasp: validate minimum RX packet size in bcmasp_rx_poll()
Date: Wed, 18 Nov 2026 15:59:13 +0100
Message-ID: <20261118150228.033044799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 07b624d2f5a4517d7d0022fbd4aef17e884b5686 ]

In bcmasp_rx_poll(), the driver removes a 2-byte alignment pad and
optionally strips the ETH_FCS_LEN CRC from received packets before
passing them to eth_type_trans().

If the hardware reports a descriptor size smaller than the sum of the
2-byte pad, the Ethernet header (ETH_HLEN), and optional CRC
(ETH_FCS_LEN), subtracting the pad and CRC lengths underflows u32 len.
This adds ~4 GiB to rx_bytes statistics, while the undersized frame
reaches eth_type_trans(), which reads past skb->len into stale buffer
data.

Check that desc->size is at least (2 + ETH_HLEN + (crc_fwd ? ETH_FCS_LEN
: 0)) before proceeding to process the descriptor.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261013204439.3494046-4-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 515404f94eabb..c2828d1d8c612 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -563,6 +563,12 @@ static int bcmasp_rx_poll(struct napi_struct *napi, int budget)
 					DMA_FROM_DEVICE);
 
 		len = desc->size;
+		if (unlikely(len < 2 + ETH_HLEN + (intf->crc_fwd ? ETH_FCS_LEN : 0))) {
+			u64_stats_update_begin(&stats->syncp);
+			u64_stats_inc(&stats->rx_dropped);
+			u64_stats_update_end(&stats->syncp);
+			goto next;
+		}
 
 		skb = napi_alloc_skb(napi, len);
 		if (!skb) {
-- 
2.53.0



