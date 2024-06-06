Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1483119B3F3;
	Thu,  6 Jun 2024 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683404; cv=none; b=JOV/2g8N0umR2sA4A+18XNmSKWMnP/O8P9X8Qtr//UTRKjQzwakTwPHKu5EuNl8b94WQkXJ9lGozvMa6t6sub4+kKvmwzNlJ4p1uBEeRQOYoVzavPV4saV0MabRYV2m/4FbZUguRO7wYkLS/Uoc5rqaVPwxiGUpY7ImhS25P7kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683404; c=relaxed/simple;
	bh=/4WNkdZ/hj5m5IscuvA3plg7wZaz/QbInuD0+ALi4rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGAzE11xjBXLaHFN/MyJz4qRtMbgVDvFSS0nbgY+OR7cC/+2iv7fXtvdv6i4A8VxWzZR3aVBGbwLKh0WKwMKOJuAXB6cK7Mzw5jPl6u98AAG//R+N3fCBsRMGmaP6qoFDGqhEQlZHTY8wHty5dn+DrbHnb4/AInD2SI/dw5ZJyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccOm3uMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccOm3uMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEA7C2BD10;
	Thu,  6 Jun 2024 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683403;
	bh=/4WNkdZ/hj5m5IscuvA3plg7wZaz/QbInuD0+ALi4rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccOm3uMtjDPHLi3TxqRxw6ex3V5rt8h5Oww/DY5aKujlN4k8hX6rlvGfbO5JhbhZl
	 KWa1RJ6gqOm77xuIXRDl2vhdetgnJsCoYxiyfDBSaKC6GEO+BzOp1QQZret/vAEz0C
	 /0fDzxQ1Ahyg6S8NO0JMFwtLNZus6WKm4wFM01+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 287/473] soundwire: cadence: fix invalid PDI offset
Date: Thu,  6 Jun 2024 16:03:36 +0200
Message-ID: <20240606131709.381871920@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7286c9b3be691..5bd874e58dd6e 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -1847,7 +1847,7 @@ struct sdw_cdns_pdi *sdw_cdns_alloc_pdi(struct sdw_cdns *cdns,
 
 	/* check if we found a PDI, else find in bi-directional */
 	if (!pdi)
-		pdi = cdns_find_pdi(cdns, 2, stream->num_bd, stream->bd,
+		pdi = cdns_find_pdi(cdns, 0, stream->num_bd, stream->bd,
 				    dai_id);
 
 	if (pdi) {
-- 
2.43.0



