Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553272C9D;
	Mon, 23 Jun 2025 21:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713631; cv=none; b=mAnHT68yH94YyIMDevwYKTAMtN7qvdgYJhsPP5epGgFcJBJAEjBUHCTlyE3UQcfTTQHwhifGN9hR2pZUdQbt+mB+KdmoXlgTkFneLk+3PVCNbrMkHR5zcEBG5+qiaCQj+HFHT4u0VLN8dywtQgpY7C9ZAAUZzXemnJG35f5GlVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713631; c=relaxed/simple;
	bh=Q8RHzzxr1VwnqaGeXDLlfYfZrjG27y8ZzGsT9GYwZPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWIosowEfB8zohCepUfgtvP5iBaHSW1KsJMiImWT5pJFVQZV2Qzd6yQL+a6LL2ZrkCy+blBhxB8MGi4j3II4RLDy6LhNwezScNEgekXujf/wXrGdSQoxFJoMCMFNusLhSveGI5KU4orMGKKqteNEUkjEK+T+XT/yX4SjWQ4Mohs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vm/xDZYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vm/xDZYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDD7C4CEEA;
	Mon, 23 Jun 2025 21:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713631;
	bh=Q8RHzzxr1VwnqaGeXDLlfYfZrjG27y8ZzGsT9GYwZPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vm/xDZYeb0bqbawihnk5q/saJzaJiU4VDah2/vCTT80NrMRJEcT0W1johyu4/tb7/
	 P2JWaVvMbxNQrzD6YDqTTcz5RFFXCoBZALptaIqVgydGBKDKQkf6F5hvnnLfHWGC6f
	 pN0NJAHfIanYh30t19BtgSt0Dg2rxKIguy7l6rqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	syzbot+a2b84e569d06ca3a949c@syzkaller.appspotmail.com,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vasiliy Kulikov <segoon@openwall.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 081/290] ipc: fix to protect IPCS lookups using RCU
Date: Mon, 23 Jun 2025 15:05:42 +0200
Message-ID: <20250623130629.423561258@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit d66adabe91803ef34a8b90613c81267b5ded1472 upstream.

syzbot reported that it discovered a use-after-free vulnerability, [0]

[0]: https://lore.kernel.org/all/67af13f8.050a0220.21dd3.0038.GAE@google.com/

idr_for_each() is protected by rwsem, but this is not enough.  If it is
not protected by RCU read-critical region, when idr_for_each() calls
radix_tree_node_free() through call_rcu() to free the radix_tree_node
structure, the node will be freed immediately, and when reading the next
node in radix_tree_for_each_slot(), the already freed memory may be read.

Therefore, we need to add code to make sure that idr_for_each() is
protected within the RCU read-critical region when we call it in
shm_destroy_orphaned().

Link: https://lkml.kernel.org/r/20250424143322.18830-1-aha310510@gmail.com
Fixes: b34a6b1da371 ("ipc: introduce shm_rmid_forced sysctl")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reported-by: syzbot+a2b84e569d06ca3a949c@syzkaller.appspotmail.com
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 ipc/shm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -430,8 +430,11 @@ static int shm_try_destroy_orphaned(int
 void shm_destroy_orphaned(struct ipc_namespace *ns)
 {
 	down_write(&shm_ids(ns).rwsem);
-	if (shm_ids(ns).in_use)
+	if (shm_ids(ns).in_use) {
+		rcu_read_lock();
 		idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_orphaned, ns);
+		rcu_read_unlock();
+	}
 	up_write(&shm_ids(ns).rwsem);
 }
 


