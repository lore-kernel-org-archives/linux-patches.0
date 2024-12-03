Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743C8381B1;
	Tue,  3 Dec 2024 15:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241424; cv=none; b=WdLUJL8v7dfKvxek196zohm6mVymEhYq4VVmaArRTS+tmmGwMCjkpSSEIL0FHaw430thneysrLNbto6GyrW5HwlqmJzPWcIhanyKOkgRf9jzUjha8fu1SQsif31XXkI/si+KEO2GJo8CuwsM+1E4YeAmmjqaXuqS4KLyxfaFiXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241424; c=relaxed/simple;
	bh=fV+eB8NILSqPvqZQcX3Ro6ZXASyJ9FD5ADQr0VHaph0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1MvREVaY9PyV7LYOCHQA3GcZZu13dLWgT7/WwOTstHsFA5az37SL5SPiGYybTkD+ESeuvDTjoJc1ljQg7zrU55gXciKkb8nBk0lKwa7mPe8hTNryJwvWnYke3IJVj4a3ZogpfhTbmP9hxtGMuDo/LJFWfMjkxlcQEN6tmmJwH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKyyKJoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKyyKJoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D655AC4CECF;
	Tue,  3 Dec 2024 15:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241424;
	bh=fV+eB8NILSqPvqZQcX3Ro6ZXASyJ9FD5ADQr0VHaph0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKyyKJohmOjYBuPie1k2wSunLsvr2xdCi6j/yjA3WvNtCLNcIoayCTqKTNksNjKOx
	 v32fUrFT1KHkpDeh6mUF+lQvwKZ846/2WCvs6vbtuCK5ev4altcBZcc54i/S+Zv/Yv
	 iHwVXAf7ppQe8OGzTSABopR4zv4ostUd26QmTtNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Disha Goel <disgoel@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 382/826] powerpc/mm/fault: Fix kfence page fault reporting
Date: Tue,  3 Dec 2024 15:41:49 +0100
Message-ID: <20241203144758.668516296@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

[ Upstream commit 06dbbb4d5f7126b6307ab807cbf04ecfc459b933 ]

copy_from_kernel_nofault() can be called when doing read of /proc/kcore.
/proc/kcore can have some unmapped kfence objects which when read via
copy_from_kernel_nofault() can cause page faults. Since *_nofault()
functions define their own fixup table for handling fault, use that
instead of asking kfence to handle such faults.

Hence we search the exception tables for the nip which generated the
fault. If there is an entry then we let the fixup table handler handle the
page fault by returning an error from within ___do_page_fault().

This can be easily triggered if someone tries to do dd from /proc/kcore.
eg. dd if=/proc/kcore of=/dev/null bs=1M

Some example false negatives:

  ===============================
  BUG: KFENCE: invalid read in copy_from_kernel_nofault+0x9c/0x1a0
  Invalid read at 0xc0000000fdff0000:
   copy_from_kernel_nofault+0x9c/0x1a0
   0xc00000000665f950
   read_kcore_iter+0x57c/0xa04
   proc_reg_read_iter+0xe4/0x16c
   vfs_read+0x320/0x3ec
   ksys_read+0x90/0x154
   system_call_exception+0x120/0x310
   system_call_vectored_common+0x15c/0x2ec

  BUG: KFENCE: use-after-free read in copy_from_kernel_nofault+0x9c/0x1a0
  Use-after-free read at 0xc0000000fe050000 (in kfence-#2):
   copy_from_kernel_nofault+0x9c/0x1a0
   0xc00000000665f950
   read_kcore_iter+0x57c/0xa04
   proc_reg_read_iter+0xe4/0x16c
   vfs_read+0x320/0x3ec
   ksys_read+0x90/0x154
   system_call_exception+0x120/0x310
   system_call_vectored_common+0x15c/0x2ec

Fixes: 90cbac0e995d ("powerpc: Enable KFENCE for PPC32")
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reported-by: Disha Goel <disgoel@linux.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/a411788081d50e3b136c6270471e35aba3dfafa3.1729271995.git.ritesh.list@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/fault.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 81c77ddce2e30..c156fe0d53c37 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -439,10 +439,16 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
 	/*
 	 * The kernel should never take an execute fault nor should it
 	 * take a page fault to a kernel address or a page fault to a user
-	 * address outside of dedicated places
+	 * address outside of dedicated places.
+	 *
+	 * Rather than kfence directly reporting false negatives, search whether
+	 * the NIP belongs to the fixup table for cases where fault could come
+	 * from functions like copy_from_kernel_nofault().
 	 */
 	if (unlikely(!is_user && bad_kernel_fault(regs, error_code, address, is_write))) {
-		if (kfence_handle_page_fault(address, is_write, regs))
+		if (is_kfence_address((void *)address) &&
+		    !search_exception_tables(instruction_pointer(regs)) &&
+		    kfence_handle_page_fault(address, is_write, regs))
 			return 0;
 
 		return SIGSEGV;
-- 
2.43.0



