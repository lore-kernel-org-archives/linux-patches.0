Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7901D1D0E39;
	Wed,  2 Oct 2024 14:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877666; cv=none; b=W0foqgrGxFIhwwXU3YK/AhtUrWJOY1eomUws88zsyp7dTIV8IE+CPfwtkgvTgw+5P92V7bwQh2a7UcwLKJ6YM8akOdgO3EiZrFwtBAN5ZBOBRhrHGJ+Vc2/qx6aXpKN0XtgONjrA0/OptTEr1epHslG0/2X067Nbd2v5X2TasDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877666; c=relaxed/simple;
	bh=xsmePFoEX/zD9+IKj2pqZYDpJk7hvYkNhSRpVNG5vhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3WKqhOD6RcV2PNsrjJlQWfddQml2Ye2EfDw9c6RPb506lxJ8JmFaOZDxmJWbDVqcNXZpVu82/kGEfbASKAV5YYYDNCECIKkPmYrVFS8mue3Z3ahsBk6QCCl3l3NqU7rb6r0WMvGDmztM+b4mq0last6UtvKDI7aGljEGnajJ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxJhs/a6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxJhs/a6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1F2C4CEC2;
	Wed,  2 Oct 2024 14:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877666;
	bh=xsmePFoEX/zD9+IKj2pqZYDpJk7hvYkNhSRpVNG5vhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxJhs/a6rjZcl+ZHTSh6Icj31OXwVQu6LR6xPQapYW7clmAsyrf8KpmEQdI6f6K2t
	 XqJH53R4Fao7hhe0dxbXJE2VYU02FwIb4JfuI/WyeW5jyR+5xqZ3rMSlrVy/FTUFbS
	 khg5AiTrxXUITfo4COf30RvNWXbKsQnEq9lWrqxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 152/634] m68k: Fix kernel_clone_args.flags in m68k_clone()
Date: Wed,  2 Oct 2024 14:54:12 +0200
Message-ID: <20241002125817.110447880@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 09b3d870faa7bc3e96c0978ab3cf4e96e4b15571 ]

Stan Johnson recently reported a failure from the 'dump' command:

  DUMP: Date of this level 0 dump: Fri Aug  9 23:37:15 2024
  DUMP: Dumping /dev/sda (an unlisted file system) to /dev/null
  DUMP: Label: none
  DUMP: Writing 10 Kilobyte records
  DUMP: mapping (Pass I) [regular files]
  DUMP: mapping (Pass II) [directories]
  DUMP: estimated 3595695 blocks.
  DUMP: Context save fork fails in parent 671

The dump program uses the clone syscall with the CLONE_IO flag, that is,
flags == 0x80000000. When that value is promoted from long int to u64 by
m68k_clone(), it undergoes sign-extension. The new value includes
CLONE_INTO_CGROUP so the validation in cgroup_css_set_fork() fails and
the syscall returns -EBADF. Avoid sign-extension by casting to u32.

Reported-by: Stan Johnson <userm57@yahoo.com>
Closes: https://lists.debian.org/debian-68k/2024/08/msg00000.html
Fixes: 6aabc1facdb2 ("m68k: Implement copy_thread_tls()")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/3463f1e5d4e95468dc9f3368f2b78ffa7b72199b.1723335149.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 2584e94e21346..fda7eac23f872 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -117,7 +117,7 @@ asmlinkage int m68k_clone(struct pt_regs *regs)
 {
 	/* regs will be equal to current_pt_regs() */
 	struct kernel_clone_args args = {
-		.flags		= regs->d1 & ~CSIGNAL,
+		.flags		= (u32)(regs->d1) & ~CSIGNAL,
 		.pidfd		= (int __user *)regs->d3,
 		.child_tid	= (int __user *)regs->d4,
 		.parent_tid	= (int __user *)regs->d3,
-- 
2.43.0



