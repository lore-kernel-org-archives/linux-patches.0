Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0A2145A05;
	Fri,  6 Dec 2024 14:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496289; cv=none; b=NBG662Rbz7PPGACzZtzM9pGMcEc2hX8MaDWSFxuigU7u1Do6WXcXzcmdsGK0YwXi0VxO+eKJooY7ejzFnauanVI7+EUpmdJ1QHsX1I3/AYysR/CV6SH+flog4gf/XF7hSqQk3/h/3bUalv9pnzc7t6d7qWJSB7If6eAG6V+Wkdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496289; c=relaxed/simple;
	bh=/N/iMUuE+QVYEe/xfhZb0sfDx80AbghepZSY0rm143Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGjNUQB+xUxrH95j+YIhqCpF2F32avGrVfigPBXKAalc7H+EM5f5qgobvbU9MKXxUdv08Qh0is0/yEhrpSpGenk6jn6nq0lxDf1MOPfKycCcOpKRzGk1t/0Nsl2uj3v6Nqu1hjRIhBSQVK7Qjk53w7a5iltythU7Pyco4FRyKxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4Z7hxfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4Z7hxfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D0CC4CED1;
	Fri,  6 Dec 2024 14:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496288;
	bh=/N/iMUuE+QVYEe/xfhZb0sfDx80AbghepZSY0rm143Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4Z7hxfpaB6OTe31YJ/VyzhOPDXAuD8c03uhm+nw8mnl8OdcruHVoS+QM9Fl/7qqs
	 aM4oKTrLIrQbAdFCKrIE3LlIGuA8KCoid1Q4oswlbUIh6WKrFbuXfAAR3LhW9cvv2w
	 rMRr57+lgvKkWhonRiGLp50WEkmsdZNSd4VV73Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Todd Kjos <tkjos@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.12 108/146] binder: fix node UAF in binder_add_freeze_work()
Date: Fri,  6 Dec 2024 15:37:19 +0100
Message-ID: <20241206143531.816456331@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit dc8aea47b928cc153b591b3558829ce42f685074 upstream.

In binder_add_freeze_work() we iterate over the proc->nodes with the
proc->inner_lock held. However, this lock is temporarily dropped in
order to acquire the node->lock first (lock nesting order). This can
race with binder_node_release() and trigger a use-after-free:

  ==================================================================
  BUG: KASAN: slab-use-after-free in _raw_spin_lock+0xe4/0x19c
  Write of size 4 at addr ffff53c04c29dd04 by task freeze/640

  CPU: 5 UID: 0 PID: 640 Comm: freeze Not tainted 6.11.0-07343-ga727812a8d45 #17
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   _raw_spin_lock+0xe4/0x19c
   binder_add_freeze_work+0x148/0x478
   binder_ioctl+0x1e70/0x25ac
   __arm64_sys_ioctl+0x124/0x190

  Allocated by task 637:
   __kmalloc_cache_noprof+0x12c/0x27c
   binder_new_node+0x50/0x700
   binder_transaction+0x35ac/0x6f74
   binder_thread_write+0xfb8/0x42a0
   binder_ioctl+0x18f0/0x25ac
   __arm64_sys_ioctl+0x124/0x190

  Freed by task 637:
   kfree+0xf0/0x330
   binder_thread_read+0x1e88/0x3a68
   binder_ioctl+0x16d8/0x25ac
   __arm64_sys_ioctl+0x124/0x190
  ==================================================================

Fix the race by taking a temporary reference on the node before
releasing the proc->inner lock. This ensures the node remains alive
while in use.

Fixes: d579b04a52a1 ("binder: frozen notification")
Cc: stable@vger.kernel.org
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20240926233632.821189-2-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 978740537a1a..4d90203ea048 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -5552,6 +5552,7 @@ static bool binder_txns_pending_ilocked(struct binder_proc *proc)
 
 static void binder_add_freeze_work(struct binder_proc *proc, bool is_frozen)
 {
+	struct binder_node *prev = NULL;
 	struct rb_node *n;
 	struct binder_ref *ref;
 
@@ -5560,7 +5561,10 @@ static void binder_add_freeze_work(struct binder_proc *proc, bool is_frozen)
 		struct binder_node *node;
 
 		node = rb_entry(n, struct binder_node, rb_node);
+		binder_inc_node_tmpref_ilocked(node);
 		binder_inner_proc_unlock(proc);
+		if (prev)
+			binder_put_node(prev);
 		binder_node_lock(node);
 		hlist_for_each_entry(ref, &node->refs, node_entry) {
 			/*
@@ -5586,10 +5590,13 @@ static void binder_add_freeze_work(struct binder_proc *proc, bool is_frozen)
 			}
 			binder_inner_proc_unlock(ref->proc);
 		}
+		prev = node;
 		binder_node_unlock(node);
 		binder_inner_proc_lock(proc);
 	}
 	binder_inner_proc_unlock(proc);
+	if (prev)
+		binder_put_node(prev);
 }
 
 static int binder_ioctl_freeze(struct binder_freeze_info *info,
-- 
2.47.1



