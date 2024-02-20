Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A989446C9;
	Tue, 20 Feb 2024 21:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465079; cv=none; b=oIPXYD75uQjjZlJg7CYwU1+s9jFwUoW6/zZG0rxc0qxKb5t0cJC7bw69w82hjlBgUHuvl92vY+0P4UJhLTWQsmQ+emKZXVgv7aICAPQHrcd5qU+cJ0b3LvhqesvZBxqmSD9zTvZIN4C68uIwcWNan+J4ypAhcEUEo4NQfxlIMKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465079; c=relaxed/simple;
	bh=W7if0nXnOl/5NOnh++qKE81RTV7T9Vf2GWJP/VvShk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/FieWBT102G+Obu6DW7YYm2ZLhnyaiA9B9SpR0Likl400bI83/i84KASUijajeYq4JExUmvLP6aabciRNuAQ1/Vvrc2VF/ULwOBMvkLJIDX0LaZgl/ZylM36xJuAhjEQpwuQTNWIAsOLheos4XeIKa88dnMUTiJfXVP9wnRJMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jenzZK4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jenzZK4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5A7C433C7;
	Tue, 20 Feb 2024 21:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465079;
	bh=W7if0nXnOl/5NOnh++qKE81RTV7T9Vf2GWJP/VvShk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jenzZK4jViJkCSMNSsMkxrVlfX8Q7VRKAouXmqZ2lvUJzH8V9jykbTP7me8chNQ/C
	 IjxrfN7vI2rz/fIIV9UeesGByCLQ+KvNtvD1NbE+3ivFBPukugkEHb9aHvH+sN8u/T
	 MyZWsmlYpJjRWO4sQB9RsxxrA74YMeSlkE9fZ5zQ=
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
Subject: [PATCH 6.7 189/309] tracefs: Zero out the tracefs_inode when allocating it
Date: Tue, 20 Feb 2024 21:55:48 +0100
Message-ID: <20240220205639.069420681@linuxfoundation.org>
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


