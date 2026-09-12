Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD3138F64D;
	Sat, 12 Sep 2026 19:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241371; cv=none; b=Qk2f+A8wcL7FhqZKuoqXZG0GnBE6G/nqMVxKjtzSUWCYjZjieW0nEEwURxjiuZuMIGCHd2kHlrdsC9jYDLyxCNOBtjqH38yB/3CPPrGNYDucnZMM/5Va8ocz4y9cjkLqKqSgZyJSPMNNjIXXtELgs7kMMrKn8GAGqJD9ooCZUnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241371; c=relaxed/simple;
	bh=V1Oztecx+m9q8bEeRqvEIYwMaecPxIPKyi4E/oqzIrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtBGqej8rJo8FjHl/OBkC/dlaVyfPOJVeG7Ts7LLWU8TxhuZRUvBxhDOq/HsmOaJP20wX06NKDvbwvQIrM1llmj/mRwbpanCCVaYl+Nhgqg26hgND/jUhSxpyGMLRygiyiMuNdYK4DnNYuSalbQFSN8GNG26ZOAlRr1ISO4MWjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXRkb120; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXRkb120"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933A31F000FF;
	Sat, 12 Sep 2026 19:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241369;
	bh=JJ03yuxT3AmwLon76j4RObrcpzAph7i4wo1rSf7C4/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXRkb120LYAybTmmj9t/ugBINTfo6ppZ/YAm3+ExDgswZkBg6pXL6tPknRE/6l2Hk
	 G26bDLDg8cAAIhcMxOZAn+G68oDL0un2/3VYCG3qG4tBHiVP+wUptzo3zBnpQsTbsg
	 O4FoufBK3MIzPS6+l4XTU1VARy73wiRR9vWrsG+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Stafford Horne <shorne@gmail.com>
Subject: [PATCH 5.10 122/798] openrisc: fix arbitrary kernel memory access via or1k_atomic syscall
Date: Sat, 12 Sep 2026 08:55:50 +0200
Message-ID: <20260912065519.771601827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1205,15 +1205,50 @@ _no_syscall_trace:
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


