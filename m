Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6282196D87;
	Thu,  6 Jun 2024 14:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682900; cv=none; b=E0ieBCEm/W6pPHoj/ane92Et2jscoZMHU2rMJtHwJOHHOqrWiwHTaZLolSnl90FHSv1gRPWnjcGkP2Oos+expflN3mOfcCyMz/J3M4ljNL6sW/FFLRFatvFZNZkWtZHFbxxyKxrQiRa064tRZdKNtgDqsG2sCLRGCVI3c6ywWqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682900; c=relaxed/simple;
	bh=ehy7gFY6LN64jbEr74suh1ob4K5D95CvIA/VQeOKlKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qhw5LLrJIu/nlG48ArFtHp7IOhRRWX1FTEldAI9kdkkofAvtSY68oCyzrIR6L1aFvPt7zNUUbT261T17szWC39Rasmj8IoEv2nRoaDfVII4oNfrO8jXa/bWTumrJ+3Q8sXkDGAk58bg1P3viwMtjYFmxw0+rH0OVZaytJ8mFU2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Pcwr0EW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Pcwr0EW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F11C4AF08;
	Thu,  6 Jun 2024 14:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682900;
	bh=ehy7gFY6LN64jbEr74suh1ob4K5D95CvIA/VQeOKlKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Pcwr0EWlNZWlDXVWWX2pzuUm8EpmLcz7jd53ZZhAOxbUyqTFY9npMLErnfsTpUhh
	 1CruJCg2+JF9TMwH5FFF4uGV3G1sqPCu54I4P4THTM5Afj1GDd93o4lAggjWt+UhcX
	 VfVqbArnFop+DC64bPFzdmgULv4a+jlASlM7xCX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 020/374] soundwire: cadence: fix invalid PDI offset
Date: Thu,  6 Jun 2024 15:59:59 +0200
Message-ID: <20240606131652.465933380@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 0efc1c3bee5f5..3e7cf04aaf2a6 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -1880,7 +1880,7 @@ struct sdw_cdns_pdi *sdw_cdns_alloc_pdi(struct sdw_cdns *cdns,
 
 	/* check if we found a PDI, else find in bi-directional */
 	if (!pdi)
-		pdi = cdns_find_pdi(cdns, 2, stream->num_bd, stream->bd,
+		pdi = cdns_find_pdi(cdns, 0, stream->num_bd, stream->bd,
 				    dai_id);
 
 	if (pdi) {
-- 
2.43.0



