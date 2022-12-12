Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527F628ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52560C433D2;
	Mon, 12 Dec 2022 13:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853250;
	bh=X9aqVZUNf+McmnMpiFENZO3UDsK6jYzgh4jSfJtul4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYimnpAQpuMex2KVWf8qAI3Pl3+j7mvl94i8kixEEoxKi5K0we/CXWrn9Orln3lkt
	 VkyZs4w/rGOLW8Ex6aIa4/Ry/JM2awbaVXbdVSbKXkRK7w9+6J4U/5kn6mB5kmPjyl
	 2RJN9pBKjfAUdKrD9t+1qQXyxfK8dQPwE9ws6HpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentina Goncharenko <goncharenko.vp@ispras.ru>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 27/38] net: encx24j600: Fix invalid logic in reading of MISTAT register
Date: Mon, 12 Dec 2022 14:19:28 +0100
Message-Id: <20221212130913.456567659@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
References: <20221212130912.069170932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Valentina Goncharenko <goncharenko.vp@ispras.ru>

[ Upstream commit 25f427ac7b8d89b0259f86c0c6407b329df742b2 ]

A loop for reading MISTAT register continues while regmap_read() fails
and (mistat & BUSY), but if regmap_read() fails a value of mistat is
undefined.

The patch proposes to check for BUSY flag only when regmap_read()
succeed. Compile test only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d70e53262f5c ("net: Microchip encx24j600 driver")
Signed-off-by: Valentina Goncharenko <goncharenko.vp@ispras.ru>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/encx24j600-regmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600-regmap.c b/drivers/net/ethernet/microchip/encx24j600-regmap.c
index 4a3c0870c8e4..4a8d9633e082 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -367,7 +367,7 @@ static int regmap_encx24j600_phy_reg_read(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
@@ -405,7 +405,7 @@ static int regmap_encx24j600_phy_reg_write(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
-- 
2.35.1



