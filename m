Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B314151CD9;
	Tue, 20 Feb 2024 21:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464260; cv=none; b=I/vccXjWAQBPk/ROZwYF6rE8N7JYueuzmZfkKVYL86Q2iuOalfuCCYny1uaP9uxzGV4ExC9Q4MM52poJoBuJ2CwcjIOfVA0GjADmXgnHRjSfUK1oAw9moMYNvvp/gRPyBPCef6uSLyMfGC/uxk3bY9oQq6P+tEqEY0DDFoVHg8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464260; c=relaxed/simple;
	bh=l4/YLMlZbzGF47oiSs+7p4m4jBEzCiuZLvUqUo51qm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPefwnZGh1A+0v3sJXmQfELR7H9PSQtgUPVgBiwUzeaQbmOQniKSCP4KvdMaUlzp1Jjo/diB1WacjlFjSaUgdUWp1LmmIKqVHzAqEqKkLNDrEKn26FjJKeeCbyFSd0HSEaBeZe+hMs4SbBwEPH5KFHe4pISmaiQ0Fr7wtmr5qrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yd/poIiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yd/poIiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19D1C433F1;
	Tue, 20 Feb 2024 21:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464260;
	bh=l4/YLMlZbzGF47oiSs+7p4m4jBEzCiuZLvUqUo51qm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yd/poIiYVA4FF46t73riQC2lDz0BOnq+dSTGM7XyGjw+1lJNvLO/FW4WfhXDSU7CA
	 +MQ1+k+hrFg5Qryl7D++q6AcuJ9Lb3k+3xJZTiylClmma3IZ2cTHmPLGciEkB0V773
	 L9WjytL04Agy3SMzRsUH1SuLRi4L0W15u4xTWiu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kaher <akaher@vmware.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 274/331] eventfs: Have a free_ei() that just frees the eventfs_inode
Date: Tue, 20 Feb 2024 21:56:30 +0100
Message-ID: <20240220205646.494228991@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit db3a397209b00d2e4e0a068608e5c546fc064b82 upstream.

As the eventfs_inode is freed in two different locations, make a helper
function free_ei() to make sure all the allocated fields of the
eventfs_inode is freed.

This requires renaming the existing free_ei() which is called by the srcu
handler to free_rcu_ei() and have free_ei() just do the freeing, where
free_rcu_ei() will call it.

Link: https://lkml.kernel.org/r/20231101172649.265214087@goodmis.org

Cc: Ajay Kaher <akaher@vmware.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -129,6 +129,13 @@ static struct dentry *create_dir(const c
 	return eventfs_end_creating(dentry);
 }
 
+static void free_ei(struct eventfs_inode *ei)
+{
+	kfree_const(ei->name);
+	kfree(ei->d_children);
+	kfree(ei);
+}
+
 /**
  * eventfs_set_ei_status_free - remove the dentry reference from an eventfs_inode
  * @ti: the tracefs_inode of the dentry
@@ -168,9 +175,7 @@ void eventfs_set_ei_status_free(struct t
 			eventfs_remove_dir(ei_child);
 		}
 
-		kfree_const(ei->name);
-		kfree(ei->d_children);
-		kfree(ei);
+		free_ei(ei);
 		return;
 	}
 
@@ -784,13 +789,11 @@ struct eventfs_inode *eventfs_create_eve
 	return ERR_PTR(-ENOMEM);
 }
 
-static void free_ei(struct rcu_head *head)
+static void free_rcu_ei(struct rcu_head *head)
 {
 	struct eventfs_inode *ei = container_of(head, struct eventfs_inode, rcu);
 
-	kfree_const(ei->name);
-	kfree(ei->d_children);
-	kfree(ei);
+	free_ei(ei);
 }
 
 /**
@@ -881,7 +884,7 @@ void eventfs_remove_dir(struct eventfs_i
 		for (i = 0; i < ei->nr_entries; i++)
 			unhook_dentry(&ei->d_children[i], &dentry_list);
 		unhook_dentry(&ei->dentry, &dentry_list);
-		call_srcu(&eventfs_srcu, &ei->rcu, free_ei);
+		call_srcu(&eventfs_srcu, &ei->rcu, free_rcu_ei);
 	}
 	mutex_unlock(&eventfs_mutex);
 


