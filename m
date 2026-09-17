Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F7C4EFFB6;
	Thu, 17 Sep 2026 15:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659828; cv=none; b=YZ7KQbjW+PXy5BCtSCzIVRew+Ebf/pDr9aMhTzbx7ExO+A8GBIyWLrC8os+N38BPL8GXfLjhB29FF8W+X6EWS3Hxwd0MOohJboYXNlK7li4a+xTx9aLVNZpxQ7WgZbyTbV7U1ZS8q+Xs7Qm/02AeQZH6kzidJ0IZSKscbS2/SX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659828; c=relaxed/simple;
	bh=QyXLDaQJKHqCl6yevn77V600i9Hf1Xt8t1oNiteMpc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrKq7yN2q5uZfmymSJ3ywbgOwNJd1eVqbYR49kIeljS1g0jNmZFzlmHcvIVfuGHjUPHjL2v08Ckhk+NBBqDOzBssU9yNnGaHDAJmJN++cBwf29Zk97wvZ6EHT1JqUdJWphTgwa83y6LjQ+3CT0tLZAo6YolVOOorGEwZIE9ZBCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTMI5Ni3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTMI5Ni3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528521F00893;
	Thu, 17 Sep 2026 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659823;
	bh=LjVVPyF4I/MwZKdoSElA9Fgqan7kZtO9KFfpTqgx7YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTMI5Ni367IDGnR6BQpyAyofI6CAnX1GRDK12i551GFb/jiOmMgssWWkCkVJU98sh
	 WlRSDyLf7G1tzSg+tsAgbJgElrb/rVlfObV9z/uBXhaVFXQg4EhYJkoTNP9mOerb6A
	 HQorjpxTkNNlzuuOhPzdcJ2Muvnezu4hzspj9B9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 387/733] nstree: check listing permission before taking a namespace reference
Date: Thu, 17 Sep 2026 16:11:35 +0100
Message-ID: <20260917151401.341179896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit 56ea4e86832d8abe8930394473566c194d189f85 ]

legitimize_ns() takes a reference on the candidate namespace before
may_list_ns() has decided whether the caller may see it. The
__free(ns_put) cleanup on the denied path can drop the last reference to a
mount namespace while we still hold the rcu read lock, and put_mnt_ns()
may sleep there. This is the same problem commit 2ec2aff3c8e2 ("ns: make
sure reference are dropped outside of rcu lock") fixed for the put_user()
path. Neither ns_requested() nor may_list_ns() needs a reference, both
only look at the namespace type and at the caller's own namespaces, so do
the checks first and take the reference last.

Splat:

  Voluntary context switch within RCU read-side critical section!
  WARNING: kernel/rcu/tree_plugin.h:332 at rcu_note_context_switch+0x238/0x2a0, CPU#5: a/3442
  CPU: 5 UID: 1000 PID: 3442 Comm: a Not tainted 7.0.0-30-generic #30-Ubuntu PREEMPT(lazy)
  RIP: 0010:rcu_note_context_switch+0x238/0x2a0
  Call Trace:
   <TASK>
   __schedule+0xcf/0x650
   schedule+0x27/0x90
   schedule_preempt_disabled+0x15/0x30
   __mutex_lock.constprop.0+0x550/0xaf0
   __mutex_lock_slowpath+0x13/0x20
   mutex_lock+0x3b/0x50
   exp_funnel_lock+0xb2/0x260
   synchronize_rcu_expedited+0xe7/0x220
   namespace_unlock+0x26a/0x320
   put_mnt_ns+0xd3/0x120
   mntns_put+0xe/0x20
   do_listns+0x13e/0x560
   __do_sys_listns+0x126/0x2d0
   __x64_sys_listns+0x20/0x30
   x64_sys_call+0x2366/0x2390
   do_syscall_64+0x105/0x5a0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

Fixes: 76b6f5dfb3fd ("nstree: add listns()")
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Link: https://patch.msgid.link/ABA32239-733B-438C-B95A-B13ED69FF0F3@doyensec.com
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/nstree.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/nstree.c b/kernel/nstree.c
index 6d12e5900ac01..831f279d174a3 100644
--- a/kernel/nstree.c
+++ b/kernel/nstree.c
@@ -533,19 +533,13 @@ DEFINE_FREE(ns_put, struct ns_common *, if (!IS_ERR_OR_NULL(_T)) ns_put(_T))
 static inline struct ns_common *__must_check legitimize_ns(const struct klistns *kls,
 							   struct ns_common *candidate)
 {
-	struct ns_common *ns __free(ns_put) = NULL;
-
 	if (!ns_requested(kls, candidate))
 		return NULL;
 
-	ns = ns_get_unless_inactive(candidate);
-	if (!ns)
-		return NULL;
-
-	if (!may_list_ns(kls, ns))
+	if (!may_list_ns(kls, candidate))
 		return NULL;
 
-	return no_free_ptr(ns);
+	return ns_get_unless_inactive(candidate);
 }
 
 static ssize_t do_listns_userns(struct klistns *kls)
-- 
2.53.0



