Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6176B1C07C7;
	Tue, 15 Oct 2024 12:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996971; cv=none; b=e9jFLJ1NyFy8Q6gRyLAlNgsBTTiEzFdSgRkvIKOS8CnNadWBoBUUqdVn82L6/bZw688DDQr2HpWH9hxa8RFD/YJ/KG5EGvnKGWigB04TEdIYFWjs17WWJM/N3poReLIs5UtiupJJp9N14nilqugrcQOd/Rszttn7rFDs7Ash5wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996971; c=relaxed/simple;
	bh=UUyh5W1bufEOYrhWRjunLFYiMTa8mFouovjZl3RLqVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skA2pwSBowKdZFGp3vRRiJOSjt++5uoPqb89TzlvWh0SAwSEbo8HAo3PCBC7eviSt2uRuarkz9Xik/OCy7rLkGjCMGbtHk27YAPiUdk4AaFXEJcXbP+psQcoMiZ4Czfc5ikw96+5hjhBUiEYe8KXwnb/7/SIjHZsT1JdxnfZEIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgiFzkc2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgiFzkc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C761CC4CEC6;
	Tue, 15 Oct 2024 12:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996971;
	bh=UUyh5W1bufEOYrhWRjunLFYiMTa8mFouovjZl3RLqVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgiFzkc2gdzD4GKNBKkdgaewZMXAkvmEDdoPbTVaoEyzIqXpvktBmbWTm+gy91byn
	 PMtn7aYmCtU47eX4pdQw2/lcjLostX/omnR66TLTJV4p2aUM67+C4DJBHkFCRzXEE0
	 qRmdhdNx1IRDEN7YdgsPhnDgO4aTROh/pt7OJ6ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.10 052/518] x86/ibt,ftrace: Search for __fentry__ location
Date: Tue, 15 Oct 2024 14:39:16 +0200
Message-ID: <20241015123919.022008439@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit aebfd12521d9c7d0b502cf6d06314cfbcdccfe3b upstream.

Currently a lot of ftrace code assumes __fentry__ is at sym+0. However
with Intel IBT enabled the first instruction of a function will most
likely be ENDBR.

Change ftrace_location() to not only return the __fentry__ location
when called for the __fentry__ location, but also when called for the
sym+0 location.

Then audit/update all callsites of this function to consistently use
these new semantics.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220308154318.227581603@infradead.org
Stable-dep-of: e60b613df8b6 ("ftrace: Fix possible use-after-free issue in ftrace_location()")
[Shivani: Modified to apply on v5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kprobes/core.c |   11 +--------
 kernel/bpf/trampoline.c        |   20 +++--------------
 kernel/kprobes.c               |    8 +-----
 kernel/trace/ftrace.c          |   48 ++++++++++++++++++++++++++++++++++-------
 4 files changed, 48 insertions(+), 39 deletions(-)

--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -194,17 +194,10 @@ static unsigned long
 __recover_probed_insn(kprobe_opcode_t *buf, unsigned long addr)
 {
 	struct kprobe *kp;
-	unsigned long faddr;
+	bool faddr;
 
 	kp = get_kprobe((void *)addr);
-	faddr = ftrace_location(addr);
-	/*
-	 * Addresses inside the ftrace location are refused by
-	 * arch_check_ftrace_location(). Something went terribly wrong
-	 * if such an address is checked here.
-	 */
-	if (WARN_ON(faddr && faddr != addr))
-		return 0UL;
+	faddr = ftrace_location(addr) == addr;
 	/*
 	 * Use the current code if it is not modified by Kprobe
 	 * and it cannot be modified by ftrace.
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -87,18 +87,6 @@ out:
 	return tr;
 }
 
-static int is_ftrace_location(void *ip)
-{
-	long addr;
-
-	addr = ftrace_location((long)ip);
-	if (!addr)
-		return 0;
-	if (WARN_ON_ONCE(addr != (long)ip))
-		return -EFAULT;
-	return 1;
-}
-
 static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
 {
 	void *ip = tr->func.addr;
@@ -127,12 +115,12 @@ static int modify_fentry(struct bpf_tram
 static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 {
 	void *ip = tr->func.addr;
+	unsigned long faddr;
 	int ret;
 
-	ret = is_ftrace_location(ip);
-	if (ret < 0)
-		return ret;
-	tr->func.ftrace_managed = ret;
+	faddr = ftrace_location((unsigned long)ip);
+	if (faddr)
+		tr->func.ftrace_managed = true;
 
 	if (tr->func.ftrace_managed)
 		ret = register_ftrace_direct((long)ip, (long)new_addr);
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1609,14 +1609,10 @@ static inline int check_kprobe_rereg(str
 
 int __weak arch_check_ftrace_location(struct kprobe *p)
 {
-	unsigned long ftrace_addr;
+	unsigned long addr = (unsigned long)p->addr;
 
-	ftrace_addr = ftrace_location((unsigned long)p->addr);
-	if (ftrace_addr) {
+	if (ftrace_location(addr) == addr) {
 #ifdef CONFIG_KPROBES_ON_FTRACE
-		/* Given address is not on the instruction boundary */
-		if ((unsigned long)p->addr != ftrace_addr)
-			return -EILSEQ;
 		p->flags |= KPROBE_FLAG_FTRACE;
 #else	/* !CONFIG_KPROBES_ON_FTRACE */
 		return -EINVAL;
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1575,17 +1575,34 @@ unsigned long ftrace_location_range(unsi
 }
 
 /**
- * ftrace_location - return true if the ip giving is a traced location
+ * ftrace_location - return the ftrace location
  * @ip: the instruction pointer to check
  *
- * Returns rec->ip if @ip given is a pointer to a ftrace location.
- * That is, the instruction that is either a NOP or call to
- * the function tracer. It checks the ftrace internal tables to
- * determine if the address belongs or not.
+ * If @ip matches the ftrace location, return @ip.
+ * If @ip matches sym+0, return sym's ftrace location.
+ * Otherwise, return 0.
  */
 unsigned long ftrace_location(unsigned long ip)
 {
-	return ftrace_location_range(ip, ip);
+	struct dyn_ftrace *rec;
+	unsigned long offset;
+	unsigned long size;
+
+	rec = lookup_rec(ip, ip);
+	if (!rec) {
+		if (!kallsyms_lookup_size_offset(ip, &size, &offset))
+			goto out;
+
+		/* map sym+0 to __fentry__ */
+		if (!offset)
+			rec = lookup_rec(ip, ip + size - 1);
+	}
+
+	if (rec)
+		return rec->ip;
+
+out:
+	return 0;
 }
 
 /**
@@ -4948,7 +4965,8 @@ ftrace_match_addr(struct ftrace_hash *ha
 {
 	struct ftrace_func_entry *entry;
 
-	if (!ftrace_location(ip))
+	ip = ftrace_location(ip);
+	if (!ip)
 		return -EINVAL;
 
 	if (remove) {
@@ -5096,11 +5114,16 @@ int register_ftrace_direct(unsigned long
 	struct ftrace_func_entry *entry;
 	struct ftrace_hash *free_hash = NULL;
 	struct dyn_ftrace *rec;
-	int ret = -EBUSY;
+	int ret = -ENODEV;
 
 	mutex_lock(&direct_mutex);
 
+	ip = ftrace_location(ip);
+	if (!ip)
+		goto out_unlock;
+
 	/* See if there's a direct function at @ip already */
+	ret = -EBUSY;
 	if (ftrace_find_rec_direct(ip))
 		goto out_unlock;
 
@@ -5229,6 +5252,10 @@ int unregister_ftrace_direct(unsigned lo
 
 	mutex_lock(&direct_mutex);
 
+	ip = ftrace_location(ip);
+	if (!ip)
+		goto out_unlock;
+
 	entry = find_direct_entry(&ip, NULL);
 	if (!entry)
 		goto out_unlock;
@@ -5360,6 +5387,11 @@ int modify_ftrace_direct(unsigned long i
 	mutex_lock(&direct_mutex);
 
 	mutex_lock(&ftrace_lock);
+
+	ip = ftrace_location(ip);
+	if (!ip)
+		goto out_unlock;
+
 	entry = find_direct_entry(&ip, &rec);
 	if (!entry)
 		goto out_unlock;


