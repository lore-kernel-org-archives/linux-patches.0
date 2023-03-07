Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BF2BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7C0C433D2;
	Tue,  7 Mar 2023 17:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210124;
	bh=BaSysB2cGpLNgLaNHuUncvKJvtQ459DHO45Z2Y1/SFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5YXywQw9AxeA+9ens7WiSn/HKSVeKwyZJeCP9cjcEkL5xCafmn9r4dwRe2Pl0uZX
	 qqdUTTBykQOB7DjHEWGJp11xZX5cDOyG9JWocU7qECQ2QPHra03XtNQbcAqUX6Vp9E
	 BuCN9t5pXwRoyWtnyRO0jBm6xlwNc+fycZWwbZH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jassi Brar <jaswinder.singh@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0441/1001] spi: synquacer: Fix timeout handling in synquacer_spi_transfer_one()
Date: Tue,  7 Mar 2023 17:53:33 +0100
Message-Id: <20230307170040.489255014@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e6a0b671880207566e1ece983bf989dde60bc1d7 ]

wait_for_completion_timeout() never returns a <0 value. It returns either
on timeout or a positive value (at least 1, or number of jiffies left
till timeout)

So, fix the error handling path and return -ETIMEDOUT should a timeout
occur.

Fixes: b0823ee35cf9 ("spi: Add spi driver for Socionext SynQuacer platform")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Jassi Brar <jaswinder.singh@linaro.org>
Link: https://lore.kernel.org/r/c2040bf3cfa201fd8890cfab14fa5a701ffeca14.1676466072.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-synquacer.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-synquacer.c b/drivers/spi/spi-synquacer.c
index 47cbe73137c23..dc188f9202c97 100644
--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -472,10 +472,9 @@ static int synquacer_spi_transfer_one(struct spi_master *master,
 		read_fifo(sspi);
 	}
 
-	if (status < 0) {
-		dev_err(sspi->dev, "failed to transfer. status: 0x%x\n",
-			status);
-		return status;
+	if (status == 0) {
+		dev_err(sspi->dev, "failed to transfer. Timeout.\n");
+		return -ETIMEDOUT;
 	}
 
 	return 0;
-- 
2.39.2



