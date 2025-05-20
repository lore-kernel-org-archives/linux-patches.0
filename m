Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A1E242922;
	Tue, 20 May 2025 13:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749201; cv=none; b=XIu3zThWRu//WnQ/fn+6a0Pz8aYizwn1+jhVqTrEJncwZYQ6bSjw+By0vlVGCR0vRqZyMzQmWjIrn3kuNkibcWtZKIkfxCarPzK8kQVmdn0lDRg8zAg+kM1PVUMgwkQndCbrTV7dh82f6UeFUmTIoR8BJ1n8sm90xg8WLjgqKhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749201; c=relaxed/simple;
	bh=Oufs6mnEbxcsG7UdLikqZvt1q0Rrjy03hsfE8v7rrlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpTQv6uttp8pAHGFfQnWksTDbqz6CarxmbW42kwDpOfQjY1lQuvf+ve/UfC239XFmgWi0Xjb+PRJu63iB8IXS1MbKrl9lh+7/EiKWEgi+cTpccYowJQ0iqqE76cdK9o3hXRbHZgiLTb7yv8M8J2BwLFLVnT4zFakhfConpNrCIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hv0au0zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hv0au0zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934CBC4CEEA;
	Tue, 20 May 2025 13:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749198;
	bh=Oufs6mnEbxcsG7UdLikqZvt1q0Rrjy03hsfE8v7rrlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hv0au0zwMW1EnAPTXVVj/vm9UCgkIsaunkm2bGQ7dn/r1FEwdlw0dkQ2ZP5QJC/UU
	 2hU4x6CJ25un3ikDUxMGvEkSnFS8+YjEfUV8sNvhCIUtPRj/aGZ2zs3YsQqAd6kevf
	 aIIT2sMLzRde+daQ6/wZBc9axD3jUXKboGlyZDhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 5.15 26/59] x86/its: Align RETs in BHB clear sequence to avoid thunking
Date: Tue, 20 May 2025 15:50:17 +0200
Message-ID: <20250520125754.901436583@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit f0cd7091cc5a032c8870b4285305d9172569d126 upstream.

The software mitigation for BHI is to execute BHB clear sequence at syscall
entry, and possibly after a cBPF program. ITS mitigation thunks RETs in the
lower half of the cacheline. This causes the RETs in the BHB clear sequence
to be thunked as well, adding unnecessary branches to the BHB clear
sequence.

Since the sequence is in hot path, align the RET instructions in the
sequence to avoid thunking.

This is how disassembly clear_bhb_loop() looks like after this change:

   0x44 <+4>:     mov    $0x5,%ecx
   0x49 <+9>:     call   0xffffffff81001d9b <clear_bhb_loop+91>
   0x4e <+14>:    jmp    0xffffffff81001de5 <clear_bhb_loop+165>
   0x53 <+19>:    int3
   ...
   0x9b <+91>:    call   0xffffffff81001dce <clear_bhb_loop+142>
   0xa0 <+96>:    ret
   0xa1 <+97>:    int3
   ...
   0xce <+142>:   mov    $0x5,%eax
   0xd3 <+147>:   jmp    0xffffffff81001dd6 <clear_bhb_loop+150>
   0xd5 <+149>:   nop
   0xd6 <+150>:   sub    $0x1,%eax
   0xd9 <+153>:   jne    0xffffffff81001dd3 <clear_bhb_loop+147>
   0xdb <+155>:   sub    $0x1,%ecx
   0xde <+158>:   jne    0xffffffff81001d9b <clear_bhb_loop+91>
   0xe0 <+160>:   ret
   0xe1 <+161>:   int3
   0xe2 <+162>:   int3
   0xe3 <+163>:   int3
   0xe4 <+164>:   int3
   0xe5 <+165>:   lfence
   0xe8 <+168>:   pop    %rbp
   0xe9 <+169>:   ret

Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1530,7 +1530,9 @@ SYM_CODE_END(rewind_stack_and_make_dead)
  * ORC to unwind properly.
  *
  * The alignment is for performance and not for safety, and may be safely
- * refactored in the future if needed.
+ * refactored in the future if needed. The .skips are for safety, to ensure
+ * that all RETs are in the second half of a cacheline to mitigate Indirect
+ * Target Selection, rather than taking the slowpath via its_return_thunk.
  */
 SYM_FUNC_START(clear_bhb_loop)
 	push	%rbp
@@ -1540,10 +1542,22 @@ SYM_FUNC_START(clear_bhb_loop)
 	call	1f
 	jmp	5f
 	.align 64, 0xcc
+	/*
+	 * Shift instructions so that the RET is in the upper half of the
+	 * cacheline and don't take the slowpath to its_return_thunk.
+	 */
+	.skip 32 - (.Lret1 - 1f), 0xcc
 	ANNOTATE_INTRA_FUNCTION_CALL
 1:	call	2f
-	RET
+.Lret1:	RET
 	.align 64, 0xcc
+	/*
+	 * As above shift instructions for RET at .Lret2 as well.
+	 *
+	 * This should be ideally be: .skip 32 - (.Lret2 - 2f), 0xcc
+	 * but some Clang versions (e.g. 18) don't like this.
+	 */
+	.skip 32 - 18, 0xcc
 2:	movl	$5, %eax
 3:	jmp	4f
 	nop
@@ -1551,7 +1565,7 @@ SYM_FUNC_START(clear_bhb_loop)
 	jnz	3b
 	sub	$1, %ecx
 	jnz	1b
-	RET
+.Lret2:	RET
 5:	lfence
 	pop	%rbp
 	RET


