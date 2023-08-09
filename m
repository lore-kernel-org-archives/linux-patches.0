Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E67917731
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E67C433C7;
	Wed,  9 Aug 2023 11:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579321;
	bh=LCJND+ZgM67MnRWij1mZk8+CUts9KAhUOPGIXFTIKoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZnQfAg5O0U2DmWrkB3N1V0XbdjvH3MaI0WOH7ijvv1E01vpcYh5nmPHB4fY2nsGS
	 OQjrdwBLhC5SJcvYsX7vxXniw3KMBcdSvB0zo30jRZUiD9YFUNPMAdzjZwVnXCOR/q
	 2wpQDYFk2+XHmKyaGPrkuXa6ys12i4rTocn0itPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 155/204] benet: fix return value check in be_lancer_xmit_workarounds()
Date: Wed,  9 Aug 2023 12:41:33 +0200
Message-ID: <20230809103647.737251739@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit 5c85f7065718a949902b238a6abd8fc907c5d3e0 ]

in be_lancer_xmit_workarounds(), it should go to label 'tx_drop'
if an unexpected value is returned by pskb_trim().

Fixes: 93040ae5cc8d ("be2net: Fix to trim skb for padded vlan packets to workaround an ASIC Bug")
Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Link: https://lore.kernel.org/r/20230725032726.15002-1-ruc_gongyuanjun@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index f8541d0c7bd52..bbe8f4b250d15 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1132,7 +1132,8 @@ static struct sk_buff *be_lancer_xmit_workarounds(struct be_adapter *adapter,
 	    (lancer_chip(adapter) || BE3_chip(adapter) ||
 	     skb_vlan_tag_present(skb)) && is_ipv4_pkt(skb)) {
 		ip = (struct iphdr *)ip_hdr(skb);
-		pskb_trim(skb, eth_hdr_len + ntohs(ip->tot_len));
+		if (unlikely(pskb_trim(skb, eth_hdr_len + ntohs(ip->tot_len))))
+			goto tx_drop;
 	}
 
 	/* If vlan tag is already inlined in the packet, skip HW VLAN
-- 
2.39.2



