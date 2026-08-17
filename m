Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6468E3B19B1;
	Mon, 17 Aug 2026 14:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977325; cv=none; b=PfOlmuaTg6YXoOe1Hh9xWHtbxyuQs2vSaUSnT/UVEa/YyKXA9mVanD5DPVIX7vNJk6l+ol+rUCSZWlJUkiZ+QOIAD80SiLcBJdmetAnJH/T+RmAHqck3+E5jTrD0bPnlewyNAe4vI2dJaxjCTeIS8Ha7p1IB/cAqjy8jv1u/VDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977325; c=relaxed/simple;
	bh=/jG5qauAJXcLteGQO+Pc5mGQVViqBq+qDF13OvfuEyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcEMw0+VBBBBjyBmgJVjYVQHvbXc1N7+1J9+JSu6hwmdmvWBO0C4SKRYirwnBptrWjkiNUCwNDnDABk+nnz6y4BtzUoNMFOyWAmYxOje/kS75qlcF933dldo0n2s0UTEbiS8x3RuuOmiAnrAIM0k1oUxAnCK4brEOzcfhbP9fQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+i6DQWM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+i6DQWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15BC1F000E9;
	Mon, 17 Aug 2026 14:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977324;
	bh=KGjLh88sC7vDZCflLbl+vVJCp9KZiSZo/g+TL6r6vMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+i6DQWMlBC8+eF7XRU1/O9yJtYG7JkwKvtpCe6LuSKjUPB6rV/lREt0P3izzHjjZ
	 38bH6seXoabwbBUyvPEoA/modFcw8AJxvXi4n9Rr2v1HGmnEGpsUoI/Fs8A9lJN/M4
	 8JTeDGf5llhgXxof5ZsdH0wgv5LMLofv1GJZUB78=
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
Subject: [PATCH 5.15 290/456] rhashtable: clear stale iter->p on table restart
Date: Mon, 17 Aug 2026 15:31:20 +0200
Message-ID: <20260817132551.226983045@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index e12bbfb240b81..c977468291ea0 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -730,6 +730,7 @@ int rhashtable_walk_start_check(struct rhashtable_iter *iter)
 		iter->walker.tbl = rht_dereference_rcu(ht->tbl, ht);
 		iter->slot = 0;
 		iter->skip = 0;
+		iter->p = NULL;
 		return -EAGAIN;
 	}
 
-- 
2.53.0



