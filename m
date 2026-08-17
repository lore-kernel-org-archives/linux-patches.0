Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8651429CD8;
	Mon, 17 Aug 2026 14:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977923; cv=none; b=VfUMepOu2/WDCR9rTXqoM6HTjUPnhYiBkH/ZC09uX4MTf+skmmB3e5zWl6ar/jUnaK6CO5dJmZESStSBdJNxgI5Ff0H44VHuNFG6J7IgZEn/WUDiF8pEs7hzMetVNsiuME2kButOi3h+7jW9FzW13/0/KZ1uM9avD1r/KjOz1y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977923; c=relaxed/simple;
	bh=3id6aUzk/mZPIqs8jHzXXaKTQUmJB3oRQHE7u23NJJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLf4KfINbbAEpxpobSLHbhaWg99LtvGDa+jBrNdBpbh8BfSAXfElahvNZzKCuLxfBjsuTRodKzrK7zj2aD6UHLHQ4Mp7jzGJJvJhUWr0+qPwph8WgKH6OjCCYB4O8irYJ5CPKbBAQ3djMvaNCMZn4RPmLc7z+9aWTHiWfZKkNWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPmG8731; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPmG8731"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FDB1F000E9;
	Mon, 17 Aug 2026 14:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977922;
	bh=nPxp3weeYOGmJOmAwsI1Ly5suEu28z10O0T+2EbbiuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPmG8731Qq7+cYB2hDg2A4+0Ko+rkfAKjeRKRWDPE7YKjEtBsJSuVYXMgoI9/lO7B
	 cC+v4DpxCoGpk4R/6zwje0OMX/F7putuhzG/h9MjVff9FPcmn6ewoESuIKYPg28i/v
	 3lL3Ar3xD3l0wtD4yOf/j3I+ZPmIvCuR6e9ZPtGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Avi Fishman <avifishman70@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/181] ARM: npcm: Fix OF node refcount leaks in SMP setup
Date: Mon, 17 Aug 2026 15:31:42 +0200
Message-ID: <20260817132535.727893470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 8eb052f48331474c2789d07b7f11165c323bd2f9 ]

npcm7xx_smp_boot_secondary() and npcm7xx_smp_prepare_cpus() look up
the GCR and SCU nodes with of_find_compatible_node(). The returned
nodes are used for of_iomap(), but the node references are never
released.

of_iomap() does not consume the device node reference, and iounmap()
only releases the MMIO mapping. Drop each node reference after the
corresponding mapping attempt.

Fixes: 7bffa14c9aed ("arm: npcm: add basic support for Nuvoton BMCs")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Avi Fishman <avifishman70@gmail.com>
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-npcm/platsmp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-npcm/platsmp.c b/arch/arm/mach-npcm/platsmp.c
index 41891d3aa1247..4c1fc9983746c 100644
--- a/arch/arm/mach-npcm/platsmp.c
+++ b/arch/arm/mach-npcm/platsmp.c
@@ -32,6 +32,7 @@ static int npcm7xx_smp_boot_secondary(unsigned int cpu,
 		goto out;
 	}
 	gcr_base = of_iomap(gcr_np, 0);
+	of_node_put(gcr_np);
 	if (!gcr_base) {
 		pr_err("could not iomap gcr");
 		ret = -ENOMEM;
@@ -60,6 +61,7 @@ static void __init npcm7xx_smp_prepare_cpus(unsigned int max_cpus)
 		return;
 	}
 	scu_base = of_iomap(scu_np, 0);
+	of_node_put(scu_np);
 	if (!scu_base) {
 		pr_err("could not iomap scu");
 		return;
-- 
2.53.0



