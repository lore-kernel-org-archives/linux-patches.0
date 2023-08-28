Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B994411C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D47DC433C7;
	Mon, 28 Aug 2023 10:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218313;
	bh=xIQa5sFus1iuUDYiH1itL5Vs2w/itsk0v6KYrMFsIqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvA2CrHLZaZb74auOiRepNMQdn6ci0zRxSk5B+rSxLsQge7jGlm78z+2Ppbm38N+y
	 kYqCXNa07c/+W7v/NbpW7UhCuYa56uzTiT+TFYxe022gDaF6zZxVQIKh9OQSbGVB7v
	 AMvmsUIsZgHL3lHlmti/7tULVQSN2IDONCxPLoyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/129] mmc: sunxi: fix deferred probing
Date: Mon, 28 Aug 2023 12:12:16 +0200
Message-ID: <20230828101154.735161155@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit c2df53c5806cfd746dae08e07bc8c4ad247c3b70 ]

The driver overrides the error codes and IRQ0 returned by platform_get_irq()
to -EINVAL, so if it returns -EPROBE_DEFER, the driver will fail the probe
permanently instead of the deferred probing. Switch to propagating the error
codes upstream.  Since commit ce753ad1549c ("platform: finally disallow IRQ0
in platform_get_irq() and its ilk") IRQ0 is no longer returned by those APIs,
so we now can safely ignore it...

Fixes: 2408a08583d2 ("mmc: sunxi-mmc: Handle return value of platform_get_irq")
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20230617203622.6812-12-s.shtylyov@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sunxi-mmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sunxi-mmc.c b/drivers/mmc/host/sunxi-mmc.c
index 757eb175611fb..bc3f8a1df10cc 100644
--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -1308,8 +1308,8 @@ static int sunxi_mmc_resource_request(struct sunxi_mmc_host *host,
 		return ret;
 
 	host->irq = platform_get_irq(pdev, 0);
-	if (host->irq <= 0) {
-		ret = -EINVAL;
+	if (host->irq < 0) {
+		ret = host->irq;
 		goto error_disable_mmc;
 	}
 
-- 
2.40.1



