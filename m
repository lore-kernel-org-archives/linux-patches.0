Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8880D470120;
	Tue, 21 Jul 2026 19:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662405; cv=none; b=e6Iek4C+mcbsMCse6NipvJtkPNUMimnSibW27ZJLGseZ7KdKv/Hr656oEPTLfVyRXpwPCPoxuzraDVsSpYVdko6+Hs191BDDn6HHaeHPg0RHZoFfnFlbTdAsunsTet6cJL7TahPNx+tZDWsddRGdyAIbSiinSsEoxUUrOTaYnSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662405; c=relaxed/simple;
	bh=Mf+xKMpi2PTKc7nU6L7BU0ivVjOoeHJ2SgJaM/Wa4kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6ijgF+F/UAMymPf16nuyfUFh2JtlZv6xnrhtHxO8P2v3n3Apct7s9UxslVYPLxAyczxOkRfye8Js2E+9MEAK0ufjDHAVzoDY4n2ZjDJA2Uh28eDvHmoMxShiam2toLRtph6+e8FddRCK7edEnqSC6agMZiEjre4+pWFdoJ6n0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jv0AcWMH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jv0AcWMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED45A1F000E9;
	Tue, 21 Jul 2026 19:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662404;
	bh=OwbHG/irKKp1ddGafxyAxNDwerrk6RrAY8ALq1dqJoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jv0AcWMHoQUbInkzYFIvyZSFkh579H+fj2aamp0biT7XtztjXXPPjizYhZBrvt4CO
	 GuYkOkH1C+nCzP1LMCBx+3Br798cINLKkRmMXZG36v8tMaAxUKQftMlnCubB9lwHpW
	 0U7iRKxkI5LF14BCviPWnn3IgWUgqUdgxxTuwQ8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingchao Deng <yingchao.deng@oss.qualcomm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0415/1276] coresight: cti: Fix DT filter signals silently ignored
Date: Tue, 21 Jul 2026 17:14:18 +0200
Message-ID: <20260721152455.385772246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d0ae10bf612811..0ed52a693c35be 100644
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



