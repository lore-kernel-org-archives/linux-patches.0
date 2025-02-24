Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7450C2747B;
	Mon, 24 Feb 2025 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409256; cv=none; b=jKBudKVKQDYgVW2+ZWhxitdoxdfeLFfCcQB4NCqD6ttD9MB7jh04I9dFQ9DxIVCyyX0BtyFMc9/UtKh1AWJJZYbEPHf2iA7PZXy3L4eUrMeP1s52zfmWK55N5Fe+B7wtEEKCSnPEPlQSmpvvITJTikoqOueBXLZOkMV6x+9AQVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409256; c=relaxed/simple;
	bh=cCG/2J39BZcCU8OJY2Niby1Gn3CcI1ECWvAuVvcV0ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipaDe1QwwcjmbzHZVA3Al7EmHDU4/8X3uJYqFYpAv96iNxr+Pwz3tc4mN/syK2tuqNx4Yzjd3UszRX56OsDMzdrAsC5MXEt3jOeajX7lHDP0oFmcVXRpY0VUeg7FQLzrRwzY19vpquIMsNOCuJzDk37ARwIPMGOM8AxvxTt5pb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRaFGAvQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRaFGAvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42875C4CED6;
	Mon, 24 Feb 2025 15:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409255;
	bh=cCG/2J39BZcCU8OJY2Niby1Gn3CcI1ECWvAuVvcV0ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRaFGAvQOyHJOR9LrQVwRQWQgCG0yMpfa0Rahf8w71zjziFyJoNxSV/w8FT0CrUp+
	 fqYMiz/NoaTKUB03nrt/rb/FMNJxfuugs0HDWCbZxsiGHuCtD7g0G1iWJ9cWc6lA32
	 xwVQVnc+Y1FA7zONgj9Roz2seQ0zmBaJ881y1iGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 132/138] ftrace: Fix accounting of adding subops to a manager ops
Date: Mon, 24 Feb 2025 15:36:02 +0100
Message-ID: <20250224142609.657156585@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 38b14061947fa546491656e3f5e388d4fedf8dba upstream.

Function graph uses a subops and manager ops mechanism to attach to
ftrace.  The manager ops connects to ftrace and the functions it connects
to is defined by a list of subops that it manages.

The function hash that defines what the above ops attaches to limits the
functions to attach if the hash has any content. If the hash is empty, it
means to trace all functions.

The creation of the manager ops hash is done by iterating over all the
subops hashes. If any of the subops hashes is empty, it means that the
manager ops hash must trace all functions as well.

The issue is in the creation of the manager ops. When a second subops is
attached, a new hash is created by starting it as NULL and adding the
subops one at a time. But the NULL ops is mistaken as an empty hash, and
once an empty hash is found, it stops the loop of subops and just enables
all functions.

  # echo "f:myevent1 kernel_clone" >> /sys/kernel/tracing/dynamic_events
  # cat /sys/kernel/tracing/enabled_functions
kernel_clone (1)           	tramp: 0xffffffffc0309000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60

  # echo "f:myevent2 schedule_timeout" >> /sys/kernel/tracing/dynamic_events
  # cat /sys/kernel/tracing/enabled_functions
trace_initcall_start_cb (1)             tramp: 0xffffffffc0309000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60
run_init_process (1)            tramp: 0xffffffffc0309000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60
try_to_run_init_process (1)             tramp: 0xffffffffc0309000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60
x86_pmu_show_pmu_cap (1)                tramp: 0xffffffffc0309000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60
cleanup_rapl_pmus (1)                   tramp: 0xffffffffc0309000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60
uncore_free_pcibus_map (1)              tramp: 0xffffffffc0309000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60
uncore_types_exit (1)                   tramp: 0xffffffffc0309000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60
uncore_pci_exit.part.0 (1)              tramp: 0xffffffffc0309000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60
kvm_shutdown (1)                tramp: 0xffffffffc0309000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60
vmx_dump_msrs (1)               tramp: 0xffffffffc0309000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60
vmx_cleanup_l1d_flush (1)               tramp: 0xffffffffc0309000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60
[..]

Fix this by initializing the new hash to NULL and if the hash is NULL do
not treat it as an empty hash but instead allocate by copying the content
of the first sub ops. Then on subsequent iterations, the new hash will not
be NULL, but the content of the previous subops. If that first subops
attached to all functions, then new hash may assume that the manager ops
also needs to attach to all functions.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Link: https://lore.kernel.org/20250220202055.060300046@goodmis.org
Fixes: 5fccc7552ccbc ("ftrace: Add subops logic to allow one ops to manage many")
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3238,15 +3238,22 @@ static struct ftrace_hash *copy_hash(str
  *  The filter_hash updates uses just the append_hash() function
  *  and the notrace_hash does not.
  */
-static int append_hash(struct ftrace_hash **hash, struct ftrace_hash *new_hash)
+static int append_hash(struct ftrace_hash **hash, struct ftrace_hash *new_hash,
+		       int size_bits)
 {
 	struct ftrace_func_entry *entry;
 	int size;
 	int i;
 
-	/* An empty hash does everything */
-	if (ftrace_hash_empty(*hash))
-		return 0;
+	if (*hash) {
+		/* An empty hash does everything */
+		if (ftrace_hash_empty(*hash))
+			return 0;
+	} else {
+		*hash = alloc_ftrace_hash(size_bits);
+		if (!*hash)
+			return -ENOMEM;
+	}
 
 	/* If new_hash has everything make hash have everything */
 	if (ftrace_hash_empty(new_hash)) {
@@ -3310,16 +3317,18 @@ static int intersect_hash(struct ftrace_
 /* Return a new hash that has a union of all @ops->filter_hash entries */
 static struct ftrace_hash *append_hashes(struct ftrace_ops *ops)
 {
-	struct ftrace_hash *new_hash;
+	struct ftrace_hash *new_hash = NULL;
 	struct ftrace_ops *subops;
+	int size_bits;
 	int ret;
 
-	new_hash = alloc_ftrace_hash(ops->func_hash->filter_hash->size_bits);
-	if (!new_hash)
-		return NULL;
+	if (ops->func_hash->filter_hash)
+		size_bits = ops->func_hash->filter_hash->size_bits;
+	else
+		size_bits = FTRACE_HASH_DEFAULT_BITS;
 
 	list_for_each_entry(subops, &ops->subop_list, list) {
-		ret = append_hash(&new_hash, subops->func_hash->filter_hash);
+		ret = append_hash(&new_hash, subops->func_hash->filter_hash, size_bits);
 		if (ret < 0) {
 			free_ftrace_hash(new_hash);
 			return NULL;
@@ -3328,7 +3337,8 @@ static struct ftrace_hash *append_hashes
 		if (ftrace_hash_empty(new_hash))
 			break;
 	}
-	return new_hash;
+	/* Can't return NULL as that means this failed */
+	return new_hash ? : EMPTY_HASH;
 }
 
 /* Make @ops trace evenything except what all its subops do not trace */
@@ -3523,7 +3533,8 @@ int ftrace_startup_subops(struct ftrace_
 		filter_hash = alloc_and_copy_ftrace_hash(size_bits, ops->func_hash->filter_hash);
 		if (!filter_hash)
 			return -ENOMEM;
-		ret = append_hash(&filter_hash, subops->func_hash->filter_hash);
+		ret = append_hash(&filter_hash, subops->func_hash->filter_hash,
+				  size_bits);
 		if (ret < 0) {
 			free_ftrace_hash(filter_hash);
 			return ret;


