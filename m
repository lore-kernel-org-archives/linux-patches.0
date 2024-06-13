Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD3413541B;
	Thu, 13 Jun 2024 11:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279973; cv=none; b=mbyK+oaXX+02x7CQPcjfFJdKeg/NAtjc9//skNF32Yr0l3ZU6O+V6/kyv/XPq/mO8z2frxoLOJm6XNM3FOxU63tHQn6AgmdHJj0LIBL/QSOX9NCIbxvI6xrni4OL5kLtmoQfdFykvXyU59H2tWSE5L2bDrzT+aa6Hs+D8ziAtmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279973; c=relaxed/simple;
	bh=pDoeqSxf5CgzYhyf6sw9i7aPJc66Gq1xERfmWX/j2og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LM2yplQ1NapLiRInoBry7ziTfCYZuwpUDxa5J04sXHEx25qTL9Jc7cGKqyHpNfoprkDF29swqDEN1g4olAQ2p667nsc9IQaq/kGWa++6jz4VHj9f2ek3NS5tFTRnKMowvIUeZNlgaN1xgzSogeLv75qf5cqcfGrFNSuoxKTjIK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACdhDTqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACdhDTqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D09C2BBFC;
	Thu, 13 Jun 2024 11:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279973;
	bh=pDoeqSxf5CgzYhyf6sw9i7aPJc66Gq1xERfmWX/j2og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACdhDTqogLNiXKFWPcxwOFQv7FULvDfqO2laLFFRFAxwx/QYCvEmBq4B7NkPVIpOg
	 Pm2vj65iHRItOAgW5aUIlDWjqKMAjdkM9hVHkJtG0tZWHmBKYXw+IVEnXJ8RXMxVKi
	 T8Sddz0EpUGAJNVs1Hiq0d/01wtnBj6vs38OTNVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/202] soundwire: cadence: fix invalid PDI offset
Date: Thu, 13 Jun 2024 13:33:18 +0200
Message-ID: <20240613113231.623604965@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 8ee1b439b1540ae543149b15a2a61b9dff937d91 ]

For some reason, we add an offset to the PDI, presumably to skip the
PDI0 and PDI1 which are reserved for BPT.

This code is however completely wrong and leads to an out-of-bounds
access. We were just lucky so far since we used only a couple of PDIs
and remained within the PDI array bounds.

A Fixes: tag is not provided since there are no known platforms where
the out-of-bounds would be accessed, and the initial code had problems
as well.

A follow-up patch completely removes this useless offset.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20240326090122.1051806-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index e589aa99e4292..07c2526033809 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -1263,7 +1263,7 @@ struct sdw_cdns_pdi *sdw_cdns_alloc_pdi(struct sdw_cdns *cdns,
 
 	/* check if we found a PDI, else find in bi-directional */
 	if (!pdi)
-		pdi = cdns_find_pdi(cdns, 2, stream->num_bd, stream->bd,
+		pdi = cdns_find_pdi(cdns, 0, stream->num_bd, stream->bd,
 				    dai_id);
 
 	if (pdi) {
-- 
2.43.0



