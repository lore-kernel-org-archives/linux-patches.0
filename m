Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE47383BA;
	Mon,  1 Apr 2024 16:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987204; cv=none; b=J4iT4EFwswsiubGufS/Kzo71aayit+TWNQjBWOQa8s7c4IL3ugK3N/+5qGz2NL35RVuRdkzfVXQGEpaUMbBBLpJQ0EE2xl8DoQLn7cX+UJAwmdAu0OvLQCNLyJUJdYD7i3AgL7kbBipj3nCrfsoc/tc7tQ2OYeJeZ7WMALGPQno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987204; c=relaxed/simple;
	bh=CDYtR0hjfu8SIhhQDvFo2BPNrG3+bGU37RBFvrEuuN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGcGnFiRu0zFpX+HYh3PZnsVDiJ55pM9+znQo9TAF7fw7Ma1xA14Pp8ozZdD/r0Zg20bg0SbdYmqwdBpFIB6Z7lXLzl8p0VR4jAFd+nd9BrQFMZNWgaSrzRMmi0yK1r81TPdNJ+SZwBHoU+Zb1k3dhP0EG8qYpR8BkG649Ts09M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eeo8j52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eeo8j52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C839C433F1;
	Mon,  1 Apr 2024 16:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987203;
	bh=CDYtR0hjfu8SIhhQDvFo2BPNrG3+bGU37RBFvrEuuN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eeo8j52/gG9WVOwg9Dq+rckgIL8gwYw/wCov5ReK1RNPK6tDHQX373mwjrQ4nIkO
	 wr035M3vF2s7bc312qkA0shfGfLK9sZEhnfvOjGg5Bs5cO0LeMk++XedvzA9iFGOaN
	 nZPCJZkC6VhB+M1ahDBfc69agZXU5v0qGkuzEzI8=
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
Subject: [PATCH 6.8 198/399] LoongArch: Change __my_cpu_offset definition to avoid mis-optimization
Date: Mon,  1 Apr 2024 17:42:44 +0200
Message-ID: <20240401152555.092177178@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 9b36ac003f890..8f290e5546cf7 100644
--- a/arch/loongarch/include/asm/percpu.h
+++ b/arch/loongarch/include/asm/percpu.h
@@ -29,7 +29,12 @@ static inline void set_my_cpu_offset(unsigned long off)
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



