Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F13592210;
	Wed,  9 Sep 2026 14:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963559; cv=none; b=ad+TN969kdpd5srMEYtqDE/R0JB2MYiUgKKE6jDsu6BV7H2VwMY+JD3BVwlGId92QIm2vX+ypjtatTPVLOUGOn1vfrkrNy/hj+cEJJXs5bm32igUjxLY/GQLk7FtjhkoTdwqHYVzTFoxPbKH9HGrOj/DcnBb3gDJ1JI9UbxuaoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963559; c=relaxed/simple;
	bh=NV8Hk2t1YMWPg8xBTTa3sycEQ62pzfq6sFfYLmlKXJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWZ1C8ZH8hwMLxXzgCTvUM3UFgtGVrpX2b1bMiYIRaLIuY+GsvMeUsQ4xI2OQEXZex9TDPgeA2ZKjaSbkjs7ljKl2RWvcb832JaB5POp5PcQ7KNiZsfARlyBfS1+rpGgZXZs4WWFpzw4XkY+IRgoMj6i5G9iSzR6cSoRss584ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDWyVz/4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDWyVz/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E9F1F00A3D;
	Wed,  9 Sep 2026 14:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963557;
	bh=9krjdHUV8Nncv/j3Gl7eE7N7U5oWBjlixAEM1zKneU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDWyVz/4RcDMQ1aib+8Ao/ArwejDS+xcWpzdFIwlmkRROl0+S4WmeWdLDNrriB7Vc
	 ph4QVNk3vzA4gukW7XJGE6vdp3lmJF2/eKUofSvjYkZrHPZbqoggjWNv3O1NnFq1YE
	 L8JCg9nqL0tj+/L+FB4Y6PhjNB09DjNZAF2A/+nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 082/583] kprobes: Protect kprobe_blacklist with RCU
Date: Wed,  9 Sep 2026 15:36:07 +0200
Message-ID: <20260909134240.958816947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -1373,8 +1373,14 @@ static bool __within_kprobe_blacklist(un
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
@@ -2435,7 +2441,7 @@ int kprobe_add_ksym_blacklist(unsigned l
 	ent->start_addr = entry;
 	ent->end_addr = entry + size;
 	INIT_LIST_HEAD(&ent->list);
-	list_add_tail(&ent->list, &kprobe_blacklist);
+	list_add_tail_rcu(&ent->list, &kprobe_blacklist);
 
 	return (int)size;
 }
@@ -2529,8 +2535,8 @@ static void kprobe_remove_area_blacklist
 	list_for_each_entry_safe(ent, n, &kprobe_blacklist, list) {
 		if (ent->start_addr < start || ent->start_addr >= end)
 			continue;
-		list_del(&ent->list);
-		kfree(ent);
+		list_del_rcu(&ent->list);
+		kfree_rcu(ent, rcu);
 	}
 }
 


