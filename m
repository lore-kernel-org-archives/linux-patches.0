Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586433DAAB7;
	Fri,  4 Sep 2026 05:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499588; cv=none; b=aTg2BQttJsY5i/1pmUAUiA8JudB4lFYpxsRElOGuR2p9Gokj2F1lbduYXuFZNtePMQMspYtjf/zxjLmHQWuRk+4X06mn3BB0zFu1GBE+IqnhYm8UTfs9iKXj1UdmuuzoULK91mAvO3QvJteSpjXRvac/+1nAus3y9wB4mOZwPlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499588; c=relaxed/simple;
	bh=0y/v7nvStnvQyE7LufQUjRz8Pfk32dm9z/6Cww8zuQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoHO1Zz2lgE2y6/YBaV08C/iW1HK6xQPHOxpqrO5Vx00MNg5/S3nw1a69/GUDfCYPeKdnZNTERH5APF25erpUg2hq13UFnHsekxwgSCQlZ78c3ABxzLqQxmnSlQa6qwG3hxQNlahnca+lPS8hb1RcuS4PhrfmC1WNNiEWqgqqtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDyaffku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDyaffku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A381F00A3D;
	Fri,  4 Sep 2026 05:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499587;
	bh=TNl+vXJ+DzqqSpH0kVeqiMxpa50Ci5Ckl3a0ng8O55U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDyaffkuX8AdMwFTFgEjddkZAdxwQPDwGbq5qgUZh2l32Vo+HRft9LlAAf9ShXtp3
	 hWdaKeSV9zipZG2+8Q+itOw8SuuA3F2yXUe33Dz67/XWlXe95qfpcU8ssnjwvekZZ3
	 W9ZMxcv8WxRn/mztMPG1CLj03hLr+F7zQIyePVpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Stafford Horne <shorne@gmail.com>
Subject: [PATCH 7.2 470/713] openrisc: fix arbitrary kernel memory access via or1k_atomic syscall
Date: Fri,  4 Sep 2026 06:57:18 +0200
Message-ID: <20260904045814.359034378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

commit 78004e9a87f240df03e2f73120d291763c32e0a7 upstream.

sys_or1k_atomic() (syscall 244 in the "or1k" ABI) takes two user
pointers, v1 and v2, and swaps the words they point to in hand-written
assembly.

    l.lwz   r29,0(r4)
    l.lwz   r27,0(r5)
    l.sw    0(r4),r27
    l.sw    0(r5),r29

The pointers are not checked with access_ok(). The four memory
accesses also have no exception table entries.

A caller passes a kernel address as either pointer, and the syscall
reads from and writes to it directly.

This gives an unprivileged process a kernel read/write primitive. It
overwrites kernel data such as the sys_call_table, gaining code
execution in kernel context.

Check both pointers before entering the critical section. Add fixups
for the four memory accesses so faults on valid but unmapped user
addresses return -EFAULT.

[shorne@gmail.com: fix comment style]
Fixes: 9d02a4283e9c ("OpenRISC: Boot code")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/openrisc/kernel/entry.S |   43 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -1223,15 +1223,50 @@ _no_syscall_trace:
  *
  */
 
+/* Keep this literal; hi()/lo() can't use the UL-suffixed TASK_SIZE. */
+#define OR1K_ATOMIC_ADDR_LIMIT	0x7ffffffc
+
 ENTRY(sys_or1k_atomic)
 	/* FIXME: This ignores r3 and always does an XCHG */
+
+	/* Check both user pointers before accessing them. */
+	l.movhi	r13,hi(OR1K_ATOMIC_ADDR_LIMIT)
+	l.ori	r13,r13,lo(OR1K_ATOMIC_ADDR_LIMIT)
+	l.sfgtu	r4,r13
+	l.bf	9f
+	 l.nop
+	l.sfgtu	r5,r13
+	l.bf	9f
+	 l.nop
+
 	DISABLE_INTERRUPTS(r17,r19)
-	l.lwz	r29,0(r4)
-	l.lwz	r27,0(r5)
-	l.sw	0(r4),r27
-	l.sw	0(r5),r29
+10:	l.lwz	r29,0(r4)
+11:	l.lwz	r27,0(r5)
+12:	l.sw	0(r4),r27
+13:	l.sw	0(r5),r29
 	ENABLE_INTERRUPTS(r17)
 	l.jr	r9
 	 l.or	r11,r0,r0
 
+	/*
+	 * Either pointer was outside user space, or turned out to be
+	 * unmapped/inaccessible when we actually touched it.
+	 */
+9:	l.jr	r9
+	 l.addi	r11,r0,-EFAULT
+
+	.section .fixup, "ax"
+14:
+	ENABLE_INTERRUPTS(r17)
+	l.j	9b
+	 l.nop
+	.previous
+
+	.section __ex_table, "a"
+	.long	10b, 14b
+	.long	11b, 14b
+	.long	12b, 14b
+	.long	13b, 14b
+	.previous
+
 /* ============================================================[ EOF ]=== */


