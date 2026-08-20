Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAADA272E53;
	Thu, 20 Aug 2026 16:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243915; cv=none; b=BV0r+8OYhVfM5IFBjtDCB2jLjLXVnBpu80cNf1n3HY7pOFXhn61GodgqZUU213IpHlB0Klu5x0nd+VtW29S2zgmon+QBt7k58YeJsoq+G6+VFigYdFmo6Ji4iQuizX2IBJYsccCSbTnlG+y9OswVWg2qHZVzZ5Cy+gpbOkk1PGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243915; c=relaxed/simple;
	bh=svZueBu2HxyBnGMVbCYOagsv+JDVB2nuDoBUsdycdGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4is34fiBmENC5nXtYTohZGipvfA1jU/Kla3uvApgR/wg9TsOZUY0/+EFg9T1iH0jI08SY1TM3Qn1A763yPspw51ikKWVtuswOy1SXeiV3MpXhlSuTxYi3FDZ6s+oJL1FykvCFcjAaZICohLYcgu2zR7YJKLAhV8orEr2ujFWUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCViypoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCViypoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF2C1F000E9;
	Thu, 20 Aug 2026 16:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243914;
	bh=SQr9Dbh88/LL4WYD/pIDkPlXgN4gveBqVw7P6qHpDw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCViypoCFsiuVFlLNUPKf2PCJcIA9QMrM9svKxjpXcj69hCaLgwW4ll6cYJjWQUB4
	 7uQTsQzaUy3N9uANTgc4+D62VwYr+ROFjqFdYtaGPA6ZvMf5Figm1qiYapCMYLCE4c
	 ai95rQy0U90YZY1DRl4wVwDNiyRsN0zBSMA7VSzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 260/272] netfilter: nf_tables_offload: suppress WARN_ON_ONCE for ENOMEM in abort path
Date: Thu, 20 Aug 2026 16:57:24 +0200
Message-ID: <20260820145239.434442667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>

[ Upstream commit d02f592064347e0c1e0d84f24941ad338838cc48 ]

In nft_flow_rule_offload_abort(), WARN_ON_ONCE(err) is triggered on every
error during rollback, including -ENOMEM. Memory allocation failures are
expected under low-memory conditions and do not indicate a kernel bug.

Trace for example:
nft_flow_offload_chain() // FLOW_BLOCK_BIND
  nft_flow_block_chain()
    nft_chain_offload_cmd()
      nft_block_offload_cmd()
        ->ndo_setup_tc()
        nsim_setup_tc()
          flow_block_cb_setup_simple()
            flow_block_cb_alloc() // fails to -ENOMEM

The warning was reproduced on the 5.10 stable kernel under memory pressure
via fault injection, but the underlying bug exists in mainline as well,
as demonstrated by the ENOMEM trace above. The following splat was
triggered during nf_tables transaction processing:

WARNING: CPU: 0 PID: 8567 at net/netfilter/nf_tables_offload.c:532 nft_flow_rule_offload_abort net/netfilter/nf_tables_offload.c:532 [inline]
WARNING: CPU: 0 PID: 8567 at net/netfilter/nf_tables_offload.c:532 nft_flow_rule_offload_commit+0x971/0xcd0 net/netfilter/nf_tables_offload.c:591
Modules linked in:
CPU: 0 PID: 8567 Comm: syz-executor.0 Not tainted 5.10.260-syzkaller #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
RIP: 0010:nft_flow_rule_offload_abort net/netfilter/nf_tables_offload.c:532 [inline]
RIP: 0010:nft_flow_rule_offload_commit+0x971/0xcd0 net/netfilter/nf_tables_offload.c:591
Call Trace:
 nf_tables_commit+0x3bd/0x4bd0 net/netfilter/nf_tables_api.c:8604
 nfnetlink_rcv_batch+0xb1e/0x1f20 net/netfilter/nfnetlink.c:509
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:579 [inline]
 nfnetlink_rcv+0x3b3/0x420 net/netfilter/nfnetlink.c:597
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x6cd/0xa00 net/netfilter/af_netlink.c:1340
 netlink_sendmsg+0x906/0xe10 net/netfilter/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 __sock_sendmsg+0x155/0x190 net/socket.c:663
 ____sys_sendmsg+0x705/0x870 net/socket.c:2379
 ___sys_sendmsg+0x100/0x170 net/socket.c:2433
 __sys_sendmsg+0xe9/0x1c0 net/socket.c:2462
 do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x67/0xd1

Change the condition to WARN_ON_ONCE(err && err != -ENOMEM) so that
warnings are only emitted for unexpected errors. This aligns with the
common kernel practice of not warning on -ENOMEM.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 63b48c73ff56 ("netfilter: nf_tables_offload: undo updates if transaction fails")
Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 910ef881c3b85..27907fa6f1571 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -550,7 +550,7 @@ static void nft_flow_rule_offload_abort(struct net *net,
 			break;
 		}
 
-		if (WARN_ON_ONCE(err))
+		if (WARN_ON_ONCE(err && err != -ENOMEM))
 			break;
 	}
 }
-- 
2.53.0



