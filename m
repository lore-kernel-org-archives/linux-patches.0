Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D812737EE;
	Fri,  9 Jan 2026 12:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960999; cv=none; b=DIsDq64yk6HADGPGDp9ZchjXvtMAatui8n83AHhmLkmrnuIVkHflLEu4SvB+KnFK/LjA507V01dxd8uOFzHN7Obj5JJfgWZqiqkmf9QKBVE0QiyUlLv3juI3ZehEHvzh/Jync6CwTNS5/sMXNA02gMlsg3F2OuJuWN2FEgPb3Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960999; c=relaxed/simple;
	bh=Tz0+gJdX6gzIpP6hCfPUHX8pRnyhVoX+RLsqpU3cfRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNSeCVswU1FrdVJFajXpLkv9siExifeHsZRKF5OmSBoF2PZvkzCLvAtTP5q3LuiBUbXODG1O7np+eV2cDYh33fV/wsdZfB1+RHdG5HLeQmJQxUBeVnxFnDZOxcXUMYKfqnPkJDocE6XABLzOlbs75TYU636cEu0iAiBuRkkS5B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y224lVA/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y224lVA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0301EC4CEF1;
	Fri,  9 Jan 2026 12:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960999;
	bh=Tz0+gJdX6gzIpP6hCfPUHX8pRnyhVoX+RLsqpU3cfRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y224lVA/wu3460lzvI2Nv86z6+U3WLqDBtcMGfL9HsAjRMyOpw5p5QsJB4ikUpJa7
	 YFkcRz+DLM5nn+lshGssBL4/UNhhbs1K/xK5meRMQo9zIYCvBBoCYQdPS62IgQp4wQ
	 jJ7LA/2HJrIcForvd2sSaHwc3BiOCTylB05wSnHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rui Wang <wangrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 598/737] LoongArch: Fix build errors for CONFIG_RANDSTRUCT
Date: Fri,  9 Jan 2026 12:42:17 +0100
Message-ID: <20260109112156.504118739@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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


