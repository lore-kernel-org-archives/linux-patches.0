Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B136151CCC;
	Tue, 20 Feb 2024 21:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464982; cv=none; b=XJDHFHX/FXoITbzHLLChSTMvrpEgGwOOnsAz0jfW1nnzBRd3JxXL4jPfrG8INGNfkwsB/rtvAdkcB2M8OZBV7PCU7TGasmskhylQCGD464O+Uybltys3eodO6F6eLeIO4q1BlwnbjWj/bP1MKupm/6wlBzemDOTUXnNrB8Cmg9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464982; c=relaxed/simple;
	bh=wOUZ/MS+j43zbpTOXwSAjCHriJQ8M3VZ5hEQYPAT+D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTWFrdRa6bJLAsgLR5wz2AcAL7iMRN+6B+HLxE/wsZO2wk6nkaJDzGpBfcbh+izZQa6FHmF967g29Qmd+XUbQ8vWGXqTcvLO4ByyBqY5/kd5GtGYu9JT7iqG7+PFsVXGZBMtBq0puYs8R0RTHeYUCV+p+hS8nNCQmnpKbWnBVko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhKsd320; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhKsd320"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC659C433F1;
	Tue, 20 Feb 2024 21:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464982;
	bh=wOUZ/MS+j43zbpTOXwSAjCHriJQ8M3VZ5hEQYPAT+D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhKsd320wvqyFAaRFy00CmKq3rJMT0f94KA/D/fMalL5rf/dZl4qK4ohNYWEtji73
	 sjQrTMQk12/s6OgyAFevFrgzkqoDMiUwE3jSzeL5n4Rbjsi5EbyJzkqGPxuVpR7OFs
	 4G+5+DnIzP4XF0rI+FDlwSvtcFf6k3FZ0htMvES8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 199/309] eventfs: Keep all directory links at 1
Date: Tue, 20 Feb 2024 21:55:58 +0100
Message-ID: <20240220205639.409923645@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit ca185770db914869ff9fe773bac5e0e5e4165b83 upstream.

The directory link count in eventfs was somewhat bogus. It was only being
updated when a directory child was being looked up and not on creation.

One solution would be to update in get_attr() the link count by iterating
the ei->children list and then adding 2. But that could slow down simple
stat() calls, especially if it's done on all directories in eventfs.

Another solution would be to add a parent pointer to the eventfs_inode
and keep track of the number of sub directories it has on creation. But
this adds overhead for something not really worthwhile.

The solution decided upon is to keep all directory links in eventfs as 1.
This tells user space not to rely on the hard links of directories. Which
in this case it shouldn't.

Link: https://lore.kernel.org/linux-trace-kernel/20240201002719.GS2087318@ZenIV/
Link: https://lore.kernel.org/linux-trace-kernel/20240201161617.339968298@goodmis.org

Cc: stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>
Fixes: c1504e510238 ("eventfs: Implement eventfs dir creation functions")
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -404,9 +404,7 @@ static struct dentry *lookup_dir_entry(s
 
 	dentry->d_fsdata = get_ei(ei);
 
-	inc_nlink(inode);
 	d_add(dentry, inode);
-	inc_nlink(dentry->d_parent->d_inode);
 	return NULL;
 }
 
@@ -769,9 +767,17 @@ struct eventfs_inode *eventfs_create_eve
 
 	dentry->d_fsdata = get_ei(ei);
 
-	/* directory inodes start off with i_nlink == 2 (for "." entry) */
-	inc_nlink(inode);
+	/*
+	 * Keep all eventfs directories with i_nlink == 1.
+	 * Due to the dynamic nature of the dentry creations and not
+	 * wanting to add a pointer to the parent eventfs_inode in the
+	 * eventfs_inode structure, keeping the i_nlink in sync with the
+	 * number of directories would cause too much complexity for
+	 * something not worth much. Keeping directory links at 1
+	 * tells userspace not to trust the link number.
+	 */
 	d_instantiate(dentry, inode);
+	/* The dentry of the "events" parent does keep track though */
 	inc_nlink(dentry->d_parent->d_inode);
 	fsnotify_mkdir(dentry->d_parent->d_inode, dentry);
 	tracefs_end_creating(dentry);


