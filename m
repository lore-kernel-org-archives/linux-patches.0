Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798F81DE4CE;
	Wed, 19 Feb 2025 08:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955456; cv=none; b=eIJuG4tRm7u7yhjmngSFoS800GOWhpfRr/fO87CaDgFSARezhC7AgCdN4GV9k0PfgWi4DV74bYRDxPGVHz7ZLdXZkH0SN+AVHaJjBDqOFAImhk4eB+dh57P4kdjAWxWQW+pDac14aeR+Hl2n4ZQe3RdHQfKPLvw8mVJHSxBoeWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955456; c=relaxed/simple;
	bh=ZGAMowGKLey3pboM4nozFNxlabxdQVRYLM86Hs8LRvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUOoOUdnalarSWC8kBhwV+B2K/lZHvKb+zidPlALWmoYgq/hAhvFS5p6WnqgRr8qmBtDJKJJPvrfG18oS/dxTJCe8r3RtlZpcHFBU/51BxTpmI1fKa4o1vCrxs9ShQuQTZ+iw+kz1UBqTrGjVcPNKtQdAvfmi+W0IzmaSucJHfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPIbJFVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPIbJFVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F93C4CED1;
	Wed, 19 Feb 2025 08:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955455;
	bh=ZGAMowGKLey3pboM4nozFNxlabxdQVRYLM86Hs8LRvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPIbJFVJvMfTLSgG6jkCJL22Rk5PuTl9wEFPmHq/76BBO1HgUEu54bvmuZ6YAOR8v
	 3nM5Ok3WXc0rfoHgPV0cCnnEvQcO6xp3LSokiH4SlS7VTDEvdUyMfB7XyLaEap01KL
	 2XPleXvPMFfLGTIE1Jfxr2nrUcWW0LwLgddhDJX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/152] LoongArch: csum: Fix OoB access in IP checksum code for negative lengths
Date: Wed, 19 Feb 2025 09:27:05 +0100
Message-ID: <20250219082550.514739235@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuli Wang <wangyuli@uniontech.com>

[ Upstream commit 6287f1a8c16138c2ec750953e35039634018c84a ]

Commit 69e3a6aa6be2 ("LoongArch: Add checksum optimization for 64-bit
system") would cause an undefined shift and an out-of-bounds read.

Commit 8bd795fedb84 ("arm64: csum: Fix OoB access in IP checksum code
for negative lengths") fixes the same issue on ARM64.

Fixes: 69e3a6aa6be2 ("LoongArch: Add checksum optimization for 64-bit system")
Co-developed-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Yuli Wang <wangyuli@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/lib/csum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/lib/csum.c b/arch/loongarch/lib/csum.c
index a5e84b403c3b3..df309ae4045de 100644
--- a/arch/loongarch/lib/csum.c
+++ b/arch/loongarch/lib/csum.c
@@ -25,7 +25,7 @@ unsigned int __no_sanitize_address do_csum(const unsigned char *buff, int len)
 	const u64 *ptr;
 	u64 data, sum64 = 0;
 
-	if (unlikely(len == 0))
+	if (unlikely(len <= 0))
 		return 0;
 
 	offset = (unsigned long)buff & 7;
-- 
2.39.5



