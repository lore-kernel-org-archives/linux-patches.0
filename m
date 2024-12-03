Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431E91EF08A;
	Tue,  3 Dec 2024 14:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236534; cv=none; b=sh2mSE8CAVQjoi+Bbmdsy4//zT/bFx6rXWlfKZnbMaIcwZ/LtYiaOYM8H3k8tywkfRdF7nB9eNKexBqtREcpdA0oaCVPdyl1+dkZAKKsG0bbN7oG4hAkBhgP+BJ4643p/uQXd3fi/puWVCXu72W48X/M0HBfrc6DeBRwEKINyig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236534; c=relaxed/simple;
	bh=MbMYqC7h2ro6GoH/iiSnoJyzFGpzOPLWHXtwwQ451lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deviw0XJf0L91T93jaWs3OFjLzbHwQU73RaPjovyjDPfSmvNy7OZWk8duwYEIicldwL4slrH5TKDBFpzO5fhG1pqpHjE5FOXsZCvFKU1oU0FPeA545bmODm1xiJTR+XSxBGOUTTxrfqCXWy3pnHEuXuAJ7nCiomSAXds6pNMifw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxkIsP1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxkIsP1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A427CC4CED8;
	Tue,  3 Dec 2024 14:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236534;
	bh=MbMYqC7h2ro6GoH/iiSnoJyzFGpzOPLWHXtwwQ451lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxkIsP1Gh0vU3mCtr0Urx2ow4ijCYJpORdtKUQU8XHp/zpp9p0lVjX4aRuXiN4sEm
	 FqwnZHmzDZFVGvCvKHZ2KcDPe9quiGz1hLPbcSyBsjeVMvpT74WTKRJ8CJAdGKPxWF
	 f0jx3QHbyX/WICEt2hyEUjswyhpJ7MmVQ/+eLe/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/138] soc: ti: smartreflex: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  3 Dec 2024 15:30:59 +0100
Message-ID: <20241203141924.708187589@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/power/avs/smartreflex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index 5ac122cd25b8c..015a406d67b8d 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -217,10 +217,10 @@ static int sr_late_init(struct omap_sr *sr_info)
 
 	if (sr_class->notify && sr_class->notify_flags && sr_info->irq) {
 		ret = devm_request_irq(&sr_info->pdev->dev, sr_info->irq,
-				       sr_interrupt, 0, sr_info->name, sr_info);
+				       sr_interrupt, IRQF_NO_AUTOEN,
+				       sr_info->name, sr_info);
 		if (ret)
 			goto error;
-		disable_irq(sr_info->irq);
 	}
 
 	if (pdata && pdata->enable_on_init)
-- 
2.43.0



