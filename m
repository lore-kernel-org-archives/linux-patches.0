Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC9D1442E8;
	Fri,  6 Dec 2024 14:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496826; cv=none; b=CZ6PjLZjXhp8LFSQqeJvqvEU/RWbrHkU1VDaI/UgnALWli1uRqp5xd5a1E3/2QihRs4nUkrxqj8hwGEdat73MHitGwtaGAX0wFxiVIL5iOCJjTeK67nBoH5LvDQnzay8bca9D/QOjonNTySg2wDQ78vWGUr9hAnYNa5CPQnNkcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496826; c=relaxed/simple;
	bh=90sYtgPKZWCVUBbuA8MsvLpVicKWCwnSerCA25wi++o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POe1hDCZVtuo3L7dGh75nFKetbNoxXkYWvsNyfjhYTvkwvInCOrAOAbNM0i9q1tVbjVui8bSKE2B6Ss1OKXgO2OHPfdzUB7D98i6tErqsyylIFA5baio6u9g5gqeTa5fUeIo3Z2DZQ3BEvfb8hg8m6LJDu+vTVV5nXL0WdXlFbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTTI/KhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTTI/KhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBA3C4CED1;
	Fri,  6 Dec 2024 14:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496826;
	bh=90sYtgPKZWCVUBbuA8MsvLpVicKWCwnSerCA25wi++o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTTI/KhG3byF3pIh0O8bB/Dsz8zPdcoaHgYPXVpi0QUqI2hsXuJtZxo/tN9sTZ9w0
	 sVlMJT+1FMGnXiECxISrsRNGEIKw40692mnOk1OTArToqX+6925OrNzdNGmbFtEvtj
	 QjnJgBuPZA7naoQZ6Yg9yAW08CsXpHO1gubSYafI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/676] soc: ti: smartreflex: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Fri,  6 Dec 2024 15:28:56 +0100
Message-ID: <20241206143657.927752242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 16a0a69244240cfa32c525c021c40f85e090557a ]

If request_irq() fails in sr_late_init(), there is no need to enable
the irq, and if it succeeds, disable_irq() after request_irq() still has
a time gap in which interrupts can come.

request_irq() with IRQF_NO_AUTOEN flag will disable IRQ auto-enable when
request IRQ.

Fixes: 1279ba5916f6 ("OMAP3+: SR: disable interrupt by default")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20240912034147.3014213-1-ruanjinjie@huawei.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/smartreflex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/ti/smartreflex.c b/drivers/soc/ti/smartreflex.c
index 62b2f1464e467..55c48ddcf50da 100644
--- a/drivers/soc/ti/smartreflex.c
+++ b/drivers/soc/ti/smartreflex.c
@@ -202,10 +202,10 @@ static int sr_late_init(struct omap_sr *sr_info)
 
 	if (sr_class->notify && sr_class->notify_flags && sr_info->irq) {
 		ret = devm_request_irq(&sr_info->pdev->dev, sr_info->irq,
-				       sr_interrupt, 0, sr_info->name, sr_info);
+				       sr_interrupt, IRQF_NO_AUTOEN,
+				       sr_info->name, sr_info);
 		if (ret)
 			goto error;
-		disable_irq(sr_info->irq);
 	}
 
 	return ret;
-- 
2.43.0



