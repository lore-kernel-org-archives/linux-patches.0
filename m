Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1814D6ADF
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697D0C433D2;
	Thu,  5 Jan 2023 12:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923489;
	bh=bloqT0XLlL6pZlvfDkPmdF+ymEdYgihtx++/A0gF1zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwgfcZxMNOp/sw4t0BF59/b9EUC+mUP0MlUfEKcHVvAql1je0QTkG+0kIX7hBSrzc
	 6G0OAvzMSLgI4LljINA3/FPPCnICOHbKCDfc7y3ZY6pKa/FSV108Bmoy2xWjN/RNJ1
	 29RHS/++w8vtzrE0GbqOdvuFy3aUNatF4EEgUyP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 037/251] irqchip: gic-pm: Use pm_runtime_resume_and_get() in gic_probe()
Date: Thu,  5 Jan 2023 13:52:54 +0100
Message-Id: <20230105125336.460162946@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit f9ee20c85b3a3ba0afd3672630ec4f93d339f015 ]

gic_probe() calls pm_runtime_get_sync() and added fail path as
rpm_put to put usage_counter. However, pm_runtime_get_sync()
will increment usage_counter even it failed. Fix it by replacing it with
pm_runtime_resume_and_get() to keep usage counter balanced.

Fixes: 9c8edddfc992 ("irqchip/gic: Add platform driver for non-root GICs that require RPM")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221124065150.22809-1-shangxiaojing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-pm.c b/drivers/irqchip/irq-gic-pm.c
index ecafd295c31c..21c5decfc55b 100644
--- a/drivers/irqchip/irq-gic-pm.c
+++ b/drivers/irqchip/irq-gic-pm.c
@@ -112,7 +112,7 @@ static int gic_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		goto rpm_disable;
 
-- 
2.35.1



