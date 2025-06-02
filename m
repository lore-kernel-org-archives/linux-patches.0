Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F9C221703;
	Mon,  2 Jun 2025 13:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872190; cv=none; b=Av5StFxqCa/HScTdBEn2ubHvk0ZDawsRdKmrzHRIH3fPNgyuioaete29dY7OSNcFx6iRthWpPqT/BtVg1MMOHqNYnYchVUE5KSxKJYCmL3SqUD383gEYqKxJSp5sa3Bf+hwcM5j3WPyK7tAR0PoHm6DT8aWC1vzi/n8M80xRBik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872190; c=relaxed/simple;
	bh=hCNY5Te4SZwxvY1LNSRiYHJei9XCZ4PUfq6qXR8/UHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sB8JekxFuioLYMrqsQRWLdL1Dd6imbAAFczbTVDJDzZMkqp6zZGTvOTpdXxZ0uwWi6naR9johfmjJPLkpZQeXtP+Bv+TVHKzZJQiEhicJI13E4pQ2fB2e/cnSo2aWR6NCOSNiL+CiMzKmhfA8xV+ckOp4EK0FdOG3CUY44Q/6uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xr7bex5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xr7bex5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE23C4CEEB;
	Mon,  2 Jun 2025 13:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872190;
	bh=hCNY5Te4SZwxvY1LNSRiYHJei9XCZ4PUfq6qXR8/UHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xr7bex5H9/UI4g40jlkamTYM07pIsyS+dHfTKuQtMGi4SW9lEW6NzZUHIfaw4dF0k
	 TkXIx3csm6AZ/5daz1dT1FEWOF10JnMJixRvluxedAHySM42dQLoUP/AFX84yWSiBL
	 zZamnOn/sxHwYBlUt+5RGbOrYsxJ7rWl7/ldIH5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.15 47/49] coredump: hand a pidfd to the usermode coredump helper
Date: Mon,  2 Jun 2025 15:47:39 +0200
Message-ID: <20250602134239.786689812@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit b5325b2a270fcaf7b2a9a0f23d422ca8a5a8bdea upstream.

Give userspace a way to instruct the kernel to install a pidfd into the
usermode helper process. This makes coredump handling a lot more
reliable for userspace. In parallel with this commit we already have
systemd adding support for this in [1].

We create a pidfs file for the coredumping process when we process the
corename pattern. When the usermode helper process is forked we then
install the pidfs file as file descriptor three into the usermode
helpers file descriptor table so it's available to the exec'd program.

Since usermode helpers are either children of the system_unbound_wq
workqueue or kthreadd we know that the file descriptor table is empty
and can thus always use three as the file descriptor number.

Note, that we'll install a pidfd for the thread-group leader even if a
subthread is calling do_coredump(). We know that task linkage hasn't
been removed due to delay_group_leader() and even if this @current isn't
the actual thread-group leader we know that the thread-group leader
cannot be reaped until @current has exited.

Link: https://github.com/systemd/systemd/pull/37125 [1]
Link: https://lore.kernel.org/20250414-work-coredump-v2-3-685bf231f828@kernel.org
Tested-by: Luca Boccassi <luca.boccassi@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c            |   56 +++++++++++++++++++++++++++++++++++++++++++----
 include/linux/coredump.h |    1 
 2 files changed, 53 insertions(+), 4 deletions(-)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -43,6 +43,8 @@
 #include <linux/timekeeping.h>
 #include <linux/sysctl.h>
 #include <linux/elf.h>
+#include <linux/pidfs.h>
+#include <uapi/linux/pidfd.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -60,6 +62,12 @@ static void free_vma_snapshot(struct cor
 #define CORE_FILE_NOTE_SIZE_DEFAULT (4*1024*1024)
 /* Define a reasonable max cap */
 #define CORE_FILE_NOTE_SIZE_MAX (16*1024*1024)
+/*
+ * File descriptor number for the pidfd for the thread-group leader of
+ * the coredumping task installed into the usermode helper's file
+ * descriptor table.
+ */
+#define COREDUMP_PIDFD_NUMBER 3
 
 static int core_uses_pid;
 static unsigned int core_pipe_limit;
@@ -339,6 +347,27 @@ static int format_corename(struct core_n
 			case 'C':
 				err = cn_printf(cn, "%d", cprm->cpu);
 				break;
+			/* pidfd number */
+			case 'F': {
+				/*
+				 * Installing a pidfd only makes sense if
+				 * we actually spawn a usermode helper.
+				 */
+				if (!ispipe)
+					break;
+
+				/*
+				 * Note that we'll install a pidfd for the
+				 * thread-group leader. We know that task
+				 * linkage hasn't been removed yet and even if
+				 * this @current isn't the actual thread-group
+				 * leader we know that the thread-group leader
+				 * cannot be reaped until @current has exited.
+				 */
+				cprm->pid = task_tgid(current);
+				err = cn_printf(cn, "%d", COREDUMP_PIDFD_NUMBER);
+				break;
+			}
 			default:
 				break;
 			}
@@ -493,7 +522,7 @@ static void wait_for_dump_helpers(struct
 }
 
 /*
- * umh_pipe_setup
+ * umh_coredump_setup
  * helper function to customize the process used
  * to collect the core in userspace.  Specifically
  * it sets up a pipe and installs it as fd 0 (stdin)
@@ -503,12 +532,31 @@ static void wait_for_dump_helpers(struct
  * is a special value that we use to trap recursive
  * core dumps
  */
-static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
+static int umh_coredump_setup(struct subprocess_info *info, struct cred *new)
 {
 	struct file *files[2];
 	struct coredump_params *cp = (struct coredump_params *)info->data;
 	int err;
 
+	if (cp->pid) {
+		struct file *pidfs_file __free(fput) = NULL;
+
+		pidfs_file = pidfs_alloc_file(cp->pid, 0);
+		if (IS_ERR(pidfs_file))
+			return PTR_ERR(pidfs_file);
+
+		/*
+		 * Usermode helpers are childen of either
+		 * system_unbound_wq or of kthreadd. So we know that
+		 * we're starting off with a clean file descriptor
+		 * table. So we should always be able to use
+		 * COREDUMP_PIDFD_NUMBER as our file descriptor value.
+		 */
+		err = replace_fd(COREDUMP_PIDFD_NUMBER, pidfs_file, 0);
+		if (err < 0)
+			return err;
+	}
+
 	err = create_pipe_files(files, 0);
 	if (err)
 		return err;
@@ -598,7 +646,7 @@ void do_coredump(const kernel_siginfo_t
 		}
 
 		if (cprm.limit == 1) {
-			/* See umh_pipe_setup() which sets RLIMIT_CORE = 1.
+			/* See umh_coredump_setup() which sets RLIMIT_CORE = 1.
 			 *
 			 * Normally core limits are irrelevant to pipes, since
 			 * we're not writing to the file system, but we use
@@ -637,7 +685,7 @@ void do_coredump(const kernel_siginfo_t
 		retval = -ENOMEM;
 		sub_info = call_usermodehelper_setup(helper_argv[0],
 						helper_argv, NULL, GFP_KERNEL,
-						umh_pipe_setup, NULL, &cprm);
+						umh_coredump_setup, NULL, &cprm);
 		if (sub_info)
 			retval = call_usermodehelper_exec(sub_info,
 							  UMH_WAIT_EXEC);
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -28,6 +28,7 @@ struct coredump_params {
 	int vma_count;
 	size_t vma_data_size;
 	struct core_vma_metadata *vma_meta;
+	struct pid *pid;
 };
 
 extern unsigned int core_file_note_size_limit;


