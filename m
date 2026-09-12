Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D5C421EFB;
	Sat, 12 Sep 2026 13:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220486; cv=none; b=OkkVdfv/bUSua1ISGEZT7z9F6lPKmbqBXNrCkcUSMGHuq/hiOIUo+yl3a9GguwHRf7KvuSd4x2qEhR2WZZMTg5EcHSaYFFLgHqdlGcrizrwwuIHVR5H7eAyCDmcSk3/GP/AnujfhOqMRtEbdBb67zsknZWxQJ69bOmBbjINXDlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220486; c=relaxed/simple;
	bh=+SDyE6Cn2b4cIKj+n9eFRnaus6jjDqhUXmi2bwVP2Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFxA6lEDYBOj4XU9YhbHfBM/6Tq1n6Yns2O9C0M5qlgI607itZQFCeWZlGasn2VkONg+75dEVIid5fvL252heIHJ0q7lXlOnaG3mYdkAQW6ZM6P90tre+CxkuZeuT+J6HDF0nNI90jBmp2sxauRgwDUddHpXh4YQrb79yiW44aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsNSXa+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsNSXa+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F9D1F000FF;
	Sat, 12 Sep 2026 13:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220485;
	bh=lZx59FbiALEqX4QR1aXNpwjjpBBYFAWX04wUFn1v/m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NsNSXa+ACaqv55aijOEq93Uh+KlIia985WB8qmtSmUouM3m2BDv3qry3SF+xdLFgi
	 CFDREWXEw8Ie9nKMrqYp3vtglM5xTBlQD3grxPPmjJs0aKiOhcM1JGDT+PQcOqHWiQ
	 jKKE0o/73IAaNXyxYp6fyYgsWWMQpu6HrKBOfB0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Stafford Horne <shorne@gmail.com>
Subject: [PATCH 6.6 0187/1424] openrisc: fix arbitrary kernel memory access via or1k_atomic syscall
Date: Sat, 12 Sep 2026 08:43:39 +0200
Message-ID: <20260912065611.476677669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1230,15 +1230,50 @@ _no_syscall_trace:
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


