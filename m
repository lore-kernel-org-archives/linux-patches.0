Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213705;
	b=RQBQf+3yazPk1yyShCX6VYRsDDWz/MYT77KpXKOAKQFg5OYMdQ7kdI9cGatTLhx5t8lH
	 RqA4VlNjn68B+2ISscMg6Vf0poYV/hoIRRnV/p9o8fTqtF3aGBlWOMOhpmKwTgezxxC5k
	 lSokhmYOKe0T7ga9iABOJ2PVg5SwcjnCyxTsuiOaIj7WbAKF7fI1sZdq7aE9k/550QzTi
	 /H7oMQ8vfJDWV/LLPUvaP34dgGVagLvhXOhyh75BEggzPdFt8zXkL9VmgTWeGl531uHSL
	 SRf00aoq2PNx6ETO2hBS9TR984BLk0lWgbHIoMR2h0Vgvb2NWAlXD+kS3542QpJRQHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dn2M9E2nVn96e3qa8XQBBQr3XHjLVp/vHo1AKPfKfdY=;
	b=W5EUBJ5XFzLi1ZaGONkFwhujGh9jHxLR/bYil9R8wbvSE3KVEsh3mWa8/GQ5pKz6OoCV
	 2KO3RWutrAv75grxMONMpjWpXKKCYk5k/3MUm+4cqq8dRJq55OI81KpBUVWKUPX4c0jmr
	 IZQCCGF+MQYtyLZ/Ie7sBzSnHJ5gYoZWaCOWXX0z1Us59GNXUS++yivOs5ToXGbNooR36
	 Yka8ItdskoPOEOt79X6T+L1dxLVh2I2ruXib+qSMgckzHta69e5nhkXFaExyL1vzIsXbS
	 6AWtv53V8Cy+mznhYlyawYbuqG5cbXVKmI2y5Vrh18mWaoBJewCBj+P5l4HElOPxtoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xasp5dC4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF0C606A31A;
	Wed, 28 Oct 2026 18:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xasp5dC4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5DC1F01825;
	Wed, 28 Oct 2026 18:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213704;
	bh=Dn2M9E2nVn96e3qa8XQBBQr3XHjLVp/vHo1AKPfKfdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xasp5dC4bzmHfosDP0LVacVVsUU1haK6Xi1IvwqquCsMNxPdscYUBiJeMXUrDi48b
	 I4qsAoGuUuyfLzX7eE53fg6RuK8Hi0bSLhiJvQN76+GLphvBc1BFtEOVmqC3NIwFu6
	 NaZTB/vNXi9Y9vE4hxIqbcKrlacWbKsDGuQ0YH00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0600/1887] netfilter: nf_tables: fix memleak in map from abort path
Date: Wed, 28 Oct 2026 17:44:56 +0100
Message-ID: <20261028170513.069221552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 86a1471d7cde792941109b93b558b5dc078b9ee9 ]

The delete set command does not rely on the transaction object for
element removal, therefore, a combination of delete element + delete set
from the abort path could result in restoring twice the refcount of the
mapping.

Check for inactive element in the next generation for the delete element
command in the abort path, skip restoring state if next generation bit
has been already cleared. This is similar to the activate logic using
the set walk iterator.

[ 6170.286929] ------------[ cut here ]------------
[ 6170.286939] WARNING: CPU: 6 PID: 790302 at net/netfilter/nf_tables_api.c:2086 nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
[ 6170.287071] Modules linked in: [...]
[ 6170.287633] CPU: 6 PID: 790302 Comm: kworker/6:2 Not tainted 6.9.0-rc3+ #365
[ 6170.287768] RIP: 0010:nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
[ 6170.287886] Code: df 48 8d 7d 58 e8 69 2e 3b df 48 8b 7d 58 e8 80 1b 37 df 48 8d 7d 68 e8 57 2e 3b df 48 8b 7d 68 e8 6e 1b 37 df 48 89 ef eb c4 <0f> 0b 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 0f
[ 6170.287895] RSP: 0018:ffff888134b8fd08 EFLAGS: 00010202
[ 6170.287904] RAX: 0000000000000001 RBX: ffff888125bffb28 RCX: dffffc0000000000
[ 6170.287912] RDX: 0000000000000003 RSI: ffffffffa20298ab RDI: ffff88811ebe4750
[ 6170.287919] RBP: ffff88811ebe4700 R08: ffff88838e812650 R09: fffffbfff0623a55
[ 6170.287926] R10: ffffffff8311d2af R11: 0000000000000001 R12: ffff888125bffb10
[ 6170.287933] R13: ffff888125bffb10 R14: dead000000000122 R15: dead000000000100
[ 6170.287940] FS:  0000000000000000(0000) GS:ffff888390b00000(0000) knlGS:0000000000000000
[ 6170.287948] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6170.287955] CR2: 00007fd31fc00710 CR3: 0000000133f60004 CR4: 00000000001706f0
[ 6170.287962] Call Trace:
[ 6170.287967]  <TASK>
[ 6170.287973]  ? __warn+0x9f/0x1a0
[ 6170.287986]  ? nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
[ 6170.288092]  ? report_bug+0x1b1/0x1e0
[ 6170.287986]  ? nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
[ 6170.288092]  ? report_bug+0x1b1/0x1e0
[ 6170.288104]  ? handle_bug+0x3c/0x70
[ 6170.288112]  ? exc_invalid_op+0x17/0x40
[ 6170.288120]  ? asm_exc_invalid_op+0x1a/0x20
[ 6170.288132]  ? nf_tables_chain_destroy+0x2b/0x220 [nf_tables]
[ 6170.288243]  ? nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
[ 6170.288366]  ? nf_tables_chain_destroy+0x2b/0x220 [nf_tables]
[ 6170.288483]  nf_tables_trans_destroy_work+0x588/0x590 [nf_tables]

Fixes: 591054469b3e ("netfilter: nf_tables: revisit chain/object refcounting from elements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9f71ad2669c7e..226fedc7477b1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6869,6 +6869,16 @@ void nft_data_hold(const struct nft_data *data, enum nft_data_types type)
 	}
 }
 
+static int nft_setelem_active_next(const struct net *net,
+				   const struct nft_set *set,
+				   struct nft_set_elem *elem)
+{
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	u8 genmask = nft_genmask_next(net);
+
+	return nft_set_elem_active(ext, genmask);
+}
+
 static void nft_setelem_data_activate(const struct net *net,
 				      const struct nft_set *set,
 				      struct nft_set_elem *elem)
@@ -10233,8 +10243,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
-			nft_setelem_data_activate(net, te->set, &te->elem);
-			nft_setelem_activate(net, te->set, &te->elem);
+			if (!nft_setelem_active_next(net, te->set, &te->elem)) {
+				nft_setelem_data_activate(net, te->set, &te->elem);
+				nft_setelem_activate(net, te->set, &te->elem);
+			}
 			if (!nft_setelem_is_catchall(te->set, &te->elem))
 				te->set->ndeact--;
 
-- 
2.53.0



