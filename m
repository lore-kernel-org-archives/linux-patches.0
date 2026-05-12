Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818883EDE76;
	Tue, 12 May 2026 17:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608381; cv=none; b=TlxSAoTcXGCj3DDkvMwgB7mmRKspqnbFAUlUY7uWbY1ot9XbIIfsuvQk/DzONNLU8tujcRfi6N4OSSGw9wU2lKcYsbeSmn3PFCVwtUrMa54WY1hpt+fKDm6t3X5gz4l5i1ettExmGtcu71oEb5sGRgpqj4l1zvGKwgc4r9129mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608381; c=relaxed/simple;
	bh=7cmMYmXvsUY8nE4Rv6sxx0HvbjrykqsGJTdOhWRhdtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xx3hNGkf/W2L/XlQmNcCgV3Wj7Wc23m6LnlYSSCpVAPxsssvKGTvcDwPZ/tDEQKcn92sXprhEgeUKzzAw5duwr0UdqHJnRqOhwjRl0xlRJv44bywobph8rJ3baGKhJcwYZEv1fUs3/V3LKr5L6aErEeuxvRigG5XoCteQnmTw/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b80xMG1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b80xMG1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA9CC2BCFD;
	Tue, 12 May 2026 17:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608381;
	bh=7cmMYmXvsUY8nE4Rv6sxx0HvbjrykqsGJTdOhWRhdtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b80xMG1KCJcRLJLbIo43FR9wOnPyFw+CE5cYjH4z2my94KuPRpSk9MZQuP/JyeATl
	 Gexxsf2vBVJK31lwnsgX/xJCCP30Nc0rc1THrqOPTcJ5iuT47SE3v5kjgr9EUFhdQx
	 Stlf+SYQsPcmBz05XXBwzaJ0eZKY3+fio5wMKMds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kosiorek <mkosiorek121@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.18 057/270] xfrm: defensively unhash xfrm_state lists in __xfrm_state_delete
Date: Tue, 12 May 2026 19:37:38 +0200
Message-ID: <20260512173939.652879535@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Kosiorek <mkosiorek121@gmail.com>

commit 14acf9652e5690de3c7486c6db5fb8dafd0a32a3 upstream.

KASAN reproduces a slab-use-after-free in __xfrm_state_delete()'s
hlist_del_rcu calls under syzkaller load on linux-6.12.y stable
(reproduced on 6.12.47, also reachable via the same code path on
torvalds/master and on the ipsec tree). Nine unique signatures cluster
in the xfrm_state lifecycle, the load-bearing one being:

  BUG: KASAN: slab-use-after-free in __hlist_del include/linux/list.h:990 [inline]
  BUG: KASAN: slab-use-after-free in hlist_del_rcu include/linux/rculist.h:516 [inline]
  BUG: KASAN: slab-use-after-free in __xfrm_state_delete net/xfrm/xfrm_state.c
  Write of size 8 at addr ffff8881198bcb70 by task kworker/u8:9/435

  Workqueue: netns cleanup_net
  Call Trace:
   __hlist_del / hlist_del_rcu
   __xfrm_state_delete
   xfrm_state_delete
   xfrm_state_flush
   xfrm_state_fini
   ops_exit_list
   cleanup_net

The other observed signatures hit the same slab object from
__xfrm_state_lookup, xfrm_alloc_spi, __xfrm_state_insert and an OOB
write variant of __xfrm_state_delete, all on the byseq/byspi
hash chains.

__xfrm_state_delete() guards its byseq and byspi unhashes with
value-based predicates:

	if (x->km.seq)
		hlist_del_rcu(&x->byseq);
	if (x->id.spi)
		hlist_del_rcu(&x->byspi);

while everywhere else in the file (e.g. state_cache, state_cache_input)
the safer hlist_unhashed() check is used. xfrm_alloc_spi() sets
x->id.spi = newspi inside xfrm_state_lock and then immediately inserts
into byspi, but a path that observes x->id.spi != 0 outside of
xfrm_state_lock can still skip-or-hit the byspi unhash inconsistently
with whether x is actually on the list. The same holds for x->km.seq
versus byseq, and the bydst/bysrc unhashes have no predicate at all,
so a second __xfrm_state_delete() on the same object writes through
LIST_POISON pprev.

The defensive change here:

  - Use hlist_del_init_rcu() instead of hlist_del_rcu() on bydst,
    bysrc, byseq and byspi so a second deletion is a no-op rather
    than a write through LIST_POISON pprev. The byseq/byspi nodes
    are already initialised in xfrm_state_alloc().
  - Test hlist_unhashed() rather than the value predicate for
    byseq/byspi, so the unhash decision tracks list state rather than
    mutable scalar fields.

Empirical verification: applied this patch on top of v6.12.47, rebuilt,
and re-ran the same syzkaller harness for 1h16m on a previously-crashy
configuration that produced ~100 hits each of slab-use-after-free
Read in xfrm_alloc_spi / Read in __xfrm_state_lookup / Write in
__xfrm_state_delete. After the patch, 7.1M execs across 32 VMs at
~1550 exec/sec produced zero xfrm_state UAF/OOB hits. /proc/slabinfo
confirms the xfrm_state slab is actively allocated and freed during
the run (~143 KiB resident), so the fuzzer is still exercising those
code paths -- they just no longer crash.

Reproduction:

  - Linux 6.12.47 x86_64 + KASAN_GENERIC + KASAN_INLINE + KCOV
  - syzkaller @ 746545b8b1e4c3a128db8652b340d3df90ce61db
  - 32 QEMU/KVM VMs x 2 vCPU on AWS c5.metal bare metal
  - 9 unique signatures collected in ~9h, all within xfrm_state
    lifecycle

Fixes: fe9f1d8779cb ("xfrm: add state hashtable keyed by seq")
Fixes: 7b4dc3600e48 ("[XFRM]: Do not add a state whose SPI is zero to the SPI hash.")
Reported-by: Michal Kosiorek <mkosiorek121@gmail.com>
Tested-by: Michal Kosiorek <mkosiorek121@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Michal Kosiorek <mkosiorek121@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_state.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -818,17 +818,17 @@ int __xfrm_state_delete(struct xfrm_stat
 
 		spin_lock(&net->xfrm.xfrm_state_lock);
 		list_del(&x->km.all);
-		hlist_del_rcu(&x->bydst);
-		hlist_del_rcu(&x->bysrc);
-		if (x->km.seq)
-			hlist_del_rcu(&x->byseq);
+		hlist_del_init_rcu(&x->bydst);
+		hlist_del_init_rcu(&x->bysrc);
+		if (!hlist_unhashed(&x->byseq))
+			hlist_del_init_rcu(&x->byseq);
 		if (!hlist_unhashed(&x->state_cache))
 			hlist_del_rcu(&x->state_cache);
 		if (!hlist_unhashed(&x->state_cache_input))
 			hlist_del_rcu(&x->state_cache_input);
 
-		if (x->id.spi)
-			hlist_del_rcu(&x->byspi);
+		if (!hlist_unhashed(&x->byspi))
+			hlist_del_init_rcu(&x->byspi);
 		net->xfrm.state_num--;
 		xfrm_nat_keepalive_state_updated(x);
 		spin_unlock(&net->xfrm.xfrm_state_lock);


