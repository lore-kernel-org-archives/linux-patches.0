Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F2B7BAF0;
	Mon,  4 Mar 2024 21:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587951; cv=none; b=HHWe4BmFwj+EVpQoAL9fsf2OsGH+Gm04/67Fm8/+R1uA5/2Bh8136yWR++HaQg2bz5ey3Hfu+pc+gm2oSIkKXdgDB65FgBPmCSXvNKFOAsv1ZA/mu209hyQcOB/PHYPFENUpH/iq63QMJM1cxOA4vded1yXyFC1W4vwdN0Zh7a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587951; c=relaxed/simple;
	bh=gBJAgclUbicNQl4spYCJE57r/etdGnzI8t1vjQvW1Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUl5adtyktzLW/uQn6KYdnjKF2sEtceYdRaDDwypuq4PdukMpoI2a6PVVph6MM0vucKN5NB8dkJxt/VEQ5mXKGHvRNhwEH+B3wa/bGL241iV0Uqy8sQJMfgmGnQSIx9P4+rZZFtfnjG3kFPFQeMy2CHsFaLvlLrM3lEbbRW/rTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5UnvQ6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5UnvQ6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10C1C433C7;
	Mon,  4 Mar 2024 21:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587951;
	bh=gBJAgclUbicNQl4spYCJE57r/etdGnzI8t1vjQvW1Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5UnvQ6vAr+fh+byt6E0P1Do/XMQ5dqz7VN1b2qxYKAg0TlQfjddJspqc0fqSdssT
	 Cc2Zl4RsKPtQvlou+25D/dRTnnpF7FqpaG7tnfb4iIKzjRU2Z7LeIAySdi3hhhTX4u
	 hxYtYzBHYoAmtY9jQe/HOU3t+BZ0bxMrtgjS0Un4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 6.7 153/162] x86/entry_32: Add VERW just before userspace transition
Date: Mon,  4 Mar 2024 21:23:38 +0000
Message-ID: <20240304211556.574180035@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -885,6 +885,7 @@ SYM_FUNC_START(entry_SYSENTER_32)
 	BUG_IF_WRONG_CR3 no_user_check=1
 	popfl
 	popl	%eax
+	CLEAR_CPU_BUFFERS
 
 	/*
 	 * Return back to the vDSO, which will pop ecx and edx.
@@ -954,6 +955,7 @@ restore_all_switch_stack:
 
 	/* Restore user state */
 	RESTORE_REGS pop=4			# skip orig_eax/error_code
+	CLEAR_CPU_BUFFERS
 .Lirq_return:
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
@@ -1146,6 +1148,7 @@ SYM_CODE_START(asm_exc_nmi)
 
 	/* Not on SYSENTER stack. */
 	call	exc_nmi
+	CLEAR_CPU_BUFFERS
 	jmp	.Lnmi_return
 
 .Lnmi_from_sysenter_stack:


