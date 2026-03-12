Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87AC22A4E9;
	Thu, 12 Mar 2026 20:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346832; cv=none; b=LdN0dzdI1XYZAOORySEsOlNSNzL5vnFBVisyQmGULNnvVsulkaWutcpM58G9JSDSnU/Y3/Khaw4+TCRBOisWX0lBzKex9RANOoKu9/D0eRTqlP/ogfQrp6M2jibPW8lH9zxQ/tpNL/aqi2VPPWUah92iU1sHtS+UeyNRA3AGr4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346832; c=relaxed/simple;
	bh=nbOuwDzAXiO7JZnAYbKjlIYUkw0rApJnRyujevonajU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIHQ3clspH5kmqmnkg3T85fezMmeFtYd0snO9SiKkV9ilN+0spui7iG2nS+N8Bx0RwOFcbf2agaboXg3/jfDJ8tW3blZEjx/NFQjeMDGt86YI+51zLwNJPlhub7yha+U089Hm3b+iZ6SMeidaUemwhG+vIMV15Cd7jZiUrb1ZMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6hruwBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6hruwBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AE9C4CEF7;
	Thu, 12 Mar 2026 20:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346832;
	bh=nbOuwDzAXiO7JZnAYbKjlIYUkw0rApJnRyujevonajU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6hruwBi5NkT15ddEA3ZWSAethiX6h1jaNl+3+ifJSxLj4NdCq19AzEqpyj1prjHS
	 6M48TjkcMVLVqZiH0WtG2wLEzcG5/qKyXD3P+YwopMEgnpnvsqNIxJ0Yr7NYaUQSzS
	 m3BbQUFfomZ8+7JGIHbgUU0SNNUwnEhtH4cf7WoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/265] LoongArch: Remove unnecessary checks for ORC unwinder
Date: Thu, 12 Mar 2026 21:08:26 +0100
Message-ID: <20260312201022.541453387@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 4cd641a79e69270a062777f64a0dd330abb9044a ]

According to the following function definitions, __kernel_text_address()
already checks __module_text_address(), so it should remove the check of
__module_text_address() in bt_address() at least.

int __kernel_text_address(unsigned long addr)
{
	if (kernel_text_address(addr))
		return 1;
	...
	return 0;
}

int kernel_text_address(unsigned long addr)
{
	bool no_rcu;
	int ret = 1;
	...
	if (is_module_text_address(addr))
		goto out;
	...
	return ret;
}

bool is_module_text_address(unsigned long addr)
{
	guard(rcu)();
	return __module_text_address(addr) != NULL;
}

Furthermore, there are two checks of __kernel_text_address(), one is in
bt_address() and the other is after calling bt_address(), it looks like
redundant.

Handle the exception address first and then use __kernel_text_address()
to validate the calculated address for exception or the normal address
in bt_address(), then it can remove the check of __kernel_text_address()
after calling bt_address().

Just remove unnecessary checks, no functional changes intended.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Stable-dep-of: 055c7e75190e ("LoongArch: Handle percpu handler address for ORC unwinder")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/unwind_orc.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/loongarch/kernel/unwind_orc.c b/arch/loongarch/kernel/unwind_orc.c
index 59809c3406c03..4924d1ecc4579 100644
--- a/arch/loongarch/kernel/unwind_orc.c
+++ b/arch/loongarch/kernel/unwind_orc.c
@@ -359,12 +359,6 @@ static inline unsigned long bt_address(unsigned long ra)
 {
 	extern unsigned long eentry;
 
-	if (__kernel_text_address(ra))
-		return ra;
-
-	if (__module_text_address(ra))
-		return ra;
-
 	if (ra >= eentry && ra < eentry +  EXCCODE_INT_END * VECSIZE) {
 		unsigned long func;
 		unsigned long type = (ra - eentry) / VECSIZE;
@@ -382,10 +376,13 @@ static inline unsigned long bt_address(unsigned long ra)
 			break;
 		}
 
-		return func + offset;
+		ra = func + offset;
 	}
 
-	return ra;
+	if (__kernel_text_address(ra))
+		return ra;
+
+	return 0;
 }
 
 bool unwind_next_frame(struct unwind_state *state)
@@ -511,9 +508,6 @@ bool unwind_next_frame(struct unwind_state *state)
 		goto err;
 	}
 
-	if (!__kernel_text_address(state->pc))
-		goto err;
-
 	return true;
 
 err:
-- 
2.51.0



