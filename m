Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7458D2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C2DC4339E;
	Tue, 18 Apr 2023 12:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821972;
	bh=wYI/r4tJiEhg6thiFHAvKr41kMTWCFXFYIv/1bsrBcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITZcN8OjtVwo9ZXKsxIRr0UMW+yMGCLUaHw2ZBf5ulFlNBxn0oW1xSggzuys/Pxgx
	 mkDEP/lqeGCXR2iAcJkBZS1bIdeC4jX5cR5Y3jqrONB5mXasZntrJk2Qu9Tv4Xegap
	 zd1tH4pxvBvhyaQvOh9iN7Zmy+awq1nCwot7Jj80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Feng <fengsheng5@huawei.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/134] i2c: hisi: Avoid redundant interrupts
Date: Tue, 18 Apr 2023 14:22:14 +0200
Message-Id: <20230418120315.769412886@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit cc9812a3096d1986caca9a23bee99effc45c08df ]

After issuing all the messages we can disable the TX_EMPTY interrupts
to avoid handling redundant interrupts. For doing a sinlge bus
detection (i2cdetect -y -r 0) we can reduce ~97% interrupts (before
~12000 after ~400).

Signed-off-by: Sheng Feng <fengsheng5@huawei.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-hisi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/i2c/busses/i2c-hisi.c b/drivers/i2c/busses/i2c-hisi.c
index d30071f299879..8a61bee745a16 100644
--- a/drivers/i2c/busses/i2c-hisi.c
+++ b/drivers/i2c/busses/i2c-hisi.c
@@ -314,6 +314,13 @@ static void hisi_i2c_xfer_msg(struct hisi_i2c_controller *ctlr)
 		    max_write == 0)
 			break;
 	}
+
+	/*
+	 * Disable the TX_EMPTY interrupt after finishing all the messages to
+	 * avoid overwhelming the CPU.
+	 */
+	if (ctlr->msg_tx_idx == ctlr->msg_num)
+		hisi_i2c_disable_int(ctlr, HISI_I2C_INT_TX_EMPTY);
 }
 
 static irqreturn_t hisi_i2c_irq(int irq, void *context)
-- 
2.39.2



