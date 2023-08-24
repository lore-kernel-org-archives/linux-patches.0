Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C64011C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2637C433C7;
	Thu, 24 Aug 2023 15:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889311;
	bh=o3ufGvVJJyvgpyBSE/Ss9rK216MCI99hBP1QRL7br8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wm8wfFASMTeAEDzM0SFVfWSrc58wvvOUOyb++s8UGc90ZzFvnsq1ajJHEnlGX8SgW
	 2OBLXUUZY8X51ZqpRkEZJu0EGG+G9MwMIVZBJK86ogJLKzJlxUbuWgal056VADoDzO
	 yD88WSajzn66s0N3BiOwVt+uVevzMCpwU1pLMPZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/135] mmc: core: add devm_mmc_alloc_host
Date: Thu, 24 Aug 2023 16:50:04 +0200
Message-ID: <20230824145029.536882212@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 80df83c2c57e75cb482ccf0c639ce84703ab41a2 ]

Add a device-managed version of mmc_alloc_host().

The argument order is reversed compared to mmc_alloc_host() because
device-managed functions typically have the device argument first.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/6d8f9fdc-7c9e-8e4f-e6ef-5470b971c74e@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: b8ada54fa1b8 ("mmc: meson-gx: fix deferred probing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/host.c  | 26 ++++++++++++++++++++++++++
 include/linux/mmc/host.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 03e2f965a96a8..1f46694b2e531 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -513,6 +513,32 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 
 EXPORT_SYMBOL(mmc_alloc_host);
 
+static void devm_mmc_host_release(struct device *dev, void *res)
+{
+	mmc_free_host(*(struct mmc_host **)res);
+}
+
+struct mmc_host *devm_mmc_alloc_host(struct device *dev, int extra)
+{
+	struct mmc_host **dr, *host;
+
+	dr = devres_alloc(devm_mmc_host_release, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return ERR_PTR(-ENOMEM);
+
+	host = mmc_alloc_host(extra, dev);
+	if (IS_ERR(host)) {
+		devres_free(dr);
+		return host;
+	}
+
+	*dr = host;
+	devres_add(dev, dr);
+
+	return host;
+}
+EXPORT_SYMBOL(devm_mmc_alloc_host);
+
 static int mmc_validate_host_caps(struct mmc_host *host)
 {
 	if (host->caps & MMC_CAP_SDIO_IRQ && !host->ops->enable_sdio_irq) {
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 40d7e98fc9902..fb294cbb9081d 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -477,6 +477,7 @@ struct mmc_host {
 struct device_node;
 
 struct mmc_host *mmc_alloc_host(int extra, struct device *);
+struct mmc_host *devm_mmc_alloc_host(struct device *dev, int extra);
 int mmc_add_host(struct mmc_host *);
 void mmc_remove_host(struct mmc_host *);
 void mmc_free_host(struct mmc_host *);
-- 
2.40.1



