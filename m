Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280E928ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E39AC433F0;
	Mon, 12 Dec 2022 13:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851089;
	bh=OyJhl0urYqLEGAXiMaD8NlhT5R4R3ciDN/M8xEd2JY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qG0SvjPT6OJtdqLyYCObXTwi4rthwB8ds9GiwpKXQkWpIcRjqCTW4HPRKZccRYcNm
	 JGIopZ4ImfLeqMHgj+PdfV2q45ujd2KkRbFQQU+oCMdvTH1nyQ0/LQiTezOr7jJJSs
	 Dy76PhaxfAgdAz/+ZAGmcJTjEFN/X04XBuEf/MSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentina Goncharenko <goncharenko.vp@ispras.ru>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/106] net: encx24j600: Fix invalid logic in reading of MISTAT register
Date: Mon, 12 Dec 2022 14:10:25 +0100
Message-Id: <20221212130928.454596427@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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
index 2e337c7a5773..5693784eec5b 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -359,7 +359,7 @@ static int regmap_encx24j600_phy_reg_read(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
@@ -397,7 +397,7 @@ static int regmap_encx24j600_phy_reg_write(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
-- 
2.35.1



