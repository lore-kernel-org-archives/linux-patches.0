Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1593C1081;
	Tue, 21 Jul 2026 22:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671773; cv=none; b=gD4j+BA0HJqXwk9gDF9D9TiDBhiz4yw0iio7SV16IYOhtpUredy7V3ZeLEI7dDlpfSWwPE20lQCoHP4NpOz10lj9ddwt9RKgWpLsCUZroA3OUi/CRy3tHKuDciLh5kocHrcv/49bvnZOWcTfjGNzy21snkF7lw/Hp7t2pGwWkVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671773; c=relaxed/simple;
	bh=1LGG7yS8L1m6UmcSztbHUEMhBJvc0SXFPAI7Wu9xWGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKdsWD+fnvXssTX9cJCkVpVXS2gTRovkITY+SJVLoVFxHW0fStOfVjATR5QtvPKgLQ7+6hclZGX77gy97vt7tpG5So3g6bmL2Zts/zfCqqIqknfjqOg7J7ccEWkZKm9uycNzJsbTci+1dRnIKxxRETv+KvwhEm/fXzETtJp2TCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDFIClap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDFIClap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD371F000E9;
	Tue, 21 Jul 2026 22:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671772;
	bh=HTCctMaijWMhfOzhPqfdah+AC0lWSWAafoJIIwcGivY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDFIClap/EVjKslVYTbRZM0UaFdQ00y9U8hgDyoF6YG6gmR7SAG9JfvAGicWUUevk
	 0Dru+xTvroEsZ0n/vjvMUfxQLPXuElgoW3eR4/Bc+X0VEMnmryU7aJkeLBIlOkyVZM
	 zeEyW8pZEAqGQ2rhwsYzOOob49WmQDeqvGvzRk04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingchao Deng <yingchao.deng@oss.qualcomm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 374/843] coresight: cti: Fix DT filter signals silently ignored
Date: Tue, 21 Jul 2026 17:20:09 +0200
Message-ID: <20260721152414.447210698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



