Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C678738E121;
	Fri,  7 Aug 2026 14:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114179; cv=none; b=gwbEkhtTnNaS8UECKATwINQWymq/KWZSsIXycVD8ZzjvdNF6HptvHSlbJJ22/ahxZwJahMgn7nFpQlxWv9D72/PRQud7wBdV01+nDr+TyJGLs4gVRQCiA6dJEIlYimCAPJ40xTEngZxlOVHwqZ/7k+tnk77wsIC+TKrxRhO62tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114179; c=relaxed/simple;
	bh=Wl68zT53vTNOgywQoE2azY3Chremu9OtYf/mTSbH4qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTbn5055Xk71p6DGSrO011sQdZfZzsrYPkKI74rUX9AVgBU4CoaI4JWDCfSMk6y++TWPaWXwDqWpl+yP/pzl3a/hPLR7zOaD6j593qX8H6BbxJ5zYMR19q6IW1oKUKhMqZv0yCzR8tXh8zR2FeoO9kowPcN+myh6Fpq+YU2q03g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bX90Ukid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bX90Ukid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBF81F000E9;
	Fri,  7 Aug 2026 14:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114178;
	bh=0HFdCRAwVkLxmqhRplE2V1sXJ18kYi8DlEVICX3o198=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bX90Ukid4I+c9AcsZHre5yanAc3ugtG0y0NrEbsTyOljJrq/kdiuM/drkwISsOj4Q
	 NIlLYfFiT31XMNAJQqkF6xi4G++AvxIP1/K2GKBuMa7pKGJAu9Atz2zYs0EUYcEGau
	 ybRdmNIaMnRp9/HV5oVdd7LVHkI0sEAti8v3FZRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	Yuan Tan <yuantan098@gmail.com>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	NeilBrown <neil@brown.name>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/337] rhashtable: clear stale iter->p on table restart
Date: Fri,  7 Aug 2026 16:35:31 +0200
Message-ID: <20260807143421.307784450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <blbllhy@gmail.com>

[ Upstream commit 8173f7e2ce67e6ca1d4763f3da14e5b01ce77456 ]

rhashtable_walk_start_check() has two restart paths when resuming a walk.
When iter->walker.tbl is valid, it re-validates iter->p against the table
and sets iter->p = NULL if the object is gone.  When iter->walker.tbl is
NULL (table was freed during resize), it resets slot and skip but forgets
to clear iter->p.

rhashtable_walk_next() then dereferences the stale iter->p, reading
freed memory.  This is a use-after-free.

Any caller that does multi-fragment rhashtable walks across
walk_stop/walk_start boundaries is affected.  Concrete cases include
netlink_diag (__netlink_diag_dump in net/netlink/diag.c) and TIPC
(tipc_nl_sk_walk in net/tipc/socket.c).

Crash stack (netlink_diag):
  BUG: KASAN: slab-use-after-free in rhashtable_walk_next+0x365/0x3c0
  Read of size 8 at addr ffff88801a9d2438 (freed kmalloc-2k, offset 1080)
  Call Trace:
   rhashtable_walk_next+0x365/0x3c0 (lib/rhashtable.c:1016)
   __netlink_diag_dump+0x160/0x760 (net/netlink/diag.c:122)
   netlink_diag_dump+0xc2/0x240
   netlink_dump+0x5bc/0x1270
   netlink_recvmsg+0x7a3/0x980
   sock_recvmsg+0x1bc/0x200
   __sys_recvfrom+0x1d4/0x2c0

Fixes: 5d240a8936f6 ("rhashtable: improve rhashtable_walk stability when stop/start used.")
Cc: <stable@vger.kernel.org>
Reported-by: AutonomousCodeSecurity@microsoft.com
Reported-by: Yuan Tan <yuantan098@gmail.com>
Closes: https://lore.kernel.org/linux-crypto/CAB8m9Wh559e+=n8z51gB8DrbEyCc2mc0MgGjrRR6_VXBmU=2AQ@mail.gmail.com
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/rhashtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 0e9a1d4cf89be..16d2ce87c22e2 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -742,6 +742,7 @@ int rhashtable_walk_start_check(struct rhashtable_iter *iter)
 		iter->walker.tbl = rht_dereference_rcu(ht->tbl, ht);
 		iter->slot = 0;
 		iter->skip = 0;
+		iter->p = NULL;
 		return -EAGAIN;
 	}
 
-- 
2.53.0



