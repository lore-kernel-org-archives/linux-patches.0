Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C191863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A000CC433EF;
	Wed, 28 Dec 2022 15:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240636;
	bh=In8AWe4cx5K5Jc3dbiscc2C85Y+3tmNLBFVVzKEGWHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWVuALRasJeVWPJJvDA0WlfU/r17TzrtYp2hMHh4Be7DcTx9VryCCf64pvtKlnLeW
	 /9RrYxTdxBVw7G+n42L5Xxd4RqmKrrmTLOycrwBw8TTDAIkSvO3CBDr8gl3VgB6HuY
	 HWgPRHyGASpjdcJcOeYpEMN03lH9wrEW7mvanGxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	=?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0148/1146] irqchip/wpcm450: Fix memory leak in wpcm450_aic_of_init()
Date: Wed, 28 Dec 2022 15:28:07 +0100
Message-Id: <20221228144334.165883182@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 4208d4faf36573a507b5e5de17abe342e9276759 ]

If of_iomap() failed, 'aic' should be freed before return. Otherwise
there is a memory leak.

Fixes: fead4dd49663 ("irqchip: Add driver for WPCM450 interrupt controller")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221115092532.1704032-1-weiyongjun@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-wpcm450-aic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-wpcm450-aic.c b/drivers/irqchip/irq-wpcm450-aic.c
index 0dcbeb1a05a1..91df62a64cd9 100644
--- a/drivers/irqchip/irq-wpcm450-aic.c
+++ b/drivers/irqchip/irq-wpcm450-aic.c
@@ -146,6 +146,7 @@ static int __init wpcm450_aic_of_init(struct device_node *node,
 	aic->regs = of_iomap(node, 0);
 	if (!aic->regs) {
 		pr_err("Failed to map WPCM450 AIC registers\n");
+		kfree(aic);
 		return -ENOMEM;
 	}
 
-- 
2.35.1



