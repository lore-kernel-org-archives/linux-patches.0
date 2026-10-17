Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8980D224D6;
	Sat, 17 Oct 2026 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253129; cv=none; b=FJC5TrVx6ggYYlLKAtNpvEst0bSeeYXstLUGB1aP251zZRUAZTBjGVz4R3FY88mzc0Iaq0pQWFydT0TJbBbANy0hxow2vM/7ht97O0kzXv5Ow8iuvGq96tQ+TLL/DbfY1lg8laI+uIrNCRVbO3TWmEUqIh3jhcHwn1Z7dJbpjCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253129; c=relaxed/simple;
	bh=pYkXCX8CNY/WPt1Z1hC2N/Rg8y02HQ+16FsxxuJ22RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eb38QkGAf1DYN7LoyykfADts5ouflS6hHjz1EbUEOCg+3leb/zZZ4vw/dKFDsRU1bxMmyynEvh73sFPw7tS8pOeVKoAQOFgKq+TiUYWoI8cGbz/iNv0+jFCyAcpwT48cY0YasvoYUvW66yeOdX+iFE9unZIQazG1B7kWNnt2h5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRIxAjZk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRIxAjZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F0B1F000C5;
	Sat, 17 Oct 2026 16:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253128;
	bh=+GQGcwcFJuNsoP0N/R5cJdaT9PGISvXN+Um+pE9OEnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pRIxAjZkkWN/JV5oKU6T2YHXQjN4helEvwGeo/bGOwRA/O0U3+NJF8w4RShgfrrHC
	 nZAdPgZ4jVlHj20123ttB/DvAlO/1ZuHU89ENDde7D3+RiN+dKZphvMuEUXr+Qrwzk
	 RSNNIT9xxF6CaJ12gtp0OBcU6BGdRrkPHPR6i6X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/869] iommu/amd: Fix ivrs_base memleak in early_amd_iommu_init()
Date: Sat, 17 Oct 2026 17:47:25 +0200
Message-ID: <20261017160037.106938948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Zhen Ni <zhen.ni@easystack.cn>

[ Upstream commit 923b70581cb6acede90f8aaf4afe5d1c58c67b71 ]

Fix a permanent ACPI table memory leak in early_amd_iommu_init() when
CMPXCHG16B feature is not supported

Fixes: 82582f85ed22 ("iommu/amd: Disable AMD IOMMU if CMPXCHG16B feature is not supported")
Cc: stable@vger.kernel.org
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20250822024915.673427-1-zhen.ni@easystack.cn
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index faa46571f6c68..804b731957db2 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3098,7 +3098,8 @@ static int __init early_amd_iommu_init(void)
 
 	if (!boot_cpu_has(X86_FEATURE_CX16)) {
 		pr_err("Failed to initialize. The CMPXCHG16B feature is required.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/*
-- 
2.53.0



