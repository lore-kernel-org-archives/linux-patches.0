Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA68355033;
	Tue,  6 Jan 2026 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722347; cv=none; b=VnlU4kw2vb5coAPwrwE93LUc4Q5E3NsemGBwfMi/aLMfi/Mu8f3MUfWX9hibsdYuXOhXRleGMK27fCfaPIe0RyWoYCQ5naNPELArPvn5BhY5PLmHBS/sN+W6iNskPX42qf7gUU7dno4+rnu3VsVlU3Wp1sBKr4cE3ho4jVyham4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722347; c=relaxed/simple;
	bh=mYTgNbc60G16wTGULF0KekEPbng2BZYeqqgQtskbUic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GD2n+p7E/wGf23lSpXc/3Fy2KLWny/91MjwV3PcHtJaeXIRw8fUq8racM+kfchRjTh0AtR+N/L2XyDX/EBQ2TF0PwqKbooZ/obK++u+J4OFQfaahndhthMbSKKtt+u5VyvDzMr8xpjrNu3D+Rljz1FKiiqhTCFvKiRFUgqwyr6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=om21sTr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="om21sTr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775AAC116C6;
	Tue,  6 Jan 2026 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722347;
	bh=mYTgNbc60G16wTGULF0KekEPbng2BZYeqqgQtskbUic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=om21sTr8puAqt/WCOogvVjulpocxWPINaL5KvGHtiQKM6UlNuXkGjFU56lNGUALyx
	 9XMVQnQ47Er2PziOkvQVuMygU84pTi+DOnTGoFTDn+gOUdzBlgJUbNAauSTuC9CwOR
	 USqf7WbokN+bYrkP6GLVl9+nIKZXTy48jMKbClVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rui Wang <wangrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 195/312] LoongArch: Fix build errors for CONFIG_RANDSTRUCT
Date: Tue,  6 Jan 2026 18:04:29 +0100
Message-ID: <20260106170554.880546726@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 3c250aecef62da81deb38ac6738ac0a88d91f1fc upstream.

When CONFIG_RANDSTRUCT enabled, members of task_struct are randomized.
There is a chance that TASK_STACK_CANARY be out of 12bit immediate's
range and causes build errors. TASK_STACK_CANARY is naturally aligned,
so fix it by replacing ld.d/st.d with ldptr.d/stptr.d which have 14bit
immediates.

Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511240656.0NaPcJs1-lkp@intel.com/
Suggested-by: Rui Wang <wangrui@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/switch.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/switch.S
+++ b/arch/loongarch/kernel/switch.S
@@ -25,8 +25,8 @@ SYM_FUNC_START(__switch_to)
 	stptr.d a4, a0, THREAD_SCHED_CFA
 #if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	la	t7, __stack_chk_guard
-	LONG_L	t8, a1, TASK_STACK_CANARY
-	LONG_S	t8, t7, 0
+	ldptr.d	t8, a1, TASK_STACK_CANARY
+	stptr.d	t8, t7, 0
 #endif
 	move	tp, a2
 	cpu_restore_nonscratch a1


