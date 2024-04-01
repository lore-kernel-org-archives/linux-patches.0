Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1941DFF4;
	Mon,  1 Apr 2024 17:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990994; cv=none; b=MkoyKcSEVaJjYl3mEpuM2LozKRs8q7hZvU5wDDMiwmY1w3sst31Fo8CswP5dOh4tWJRx8P5fqYOOuoRPYsMZYsMPD/OUWzey9nx5aRi7n3MAT56iTwfPpSND4mfieQ8nNb9oU1ciNmW/1/6A0RfDZvwtUdmlpiKI65ctCM4CEJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990994; c=relaxed/simple;
	bh=ZNuwqdmv1iTi4B1cUeuYr/P2Y0wcmZ9QyFK38f6UNIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bw/AwYKJ6t7uI19OIEKENGd+51FePUTk5xb/Y9mplq2FboYseMaF3RFtQ6wZbzl7rRz1VLzciYXhbliEskUxVE56BBqm/KanjcWhb+wCzCkOUbCJW0zU56k0LXYHg2kSB+MutJVJ8gPxA5JYn5LtDU52b0sjaMD2LFlDg+8gSWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrIULiES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrIULiES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51838C43390;
	Mon,  1 Apr 2024 17:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990994;
	bh=ZNuwqdmv1iTi4B1cUeuYr/P2Y0wcmZ9QyFK38f6UNIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrIULiESzfffximXKMPuwiCzQ0Ss0a+rc1q1oAqLiGCs4K1ZHAN4tniUMQjz8Kcmu
	 juQJl648osHuRJFPGywrnhzXAuhIbdec5RkRE3SZTEW3avBxvmcVgZsqAn9pigu0NP
	 9y2Tm1G/xE9tWbZ00CR90fNVK34ZivPJGIxgsAqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaotian Wu <wuxiaotian@loongson.cn>,
	Miao Wang <shankerwangmiao@gmail.com>,
	Xing Li <lixing@loongson.cn>,
	Hongchen Zhang <zhanghongchen@loongson.cn>,
	Rui Wang <wangrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/272] LoongArch: Change __my_cpu_offset definition to avoid mis-optimization
Date: Mon,  1 Apr 2024 17:45:21 +0200
Message-ID: <20240401152534.768382078@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit c87e12e0e8c1241410e758e181ca6bf23efa5b5b ]

>From GCC commit 3f13154553f8546a ("df-scan: remove ad-hoc handling of
global regs in asms"), global registers will no longer be forced to add
to the def-use chain. Then current_thread_info(), current_stack_pointer
and __my_cpu_offset may be lifted out of the loop because they are no
longer treated as "volatile variables".

This optimization is still correct for the current_thread_info() and
current_stack_pointer usages because they are associated to a thread.
However it is wrong for __my_cpu_offset because it is associated to a
CPU rather than a thread: if the thread migrates to a different CPU in
the loop, __my_cpu_offset should be changed.

Change __my_cpu_offset definition to treat it as a "volatile variable",
in order to avoid such a mis-optimization.

Cc: stable@vger.kernel.org
Reported-by: Xiaotian Wu <wuxiaotian@loongson.cn>
Reported-by: Miao Wang <shankerwangmiao@gmail.com>
Signed-off-by: Xing Li <lixing@loongson.cn>
Signed-off-by: Hongchen Zhang <zhanghongchen@loongson.cn>
Signed-off-by: Rui Wang <wangrui@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/percpu.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/percpu.h b/arch/loongarch/include/asm/percpu.h
index 302f0e33975a2..c90c560941685 100644
--- a/arch/loongarch/include/asm/percpu.h
+++ b/arch/loongarch/include/asm/percpu.h
@@ -25,7 +25,12 @@ static inline void set_my_cpu_offset(unsigned long off)
 	__my_cpu_offset = off;
 	csr_write64(off, PERCPU_BASE_KS);
 }
-#define __my_cpu_offset __my_cpu_offset
+
+#define __my_cpu_offset					\
+({							\
+	__asm__ __volatile__("":"+r"(__my_cpu_offset));	\
+	__my_cpu_offset;				\
+})
 
 #define PERCPU_OP(op, asm_op, c_op)					\
 static __always_inline unsigned long __percpu_##op(void *ptr,		\
-- 
2.43.0



