Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1C22686A5;
	Tue,  8 Apr 2025 11:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110090; cv=none; b=P0F9u3dMgXQw0LEYxXUPfJo7Z5DPRLU2aglNm3zxX5bkJc8O4nvPr4PgZBgmgCOqYsZBqYCXs3n+k7wRoqaylWJHz2aWNMU5B19UlBtGYcdbnpWldxSJYq+l8utcR2nr7/rRLRi3MmPdhUr5u34wznUUQDTyihp9gaSpgi39bUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110090; c=relaxed/simple;
	bh=2Dm6L2Y0b7/5U70WCO8W+yW/uHA5D7UD0Xkz3mq/4UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yb5o0BMGjt+2i96peo3TzphXZrT0ny6tfhBEVaE+0ojjpUED6NcZwb4dzwjN8doq3n/imdM5KgSSGVq9jZ7GRp3X39a50VEhC8f+5MOBSJu7LmZi2eKDoSiGCF3vihP3bhvauSZrD8PCyGE0lb0p4lsLadMwuh1WOmdarmWnQ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVP9KCAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVP9KCAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75604C4CEE5;
	Tue,  8 Apr 2025 11:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110089;
	bh=2Dm6L2Y0b7/5U70WCO8W+yW/uHA5D7UD0Xkz3mq/4UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVP9KCAxQ1BfQ2UAq75seyrneiUMGsTh1HA1U7DmCIy50G4Q6osLBi+rCJl+8cWiY
	 DjwRRlyY+UyDBuhCF1RMv4sCifHUXg/yBwps/2w1HKY7abTM83KVFP6bdYH1lRVcWK
	 6HcIxajWOraBqpU0JXp1Kvdj9x9iTBDBcfOV+ojY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/227] coresight: catu: Fix number of pages while using 64k pages
Date: Tue,  8 Apr 2025 12:49:01 +0200
Message-ID: <20250408104825.207827821@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8e19e8cdcce5e..3357e55fc5590 100644
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



