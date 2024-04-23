Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0360414388A;
	Tue, 23 Apr 2024 21:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908479; cv=none; b=aoRZvmDlYi5ZIrvSqP0WZaOwnGil0uUXZS4ojf4gD+gJaTPCSSOssRjCOb0caMrl0RLXAJtBGGVJ/Xwt5mBCY8OuZKfw3rJ1IYFNWr1aoiy9hBQg3NCKL0RzQWolzhuEx+VkSnmAxkhk2/nqodAVW1hi8eAMOH7tKDXE/mL4dVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908479; c=relaxed/simple;
	bh=XqxXaxr28isE1rcgLLSfNjlvLUPRB2Bkhqsfzek06Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDWq5v6YzsD+rddyv9h2aAypyI2NT5g7FamY2AWdoDDzWjL/QBVBwgnYv8mDC8JiiQ7u1QfztW9hbqg6vTk2Ja2RPS5DF9Sghk73VJDaApcqs6+TVi9V/jrkfVd8xJpUMDfNBfG4woUR4EqwsYwyD/zGn+2WRpVU8TPwcIw4zU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYmoz0m7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYmoz0m7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEC7C3277B;
	Tue, 23 Apr 2024 21:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908478;
	bh=XqxXaxr28isE1rcgLLSfNjlvLUPRB2Bkhqsfzek06Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYmoz0m7O7Gvmjphfkwt2HDuBaLrwyApgopAF6GCUGstqrIWx4pi7OHdNQCDIPkmD
	 LK7sbvd171qcJDg7e+6YXvteSVdjbnd/62qLh/yO8RkBBOeP1/gF+GYT9bFgwpsmcG
	 m8I9+KvN8ybAPovBF1Cv5h1XZYFb5xdePhqY1PKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 047/158] netfilter: nf_tables: fix memleak in map from abort path
Date: Tue, 23 Apr 2024 14:37:49 -0700
Message-ID: <20240423213857.439817757@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 32a73f3670664..0e697e53a7902 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7219,6 +7219,16 @@ void nft_data_hold(const struct nft_data *data, enum nft_data_types type)
 	}
 }
 
+static int nft_setelem_active_next(const struct net *net,
+				   const struct nft_set *set,
+				   struct nft_elem_priv *elem_priv)
+{
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
+	u8 genmask = nft_genmask_next(net);
+
+	return nft_set_elem_active(ext, genmask);
+}
+
 static void nft_setelem_data_activate(const struct net *net,
 				      const struct nft_set *set,
 				      struct nft_elem_priv *elem_priv)
@@ -10636,8 +10646,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DESTROYSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
-			nft_setelem_data_activate(net, te->set, te->elem_priv);
-			nft_setelem_activate(net, te->set, te->elem_priv);
+			if (!nft_setelem_active_next(net, te->set, te->elem_priv)) {
+				nft_setelem_data_activate(net, te->set, te->elem_priv);
+				nft_setelem_activate(net, te->set, te->elem_priv);
+			}
 			if (!nft_setelem_is_catchall(te->set, te->elem_priv))
 				te->set->ndeact--;
 
-- 
2.43.0



