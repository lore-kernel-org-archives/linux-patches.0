Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A1715575F;
	Fri,  6 Dec 2024 14:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496309; cv=none; b=HClMDSMVIBqN3r4fzVs6D/Y40W80Tash+MLSK8HkZR1y3vkCIM2zLtDk/9KI5VpId5mcisSO0vguy8vWzYK10ivjhHJIn8euH1/6/pb2xNGPPrORjSPt7apndbnkbGkjKM2dc2hhnkxbg4CrwyOOS9DNgO5tlmQxWK5AoCWyPzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496309; c=relaxed/simple;
	bh=OP8DNDZVwp33l3y9rlV7N7uxkgVPE/XbD6Gv3R9uLdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVWmH+/KcZFGIF2x9WwF5sDlBuwyIk+NV07xS7RKCkOKEhQ0QYtc+D6D9ieLGcO2ogYe/cCY+z0CFxKqbwpDLWf4B9Pu4wnNKSthfXt0gh4jh/mfZGjxP3uQkjIPHpH3TdzFy98t6FFV5dnLKyE6INXDR/PRjjcnJI1flfcod+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00QamTNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00QamTNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB747C4CED1;
	Fri,  6 Dec 2024 14:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496309;
	bh=OP8DNDZVwp33l3y9rlV7N7uxkgVPE/XbD6Gv3R9uLdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00QamTNeZpqZzuELjyl83vlSc5mE2O8QPbfPYDGRhgXQix/iwUAR26Vl+hrgIdXyY
	 agcNgqg1sXpKREh8KbKiGB7lyvrbEPfnSghVy23eL0oA9iOjp2T8+FXLbCIN885cti
	 giQey8FctU9DVKgfvUwVOznGgEB+JCl1ogmF8wcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Todd Kjos <tkjos@google.com>
Subject: [PATCH 6.12 113/146] binder: allow freeze notification for dead nodes
Date: Fri,  6 Dec 2024 15:37:24 +0100
Message-ID: <20241206143532.006017505@linuxfoundation.org>
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

commit ca63c66935b978441055e3d87d30225267f99329 upstream.

Alice points out that binder_request_freeze_notification() should not
return EINVAL when the relevant node is dead [1]. The node can die at
any point even if the user input is valid. Instead, allow the request
to be allocated but skip the initial notification for dead nodes. This
avoids propagating unnecessary errors back to userspace.

Fixes: d579b04a52a1 ("binder: frozen notification")
Cc: stable@vger.kernel.org
Suggested-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/all/CAH5fLghapZJ4PbbkC8V5A6Zay-_sgTzwVpwqk6RWWUNKKyJC_Q@mail.gmail.com/ [1]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20240926233632.821189-7-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 73dc6cbc1681..415fc9759249 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3856,7 +3856,6 @@ binder_request_freeze_notification(struct binder_proc *proc,
 {
 	struct binder_ref_freeze *freeze;
 	struct binder_ref *ref;
-	bool is_frozen;
 
 	freeze = kzalloc(sizeof(*freeze), GFP_KERNEL);
 	if (!freeze)
@@ -3872,32 +3871,31 @@ binder_request_freeze_notification(struct binder_proc *proc,
 	}
 
 	binder_node_lock(ref->node);
-
-	if (ref->freeze || !ref->node->proc) {
-		binder_user_error("%d:%d invalid BC_REQUEST_FREEZE_NOTIFICATION %s\n",
-				  proc->pid, thread->pid,
-				  ref->freeze ? "already set" : "dead node");
+	if (ref->freeze) {
+		binder_user_error("%d:%d BC_REQUEST_FREEZE_NOTIFICATION already set\n",
+				  proc->pid, thread->pid);
 		binder_node_unlock(ref->node);
 		binder_proc_unlock(proc);
 		kfree(freeze);
 		return -EINVAL;
 	}
-	binder_inner_proc_lock(ref->node->proc);
-	is_frozen = ref->node->proc->is_frozen;
-	binder_inner_proc_unlock(ref->node->proc);
 
 	binder_stats_created(BINDER_STAT_FREEZE);
 	INIT_LIST_HEAD(&freeze->work.entry);
 	freeze->cookie = handle_cookie->cookie;
 	freeze->work.type = BINDER_WORK_FROZEN_BINDER;
-	freeze->is_frozen = is_frozen;
-
 	ref->freeze = freeze;
 
-	binder_inner_proc_lock(proc);
-	binder_enqueue_work_ilocked(&ref->freeze->work, &proc->todo);
-	binder_wakeup_proc_ilocked(proc);
-	binder_inner_proc_unlock(proc);
+	if (ref->node->proc) {
+		binder_inner_proc_lock(ref->node->proc);
+		freeze->is_frozen = ref->node->proc->is_frozen;
+		binder_inner_proc_unlock(ref->node->proc);
+
+		binder_inner_proc_lock(proc);
+		binder_enqueue_work_ilocked(&freeze->work, &proc->todo);
+		binder_wakeup_proc_ilocked(proc);
+		binder_inner_proc_unlock(proc);
+	}
 
 	binder_node_unlock(ref->node);
 	binder_proc_unlock(proc);
-- 
2.47.1



