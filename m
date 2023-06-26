Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BD5BE6B
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34036C433C0;
	Mon, 26 Jun 2023 18:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804844;
	bh=qPdjSeRTJmgO58+2QftlPctk6GmTfbQ6c2FZDO7jRR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lS2+IIV9CTQeiqx3EhLUkCHAd1gYEsULSks8hvJKK6csOQnkn+ThliMPgm62mxR7e
	 lT9OOP+fux3h8IAqF3tCLs44LT1IcfUigGW/ztKZRHjPQ7TpMpubcSPGR1oDLK2SKE
	 LCAMgDPssd/l/7cMwD7olhButH14mA+PNRPyaO7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 60/96] be2net: Extend xmit workaround to BE3 chip
Date: Mon, 26 Jun 2023 20:12:15 +0200
Message-ID: <20230626180749.439181577@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit 7580e0a78eb29e7bb1a772eba4088250bbb70d41 ]

We have seen a bug where the NIC incorrectly changes the length in the
IP header of a padded packet to include the padding bytes. The driver
already has a workaround for this so do the workaround for this NIC too.
This resolves the issue.

The NIC in question identifies itself as follows:

[    8.828494] be2net 0000:02:00.0: FW version is 10.7.110.31
[    8.834759] be2net 0000:02:00.0: Emulex OneConnect(be3): PF FLEX10 port 1

02:00.0 Ethernet controller: Emulex Corporation OneConnect 10Gb NIC (be3) (rev 01)

Fixes: ca34fe38f06d ("be2net: fix wrong usage of adapter->generation")
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Link: https://lore.kernel.org/r/20230616164549.2863037-1-ross.lagerwall@citrix.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 361c1c87c1830..e874b907bfbdf 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1136,8 +1136,8 @@ static struct sk_buff *be_lancer_xmit_workarounds(struct be_adapter *adapter,
 	eth_hdr_len = ntohs(skb->protocol) == ETH_P_8021Q ?
 						VLAN_ETH_HLEN : ETH_HLEN;
 	if (skb->len <= 60 &&
-	    (lancer_chip(adapter) || skb_vlan_tag_present(skb)) &&
-	    is_ipv4_pkt(skb)) {
+	    (lancer_chip(adapter) || BE3_chip(adapter) ||
+	     skb_vlan_tag_present(skb)) && is_ipv4_pkt(skb)) {
 		ip = (struct iphdr *)ip_hdr(skb);
 		pskb_trim(skb, eth_hdr_len + ntohs(ip->tot_len));
 	}
-- 
2.39.2



