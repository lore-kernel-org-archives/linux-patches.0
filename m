Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3282EBB8D;
	Tue, 21 Jul 2026 20:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666346; cv=none; b=ofLjmBo7Qtd9TV+YYs5fz6rr3ZqC+sjzNWL8Ald80A6tP0U38MPGqInJKU1AtlLBpxTYoK0bFSAkKmIMUxWhjKAF6bUzxR8ZGBFL0wnFpNxX6WU1VebE7CkH4IBm0/G3JiNh4jJfEDMADHtNuNShsZGIAo4omtV0jcHJD22FzyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666346; c=relaxed/simple;
	bh=AjJzT3Za2RvvpsfmIOyzVy2RBb4vli6yD2nEdvojBq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+NMCnSdDrD0oXp5dGCtFXZEEMadszh7hafOdfhjbjhAbGdZuA3p6i+eXLGS3hHYpdjoH+CY+WmpczKsZw+/NoEOY8yAxpZeWRujIeSdyUHzl4olMDPQYXgKqDWJWjgmRWtvmxVPER9bob2hCsmVLXbdpyl+ix/uTNA3PFYrXr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQpYdVF4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQpYdVF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8E31F000E9;
	Tue, 21 Jul 2026 20:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666345;
	bh=34FPN60ivvfHJZuzqx8p2ysbDvcQbbGO/SNl2nQT+Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQpYdVF4waEhXGQ/JO8ffEXrZxzQJDDbl5rWsij+JZv031SO4Zj/48sPvXZEFZpPt
	 wymTJpg3fQl2S2TUpzIrXZ2waXkBh2VIaLn5qohORqyJ2a03OqPRy/d7tcWkjJ13RQ
	 jOfFhruThwtbuOJubxBK5ai9CIz0hRnaRf72A8is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingchao Deng <yingchao.deng@oss.qualcomm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0605/1266] coresight: cti: Fix DT filter signals silently ignored
Date: Tue, 21 Jul 2026 17:17:22 +0200
Message-ID: <20260721152455.402202851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



