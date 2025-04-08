Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C25F267B65;
	Tue,  8 Apr 2025 12:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114151; cv=none; b=SMVDCXY0Mp6lCVqYkEF+hvSykGJok+sV+MxwCnSnloh7xGaJcXlSBsd5DSa1dXkgZmjKw0QageD42HFevaWlMcwQkyOGjy1SGlDfDI9sxBZQi+mJmU3S5zrpKf6kCAWLVfU2+/BtbuAtJoaS47QZrJD7yZOdF++sg7N3HzU8SbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114151; c=relaxed/simple;
	bh=t8MyNbvLfT9JP76H8wSi8joxPPY5SnOmiMC7cQieJ5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecEvyIxHs7DzMNeYzxD5o3yXP4zGZC9SORJyoJGDYR91QgZzTym904W/w63kdTh0ycWwCAouVltxPJkL4xoaiUKouSD6JvbwN1BXBYm2x5gRJIiUye3mOvBldf3pgfW58jERqrJNQXWFQtDKL3W6yvuJ9yA0goDQ4o4npRMStVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVEHB+At; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVEHB+At"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEC1C4CEE5;
	Tue,  8 Apr 2025 12:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114150;
	bh=t8MyNbvLfT9JP76H8wSi8joxPPY5SnOmiMC7cQieJ5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVEHB+At/48vlq1uLtdVs40nm5kFZRJilmEm2igpqgus7/KYx5ajHQlfcFPNHDrPY
	 HgaAJ6KGqP29EofgwV9xQYKAiupTrvnI/BCmc0wKkEyP9nvQ9LgP7m0H5wvm9z6dM+
	 sCc1xzHOSQUsd3Q9HNkKTOmCT9nYUuxvzNpE0nH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/154] coresight: catu: Fix number of pages while using 64k pages
Date: Tue,  8 Apr 2025 12:50:57 +0200
Message-ID: <20250408104819.043889254@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilkka Koskinen <ilkka@os.amperecomputing.com>

[ Upstream commit 0e14e062f5ff98aa15264dfa87c5f5e924028561 ]

Trying to record a trace on kernel with 64k pages resulted in -ENOMEM.
This happens due to a bug in calculating the number of table pages, which
returns zero. Fix the issue by rounding up.

$ perf record --kcore -e cs_etm/@tmc_etr55,cycacc,branch_broadcast/k --per-thread taskset --cpu-list 1 dd if=/dev/zero of=/dev/null
failed to mmap with 12 (Cannot allocate memory)

Fixes: 8ed536b1e283 ("coresight: catu: Add support for scatter gather tables")
Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250109215348.5483-1-ilkka@os.amperecomputing.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-catu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-catu.c b/drivers/hwtracing/coresight/coresight-catu.c
index 16ebf38a9f664..da205738e8c96 100644
--- a/drivers/hwtracing/coresight/coresight-catu.c
+++ b/drivers/hwtracing/coresight/coresight-catu.c
@@ -267,7 +267,7 @@ catu_init_sg_table(struct device *catu_dev, int node,
 	 * Each table can address upto 1MB and we can have
 	 * CATU_PAGES_PER_SYSPAGE tables in a system page.
 	 */
-	nr_tpages = DIV_ROUND_UP(size, SZ_1M) / CATU_PAGES_PER_SYSPAGE;
+	nr_tpages = DIV_ROUND_UP(size, CATU_PAGES_PER_SYSPAGE * SZ_1M);
 	catu_table = tmc_alloc_sg_table(catu_dev, node, nr_tpages,
 					size >> PAGE_SHIFT, pages);
 	if (IS_ERR(catu_table))
-- 
2.39.5



