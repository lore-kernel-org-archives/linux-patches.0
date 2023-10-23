Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560DE14F6A
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5KFslMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79DAC433C7;
	Mon, 23 Oct 2023 11:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060089;
	bh=X8lJJ75ZDn7AnBJh9AHRIucu8/PxO/uame38CaPEZTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5KFslMHmRKfQiokuUneqTutoK40nGNsYDV6SDdn0M/yE8PmcnZ4qsq0HJe3iB3uL
	 rcGzng2fqeQx/g3oA9ePxZeAWS83VNv/JCBPAvg4LxgR7QDpAaaZqK7NCFzrLs3PQg
	 Vf8WOORr2dA8wuWXELN2n6usmzp6oxezEPMI3XyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Clash <daclash@linux.microsoft.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 028/196] audit,io_uring: io_uring openat triggers audit reference count underflow
Date: Mon, 23 Oct 2023 12:54:53 +0200
Message-ID: <20231023104829.278495323@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Clash <daclash@linux.microsoft.com>

commit 03adc61edad49e1bbecfb53f7ea5d78f398fe368 upstream.

An io_uring openat operation can update an audit reference count
from multiple threads resulting in the call trace below.

A call to io_uring_submit() with a single openat op with a flag of
IOSQE_ASYNC results in the following reference count updates.

These first part of the system call performs two increments that do not race.

do_syscall_64()
  __do_sys_io_uring_enter()
    io_submit_sqes()
      io_openat_prep()
        __io_openat_prep()
          getname()
            getname_flags()       /* update 1 (increment) */
              __audit_getname()   /* update 2 (increment) */

The openat op is queued to an io_uring worker thread which starts the
opportunity for a race.  The system call exit performs one decrement.

do_syscall_64()
  syscall_exit_to_user_mode()
    syscall_exit_to_user_mode_prepare()
      __audit_syscall_exit()
        audit_reset_context()
           putname()              /* update 3 (decrement) */

The io_uring worker thread performs one increment and two decrements.
These updates can race with the system call decrement.

io_wqe_worker()
  io_worker_handle_work()
    io_wq_submit_work()
      io_issue_sqe()
        io_openat()
          io_openat2()
            do_filp_open()
              path_openat()
                __audit_inode()   /* update 4 (increment) */
            putname()             /* update 5 (decrement) */
        __audit_uring_exit()
          audit_reset_context()
            putname()             /* update 6 (decrement) */

The fix is to change the refcnt member of struct audit_names
from int to atomic_t.

kernel BUG at fs/namei.c:262!
Call Trace:
...
 ? putname+0x68/0x70
 audit_reset_context.part.0.constprop.0+0xe1/0x300
 __audit_uring_exit+0xda/0x1c0
 io_issue_sqe+0x1f3/0x450
 ? lock_timer_base+0x3b/0xd0
 io_wq_submit_work+0x8d/0x2b0
 ? __try_to_del_timer_sync+0x67/0xa0
 io_worker_handle_work+0x17c/0x2b0
 io_wqe_worker+0x10a/0x350

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/MW2PR2101MB1033FFF044A258F84AEAA584F1C9A@MW2PR2101MB1033.namprd21.prod.outlook.com/
Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
Signed-off-by: Dan Clash <daclash@linux.microsoft.com>
Link: https://lore.kernel.org/r/20231012215518.GA4048@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c         |    9 +++++----
 include/linux/fs.h |    2 +-
 kernel/auditsc.c   |    8 ++++----
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -187,7 +187,7 @@ getname_flags(const char __user *filenam
 		}
 	}
 
-	result->refcnt = 1;
+	atomic_set(&result->refcnt, 1);
 	/* The empty path is special. */
 	if (unlikely(!len)) {
 		if (empty)
@@ -248,7 +248,7 @@ getname_kernel(const char * filename)
 	memcpy((char *)result->name, filename, len);
 	result->uptr = NULL;
 	result->aname = NULL;
-	result->refcnt = 1;
+	atomic_set(&result->refcnt, 1);
 	audit_getname(result);
 
 	return result;
@@ -259,9 +259,10 @@ void putname(struct filename *name)
 	if (IS_ERR(name))
 		return;
 
-	BUG_ON(name->refcnt <= 0);
+	if (WARN_ON_ONCE(!atomic_read(&name->refcnt)))
+		return;
 
-	if (--name->refcnt > 0)
+	if (!atomic_dec_and_test(&name->refcnt))
 		return;
 
 	if (name->name != name->iname) {
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2735,7 +2735,7 @@ struct audit_names;
 struct filename {
 	const char		*name;	/* pointer to actual string */
 	const __user char	*uptr;	/* original userland pointer */
-	int			refcnt;
+	atomic_t		refcnt;
 	struct audit_names	*aname;
 	const char		iname[];
 };
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2208,7 +2208,7 @@ __audit_reusename(const __user char *upt
 		if (!n->name)
 			continue;
 		if (n->name->uptr == uptr) {
-			n->name->refcnt++;
+			atomic_inc(&n->name->refcnt);
 			return n->name;
 		}
 	}
@@ -2237,7 +2237,7 @@ void __audit_getname(struct filename *na
 	n->name = name;
 	n->name_len = AUDIT_NAME_FULL;
 	name->aname = n;
-	name->refcnt++;
+	atomic_inc(&name->refcnt);
 }
 
 static inline int audit_copy_fcaps(struct audit_names *name,
@@ -2369,7 +2369,7 @@ out_alloc:
 		return;
 	if (name) {
 		n->name = name;
-		name->refcnt++;
+		atomic_inc(&name->refcnt);
 	}
 
 out:
@@ -2496,7 +2496,7 @@ void __audit_inode_child(struct inode *p
 		if (found_parent) {
 			found_child->name = found_parent->name;
 			found_child->name_len = AUDIT_NAME_FULL;
-			found_child->name->refcnt++;
+			atomic_inc(&found_child->name->refcnt);
 		}
 	}
 


