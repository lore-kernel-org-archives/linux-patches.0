Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A370A2D8760;
	Wed, 28 Jan 2026 15:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614656; cv=none; b=b3uUgXGRsAHZPoR6g5WKCGpwCHAL32agCqlS4FtulRPVJO8dxH0QB/jryxvH4JUz9b30sUQShtkAavc7kjBtVaz42vrNNcdqEQ2mmhtob27v6joieLFfCFFGrJne/AqTKPDJT6sUBP26S3/SVZZ1XUhBHKgZJxUdfC2Xzysdvxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614656; c=relaxed/simple;
	bh=nOt1KlxLmnDvHNZHTNrEzMIEsX/t/35eA33x6ygPUwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz4Bp3m2Qrrj4neGDCTQ6SYVF4mRHgatjk1PIidj9065wePSW5kKjngeVTkWTo0ho56EDupVz6lnk7uSXq6XUu1ow3QoOpyDjBUJM3zTxG1w29FqKRALLHC9B7ODGOq9Fss9XaqC5TW6QS5yUVPi6lJV7l7Y83pkwN9jq83vINI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKQ8dewS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKQ8dewS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98ACC2BCB0;
	Wed, 28 Jan 2026 15:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614656;
	bh=nOt1KlxLmnDvHNZHTNrEzMIEsX/t/35eA33x6ygPUwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKQ8dewSoyD5NiHnihZA2CkYi2GH7oNP0OdjQ+AD/7aV0OOWtznPuRN+375aSW2o+
	 ciZT9bm6kaW7UYzqX3GBUvntz/xsD7sA22ZpbRudykQ3GJMRxiqfcb30SJlJBPwIdE
	 ZoqlVy1SYBwAktYgcckM6KDyAEpkmzw5ATAA0x+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c46409299c70a221415e@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Matteo Croce <mcroce@redhat.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/254] bonding: provide a net pointer to __skb_flow_dissect()
Date: Wed, 28 Jan 2026 16:22:31 +0100
Message-ID: <20260128145351.102509605@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5f9b329096596b7e53e07d041d7fca4cbe1be752 ]

After 3cbf4ffba5ee ("net: plumb network namespace into __skb_flow_dissect")
we have to provide a net pointer to __skb_flow_dissect(),
either via skb->dev, skb->sk, or a user provided pointer.

In the following case, syzbot was able to cook a bare skb.

WARNING: net/core/flow_dissector.c:1131 at __skb_flow_dissect+0xb57/0x68b0 net/core/flow_dissector.c:1131, CPU#1: syz.2.1418/11053
Call Trace:
 <TASK>
  bond_flow_dissect drivers/net/bonding/bond_main.c:4093 [inline]
  __bond_xmit_hash+0x2d7/0xba0 drivers/net/bonding/bond_main.c:4157
  bond_xmit_hash_xdp drivers/net/bonding/bond_main.c:4208 [inline]
  bond_xdp_xmit_3ad_xor_slave_get drivers/net/bonding/bond_main.c:5139 [inline]
  bond_xdp_get_xmit_slave+0x1fd/0x710 drivers/net/bonding/bond_main.c:5515
  xdp_master_redirect+0x13f/0x2c0 net/core/filter.c:4388
  bpf_prog_run_xdp include/net/xdp.h:700 [inline]
  bpf_test_run+0x6b2/0x7d0 net/bpf/test_run.c:421
  bpf_prog_test_run_xdp+0x795/0x10e0 net/bpf/test_run.c:1390
  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4703
  __sys_bpf+0x562/0x860 kernel/bpf/syscall.c:6182
  __do_sys_bpf kernel/bpf/syscall.c:6274 [inline]
  __se_sys_bpf kernel/bpf/syscall.c:6272 [inline]
  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6272
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94

Fixes: 58deb77cc52d ("bonding: balance ICMP echoes in layer3+4 mode")
Reported-by: syzbot+c46409299c70a221415e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/696faa23.050a0220.4cb9c.001f.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Matteo Croce <mcroce@redhat.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260120161744.1893263-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 9dfbbf4cd71f0..9385c3ac0c83c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4186,8 +4186,9 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb, const v
 	case BOND_XMIT_POLICY_ENCAP23:
 	case BOND_XMIT_POLICY_ENCAP34:
 		memset(fk, 0, sizeof(*fk));
-		return __skb_flow_dissect(NULL, skb, &flow_keys_bonding,
-					  fk, data, l2_proto, nhoff, hlen, 0);
+		return __skb_flow_dissect(dev_net(bond->dev), skb,
+					  &flow_keys_bonding, fk, data,
+					  l2_proto, nhoff, hlen, 0);
 	default:
 		break;
 	}
-- 
2.51.0



