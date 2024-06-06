Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57524196D90;
	Thu,  6 Jun 2024 14:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683668; cv=none; b=HKbG1VuOv4jBiq2R5IWBRCA4PhwmMgubGkSQAUYZaByzYy08O35TbV6aMiZYd4F3HAYGmQu2pgZ7UfBIl8letV+7N+GmfKRixFscHGCSqD8FrKHAw93IBgU9Iu9G3g4mQPH9aHZraOSB3VE9ccg9IPrENGT/4mdynz/Yl0gwtok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683668; c=relaxed/simple;
	bh=z0B46F1NaHIOf2abid2fSkizNmm7lCAIaGt3V6ytoN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KASVrOApDa6l+1TrWofThr3fXlVSkFyjhMSJet+9lcvoqyCjL8Q6swjXH3s69/4gIYH0EP5pBfKAhDx5cP0h9DjK7+qjONOJlDL2QysL+vGbh5FmJer6gvE7YND3ZrMZ7D5IzG4FVDo7YbajTGtxb/gSvXH+CBuOsQ6jk/u+Ufc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tm9Nig2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tm9Nig2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BADC2BD10;
	Thu,  6 Jun 2024 14:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683668;
	bh=z0B46F1NaHIOf2abid2fSkizNmm7lCAIaGt3V6ytoN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tm9Nig2sGYhlkK5PeXTeWCg8TggDbduWMfva4cyT+Lb3AGvSNR7qkIwxojt6nUl6H
	 w2VRcb4jnQ+jgET3ZRgb4WtfsQDKyPeAb0QQoI7PK5BfaG3oFUBT9MdSkg1eeZqXMl
	 1uA94dANyJoay9Om2u8IzC6w2+PFHy5EyNCebJL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 555/744] eventfs: Free all of the eventfs_inode after RCU
Date: Thu,  6 Jun 2024 16:03:47 +0200
Message-ID: <20240606131750.259086002@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit ee4e0379475e4fe723986ae96293e465014fa8d9 ]

The freeing of eventfs_inode via a kfree_rcu() callback. But the content
of the eventfs_inode was being freed after the last kref. This is
dangerous, as changes are being made that can access the content of an
eventfs_inode from an RCU loop.

Instead of using kfree_rcu() use call_rcu() that calls a function to do
all the freeing of the eventfs_inode after a RCU grace period has expired.

Link: https://lore.kernel.org/linux-trace-kernel/20240502200905.370261163@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 43aa6f97c2d03 ("eventfs: Get rid of dentry pointers without refcounts")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/event_inode.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index a598fec065684..fd111e10f04e4 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -72,6 +72,21 @@ enum {
 
 #define EVENTFS_MODE_MASK	(EVENTFS_SAVE_MODE - 1)
 
+static void free_ei_rcu(struct rcu_head *rcu)
+{
+	struct eventfs_inode *ei = container_of(rcu, struct eventfs_inode, rcu);
+	struct eventfs_root_inode *rei;
+
+	kfree(ei->entry_attrs);
+	kfree_const(ei->name);
+	if (ei->is_events) {
+		rei = get_root_inode(ei);
+		kfree(rei);
+	} else {
+		kfree(ei);
+	}
+}
+
 /*
  * eventfs_inode reference count management.
  *
@@ -84,7 +99,6 @@ static void release_ei(struct kref *ref)
 {
 	struct eventfs_inode *ei = container_of(ref, struct eventfs_inode, kref);
 	const struct eventfs_entry *entry;
-	struct eventfs_root_inode *rei;
 
 	WARN_ON_ONCE(!ei->is_freed);
 
@@ -94,14 +108,7 @@ static void release_ei(struct kref *ref)
 			entry->release(entry->name, ei->data);
 	}
 
-	kfree(ei->entry_attrs);
-	kfree_const(ei->name);
-	if (ei->is_events) {
-		rei = get_root_inode(ei);
-		kfree_rcu(rei, ei.rcu);
-	} else {
-		kfree_rcu(ei, rcu);
-	}
+	call_rcu(&ei->rcu, free_ei_rcu);
 }
 
 static inline void put_ei(struct eventfs_inode *ei)
-- 
2.43.0



