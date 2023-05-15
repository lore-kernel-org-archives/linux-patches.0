Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FE817730
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95719C433D2;
	Mon, 15 May 2023 18:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684174002;
	bh=B/bAqrSB3C2f4YL3jVbpj8jICGWmWfxbQOQ18kxBjQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpdiPZujqR4hXA0bnycLVej2qGPthqlKDhw4hkDhJ6Ale1PnLeRV9TxYgm83flazX
	 4tL0dJK5JPzyhVNhYbafmlP42okpvNV28+GbI4aqzlbRz61vED3bcnGoi7RUrq9upS
	 scaVc0T17oiZmeSRiUYOgm6Ml+hniLJvkAUOqTeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Qilong <zhangqilong3@huawei.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 276/282] spi: imx: fix reference leak in two imx operations
Date: Mon, 15 May 2023 18:30:54 +0200
Message-Id: <20230515161730.648023288@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Qilong <zhangqilong3@huawei.com>

commit 1dcbdd944824369d4569959f8130336fe6fe5f39 upstream.

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in callers(spi_imx_prepare_message and
spi_imx_remove), so we should fix it.

Fixes: 525c9e5a32bd7 ("spi: imx: enable runtime pm support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201102145835.4765-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-imx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1538,6 +1538,7 @@ spi_imx_prepare_message(struct spi_maste
 
 	ret = pm_runtime_resume_and_get(spi_imx->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(spi_imx->dev);
 		dev_err(spi_imx->dev, "failed to enable clock\n");
 		return ret;
 	}


