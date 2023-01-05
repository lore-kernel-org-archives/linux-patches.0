Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EBE63DA
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A532C433EF;
	Thu,  5 Jan 2023 12:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923431;
	bh=AIySWzne8xQFG254NIBWXqXWpxhUxnIRuPEW+9xdfK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjtYcKFztitQjMBllURH8isPdS2TU9l5gcJblx4FJMcytKnQFaCncQgnagd0uHQhn
	 WcYByDJabGqHVCBmGCYGrZ6iPP31lPnvd/azaTGOd5Hlp++v+eaybHpTPAimfon0wa
	 Cbgzh/xsgZB4gX6DkZSPmzJGIruTom4l58GiHHrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Qilong <zhangqilong3@huawei.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 018/251] soc: ti: smartreflex: Fix PM disable depth imbalance in omap_sr_probe
Date: Thu,  5 Jan 2023 13:52:35 +0100
Message-Id: <20230105125335.572352660@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 69460e68eb662064ab4188d4e129ff31c1f23ed9 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context.

Fixes: 984aa6dbf4ca ("OMAP3: PM: Adding smartreflex driver support.")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20221108080322.52268-3-zhangqilong3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/avs/smartreflex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index bb7b817cca59..a695c87ae459 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -971,6 +971,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 err_debugfs:
 	debugfs_remove_recursive(sr_info->dbg_dir);
 err_list_del:
+	pm_runtime_disable(&pdev->dev);
 	list_del(&sr_info->node);
 	return ret;
 }
-- 
2.35.1



