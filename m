Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FEBDF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39179C433D2;
	Mon, 15 May 2023 16:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168803;
	bh=1N7eNSNY1ukaWHXW3Xn2yQuREBJugGp2vtfk62fbrx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvym79zmUitlcH2cfFihMBuPgJp85Asza9IoIqmpPucEn/BZwQGPHa5otBD7+WUos
	 KLkB5Y14cRQn6Mn0klJkoXTLb4FJ+gvQwBgO6XUx5tu7m9OveUA7GkS1v1GclzGjq8
	 gnOXFeV//4Eq+hY60kvFsMFluk3Vrr4HoKfyYCBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yang Shi <yang.shi@linux.alibaba.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Qian Cai <cai@gmx.us>,
	Zhong Jiang <zhongjiang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/191] debugobjects: Move printk out of db->lock critical sections
Date: Mon, 15 May 2023 18:24:43 +0200
Message-Id: <20230515161708.872191992@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Waiman Long <longman@redhat.com>

[ Upstream commit d5f34153e526903abe71869dbbc898bfc0f69373 ]

The db->lock is a raw spinlock and so the lock hold time is supposed
to be short. This will not be the case when printk() is being involved
in some of the critical sections. In order to avoid the long hold time,
in case some messages need to be printed, the debug_object_is_on_stack()
and debug_print_object() calls are now moved out of those critical
sections.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: Qian Cai <cai@gmx.us>
Cc: Zhong Jiang <zhongjiang@huawei.com>
Link: https://lkml.kernel.org/r/20190520141450.7575-6-longman@redhat.com
Stable-dep-of: 63a759694eed ("debugobject: Prevent init race with static objects")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/debugobjects.c | 58 +++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 19 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 6e2baf9e9eb27..6909a6e51de83 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -429,6 +429,7 @@ static void
 __debug_object_init(void *addr, struct debug_obj_descr *descr, int onstack)
 {
 	enum debug_obj_state state;
+	bool check_stack = false;
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
@@ -448,7 +449,7 @@ __debug_object_init(void *addr, struct debug_obj_descr *descr, int onstack)
 			debug_objects_oom();
 			return;
 		}
-		debug_object_is_on_stack(addr, onstack);
+		check_stack = true;
 	}
 
 	switch (obj->state) {
@@ -459,20 +460,23 @@ __debug_object_init(void *addr, struct debug_obj_descr *descr, int onstack)
 		break;
 
 	case ODEBUG_STATE_ACTIVE:
-		debug_print_object(obj, "init");
 		state = obj->state;
 		raw_spin_unlock_irqrestore(&db->lock, flags);
+		debug_print_object(obj, "init");
 		debug_object_fixup(descr->fixup_init, addr, state);
 		return;
 
 	case ODEBUG_STATE_DESTROYED:
+		raw_spin_unlock_irqrestore(&db->lock, flags);
 		debug_print_object(obj, "init");
-		break;
+		return;
 	default:
 		break;
 	}
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
+	if (check_stack)
+		debug_object_is_on_stack(addr, onstack);
 }
 
 /**
@@ -530,6 +534,8 @@ int debug_object_activate(void *addr, struct debug_obj_descr *descr)
 
 	obj = lookup_object(addr, db);
 	if (obj) {
+		bool print_object = false;
+
 		switch (obj->state) {
 		case ODEBUG_STATE_INIT:
 		case ODEBUG_STATE_INACTIVE:
@@ -538,14 +544,14 @@ int debug_object_activate(void *addr, struct debug_obj_descr *descr)
 			break;
 
 		case ODEBUG_STATE_ACTIVE:
-			debug_print_object(obj, "activate");
 			state = obj->state;
 			raw_spin_unlock_irqrestore(&db->lock, flags);
+			debug_print_object(obj, "activate");
 			ret = debug_object_fixup(descr->fixup_activate, addr, state);
 			return ret ? 0 : -EINVAL;
 
 		case ODEBUG_STATE_DESTROYED:
-			debug_print_object(obj, "activate");
+			print_object = true;
 			ret = -EINVAL;
 			break;
 		default:
@@ -553,10 +559,13 @@ int debug_object_activate(void *addr, struct debug_obj_descr *descr)
 			break;
 		}
 		raw_spin_unlock_irqrestore(&db->lock, flags);
+		if (print_object)
+			debug_print_object(obj, "activate");
 		return ret;
 	}
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
+
 	/*
 	 * We are here when a static object is activated. We
 	 * let the type specific code confirm whether this is
@@ -588,6 +597,7 @@ void debug_object_deactivate(void *addr, struct debug_obj_descr *descr)
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
+	bool print_object = false;
 
 	if (!debug_objects_enabled)
 		return;
@@ -605,24 +615,27 @@ void debug_object_deactivate(void *addr, struct debug_obj_descr *descr)
 			if (!obj->astate)
 				obj->state = ODEBUG_STATE_INACTIVE;
 			else
-				debug_print_object(obj, "deactivate");
+				print_object = true;
 			break;
 
 		case ODEBUG_STATE_DESTROYED:
-			debug_print_object(obj, "deactivate");
+			print_object = true;
 			break;
 		default:
 			break;
 		}
-	} else {
+	}
+
+	raw_spin_unlock_irqrestore(&db->lock, flags);
+	if (!obj) {
 		struct debug_obj o = { .object = addr,
 				       .state = ODEBUG_STATE_NOTAVAILABLE,
 				       .descr = descr };
 
 		debug_print_object(&o, "deactivate");
+	} else if (print_object) {
+		debug_print_object(obj, "deactivate");
 	}
-
-	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
 EXPORT_SYMBOL_GPL(debug_object_deactivate);
 
@@ -637,6 +650,7 @@ void debug_object_destroy(void *addr, struct debug_obj_descr *descr)
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
+	bool print_object = false;
 
 	if (!debug_objects_enabled)
 		return;
@@ -656,20 +670,22 @@ void debug_object_destroy(void *addr, struct debug_obj_descr *descr)
 		obj->state = ODEBUG_STATE_DESTROYED;
 		break;
 	case ODEBUG_STATE_ACTIVE:
-		debug_print_object(obj, "destroy");
 		state = obj->state;
 		raw_spin_unlock_irqrestore(&db->lock, flags);
+		debug_print_object(obj, "destroy");
 		debug_object_fixup(descr->fixup_destroy, addr, state);
 		return;
 
 	case ODEBUG_STATE_DESTROYED:
-		debug_print_object(obj, "destroy");
+		print_object = true;
 		break;
 	default:
 		break;
 	}
 out_unlock:
 	raw_spin_unlock_irqrestore(&db->lock, flags);
+	if (print_object)
+		debug_print_object(obj, "destroy");
 }
 EXPORT_SYMBOL_GPL(debug_object_destroy);
 
@@ -698,9 +714,9 @@ void debug_object_free(void *addr, struct debug_obj_descr *descr)
 
 	switch (obj->state) {
 	case ODEBUG_STATE_ACTIVE:
-		debug_print_object(obj, "free");
 		state = obj->state;
 		raw_spin_unlock_irqrestore(&db->lock, flags);
+		debug_print_object(obj, "free");
 		debug_object_fixup(descr->fixup_free, addr, state);
 		return;
 	default:
@@ -773,6 +789,7 @@ debug_object_active_state(void *addr, struct debug_obj_descr *descr,
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
+	bool print_object = false;
 
 	if (!debug_objects_enabled)
 		return;
@@ -788,22 +805,25 @@ debug_object_active_state(void *addr, struct debug_obj_descr *descr,
 			if (obj->astate == expect)
 				obj->astate = next;
 			else
-				debug_print_object(obj, "active_state");
+				print_object = true;
 			break;
 
 		default:
-			debug_print_object(obj, "active_state");
+			print_object = true;
 			break;
 		}
-	} else {
+	}
+
+	raw_spin_unlock_irqrestore(&db->lock, flags);
+	if (!obj) {
 		struct debug_obj o = { .object = addr,
 				       .state = ODEBUG_STATE_NOTAVAILABLE,
 				       .descr = descr };
 
 		debug_print_object(&o, "active_state");
+	} else if (print_object) {
+		debug_print_object(obj, "active_state");
 	}
-
-	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
 EXPORT_SYMBOL_GPL(debug_object_active_state);
 
@@ -839,10 +859,10 @@ static void __debug_check_no_obj_freed(const void *address, unsigned long size)
 
 			switch (obj->state) {
 			case ODEBUG_STATE_ACTIVE:
-				debug_print_object(obj, "free");
 				descr = obj->descr;
 				state = obj->state;
 				raw_spin_unlock_irqrestore(&db->lock, flags);
+				debug_print_object(obj, "free");
 				debug_object_fixup(descr->fixup_free,
 						   (void *) oaddr, state);
 				goto repeat;
-- 
2.39.2



