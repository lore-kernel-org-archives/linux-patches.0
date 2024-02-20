Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6E91509BC;
	Tue, 20 Feb 2024 21:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464360; cv=none; b=UXuA/C1P02xWbyyKlZ4DgioxHFH97f6p3cTs2cU4PfM6fsv8Kt4JLDeD80HWALgAH42Uj9MdtYLcvsHwyehJMdj4Ky2KxcRcRK91ysZwxmQ3EVvur8UsD7oLBNgHXs+cBU6IdTo9z7fQLHytsnH5n5rH9bAZYifWTndTdLoF4eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464360; c=relaxed/simple;
	bh=mZrZv5hElNnZQvoDdJqU2qKw+4mxVPX/y5KcRa3tsHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8SUexgy+VyOXDp3bRQy81nSxweMYySOfF9pvqq4yyJZw5P6iHjmjP7EkPpMLlODRXbpfmt87y2RaBH+nAnaRnmeKmBleeiKRbcUvv6EDfqbi1nRYr7YhRVlsMpcPXiNWXLNx66ahKD4fMVsf77NXuMDZIC+0DYVJ0fHpyDBKJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuUqZbtW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuUqZbtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8713CC433F1;
	Tue, 20 Feb 2024 21:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464359;
	bh=mZrZv5hElNnZQvoDdJqU2qKw+4mxVPX/y5KcRa3tsHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuUqZbtWAkoqC4XVO4PSzW8x6nVeJLebgiFCpPUeJ05ea18ao6c5nuWczl9oCCpG+
	 h3kVOHZS24TYbaloxSLVMd0jZLuvbVDuaxxyqeeGa/c4+7IaoS/uZPhrgEHNWLNKLA
	 KqQOdyEJkJkEFSvR5I0JfPuvFwqBfBYtzkIE7TVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	kernel test robot <oliver.sang@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 305/331] eventfs: Initialize the tracefs inode properly
Date: Tue, 20 Feb 2024 21:57:01 +0100
Message-ID: <20240220205647.719531665@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 4fa4b010b83fb2f837b5ef79e38072a79e96e4f1 upstream.

The tracefs-specific fields in the inode were not initialized before the
inode was exposed to others through the dentry with 'd_instantiate()'.

Move the field initializations up to before the d_instantiate.

Link: https://lore.kernel.org/linux-trace-kernel/20240131185512.478449628@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 5790b1fb3d672 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202401291043.e62e89dc-oliver.sang@intel.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -370,6 +370,8 @@ static struct dentry *create_dir(struct
 
 	ti = get_tracefs(inode);
 	ti->flags |= TRACEFS_EVENT_INODE;
+	/* Only directories have ti->private set to an ei, not files */
+	ti->private = ei;
 
 	inc_nlink(inode);
 	d_instantiate(dentry, inode);
@@ -515,7 +517,6 @@ create_file_dentry(struct eventfs_inode
 static void eventfs_post_create_dir(struct eventfs_inode *ei)
 {
 	struct eventfs_inode *ei_child;
-	struct tracefs_inode *ti;
 
 	lockdep_assert_held(&eventfs_mutex);
 
@@ -525,9 +526,6 @@ static void eventfs_post_create_dir(stru
 				 srcu_read_lock_held(&eventfs_srcu)) {
 		ei_child->d_parent = ei->dentry;
 	}
-
-	ti = get_tracefs(ei->dentry->d_inode);
-	ti->private = ei;
 }
 
 /**


