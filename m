Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97627D416;
	Mon,  8 Apr 2024 13:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582532; cv=none; b=kP1s5kPjJi/LsgXjGEshQRgaOZQEN4FNH0IPbD1z9ra0MgsseKcHDifZlBjD8zJwaA5IbjaCdNVGrdIg/HnfPK0KVAefc9cFRgFrVI7XRxgSJauuCnI8F3qxOUQCrFkjxv8pTuUOpLz1ulhx0tuoK5LQHN9PX95EHt/gp0PyMzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582532; c=relaxed/simple;
	bh=TEkoRqIRcQi7MpbDpMmDjOpHa5329/td6FQPI52hBqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itnEY4tG8hDeluVo/bfcyy0RrWSyMsNZKP9X8P0jIGuAHnf6kGtGAYfEVenZKW0IaGPH20s3YP7FNqeF13MdAcavJBQLlpdJfcBZLtp9zl94k8yCUvTvB0yrNc86PRzmwVa2KJrlb0YeivJArlaUGypMM4vAPDuMnyaZlGFqFeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNFV1LwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNFV1LwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C2AC43394;
	Mon,  8 Apr 2024 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582532;
	bh=TEkoRqIRcQi7MpbDpMmDjOpHa5329/td6FQPI52hBqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNFV1LwG1hA8qnqK0gNpPpbhJjLN95y77jzOREtL+d1f45kZTnSLU8HVOj/ddvyBe
	 2EqUL8SJp7YbDU2VYHfT+zrPkCZxhR2Fd4yLUg8hOgm7IM91x/34pamOuyCMv1UfNO
	 F13+i4ZWefnZdv2+mimJpGBzmikOSMmS3J/FrifM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.15 153/690] x86/entry_32: Add VERW just before userspace transition
Date: Mon,  8 Apr 2024 14:50:19 +0200
Message-ID: <20240408125405.048852629@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit a0e2dab44d22b913b4c228c8b52b2a104434b0b3 upstream.

As done for entry_64, add support for executing VERW late in exit to
user path for 32-bit mode.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20240213-delay-verw-v8-3-a6216d83edb7%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_32.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -912,6 +912,7 @@ SYM_FUNC_START(entry_SYSENTER_32)
 	BUG_IF_WRONG_CR3 no_user_check=1
 	popfl
 	popl	%eax
+	CLEAR_CPU_BUFFERS
 
 	/*
 	 * Return back to the vDSO, which will pop ecx and edx.
@@ -981,6 +982,7 @@ restore_all_switch_stack:
 
 	/* Restore user state */
 	RESTORE_REGS pop=4			# skip orig_eax/error_code
+	CLEAR_CPU_BUFFERS
 .Lirq_return:
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
@@ -1173,6 +1175,7 @@ SYM_CODE_START(asm_exc_nmi)
 
 	/* Not on SYSENTER stack. */
 	call	exc_nmi
+	CLEAR_CPU_BUFFERS
 	jmp	.Lnmi_return
 
 .Lnmi_from_sysenter_stack:


