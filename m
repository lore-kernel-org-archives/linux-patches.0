Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F4F5102A;
	Mon, 11 Dec 2023 18:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvQPCIGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F401EC433CA;
	Mon, 11 Dec 2023 18:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320542;
	bh=/5N5nUh8IAdRZ99HHJkaH5f0ejuwBdi2J53DZoxSB9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvQPCIGC0oKIPEhapCAj872auHMQg3csN0N73nx9fCp0mbt6qW1bA8T6k0PU8sDgz
	 U7SGxxcay+bB08a/Eb0nzgoxwIu8F6qA+JZeBHUSONHm2stegkJgcbAf4Kh/lVXRLg
	 cZ3LpVzahNrrXa93vST7XURRZerrMSW10sGtWxwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	JP Kobryn <inwardvessel@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 099/194] rethook: Use __rcu pointer for rethook::handler
Date: Mon, 11 Dec 2023 19:21:29 +0100
Message-ID: <20231211182040.865904838@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit a1461f1fd6cfdc4b8917c9d4a91e92605d1f28dc upstream.

Since the rethook::handler is an RCU-maganged pointer so that it will
notice readers the rethook is stopped (unregistered) or not, it should
be an __rcu pointer and use appropriate functions to be accessed. This
will use appropriate memory barrier when accessing it. OTOH,
rethook::data is never changed, so we don't need to check it in
get_kretprobe().

NOTE: To avoid sparse warning, rethook::handler is defined by a raw
function pointer type with __rcu instead of rethook_handler_t.

Link: https://lore.kernel.org/all/170126066201.398836.837498688669005979.stgit@devnote2/

Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311241808.rv9ceuAh-lkp@intel.com/
Tested-by: JP Kobryn <inwardvessel@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kprobes.h |    6 ++----
 include/linux/rethook.h |    7 ++++++-
 kernel/trace/rethook.c  |   23 ++++++++++++++---------
 3 files changed, 22 insertions(+), 14 deletions(-)

--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -202,10 +202,8 @@ extern int arch_trampoline_kprobe(struct
 #ifdef CONFIG_KRETPROBE_ON_RETHOOK
 static nokprobe_inline struct kretprobe *get_kretprobe(struct kretprobe_instance *ri)
 {
-	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
-		"Kretprobe is accessed from instance under preemptive context");
-
-	return (struct kretprobe *)READ_ONCE(ri->node.rethook->data);
+	/* rethook::data is non-changed field, so that you can access it freely. */
+	return (struct kretprobe *)ri->node.rethook->data;
 }
 static nokprobe_inline unsigned long get_kretprobe_retaddr(struct kretprobe_instance *ri)
 {
--- a/include/linux/rethook.h
+++ b/include/linux/rethook.h
@@ -29,7 +29,12 @@ typedef void (*rethook_handler_t) (struc
  */
 struct rethook {
 	void			*data;
-	rethook_handler_t	handler;
+	/*
+	 * To avoid sparse warnings, this uses a raw function pointer with
+	 * __rcu, instead of rethook_handler_t. But this must be same as
+	 * rethook_handler_t.
+	 */
+	void (__rcu *handler) (struct rethook_node *, void *, struct pt_regs *);
 	struct freelist_head	pool;
 	refcount_t		ref;
 	struct rcu_head		rcu;
--- a/kernel/trace/rethook.c
+++ b/kernel/trace/rethook.c
@@ -63,7 +63,7 @@ static void rethook_free_rcu(struct rcu_
  */
 void rethook_stop(struct rethook *rh)
 {
-	WRITE_ONCE(rh->handler, NULL);
+	rcu_assign_pointer(rh->handler, NULL);
 }
 
 /**
@@ -78,11 +78,17 @@ void rethook_stop(struct rethook *rh)
  */
 void rethook_free(struct rethook *rh)
 {
-	WRITE_ONCE(rh->handler, NULL);
+	rethook_stop(rh);
 
 	call_rcu(&rh->rcu, rethook_free_rcu);
 }
 
+static inline rethook_handler_t rethook_get_handler(struct rethook *rh)
+{
+	return (rethook_handler_t)rcu_dereference_check(rh->handler,
+							rcu_read_lock_any_held());
+}
+
 /**
  * rethook_alloc() - Allocate struct rethook.
  * @data: a data to pass the @handler when hooking the return.
@@ -102,7 +108,7 @@ struct rethook *rethook_alloc(void *data
 	}
 
 	rh->data = data;
-	rh->handler = handler;
+	rcu_assign_pointer(rh->handler, handler);
 	rh->pool.head = NULL;
 	refcount_set(&rh->ref, 1);
 
@@ -142,9 +148,10 @@ static void free_rethook_node_rcu(struct
  */
 void rethook_recycle(struct rethook_node *node)
 {
-	lockdep_assert_preemption_disabled();
+	rethook_handler_t handler;
 
-	if (likely(READ_ONCE(node->rethook->handler)))
+	handler = rethook_get_handler(node->rethook);
+	if (likely(handler))
 		freelist_add(&node->freelist, &node->rethook->pool);
 	else
 		call_rcu(&node->rcu, free_rethook_node_rcu);
@@ -160,11 +167,9 @@ NOKPROBE_SYMBOL(rethook_recycle);
  */
 struct rethook_node *rethook_try_get(struct rethook *rh)
 {
-	rethook_handler_t handler = READ_ONCE(rh->handler);
+	rethook_handler_t handler = rethook_get_handler(rh);
 	struct freelist_node *fn;
 
-	lockdep_assert_preemption_disabled();
-
 	/* Check whether @rh is going to be freed. */
 	if (unlikely(!handler))
 		return NULL;
@@ -312,7 +317,7 @@ unsigned long rethook_trampoline_handler
 		rhn = container_of(first, struct rethook_node, llist);
 		if (WARN_ON_ONCE(rhn->frame != frame))
 			break;
-		handler = READ_ONCE(rhn->rethook->handler);
+		handler = rethook_get_handler(rhn->rethook);
 		if (handler)
 			handler(rhn, rhn->rethook->data, regs);
 


