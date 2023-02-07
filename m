Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9883212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599B5C4339B;
	Tue,  7 Feb 2023 13:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775578;
	bh=4qiiscSFxK43dBaW2SJP//lWmZU4i4CrpOr661Bi32U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMFAvP9Kw0o5SA2BGrhg8FO1DB4NRAKq3t/sIMJ2DoPUJXBzGwjRmnsVC90YE3XgT
	 Od/3FBSN+CnvVwBn6wUKW7jgzSBZSDltiXZ8TM6HYA3yPLuKehkKqDB0SUkF6uHvL9
	 YVTKkbfIn1cm9kvOsXM/Yx18y0oCWwlGy4lfNqiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 088/120] parisc: Wire up PTRACE_GETREGS/PTRACE_SETREGS for compat case
Date: Tue,  7 Feb 2023 13:57:39 +0100
Message-Id: <20230207125622.494301085@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit 316f1f42b5cc1d95124c1f0387c867c1ba7b6d0e upstream.

Wire up the missing ptrace requests PTRACE_GETREGS, PTRACE_SETREGS,
PTRACE_GETFPREGS and PTRACE_SETFPREGS when running 32-bit applications
on 64-bit kernels.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # 4.7+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/ptrace.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -127,6 +127,12 @@ long arch_ptrace(struct task_struct *chi
 	unsigned long tmp;
 	long ret = -EIO;
 
+	unsigned long user_regs_struct_size = sizeof(struct user_regs_struct);
+#ifdef CONFIG_64BIT
+	if (is_compat_task())
+		user_regs_struct_size /= 2;
+#endif
+
 	switch (request) {
 
 	/* Read the word at location addr in the USER area.  For ptraced
@@ -182,14 +188,14 @@ long arch_ptrace(struct task_struct *chi
 		return copy_regset_to_user(child,
 					   task_user_regset_view(current),
 					   REGSET_GENERAL,
-					   0, sizeof(struct user_regs_struct),
+					   0, user_regs_struct_size,
 					   datap);
 
 	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
 		return copy_regset_from_user(child,
 					     task_user_regset_view(current),
 					     REGSET_GENERAL,
-					     0, sizeof(struct user_regs_struct),
+					     0, user_regs_struct_size,
 					     datap);
 
 	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
@@ -303,6 +309,11 @@ long compat_arch_ptrace(struct task_stru
 			}
 		}
 		break;
+	case PTRACE_GETREGS:
+	case PTRACE_SETREGS:
+	case PTRACE_GETFPREGS:
+	case PTRACE_SETFPREGS:
+		return arch_ptrace(child, request, addr, data);
 
 	default:
 		ret = compat_ptrace_request(child, request, addr, data);


