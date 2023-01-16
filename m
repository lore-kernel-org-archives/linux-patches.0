Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF57246B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EA5C433EF;
	Mon, 16 Jan 2023 16:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886316;
	bh=IPKg4mrV/EQ8yFcdj3kSnTDjschFFpm9HsWLSHtCM3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGoauEGMN3bTPAgiS+s9rDkb23bOpExecjyAzjTueiPzOEBMl20hfsMx47QTzhpv9
	 6GuZ6XGqp0+p/7WS0VWTXl6KStz0mmrRXjpWQhZmOtRqWLvrIBF06KlWvu5Lffk7Ah
	 CEJttrI7XoG+lAQIkZYjGt71cGpdUvYnhHMz0ckc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 355/658] powerpc/xive: add missing iounmap() in error path in xive_spapr_populate_irq_data()
Date: Mon, 16 Jan 2023 16:47:23 +0100
Message-Id: <20230116154925.829518931@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8b49670f3bb3f10cd4d5a6dca17f5a31b173ecdc ]

If remapping 'data->trig_page' fails, the 'data->eoi_mmio' need be unmapped
before returning from xive_spapr_populate_irq_data().

Fixes: eac1e731b59e ("powerpc/xive: guest exploitation of the XIVE interrupt controller")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221017032333.1852406-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/spapr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
index b21d71badaec..e6788bc06584 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -422,6 +422,7 @@ static int xive_spapr_populate_irq_data(u32 hw_irq, struct xive_irq_data *data)
 
 	data->trig_mmio = ioremap(data->trig_page, 1u << data->esb_shift);
 	if (!data->trig_mmio) {
+		iounmap(data->eoi_mmio);
 		pr_err("Failed to map trigger page for irq 0x%x\n", hw_irq);
 		return -ENOMEM;
 	}
-- 
2.35.1



