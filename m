Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A459B79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A33EC433D6;
	Wed, 30 Nov 2022 18:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833938;
	bh=cmGg9lO5EOzcd0xbELic2ofZBztqV9txlHtyEbKMqsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WS1WiPs4rI1hLNwmvOyYhjwtgNFQM9L44MW7IGjziUWehOCydyX/C8qwyB1Xi5t7c
	 QiZlU5iYWfg7iL4vvDTJCtxnFCe2VP3z1D8O4fp9n8EBQM9hz6F1dsvi8abmCsOEim
	 yad6BJParydqvT1o7dfszlzowpkz0YJJbEf+ZQfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Yarlagadda <kyarlagadda@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 069/289] spi: tegra210-quad: Fix duplicate resource error
Date: Wed, 30 Nov 2022 19:20:54 +0100
Message-Id: <20221130180545.694098990@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krishna Yarlagadda <kyarlagadda@nvidia.com>

[ Upstream commit 2197aa6b0aa236b9896a09b9d08d6924d18b84f6 ]

controller data alloc is done with client device data causing duplicate
resource error. Allocate memory using controller device when using devm

Fixes: f89d2cc3967a ("spi: tegra210-quad: use devm call for cdata memory")

Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20221117070320.18720-1-kyarlagadda@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 10f0c5a6e0dc..9f356612ba7e 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -924,8 +924,9 @@ static int tegra_qspi_start_transfer_one(struct spi_device *spi,
 static struct tegra_qspi_client_data *tegra_qspi_parse_cdata_dt(struct spi_device *spi)
 {
 	struct tegra_qspi_client_data *cdata;
+	struct tegra_qspi *tqspi = spi_master_get_devdata(spi->master);
 
-	cdata = devm_kzalloc(&spi->dev, sizeof(*cdata), GFP_KERNEL);
+	cdata = devm_kzalloc(tqspi->dev, sizeof(*cdata), GFP_KERNEL);
 	if (!cdata)
 		return NULL;
 
-- 
2.35.1



