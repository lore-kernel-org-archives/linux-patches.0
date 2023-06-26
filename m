Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCEB14A8F
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D64FC433C8;
	Mon, 26 Jun 2023 18:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804277;
	bh=U1WP+wywmwTYfoJG24IM1926hIeSyuga01PtxEr31WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yI4n3W1VE1jBCgiD4/Z6iSOeGzTk5yiEcy0sChm+W42fD99rvpo6Rzw/7uSnReeC5
	 kPUcWe1rpkL/4ItkveS1h9NqdSd30kOB95lmWFuZRWtDgRyJwGfNWVo+dbjZRpSiCe
	 3NNF/Xczu6+FUOyB8tHs83rB44vcZceA+Y4nX1Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/170] mmc: owl: fix deferred probing
Date: Mon, 26 Jun 2023 20:11:10 +0200
Message-ID: <20230626180805.074060287@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 3c482e1e830d79b9be8afb900a965135c01f7893 ]

The driver overrides the error codes returned by platform_get_irq() to
-EINVAL, so if it returns -EPROBE_DEFER, the driver will fail the probe
permanently instead of the deferred probing. Switch to propagating the
error codes upstream.

Fixes: ff65ffe46d28 ("mmc: Add Actions Semi Owl SoCs SD/MMC driver")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20230617203622.6812-8-s.shtylyov@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/owl-mmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/owl-mmc.c b/drivers/mmc/host/owl-mmc.c
index 3dc143b039397..679b8b0b310e5 100644
--- a/drivers/mmc/host/owl-mmc.c
+++ b/drivers/mmc/host/owl-mmc.c
@@ -638,7 +638,7 @@ static int owl_mmc_probe(struct platform_device *pdev)
 
 	owl_host->irq = platform_get_irq(pdev, 0);
 	if (owl_host->irq < 0) {
-		ret = -EINVAL;
+		ret = owl_host->irq;
 		goto err_release_channel;
 	}
 
-- 
2.39.2



