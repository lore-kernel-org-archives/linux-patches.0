Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794778634E;
	Wed,  5 Feb 2025 14:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766292; cv=none; b=qDq6itycVvb+Hz4t3N5M6SjxqMAoR5fu2OUl+2iY74wqnPnvnHXKODwDD2aMzCxBfPEiJ/J3kgEDIQz1xe/PVQKMbREEf04nbIUQXKSyVLgvGtOteaD2zzfgx9Lu4pbxYeDEeJPVayLlt3UOh+Hf9sKf5frzskFiknPtWrdow3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766292; c=relaxed/simple;
	bh=LmV8m+UZpwCLSWipRxicntYF6l4pbda9BVN73j/tYmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgze2QF8rnTxm0efZ1yX0sPxaK11/Gihlv+FbyG3eLi/9WduC3kE0hmJMT6e6mGDnBiR8Ry4/46lvsbv/9mQbohQr+OBv4//JsbFpPrxtLIj11QrLUh9mOnfRxgkuGg4RDbY+z4z/ROfnVtiM59VJPgz3903CqXZk2xqzNeBxTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4Qtznhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4Qtznhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D742CC4CED1;
	Wed,  5 Feb 2025 14:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766292;
	bh=LmV8m+UZpwCLSWipRxicntYF6l4pbda9BVN73j/tYmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4Qtznhd8RVGHz5CATkX8Zq1QGx43BGnsXWAlPDPl+SNivK98eYcR/AvpffyHT65o
	 sLQsPFtHU43QbPVq6XXXXRPIkhJ/EAbaF10iD6aSmsAETemDzhE0i84t/zHXJb+YYu
	 pY+l/Z9LYQV8eHa1P8cH9VaERZIyj98nm1i4fPWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Kumar Bhaskar <skb99@linux.ibm.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 260/623] selftests/bpf: Fix fill_link_info selftest on powerpc
Date: Wed,  5 Feb 2025 14:40:02 +0100
Message-ID: <20250205134506.178052737@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saket Kumar Bhaskar <skb99@linux.ibm.com>

[ Upstream commit 4d33dc1bc31df80356c49e40dbd3ddff19500bcb ]

With CONFIG_KPROBES_ON_FTRACE enabled on powerpc, ftrace_location_range
returns ftrace location for bpf_fentry_test1 at offset of 4 bytes from
function entry. This is because branch to _mcount function is at offset
of 4 bytes in function profile sequence.

To fix this, add entry_offset of 4 bytes while verifying the address for
kprobe entry address of bpf_fentry_test1 in verify_perf_link_info in
selftest, when CONFIG_KPROBES_ON_FTRACE is enabled.

Disassemble of bpf_fentry_test1:

c000000000e4b080 <bpf_fentry_test1>:
c000000000e4b080:       a6 02 08 7c     mflr    r0
c000000000e4b084:       b9 e2 22 4b     bl      c00000000007933c <_mcount>
c000000000e4b088:       01 00 63 38     addi    r3,r3,1
c000000000e4b08c:       b4 07 63 7c     extsw   r3,r3
c000000000e4b090:       20 00 80 4e     blr

When CONFIG_PPC_FTRACE_OUT_OF_LINE [1] is enabled, these function profile
sequence is moved out of line with an unconditional branch at offset 0.
So, the test works without altering the offset for
'CONFIG_KPROBES_ON_FTRACE && CONFIG_PPC_FTRACE_OUT_OF_LINE' case.

Disassemble of bpf_fentry_test1:

c000000000f95190 <bpf_fentry_test1>:
c000000000f95190:       00 00 00 60     nop
c000000000f95194:       01 00 63 38     addi    r3,r3,1
c000000000f95198:       b4 07 63 7c     extsw   r3,r3
c000000000f9519c:       20 00 80 4e     blr

[1] https://lore.kernel.org/all/20241030070850.1361304-13-hbathini@linux.ibm.com/

Fixes: 23cf7aa539dc ("selftests/bpf: Add selftest for fill_link_info")
Signed-off-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241209065720.234344-1-skb99@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/fill_link_info.c       |  4 ++++
 .../selftests/bpf/progs/test_fill_link_info.c       | 13 ++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fill_link_info.c b/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
index d50cbd8040d45..e59af2aa66016 100644
--- a/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
+++ b/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
@@ -171,6 +171,10 @@ static void test_kprobe_fill_link_info(struct test_fill_link_info *skel,
 		/* See also arch_adjust_kprobe_addr(). */
 		if (skel->kconfig->CONFIG_X86_KERNEL_IBT)
 			entry_offset = 4;
+		if (skel->kconfig->CONFIG_PPC64 &&
+		    skel->kconfig->CONFIG_KPROBES_ON_FTRACE &&
+		    !skel->kconfig->CONFIG_PPC_FTRACE_OUT_OF_LINE)
+			entry_offset = 4;
 		err = verify_perf_link_info(link_fd, type, kprobe_addr, 0, entry_offset);
 		ASSERT_OK(err, "verify_perf_link_info");
 	} else {
diff --git a/tools/testing/selftests/bpf/progs/test_fill_link_info.c b/tools/testing/selftests/bpf/progs/test_fill_link_info.c
index 6afa834756e9f..fac33a14f2009 100644
--- a/tools/testing/selftests/bpf/progs/test_fill_link_info.c
+++ b/tools/testing/selftests/bpf/progs/test_fill_link_info.c
@@ -6,13 +6,20 @@
 #include <stdbool.h>
 
 extern bool CONFIG_X86_KERNEL_IBT __kconfig __weak;
+extern bool CONFIG_PPC_FTRACE_OUT_OF_LINE __kconfig __weak;
+extern bool CONFIG_KPROBES_ON_FTRACE __kconfig __weak;
+extern bool CONFIG_PPC64 __kconfig __weak;
 
-/* This function is here to have CONFIG_X86_KERNEL_IBT
- * used and added to object BTF.
+/* This function is here to have CONFIG_X86_KERNEL_IBT,
+ * CONFIG_PPC_FTRACE_OUT_OF_LINE, CONFIG_KPROBES_ON_FTRACE,
+ * CONFIG_PPC6 used and added to object BTF.
  */
 int unused(void)
 {
-	return CONFIG_X86_KERNEL_IBT ? 0 : 1;
+	return CONFIG_X86_KERNEL_IBT ||
+			CONFIG_PPC_FTRACE_OUT_OF_LINE ||
+			CONFIG_KPROBES_ON_FTRACE ||
+			CONFIG_PPC64 ? 0 : 1;
 }
 
 SEC("kprobe")
-- 
2.39.5



