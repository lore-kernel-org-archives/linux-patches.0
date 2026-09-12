Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5820233BBAF;
	Sat, 12 Sep 2026 13:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221338; cv=none; b=pSPCUM97t1HMjm5Uthl/T/ba9g+34zudYs2bFr4+yHcQvN/z8iV7R0JvkZ5TnHK4xHezkSVxIdUTiF1fiJovWppSYCWYo3Sih16fMS9d4sSjiYYWNwD3K7ApH9o3IPG0Bcnj/BzfOBVduZQyCDYwwt1z0Bgb8uCmZmpTgJndqgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221338; c=relaxed/simple;
	bh=xNBisfIygmRDNxnC3+NF85SbFdV2kPtBA76v70ln5GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eolQs5s5v8cp2Lnkx6OF79GR5NAgyvZWJncLlsxDy7D4lDQDiOPYRFwefUk4xFHhhBWtDztbgvuDa3NPH/90LuQlB/1eWJYijY3EwyBC9Og0dersyiBKo3lDgK5pl+EPGncAe/kzHh+24kkap0WjPpPRRqVmr5fXAXGtNfYI4Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmwCbXMl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmwCbXMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73421F00893;
	Sat, 12 Sep 2026 13:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221327;
	bh=36LrI1BPnONLPJbaZAWyR+7U7d3gtagIgeIwCE8bFKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmwCbXMllGLEvHBGd+M839o9hHPC03UO7DZmzu3sag79iNHT2TvVpJAkx9UHFqwYw
	 z5xZ6QIz+MneiWtyE+JJcF9b+3xq4yNMpNelrMJME9x+PYNaqk658T7pfJUaLWg6Zh
	 XjH+a67JtwhC5AbHyhaurjgZkVFfhtPsY/+eJ92g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 0361/1424] kprobes: Protect kprobe_blacklist with RCU
Date: Sat, 12 Sep 2026 08:46:33 +0200
Message-ID: <20260912065615.373951954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -186,6 +186,7 @@ struct kprobe_blacklist_entry {
 	struct list_head list;
 	unsigned long start_addr;
 	unsigned long end_addr;
+	struct rcu_head rcu;
 };
 
 #ifdef CONFIG_KPROBES
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1394,8 +1394,14 @@ static bool __within_kprobe_blacklist(un
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
@@ -2487,7 +2493,7 @@ int kprobe_add_ksym_blacklist(unsigned l
 	ent->start_addr = entry;
 	ent->end_addr = entry + size;
 	INIT_LIST_HEAD(&ent->list);
-	list_add_tail(&ent->list, &kprobe_blacklist);
+	list_add_tail_rcu(&ent->list, &kprobe_blacklist);
 
 	return (int)size;
 }
@@ -2516,8 +2522,8 @@ static void kprobe_remove_area_blacklist
 	list_for_each_entry_safe(ent, n, &kprobe_blacklist, list) {
 		if (ent->start_addr < start || ent->start_addr >= end)
 			continue;
-		list_del(&ent->list);
-		kfree(ent);
+		list_del_rcu(&ent->list);
+		kfree_rcu(ent, rcu);
 	}
 }
 


