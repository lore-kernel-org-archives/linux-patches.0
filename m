Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3068278B4B;
	Wed, 21 Feb 2024 14:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524852; cv=none; b=r6EMuEYA4g/+vnKOgKhQXiPeWxssB1JpfPZugYIvzb+QZKSaRRCviKZG6n6qZLpopGQ+V0RepeRzKuTZyudklDmqb4uZuVz296+mAzB9BMlea6sJn3Fn3BDAA4mQR331a7kP6Y1+VJUnEModoTpbylAlFVqDLJ/YRPalMynp9zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524852; c=relaxed/simple;
	bh=3MiNwxrL67HE70LKre8tez7BBZ4TT6h6T87itWp7KDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hB6FBRR3u3MHvmaZ/HGUOymQaI5qt+piRpsjXlZVencjB6g0yKj8f5Ot4nB+6iCnK6/CpWlGMxVT0pwe/B2ovpkVPVkPartMUOd1Bn9bB3HB/6Yxp0SJEmbOxHc5A3L4McBycyP/kHsancU/52Dc/pNbAm6r6bnYtPOeWc2CByk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I37vSY/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I37vSY/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE7BC433C7;
	Wed, 21 Feb 2024 14:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524852;
	bh=3MiNwxrL67HE70LKre8tez7BBZ4TT6h6T87itWp7KDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I37vSY/o39PmebRHJpVWDIPPzZrKzoCClTa+6vV2Y9t3DkVnFtZPuNdQOaC4xyRKX
	 0igPWw5JWHAyJ/YXEU0aVpp86CVrgHZTHSgfO84E6iVSrYybXvHsby9h4o1lB/Z+h9
	 BXTtSXls1GpAl6751EdOB+JIvDZyLtHeZjpojHRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Yang <xiangyang3@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.10 368/379] Revert "arm64: Stash shadow stack pointer in the task struct on interrupt"
Date: Wed, 21 Feb 2024 14:09:07 +0100
Message-ID: <20240221130005.949150800@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------


This reverts commit 3f225f29c69c13ce1cbdb1d607a42efeef080056 which is
commit 59b37fe52f49955791a460752c37145f1afdcad1 upstream.

The shadow call stack for irq now is stored in current task's thread info
in irq_stack_entry. There is a possibility that we have some soft irqs
pending at the end of hard irq, and when we process softirq with the irq
enabled, irq_stack_entry will enter again and overwrite the shadow call
stack whitch stored in current task's thread info, leading to the
incorrect shadow call stack restoration for the first entry of the hard
IRQ, then the system end up with a panic.

task A                               |  task A
-------------------------------------+------------------------------------
el1_irq        //irq1 enter          |
  irq_handler  //save scs_sp1        |
    gic_handle_irq                   |
    irq_exit                         |
      __do_softirq                   |
                                     | el1_irq         //irq2 enter
                                     |   irq_handler   //save scs_sp2
                                     |                 //overwrite scs_sp1
                                     |   ...
                                     |   irq_stack_exit //restore scs_sp2
  irq_stack_exit //restore wrong     |
                 //scs_sp2           |

So revert this commit to fix it.

Fixes: 3f225f29c69c ("arm64: Stash shadow stack pointer in the task struct on interrupt")
Signed-off-by: Xiang Yang <xiangyang3@huawei.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -431,7 +431,9 @@ SYM_CODE_END(__swpan_exit_el0)
 
 	.macro	irq_stack_entry
 	mov	x19, sp			// preserve the original sp
-	scs_save tsk			// preserve the original shadow stack
+#ifdef CONFIG_SHADOW_CALL_STACK
+	mov	x24, scs_sp		// preserve the original shadow stack
+#endif
 
 	/*
 	 * Compare sp with the base of the task stack.
@@ -465,7 +467,9 @@ SYM_CODE_END(__swpan_exit_el0)
 	 */
 	.macro	irq_stack_exit
 	mov	sp, x19
-	scs_load_current
+#ifdef CONFIG_SHADOW_CALL_STACK
+	mov	scs_sp, x24
+#endif
 	.endm
 
 /* GPRs used by entry code */


