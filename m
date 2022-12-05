Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE53115C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388C5C433D6;
	Mon,  5 Dec 2022 19:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268930;
	bh=h3RyOLsHQ2Iay+oG81+7CC6e69NXb0Sy1C4sKQ5fJ2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBl1h3+VdepPhyJ6kx7CaBLsPqM3v+BNraD5pIopK5T8IUT9DljdxKREOJRL5qjzE
	 8TQ5oyxSEiLrlNoSeTk0Cve2xPH0wqxdSVKwwbK0sj6FyO6Tq5HCWrAkZL/2G02XlI
	 pn7QLLTRlhkPwKSkSKTpENWGm7nNR9FPHa5n12Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tho Vu <tho.vu.wh@renesas.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/120] net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed
Date: Mon,  5 Dec 2022 20:10:03 +0100
Message-Id: <20221205190808.518281592@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit d66233a312ec9013af3e37e4030b479a20811ec3 ]

After system resumed on some environment board, the promiscuous mode
is disabled because the SoC turned off. So, call ravb_set_rx_mode() in
the ravb_resume() to fix the issue.

Reported-by: Tho Vu <tho.vu.wh@renesas.com>
Fixes: 0184165b2f42 ("ravb: add sleep PM suspend/resume support")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20221128065604.1864391-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 12420239c8ca..77a19336abec 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2491,6 +2491,7 @@ static int __maybe_unused ravb_resume(struct device *dev)
 		ret = ravb_open(ndev);
 		if (ret < 0)
 			return ret;
+		ravb_set_rx_mode(ndev);
 		netif_device_attach(ndev);
 	}
 
-- 
2.35.1



