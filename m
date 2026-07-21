Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD50235C6A0;
	Tue, 21 Jul 2026 21:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669340; cv=none; b=qnuM/YxvWHgERpZ7A9J7vsaj6ZBFAFzF/mKpNzOxhjEH4O2+vo9jXeOTxi7JcCRqnshYIvvkvJQ4sxA/UyLvm8tTZqPPiFY4yC0NZPUZau1QCFeQebfl4RUuYlbVZ0KaNa5oTvolfMaBG+7gAeI/TU44JOcnjuSd6PNKAArxZos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669340; c=relaxed/simple;
	bh=dCUBmSSgIRz5jq4pUtkZWw1mho7pSVsp5oUpB2Xrl0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JA9YfeN/m6YnjRTilJLdF1RFVc0SyZ0Tpla4uGRiTtaeQlQAulz94wuhTo0nYmlpLRyZTQk/UL7J49u0iI3t7FvO0lrS/lgATQtM3cZuh2BBoWgdKn3hi60N8YlXWiIxLypcC3GGXD4Hh4aO2xkC3sDdZLbPA2bk7Bh/4s1omAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDMfDbCE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDMfDbCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6281F00A3A;
	Tue, 21 Jul 2026 21:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669337;
	bh=4xSujaihKgkgfr+c/MzgMP02xnqKXhmpMySB1U/P9Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDMfDbCESoyDPClVsB3J53nQI4bi94h9ZVwlOMfhcbqZWNO27tEBQSzR3NeUT7ArO
	 xIneFIimWJxtv+h29nz00Cu3SOwFwWAtJLT03nM7p4EtkpyHoBE4DVv+6e54PYRI9l
	 mJ2EoFoF3esejyBF3hJJlk+S500O2kwDg2nKc+6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingchao Deng <yingchao.deng@oss.qualcomm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0473/1067] coresight: cti: Fix DT filter signals silently ignored
Date: Tue, 21 Jul 2026 17:17:54 +0200
Message-ID: <20260721152435.197083908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yingchao Deng <yingchao.deng@oss.qualcomm.com>

[ Upstream commit 551bb2fd5e4ed63d33aa11f07102cce5179b7595 ]

In cti_plat_process_filter_sigs(), after allocating a temporary
cti_trig_grp struct via kzalloc_obj(), the code never assigns tg->nr_sigs
= nr_filter_sigs. Since kzalloc zero-initialises the struct, tg->nr_sigs
remains 0. cti_plat_read_trig_group() guards with:
    if (!tgrp->nr_sigs)
        return 0;

so it returns immediately without reading any signal indices from DT.

Fix by assigning tg->nr_sigs before calling cti_plat_read_trig_group().

Fixes: a5614770ab97 ("coresight: cti: Add device tree support for custom CTI")
Signed-off-by: Yingchao Deng <yingchao.deng@oss.qualcomm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260426-nr_sigs-v1-1-3b9df99dab97@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-cti-platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwtracing/coresight/coresight-cti-platform.c b/drivers/hwtracing/coresight/coresight-cti-platform.c
index ccef04f27f12fa..438f9c7ddccdc3 100644
--- a/drivers/hwtracing/coresight/coresight-cti-platform.c
+++ b/drivers/hwtracing/coresight/coresight-cti-platform.c
@@ -329,6 +329,7 @@ static int cti_plat_process_filter_sigs(struct cti_drvdata *drvdata,
 	if (!tg)
 		return -ENOMEM;
 
+	tg->nr_sigs = nr_filter_sigs;
 	err = cti_plat_read_trig_group(tg, fwnode, CTI_DT_FILTER_OUT_SIGS);
 	if (!err)
 		drvdata->config.trig_out_filter |= tg->used_mask;
-- 
2.53.0



