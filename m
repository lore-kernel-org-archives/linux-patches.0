Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFB026A1D4;
	Tue,  8 Apr 2025 11:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111530; cv=none; b=CH/XdTzD8NV2671qpla0sizxs5X6qY3eXOkwRLOuKGNH+qsOeIFlOgfun3VbMlEqCq9PmGYLKW+g8nYGhqXblyqxqUKt5TcgRd/tZwcOxWEC4FwR85zkKMKy6T3N7RssnF+FXzeKRFjpuDcowMjkwxpZDHuEHUclTm8Roa9sC+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111530; c=relaxed/simple;
	bh=JLOwGtoBcqS7SOjpZLAJvqqdHx/ZXzFDLoPosS5xWPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nliY4hOcZTpBghwJMjeh1jlQipeAcxe5antEPpq7WOc8AkKSpbB4nE0mOiwsEIxsmpzYEVMC9EKREyH486ACkeLly+jZ2DUM4CA5tgeln+kB0vdG8lmBzF49kY11b9JJ4w63+qDsN6i1ORC57hT6TKrvmaFmtgS4mzJ4sZOUs6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvb2XXhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvb2XXhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE10DC4CEEA;
	Tue,  8 Apr 2025 11:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111530;
	bh=JLOwGtoBcqS7SOjpZLAJvqqdHx/ZXzFDLoPosS5xWPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvb2XXhZfzWxVpoPJsB9MlupE3SE2trJ7piyuxOAfHsQq6wpfdJwFAo8/7sL6ZCVU
	 OLT7ZYATrfuIN7HPLhzyhFYwJTYUizZx7kzten9SAZPDL3oSBbSro0ZLYLxwRlmA8e
	 SrSiRWyQt3iSXE1H3ZDqI0oiUikFoPoutRY3hqE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 462/731] coresight: catu: Fix number of pages while using 64k pages
Date: Tue,  8 Apr 2025 12:45:59 +0200
Message-ID: <20250408104925.025981428@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 275cc0d9f505f..3378bb77e6b41 100644
--- a/drivers/hwtracing/coresight/coresight-catu.c
+++ b/drivers/hwtracing/coresight/coresight-catu.c
@@ -269,7 +269,7 @@ catu_init_sg_table(struct device *catu_dev, int node,
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



