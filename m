Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB0C749E
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66403C433D2;
	Thu, 12 Jan 2023 14:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532757;
	bh=/qstePaWwVoqNJinnTPLhRr1bJicMkp4Vwoxl6xorRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1+imMAEr4XkLMRG2Uw1xivUGzcpGy6mUUTONaysWe3looTabJPgSdDwrH+JR/v5s
	 4IiJyZlu1ppV0sCv9ES5FLcFNh7yymCigaOE3jXJr22TBK9efoXqnt3x2Ht9ES3dhF
	 FKYmTzvVwLymmFnkQ5QCsuR4CCNkEJfaGr1swx0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 265/783] can: tcan4x5x: Remove invalid write in clear_interrupts
Date: Thu, 12 Jan 2023 14:49:41 +0100
Message-Id: <20230112135536.716607685@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit 40c9e4f676abbe194541d88e796341c92d5a13c0 ]

Register 0x824 TCAN4X5X_MCAN_INT_REG is a read-only register. Any writes
to this register do not have any effect.

Remove this write. The m_can driver aldready clears the interrupts in
m_can_isr() by writing to M_CAN_IR which is translated to register
0x1050 which is a writable version of this register.

Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20221206115728.1056014-9-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/tcan4x5x.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index f169d9090e52..f903f78af087 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -294,11 +294,6 @@ static int tcan4x5x_clear_interrupts(struct m_can_classdev *cdev)
 	if (ret)
 		return ret;
 
-	ret = tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_MCAN_INT_REG,
-				      TCAN4X5X_ENABLE_MCAN_INT);
-	if (ret)
-		return ret;
-
 	ret = tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_INT_FLAGS,
 				      TCAN4X5X_CLEAR_ALL_INT);
 	if (ret)
-- 
2.35.1



