Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4292C4C6803;
	Wed,  9 Sep 2026 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962005; cv=none; b=hoHCYF+UuQTcMSjJx9xx/+r1UC/elpk0lBo9sd6WACT4ct0vyRoXwEFjHhD3Vw+HK+32jIwCxqGEL5cX0kvZGdWyim2y98Z5z3rm9R2KM9pqo2hGf30XFpyhXJgrn6YJU3TYL4/qFYPGzLBwEkZ6hPomu589i2WrMyjOlbA79jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962005; c=relaxed/simple;
	bh=JMZFk7Rw9StiV8lAVf80TZls0c7jotDI89q8+DAEnxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlPy32AWh5a/sej+ICfIOLNUzZPZ1fUX4ECoMwn66lMlQtBgSpX1ntzKqvjAw0p3rljGhKimr0SqFKJQiVBKHlXf9u7sI9jGV4P4SwC8K/CFB6NFn4T3P+VIuP20/eoR0mozC9VUSdOm2DSwQiOLFiLwOl6qoT9u4WSOrHcLgaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPMxy1A7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPMxy1A7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921D31F00A3A;
	Wed,  9 Sep 2026 13:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962004;
	bh=dDRtgHTqhfoYMQdCAt3OjbVMEzGCq7Fnxy5gm26Yyvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPMxy1A7lB0IdOHCnN9RzuEAJ+7hHG4pmUcS7UbfjEumIj5ykncbSywCXda3Ffz6m
	 T10q2Nx4f7SNxBVwfnuLG+YYKB9FN0TgvmsNvP63zSMWpoS9oMFOGfpqVr1BSpWuED
	 E3AyS/08SJ9zgn4lG7p79mKpILY9OU8Xdw3REylc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.2 123/556] kprobes: Protect kprobe_blacklist with RCU
Date: Wed,  9 Sep 2026 15:36:43 +0200
Message-ID: <20260909134234.788189548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 0c4256196b3a105307e2235fbfd85e768bbcdd0f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kprobes.h |    1 +
 kernel/kprobes.c        |   14 ++++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -181,6 +181,7 @@ struct kprobe_blacklist_entry {
 	struct list_head list;
 	unsigned long start_addr;
 	unsigned long end_addr;
+	struct rcu_head rcu;
 };
 
 #ifdef CONFIG_KPROBES
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1447,8 +1447,14 @@ static bool __within_kprobe_blacklist(un
 	/*
 	 * If 'kprobe_blacklist' is defined, check the address and
 	 * reject any probe registration in the prohibited area.
+	 * Note: this can return true during transition period where
+	 * (start_addr, end_addr) in the black list is shrinking
+	 * but old entry has not been removed yet. This is acceptable
+	 * because the worst case is that we reject more probes than
+	 * we should.
 	 */
-	list_for_each_entry(ent, &kprobe_blacklist, list) {
+	guard(rcu)();
+	list_for_each_entry_rcu(ent, &kprobe_blacklist, list) {
 		if (addr >= ent->start_addr && addr < ent->end_addr)
 			return true;
 	}
@@ -2509,7 +2515,7 @@ int kprobe_add_ksym_blacklist(unsigned l
 	ent->start_addr = entry;
 	ent->end_addr = entry + size;
 	INIT_LIST_HEAD(&ent->list);
-	list_add_tail(&ent->list, &kprobe_blacklist);
+	list_add_tail_rcu(&ent->list, &kprobe_blacklist);
 
 	return (int)size;
 }
@@ -2603,8 +2609,8 @@ static void kprobe_remove_area_blacklist
 	list_for_each_entry_safe(ent, n, &kprobe_blacklist, list) {
 		if (ent->start_addr < start || ent->start_addr >= end)
 			continue;
-		list_del(&ent->list);
-		kfree(ent);
+		list_del_rcu(&ent->list);
+		kfree_rcu(ent, rcu);
 	}
 }
 


