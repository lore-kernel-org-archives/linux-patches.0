Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8968370ACE;
	Sat, 17 Oct 2026 16:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253368; cv=none; b=Hn1fJwafdTndAPAmKAEsmLTLrpQV8MuSoCaLNTwyrmZxbc2v5KI5M1Wl788yrm6Z570c13pC311j700PY/kJe+TkjL/9nrT+dm0bOXAmSCqjOpbMvSj2CDz+3U/JLdM06hulbk5mjHwPi0XBMR1Ym8ykvu4cOC9FmC/4dqqLljc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253368; c=relaxed/simple;
	bh=jLjvkKgYzr/6faVKEaDgX4WfiLmGBMS+6XLE/VS1FCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAPqYFQiyRmA0d0D9r7j7JT7pDGb5KWGkoSBoLDd19cHEQ0iRCBGrhb+3/O+R5nT5cJquawMQDvCbe0ynijeJJcK8bLkj+yTxqzSBmGjB481260p9FbZH8Iq3M5lmvOXLaBGtWcCESWQ4s75dQ3bpF5aWlOd3Fa+//87HQN94Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tK+nt7mF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tK+nt7mF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D430A1F000C5;
	Sat, 17 Oct 2026 16:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253367;
	bh=2c53FjLPkuh7y7FBQAvxd1KyRU1dIobjCJh0TQ0h4JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tK+nt7mFx8F5nuewjz8+aRt2ST+zNBDb7BsG0x3l6owDhsJFsXaPpr4HzRkVItapo
	 ahT56Wzlwa6kxS8OWo3A2Y9dd3LHlUUIe15TabGVW9RmYfK+FJLtKPKpHnys9vWJDW
	 87dRceLogC8rm9EHilfbYLD8jURJu42PQP7r3tqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/869] s390/mm: Fix in_atomic() handling in do_secure_storage_access()
Date: Sat, 17 Oct 2026 17:48:55 +0200
Message-ID: <20261017160039.447394421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 11709abccf93b08adde95ef313c300b0d4bc28f1 ]

Kernel user spaces accesses to not exported pages in atomic context
incorrectly try to resolve the page fault.
With debug options enabled call traces like this can be seen:

BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1523
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 419074, name: qemu-system-s39
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<00000383ea47cfa2>] copy_page_from_iter_atomic+0xa2/0x8a0
CPU: 12 UID: 0 PID: 419074 Comm: qemu-system-s39
Tainted: G        W           6.16.0-20250531.rc0.git0.69b3a602feac.63.fc42.s390x+debug #1 PREEMPT
Tainted: [W]=WARN
Hardware name: IBM 3931 A01 703 (LPAR)
Call Trace:
 [<00000383e990d282>] dump_stack_lvl+0xa2/0xe8
 [<00000383e99bf152>] __might_resched+0x292/0x2d0
 [<00000383eaa7c374>] down_read+0x34/0x2d0
 [<00000383e99432f8>] do_secure_storage_access+0x108/0x360
 [<00000383eaa724b0>] __do_pgm_check+0x130/0x220
 [<00000383eaa842e4>] pgm_check_handler+0x114/0x160
 [<00000383ea47d028>] copy_page_from_iter_atomic+0x128/0x8a0
([<00000383ea47d016>] copy_page_from_iter_atomic+0x116/0x8a0)
 [<00000383e9c45eae>] generic_perform_write+0x16e/0x310
 [<00000383e9eb87f4>] ext4_buffered_write_iter+0x84/0x160
 [<00000383e9da0de4>] vfs_write+0x1c4/0x460
 [<00000383e9da123c>] ksys_write+0x7c/0x100
 [<00000383eaa7284e>] __do_syscall+0x15e/0x280
 [<00000383eaa8417e>] system_call+0x6e/0x90
INFO: lockdep is turned off.

It is not allowed to take the mmap_lock while in atomic context. Therefore
handle such a secure storage access fault as if the accessed page is not
mapped: the uaccess function will return -EFAULT, and the caller has to
deal with this. Usually this means that the access is retried in process
context, which allows to resolve the page fault (or in this case export the
page).

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20250603134936.1314139-1-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 93ae097ef0e08..f907e916aa20d 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -448,6 +448,8 @@ void do_secure_storage_access(struct pt_regs *regs)
 		if (rc)
 			BUG();
 	} else {
+		if (faulthandler_disabled())
+			return handle_fault_error_nolock(regs, 0);
 		mm = current->mm;
 		mmap_read_lock(mm);
 		vma = find_vma(mm, addr);
-- 
2.53.0



