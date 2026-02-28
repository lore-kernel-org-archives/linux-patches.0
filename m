Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC1A37312B;
	Sat, 28 Feb 2026 17:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301505; cv=none; b=IpfgXmbqYipRuJ8lrMIX8Bwg+Pyqi77/1uQVtM2yyWnAJP1RjKA0VdVKFzFzPiga5D3B0X6T8U9fybeyhObrxJXTfkEcAhhuww/EoxS8H4gN3+AzUZT2USrmhZW0Tgm3hgtWWH4CD5VwpvYwWNLxzYXFoHLvZcmfhTxKM0OLTP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301505; c=relaxed/simple;
	bh=9L1oZcuaQriepnx5tlDnK2zkiVRUhPcE3h+4TexLDM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRrD/hQeouy4/epRGBln+TE9Ahyem8/TLOQTvOow/2+LLl0UL65D6xR5tfRdk6K/LbXnzkcHJGjC7NQrNzDqIjXZSz2ztKMdftWhEPpn56cF0g2RuoYOKZBdG7sRJfgV83B4pjSlKdHL/lVreLuBDUcLUgf2iarxQBUaln+zxrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pTQchcUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pTQchcUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC44AC19424;
	Sat, 28 Feb 2026 17:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301505;
	bh=9L1oZcuaQriepnx5tlDnK2zkiVRUhPcE3h+4TexLDM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTQchcUyi9lp9o3IRkwkl0chomM1gHCKwAsmuXM/vM+MDj47IjnM6ArJekxkaL+iy
	 dPBmudhu+Wt4sSLkLFvFaJplGrWPbv6ekJYNHrkv/LbrDfqsVQsedzZreKyF+ydX8r
	 0jnspcskkhx+heFs9IMXqm4GcRZI8iHHHR1mhUZV6tuQZATb6qM2EHpSLIlTvUo8tG
	 O8QYsxaQSVvMD9AG1j2EqeUIEf0Zn5enYKuVZGNb6RJoAT7Pan0lUmS9t0IApBpAA4
	 iB06zfdSN6lTeXFoqQppb1WXzvXWhkx1oCz5vPIu40N3Pf4rU0NytDaBsdECNrJ1VB
	 GBpsSHgDaY9EQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>,
	stable@vger.kernel.org,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 690/752] LoongArch: Guard percpu handler under !CONFIG_PREEMPT_RT
Date: Sat, 28 Feb 2026 12:46:41 -0500
Message-ID: <20260228174750.1542406-690-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 70b0faae3590c628a98a627a10e5d211310169d4 ]

After commit 88fd2b70120d ("LoongArch: Fix sleeping in atomic context for
PREEMPT_RT"), it should guard percpu handler under !CONFIG_PREEMPT_RT to
avoid redundant operations.

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/unwind_prologue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/unwind_prologue.c b/arch/loongarch/kernel/unwind_prologue.c
index 729e775bd40dd..ee1c29686ab05 100644
--- a/arch/loongarch/kernel/unwind_prologue.c
+++ b/arch/loongarch/kernel/unwind_prologue.c
@@ -65,7 +65,7 @@ static inline bool scan_handlers(unsigned long entry_offset)
 
 static inline bool fix_exception(unsigned long pc)
 {
-#ifdef CONFIG_NUMA
+#if defined(CONFIG_NUMA) && !defined(CONFIG_PREEMPT_RT)
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-- 
2.51.0

