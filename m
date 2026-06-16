Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8F643E9FD;
	Tue, 16 Jun 2026 15:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623016; cv=none; b=qPT6kmeW1IhWKrIQJeOgal9y7Xs4I7w4S79PeoIXFzYXAoIIiilfIA30Gk74FXWeJH/tcA0D6i+473OeHO9BTQsVKOgmpaTGk/ilzKM97ZK0VMmltpm2xQGVV08jmA9IRpE8zIMmsbHDjDq+PY4dDBe5V7/kSo2247wyqO/Uvew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623016; c=relaxed/simple;
	bh=dOGQkbE3NU/PzLl6z3B4fbUasK221LAgvLiFb0MfpBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fie+UWxan9YYUs51U39tVwPTFEtDQDUwV5NljmWoxTMu8/pQ9LyTd/jKQlJ+6mGg8RO9gTGUstPfaa+nqBinqzhp1+MknxKl/cLauk9zTmUC7wD0oqHdgjN2OfEQNyfS0pUdOVz6Q+t6fkHHE2hWGR+mEfvlrDlp2RDDzIQwCmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qq6pxMMu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qq6pxMMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED1A1F000E9;
	Tue, 16 Jun 2026 15:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623014;
	bh=sBQ53rtrG0C9ZUQKXO3w12OUAiYTSBx/g29sn3f28Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qq6pxMMuueFFFJ8na/BLBHLU3NePkgSgcwd7hhEstpgoP9QfXw4pJ4RiESbrcYf0q
	 jX7euucDGfYFpakmtw6/bgqSDGtjeFCjHuLZYKOLRozILJc5i7AJDz5Ta3gtGNgfWW
	 kM2rjXbxV3FpFJj14uLi3ER0rTGLnq3TEJmRlVOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+819eb928d120d2bdad0e@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 039/378] ipv6: anycast: insert aca into global hash under idev->lock
Date: Tue, 16 Jun 2026 20:24:30 +0530
Message-ID: <20260616145111.953967878@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit f723ccaff2fb72b71ae8a9fd283f0dee4d9ae7a3 ]

syzbot reported a splat [1]: a slab-use-after-free in
ipv6_chk_acast_addr(), which walks the global inet6_acaddr_lst[] hash
under RCU and dereferences a struct ifacaddr6 that has already been
freed while still linked in the hash, so a later reader walks into a
dangling node.

In __ipv6_dev_ac_inc() the aca is allocated with refcount 1, then
aca_get() bumps it to 2 to keep it alive across the unlocked region.
It is published to idev->ac_list under idev->lock, but
ipv6_add_acaddr_hash() runs after write_unlock_bh(). A concurrent
teardown (ipv6_ac_destroy_dev() from addrconf_ifdown(), under RTNL)
can slip into that window:

  CPU0 __ipv6_dev_ac_inc           CPU1 ipv6_ac_destroy_dev (RTNL)
  ------------------------------   ------------------------------------
  aca_alloc()              refcnt 1
  aca_get()               refcnt 2
  write_lock_bh(idev->lock)
    add aca to ac_list
  write_unlock_bh(idev->lock)
                                   write_lock_bh(idev->lock)
                                     pull aca off ac_list
                                   write_unlock_bh(idev->lock)
                                   ipv6_del_acaddr_hash(aca)
                                     hlist_del_init_rcu() is a no-op,
                                     aca is not in the hash yet
                                   aca_put()           refcnt 2->1
  ipv6_add_acaddr_hash(aca)
    aca now inserted into the hash
  aca_put()                refcnt 1->0
    call_rcu(aca_free_rcu) -> kfree(aca)

The hash removal becomes a no-op because the insertion has not
happened yet, so once CPU0 inserts and drops the last reference, the
aca is freed while still linked in inet6_acaddr_lst[], and readers
dereference freed memory after the slab slot is reused.

This window opened once RTNL stopped serializing the join path against
device teardown. Move ipv6_add_acaddr_hash() inside the idev->lock
section so the ac_list and hash insertions are atomic with respect to
teardown: a racing remover now either misses the aca entirely or finds
it in both lists.

acaddr_hash_lock is now nested under idev->lock, which is acquired in
softirq context, so switch all acaddr_hash_lock sites to spin_lock_bh()
to avoid the irq lock inversion reported in [2].

[1] https://syzkaller.appspot.com/bug?extid=a01df04303c131efbf3a
[2] https://lore.kernel.org/netdev/6a194ef7.ba3b1513.1890b4.0000.GAE@google.com/

Reported-by: syzbot+819eb928d120d2bdad0e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a191f87.ce022c6e.138e56.0003.GAE@google.com/T/
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Fixes: eb1ac9ff6c4a ("ipv6: anycast: Don't hold RTNL for IPV6_JOIN_ANYCAST.")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260529152219.235475-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/anycast.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
index 67a42e01dfc3f0..be6dac8a8566a1 100644
--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -243,16 +243,16 @@ static void ipv6_add_acaddr_hash(struct net *net, struct ifacaddr6 *aca)
 {
 	unsigned int hash = inet6_acaddr_hash(net, &aca->aca_addr);
 
-	spin_lock(&acaddr_hash_lock);
+	spin_lock_bh(&acaddr_hash_lock);
 	hlist_add_head_rcu(&aca->aca_addr_lst, &inet6_acaddr_lst[hash]);
-	spin_unlock(&acaddr_hash_lock);
+	spin_unlock_bh(&acaddr_hash_lock);
 }
 
 static void ipv6_del_acaddr_hash(struct ifacaddr6 *aca)
 {
-	spin_lock(&acaddr_hash_lock);
+	spin_lock_bh(&acaddr_hash_lock);
 	hlist_del_init_rcu(&aca->aca_addr_lst);
-	spin_unlock(&acaddr_hash_lock);
+	spin_unlock_bh(&acaddr_hash_lock);
 }
 
 static void aca_get(struct ifacaddr6 *aca)
@@ -371,10 +371,10 @@ int __ipv6_dev_ac_inc(struct inet6_dev *idev, const struct in6_addr *addr)
 	aca->aca_next = idev->ac_list;
 	rcu_assign_pointer(idev->ac_list, aca);
 
-	write_unlock_bh(&idev->lock);
-
 	ipv6_add_acaddr_hash(net, aca);
 
+	write_unlock_bh(&idev->lock);
+
 	ip6_ins_rt(net, f6i);
 
 	addrconf_join_solict(idev->dev, &aca->aca_addr);
@@ -649,8 +649,8 @@ void ipv6_anycast_cleanup(void)
 {
 	int i;
 
-	spin_lock(&acaddr_hash_lock);
+	spin_lock_bh(&acaddr_hash_lock);
 	for (i = 0; i < IN6_ADDR_HSIZE; i++)
 		WARN_ON(!hlist_empty(&inet6_acaddr_lst[i]));
-	spin_unlock(&acaddr_hash_lock);
+	spin_unlock_bh(&acaddr_hash_lock);
 }
-- 
2.53.0



