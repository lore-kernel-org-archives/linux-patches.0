Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBB714D28C;
	Mon,  6 Jan 2025 15:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177894; cv=none; b=SPgFWW5DTCbaF5Kfih+Q5EKXTL04rLJm2zpo+s2BSDjU/zvg3yGDAxajGAw9hc/NxTYegYY4zUHwevfMNQbXzJacNF+Nqq4yypr9L4uzpC9TWnKkq2Z6SLbDXP0ZHCPl3FhSWA58BPvI9MTQLAglLCOh7wXXXVtc7aBLkPnnX5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177894; c=relaxed/simple;
	bh=C5JEKG5RgZH5KRrMcYtYvL5Uq2z1F6hYLqNSYk9u0A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWLJVxaKIvpX4Wbwv+APfHr/bPsSGl390jEjD/e9bV4xp6XNYsVpBgLR092k+2PjpH+fgyZpGJrQAlDp3c6Zudev6qyHf2Dd32ofDOgqlO/R21mw8q3bvbaZaK2UeO0PryZmlm8N29VkusYurp7EFWjTRJF+HGuKelNr9/uJlFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mf0c9hpC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mf0c9hpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C73C4CED2;
	Mon,  6 Jan 2025 15:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177894;
	bh=C5JEKG5RgZH5KRrMcYtYvL5Uq2z1F6hYLqNSYk9u0A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mf0c9hpCt6Y9l9HcVlXtlwYDidD8Fj6LZne1B4RbHQoWlBe1YVL8VkfedRG/fA1qU
	 U5Q3tWuMPUAeNjUUKoARYfe9RV8kgP0ykat/HdLp/6PBAjSnxr6nnsppmh8/RGsD9i
	 N021ES+qc1sb9gy/15caurinXQKmN+qILuK+/63o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/156] ARC: build: disallow invalid PAE40 + 4K page config
Date: Mon,  6 Jan 2025 16:16:19 +0100
Message-ID: <20250106151145.228665590@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@kernel.org>

[ Upstream commit 8871331b1769978ecece205a430338a2581e5050 ]

The config option being built was
| CONFIG_ARC_MMU_V4=y
| CONFIG_ARC_PAGE_SIZE_4K=y
| CONFIG_HIGHMEM=y
| CONFIG_ARC_HAS_PAE40=y

This was hitting a BUILD_BUG_ON() since a 4K page can't hoist 1k, 8-byte
PTE entries (8 byte due to PAE40). BUILD_BUG_ON() is a good last ditch
resort, but such a config needs to be disallowed explicitly in Kconfig.

Side-note: the actual fix is single liner dependency, but while at it
cleaned out a few things:
 - 4K dependency on MMU v3 or v4 is always true, since 288ff7de62af09
   ("ARC: retire MMUv1 and MMUv2 support")
 - PAE40 dependency in on MMU ver not really ISA, although that follows
   eventually.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202409160223.xydgucbY-lkp@intel.com/
Signed-off-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 5b2488142041..69c6e71fa1e6 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -297,7 +297,6 @@ config ARC_PAGE_SIZE_16K
 config ARC_PAGE_SIZE_4K
 	bool "4KB"
 	select HAVE_PAGE_SIZE_4KB
-	depends on ARC_MMU_V3 || ARC_MMU_V4
 
 endchoice
 
@@ -474,7 +473,8 @@ config HIGHMEM
 
 config ARC_HAS_PAE40
 	bool "Support for the 40-bit Physical Address Extension"
-	depends on ISA_ARCV2
+	depends on MMU_V4
+	depends on !ARC_PAGE_SIZE_4K
 	select HIGHMEM
 	select PHYS_ADDR_T_64BIT
 	help
-- 
2.39.5



