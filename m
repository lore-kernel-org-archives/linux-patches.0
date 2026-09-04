Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDFC37C106;
	Fri,  4 Sep 2026 05:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501255; cv=none; b=tIxY57Pc83CCvpR6f0T8YFN3Lwftmkl0rKE+moOOzBiDCm7IgVAk5KRh+PC5/286xEzfMJ7HJXturiY+fopcjfMX8+HFGB+hkq+l/qM8/dNn4ESy1807VENI9EhWuJItjffIrNDYHhPLM63Hrqi/IkAtW43arwZIfRpfMmcXYx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501255; c=relaxed/simple;
	bh=c9B5NlKCwJ8xqoRAjGLD5ytRl9Ech889Y/UFIWKu/4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RT0Qivptmuyftg4H3KOF0YhKoM9nR2FEqNFgvT21p8C1zBvrmkHBM7LgPKjInvaI7QO5vi5yWyftIMckjHdeesklpKyI5YU/HWA7ayPPVseDQZNQNacG7UZanWNnw05vqgC1U90tQpTqy4zsq4yxnqfnF6jyE+9WcUch7oPfBm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XScLfM4h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XScLfM4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019CE1F00A3D;
	Fri,  4 Sep 2026 05:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501254;
	bh=sKUluryQABa6TAUi/chiEPxl0GGBIqMEoyn9z3elZ5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XScLfM4hOvNTbGD3LOXgE2UKlJDLu0eee1vST5c02SDRbggsFt92q/yrIcPXuZevP
	 0kyFRSpBZ/6OMCoiXqmmJr42t22t082R3Aaz/5w691HblvyZTipK4jV6EnoQfPNgOs
	 ZxHKAdUje1SprykX4pIZuV/pC7Hc6rXRf8Kw91aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Stafford Horne <shorne@gmail.com>
Subject: [PATCH 6.18 343/552] openrisc: fix arbitrary kernel memory access via or1k_atomic syscall
Date: Fri,  4 Sep 2026 06:58:20 +0200
Message-ID: <20260904045758.031107981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


