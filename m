Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDE413AA5F;
	Fri,  6 Dec 2024 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497389; cv=none; b=WHIRIK8qe2+LHEYU4xZ6nvyC2RtSvXIbuKd54q9/hee+XfHlAfc2ps1yoXSr4LnuKp+jVOdbC84aE44qhgVHlIrFZw15SvyyBJj08ObzSoO7F5WhHyQWDwv5gQ9gQFOKfYkT8uuGsIxZG0T9p8IvfCxi6jLvq5Hi/Ftl8V/4yaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497389; c=relaxed/simple;
	bh=KIwEOfTbdzlofnoifd6m5wYXKpSK2xrVBrFbmv12ANM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmiZ5plQWKELlez4tRaKA7xmg6QOXNw2WNT3D4W3Qr40eT7/pVyNVK8VaR5MrC9nIDJr2HzYifGVXK/CXIwcemdTe+QJtBH66+2i07+B3qpdNtu0/m9ckie0nKLgZZGP7wPwTYGUt/l3wXw4MlXK2qSHjRjEmhxIerWtG0+UxlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWCQvb1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWCQvb1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4389FC4CED1;
	Fri,  6 Dec 2024 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497389;
	bh=KIwEOfTbdzlofnoifd6m5wYXKpSK2xrVBrFbmv12ANM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWCQvb1yNvJX6VuIiSErFIvuNtABzgdWNi7xURh8nv21kowz+iVWgJOcTsNCfbZMJ
	 neZMZjXQ0HmT8GDGTGnEyPnokd+Q5eGUHMoQd2lNgZpfJ1y7gm51aLHlndsDhQ4aPw
	 u8Eif6zWVjJxOwkpBac3zIwsocfr/kpBtHopGumw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Disha Goel <disgoel@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/676] powerpc/mm/fault: Fix kfence page fault reporting
Date: Fri,  6 Dec 2024 15:31:35 +0100
Message-ID: <20241206143704.122141200@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index b1723094d464c..d3e0f5b3ecc74 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -431,10 +431,16 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
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



