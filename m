Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE46D512
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB66C433EF;
	Mon, 15 May 2023 16:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169052;
	bh=HXTn+4hHQXWvrvSEDkcfWtqNTaJfHkpUK//JWXTOcYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgoTST/8M+Nga1ZyJD4DOfAjClwXPaXjh/wmMJQUlW7bA/zl18xFj+GGQ5b0lrkQr
	 61T/rPzSy8F0piA/E4TO9wKS+D832OKePjSG/OOgW2RFdGJIs2eyTPIGlhs2p5wiTl
	 BFBEs5O+8GAIRdzvpbiE2xANHkv0Hg8bbjlbYmu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Wang Li <wangli74@huawei.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/191] spi: qup: fix PM reference leak in spi_qup_remove()
Date: Mon, 15 May 2023 18:25:23 +0200
Message-Id: <20230515161710.392006942@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Li <wangli74@huawei.com>

[ Upstream commit cec77e0a249892ceb10061bf17b63f9fb111d870 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Li <wangli74@huawei.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210409095458.29921-1-wangli74@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 61f49171a43a ("spi: qup: Don't skip cleanup in remove's error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index 1ca678bcb5279..e8009f8c212c0 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1249,7 +1249,7 @@ static int spi_qup_remove(struct platform_device *pdev)
 	struct spi_qup *controller = spi_master_get_devdata(master);
 	int ret;
 
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.39.2



