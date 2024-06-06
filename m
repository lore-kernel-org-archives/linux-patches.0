Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6015A1974EB;
	Thu,  6 Jun 2024 14:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683459; cv=none; b=QkppPoC052vbA6faD1GIgVh6jejTCbC/mwghLhaQTiVAqmQgtbUnTj7T3BF0iCzDW7LQKebAd0rmrqJ7WyVzXdDp/ad6sWJ21jaVZJtE6meAO2GxS7PoyhuJoQrnYdDzCuDfw/NF8u3oL16ZOBGDXJBdnlB4/6/1lrB0AymDoKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683459; c=relaxed/simple;
	bh=WZEBgiQu/AbnG9LTFkVPZ6GdjftRWB6ArE7SdixOeQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMPr7u7U6Cyvce1A28lUzXCddoB9O0aoLowdYOLYZD8bGDL1gG04G+YNgPMTPUrxa4ltcTpD4D0VXh5LshzkDg8hEJkIkRU9DvvZ6JY0VmuNFDDLTMKSBw27MSShVbwqsxe3UJRvEzkxHlhZhnp8CJOM2THEJcF25DJr4GAy0XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VasY/2zt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VasY/2zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7E7C4AF0A;
	Thu,  6 Jun 2024 14:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683459;
	bh=WZEBgiQu/AbnG9LTFkVPZ6GdjftRWB6ArE7SdixOeQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VasY/2ztzwxJJDgILqrvoGv33ku8pyqacTExfgIeY+G39eLSX2tBgQXmjBw6Cb7qt
	 fLJ3m5WRvi6QU3tLbjy3IO9chdyPSvF41qU6Kbtgl2/a0pz0+0/80d3HRr1WxHR5Ww
	 szlKVnOUCziSMWHO8xGCMXmC71eQdwdvNONWlui4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 404/744] soundwire: cadence: fix invalid PDI offset
Date: Thu,  6 Jun 2024 16:01:16 +0200
Message-ID: <20240606131745.415197105@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



