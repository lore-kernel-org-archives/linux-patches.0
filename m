Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208152;
	b=zp445LrVhmHGA5r1aoHYfOmE6RG7vR/PZpwW41svwa+gdfjfQc1Ao6O2KCG65v/mKPip
	 uIgpWWhIdUmcDa7g67qViHoWXfeNbxquSudgp1wp7jZvo0jsUZpShbbPxVfQOYS0Rr/w/
	 08JAnHYsQlSpXiWv1SBNJEd4RvhRtOSKYnaqoOcl7ON/etje5yHkNnQ8xoViIJ321XH8I
	 ouFy9M1MVENAegSas6XYaOJESJ+hoxNwjn7HXOMlzz5UVwSdHpWVZ3Ryf5/0aDzqOQVFQ
	 kHcWI+sATWRCaOCeFpc4jYchQM9PAhE0gGctVIrKOrh4lw8Hz64ycvApJupwOn+wM+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7f1Np7COhW3ocT8RKhFRjYg35M4T1b4lBHrmx3GGddY=;
	b=Zt/9bRioN+JrSbiQsM6Pzg5JdvlJ+SPhxcfH+I752oH0XXNb8z5M9ulJbmZMDfCx8qu+
	 DvEyDCOXfyX6ExwnxnwmzS9+Lfn8gvlAYGQeN2F8FO4r229ASwvNXNjxSL498Pjsj6jHB
	 cJJRaxqun+2cLi11ncpAIhaVrIfXsBQj41buku6CvIE9ehxsxyWxqDa6XzRF8t+IprhOH
	 o2Bp3fzsqhDdS0ifwg9aCk0FQyCM1f7RWrZnU7DuasM9o+gWinD6zewaFZSMCPb9d9NB4
	 d34rYOrxNIkEGqGNiHm+ZcmWzL+CohtqVlxYJelgWW2L0sxcpNdfF9z/5pWpbvkaqbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SgW4BvGR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6216A606A31A;
	Wed, 28 Oct 2026 17:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SgW4BvGR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAE41F01825;
	Wed, 28 Oct 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208152;
	bh=7f1Np7COhW3ocT8RKhFRjYg35M4T1b4lBHrmx3GGddY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SgW4BvGR/9H7TZzryLsyIPNJWGDiMrdaNnxFSYByySIO0+bl06oZI0Kxu2AIgtoHY
	 BrlzAqWQ6UxeXaDGa3uYgUxuSopv2ygwR7DHn3kd9CQjft1W0p7pZhUS+VP4k0T6Yz
	 66Rwivl4sRCQWdvnXe/5zlsRGaAhNz75ksn8iWk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/516] kprobes: Protect kprobe_blacklist with RCU
Date: Wed, 28 Oct 2026 17:52:52 +0100
Message-ID: <20261028170004.006022796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 0c4256196b3a105307e2235fbfd85e768bbcdd0f ]

__within_kprobe_blacklist() traverses kprobe_blacklist without holding
kprobe_mutex. When a module is unloaded, kprobe_remove_area_blacklist()
removes blacklist entries and immediately frees them with kfree().
A concurrent call to within_kprobe_blacklist() can therefore dereference
freed memory.

Furthermore, within_kprobe_blacklist() can be called in atomic or
non-preemptible contexts where the sleeping kprobe_mutex cannot be taken.

Protect kprobe_blacklist with RCU. Use guard(rcu)() and
list_for_each_entry_rcu() for traversal, list_add_tail_rcu() for
insertions, list_del_rcu() for deletions, and kfree_rcu() to reclaim
entries safely after a grace period.

Link: https://lore.kernel.org/all/178810004323.64882.16493230858653316962.stgit@devnote2/

Fixes: 376e242429bf ("kprobes: Introduce NOKPROBE_SYMBOL() macro to maintain kprobes blacklist")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260807155802.F06041F000E9@smtp.kernel.org/
Assisted-by: Antigravity:gemini-3.7-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
[ Replaced guard(rcu)() with explicit rcu_read_lock()/rcu_read_unlock() to avoid declaration-after-statement warnings. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kprobes.h |  1 +
 kernel/kprobes.c        | 19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 18b7c40ffb37a..71b15c923077e 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -178,6 +178,7 @@ struct kprobe_blacklist_entry {
 	struct list_head list;
 	unsigned long start_addr;
 	unsigned long end_addr;
+	struct rcu_head rcu;
 };
 
 #ifdef CONFIG_KPROBES
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 551ac118159f9..46398072b5bea 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1513,11 +1513,20 @@ static bool __within_kprobe_blacklist(unsigned long addr)
 	/*
 	 * If there exists a kprobe_blacklist, verify and
 	 * fail any probe registration in the prohibited area
+	 * Note: this can return true during transition period where
+	 * (start_addr, end_addr) in the black list is shrinking
+	 * but old entry has not been removed yet. This is acceptable
+	 * because the worst case is that we reject more probes than
+	 * we should.
 	 */
-	list_for_each_entry(ent, &kprobe_blacklist, list) {
-		if (addr >= ent->start_addr && addr < ent->end_addr)
+	rcu_read_lock();
+	list_for_each_entry_rcu(ent, &kprobe_blacklist, list) {
+		if (addr >= ent->start_addr && addr < ent->end_addr) {
+			rcu_read_unlock();
 			return true;
+		}
 	}
+	rcu_read_unlock();
 	return false;
 }
 
@@ -2388,7 +2397,7 @@ int kprobe_add_ksym_blacklist(unsigned long entry)
 	ent->start_addr = entry;
 	ent->end_addr = entry + size;
 	INIT_LIST_HEAD(&ent->list);
-	list_add_tail(&ent->list, &kprobe_blacklist);
+	list_add_tail_rcu(&ent->list, &kprobe_blacklist);
 
 	return (int)size;
 }
@@ -2417,8 +2426,8 @@ static void kprobe_remove_area_blacklist(unsigned long start, unsigned long end)
 	list_for_each_entry_safe(ent, n, &kprobe_blacklist, list) {
 		if (ent->start_addr < start || ent->start_addr >= end)
 			continue;
-		list_del(&ent->list);
-		kfree(ent);
+		list_del_rcu(&ent->list);
+		kfree_rcu(ent, rcu);
 	}
 }
 
-- 
2.53.0



