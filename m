Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A3D4C3C9;
	Mon,  8 Jan 2024 15:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zK9Iu+WE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AC5C433CB;
	Mon,  8 Jan 2024 15:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726675;
	bh=rHbjRKJpeap2vIVNPzAzWNLt47mPpvHL2BB4Cof8Ykc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zK9Iu+WEAYjMUvxce9U0b/cVp1jjqvof9qVJTxQ1Q6hnRHkm95Zq4EpoCVKdtOQ9P
	 UTb1ZkTkrNxQRUYzYH00yB6U9x1hoJVa72HqjKHD7DQmcBSyZqaVYJefOYaTDFpy6D
	 Nzq8YPlG5GGRmMqk32bnap+aMrp2YSHj/NFntvdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Cowie <brad@faucet.nz>,
	Simon Horman <horms@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Aaron Conole <aconole@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/124] netfilter: nf_nat: fix action not being set for all ct states
Date: Mon,  8 Jan 2024 16:07:48 +0100
Message-ID: <20240108150604.914415143@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Brad Cowie <brad@faucet.nz>

[ Upstream commit e6345d2824a3f58aab82428d11645e0da861ac13 ]

This fixes openvswitch's handling of nat packets in the related state.

In nf_ct_nat_execute(), which is called from nf_ct_nat(), ICMP/ICMPv6
packets in the IP_CT_RELATED or IP_CT_RELATED_REPLY state, which have
not been dropped, will follow the goto, however the placement of the
goto label means that updating the action bit field will be bypassed.

This causes ovs_nat_update_key() to not be called from ovs_ct_nat()
which means the openvswitch match key for the ICMP/ICMPv6 packet is not
updated and the pre-nat value will be retained for the key, which will
result in the wrong openflow rule being matched for that packet.

Move the goto label above where the action bit field is being set so
that it is updated in all cases where the packet is accepted.

Fixes: ebddb1404900 ("net: move the nat function to nf_nat_ovs for ovs and tc")
Signed-off-by: Brad Cowie <brad@faucet.nz>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_ovs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_ovs.c b/net/netfilter/nf_nat_ovs.c
index 551abd2da6143..0f9a559f62079 100644
--- a/net/netfilter/nf_nat_ovs.c
+++ b/net/netfilter/nf_nat_ovs.c
@@ -75,9 +75,10 @@ static int nf_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
+out:
 	if (err == NF_ACCEPT)
 		*action |= BIT(maniptype);
-out:
+
 	return err;
 }
 
-- 
2.43.0



