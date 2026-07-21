Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AD22DF3EA;
	Tue, 21 Jul 2026 18:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660072; cv=none; b=H7RgFylF9XHId0m2DKPX4MBRtnesxNUbuqYXvUTcthCL2ufbCZfn8tLyS9pAVPO6aI1NMI2JKCZmiyOgMwSZD0upjqzcAXAPshsHbdL+xtEeWWdETWxeUr+P8hskay3wmB7QBTgkHHZ4fyvseR8McTVf290fRHhzpxVV8H2M3zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660072; c=relaxed/simple;
	bh=lH9TTV4MVHN1GANJbAa4/i0vgopoMB7Oi8PnnP0kMFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhCzAzfdfHfAyXeZNyyGEHInlIXzMeUygsfd7TcOZMOg2TZcgos/G3OlsNGtIrLGAtgVmxYQwvaVrU26nNm5DBIzRPKvSyd7EsI47qgD9C9KXK9KbzfBjaRke6zoPWc0mU7qVzLraO9jj/stIomQ4yfeeDFQ6Dk8ApRXO38Wuoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zdrK6wTs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zdrK6wTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138B11F000E9;
	Tue, 21 Jul 2026 18:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660071;
	bh=ycU+adGtALXQ+DLwnFfdzeHME7JUFOknFqK2ud/6p5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zdrK6wTsgBRnM3vlgQPWrW1NP3qKTHaUFhmrv+U7Wz3YWRVPdrPGijqYEaxpReJw2
	 uATcnPJUW2lOdPbCZOrzKSsP1pfAvFSgcTHnFCWYp1AMzTy0NlCKy+CzSDNlCcv/QB
	 Rs2u+Nk+m9X7aKicl2G6Y0kEfiHLrHRXuxy/OndI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingchao Deng <yingchao.deng@oss.qualcomm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0842/2077] coresight: cti: Fix DT filter signals silently ignored
Date: Tue, 21 Jul 2026 17:08:35 +0200
Message-ID: <20260721152612.652406355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4eff96f48594e8..d6d5388705c3e1 100644
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



