Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6BD3398B;
	Sun,  1 Sep 2024 17:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210033; cv=none; b=JhJ/TJSsRLrICecW90X/gpKHUQXOTtOLe1ai1iMUpMwsvo0twrIYYHjIWFEscxrV1CaRjlr10t51Y+Kdk4OORh4g4FlNddBV7iEY3+MDaVHkYiDBFoHDoou8Tsoq+ByZEKdw5bNB0527EfnhzTqw0TLSQlv6ndY04dV2vUOH2W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210033; c=relaxed/simple;
	bh=P77+rzpc+2ntTwoT6FJiNTI/zxwMfYjjSKw8RNDKX/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlzHlE54u9iJeaCgJPsEDJA4xOkUpHsXLosW+zwZbZIag/FHGQP8rZ7wZcLZWfKiE/ctxPoe4VV+tzL3G56CYCfbn2CHIJA1cJeW7sCn7mhXxxQS32K9Rjj3kSZhIBoDBIVAg4ovfZR4cK2dLXUZ0bNM3M4UqbJNF9GFWSTCKms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sg40YgI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sg40YgI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B08C4CEC3;
	Sun,  1 Sep 2024 17:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210033;
	bh=P77+rzpc+2ntTwoT6FJiNTI/zxwMfYjjSKw8RNDKX/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sg40YgI0ieqw13VPkmYX+xoTzos+JVTZw6t8/r3gYz74M5Ast3/39552NNtwwz4QU
	 x+qXxi7QOzSIRuu68dwFY0weHdz+9gf6GF4grvHD2rcnKUMikQfbCs2T6DqT0qVlbL
	 Z9q6+iTMep8r5Af1zPg9Mlvc1wWyNJCI/sUN8j6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/215] powerpc/xics: Check return value of kasprintf in icp_native_map_one_cpu
Date: Sun,  1 Sep 2024 18:16:18 +0200
Message-ID: <20240901160825.849191254@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 45b1ba7e5d1f6881050d558baf9bc74a2ae13930 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful
by checking the pointer validity.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231122030651.3818-1-chentao@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xics/icp-native.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/sysdev/xics/icp-native.c b/arch/powerpc/sysdev/xics/icp-native.c
index 7d13d2ef5a905..66de291b27d08 100644
--- a/arch/powerpc/sysdev/xics/icp-native.c
+++ b/arch/powerpc/sysdev/xics/icp-native.c
@@ -235,6 +235,8 @@ static int __init icp_native_map_one_cpu(int hw_id, unsigned long addr,
 	rname = kasprintf(GFP_KERNEL, "CPU %d [0x%x] Interrupt Presentation",
 			  cpu, hw_id);
 
+	if (!rname)
+		return -ENOMEM;
 	if (!request_mem_region(addr, size, rname)) {
 		pr_warn("icp_native: Could not reserve ICP MMIO for CPU %d, interrupt server #0x%x\n",
 			cpu, hw_id);
-- 
2.43.0



