Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FCA1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19A6C433EF;
	Wed, 28 Dec 2022 16:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244922;
	bh=td1nQZGRejRUOszUsoW+P8+Im1nKoFmTgQ/JODahWIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCXscEbhFaCmgArSruxK3CLNBXTUqoDZNY5i3kJDmg18O5z/X0z86y6GBS7aApznl
	 5YlRsVahOr9XXYQe1mYt3IM6QMQhyAcvcvVMj8rkdQ+m9mzgKTv8VFBU9W0cOkKkAb
	 vdfIBdp9bIQgHNUf7vCSjv6/lh71bO1YDLYhpxEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0800/1073] powerpc/xive: add missing iounmap() in error path in xive_spapr_populate_irq_data()
Date: Wed, 28 Dec 2022 15:39:48 +0100
Message-Id: <20221228144349.740247476@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index e2c8f93b535b..e45419264391 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -439,6 +439,7 @@ static int xive_spapr_populate_irq_data(u32 hw_irq, struct xive_irq_data *data)
 
 	data->trig_mmio = ioremap(data->trig_page, 1u << data->esb_shift);
 	if (!data->trig_mmio) {
+		iounmap(data->eoi_mmio);
 		pr_err("Failed to map trigger page for irq 0x%x\n", hw_irq);
 		return -ENOMEM;
 	}
-- 
2.35.1



