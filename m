Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEB514F9CE;
	Tue, 20 Feb 2024 21:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464323; cv=none; b=JR+rP2+wkMj+VnAefUPzmwUcGzwUgqX2naotHT8ildbFaR1EXsWadvs9njEQh1o7SxvYyp+PL33sc/OvsIYtTJLQxu7hnJUg39bpySjc/XmFZ/x2MKA1JRbThbALOP0BdZ886UbT9tmzmfQ65IEP3/j19BFi3O/WES+LmWFS0xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464323; c=relaxed/simple;
	bh=u2+NXNRVbQoGk57FtB085oAE22bAo+A635ag+NJ4HB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAFWXpPUQDv0975MFr2fmzpNzb18ikpUdoJBAajJT7/nV5IVY7MAnSXCU2cxsWN1Yzc4OCGcbjYvvhimKyV4qftQfCFzwp5iOrOD+N9oGoM1Tl3Et8oAEQupZkxorx7UfvombJJw8b6QaGnvQ/7egLu55JgeP+TTaEs9+sqaM58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wD4YqUXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wD4YqUXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C01C433C7;
	Tue, 20 Feb 2024 21:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464323;
	bh=u2+NXNRVbQoGk57FtB085oAE22bAo+A635ag+NJ4HB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wD4YqUXq6U30WyfCmGSSC8z99fARETV5iscLZTuqYOQM/cmWyz6dTZOggepDd1PZy
	 TdNpVl7bIq57ywTbD8MvyqEqGwv25tdEDLoov63v/8HAuEp1wJUDRcZn1E+CwhvHL0
	 /PRYQHrjPdhX1ZACRuBor0RjlncY7hdcGZHTFMtI=
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
Subject: [PATCH 6.6 304/331] tracefs: Zero out the tracefs_inode when allocating it
Date: Tue, 20 Feb 2024 21:57:00 +0100
Message-ID: <20240220205647.679693492@linuxfoundation.org>
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

commit d81786f53aec14fd4d56263145a0635afbc64617 upstream.

eventfs uses the tracefs_inode and assumes that it's already initialized
to zero. That is, it doesn't set fields to zero (like ti->private) after
getting its tracefs_inode. This causes bugs due to stale values.

Just initialize the entire structure to zero on allocation so there isn't
any more surprises.

This is a partial fix to access to ti->private. The assignment still needs
to be made before the dentry is instantiated.

Link: https://lore.kernel.org/linux-trace-kernel/20240131185512.315825944@goodmis.org

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
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/inode.c    |    6 ++++--
 fs/tracefs/internal.h |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -38,8 +38,6 @@ static struct inode *tracefs_alloc_inode
 	if (!ti)
 		return NULL;
 
-	ti->flags = 0;
-
 	return &ti->vfs_inode;
 }
 
@@ -779,7 +777,11 @@ static void init_once(void *foo)
 {
 	struct tracefs_inode *ti = (struct tracefs_inode *) foo;
 
+	/* inode_init_once() calls memset() on the vfs_inode portion */
 	inode_init_once(&ti->vfs_inode);
+
+	/* Zero out the rest */
+	memset_after(ti, 0, vfs_inode);
 }
 
 static int __init tracefs_init(void)
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -11,9 +11,10 @@ enum {
 };
 
 struct tracefs_inode {
+	struct inode            vfs_inode;
+	/* The below gets initialized with memset_after(ti, 0, vfs_inode) */
 	unsigned long           flags;
 	void                    *private;
-	struct inode            vfs_inode;
 };
 
 /*


