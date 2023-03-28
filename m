Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F84E8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DACC433EF;
	Tue, 28 Mar 2023 14:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015399;
	bh=hlujoLXWxnN8F554mrWZ0ZDnICvfhhTyzshLYwelEp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJZ/+YxCXiPapHe4lhgehjmrzAcoXQ7zhucjcXTtYrLyh761TKEAtzxDfOFEMbHV2
	 Zf9ESQfjHL9jsZkSkxo54qz6OhcJVcBZDL2c+AzZozOMIm4N4NcVScaZj/eQy2DJ40
	 xABseIWDZN+OD2yjylM/iq7sXhCe3RTiQ9PtuDEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Feng <fengsheng5@huawei.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/224] i2c: hisi: Only use the completion interrupt to finish the transfer
Date: Tue, 28 Mar 2023 16:40:30 +0200
Message-Id: <20230328142618.750864797@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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

[ Upstream commit d98263512684a47e81bcb72a5408958ecd1e60b0 ]

The controller will always generate a completion interrupt when the
transfer is finished normally or not. Currently we use either error or
completion interrupt to finish, this may result the completion
interrupt unhandled and corrupt the next transfer, especially at low
speed mode. Since on error case, the error interrupt will come first
then is the completion interrupt. So only use the completion interrupt
to finish the whole transfer process.

Fixes: d62fbdb99a85 ("i2c: add support for HiSilicon I2C controller")
Reported-by: Sheng Feng <fengsheng5@huawei.com>
Signed-off-by: Sheng Feng <fengsheng5@huawei.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-hisi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-hisi.c b/drivers/i2c/busses/i2c-hisi.c
index 76c3d8f6fc3c6..d30071f299879 100644
--- a/drivers/i2c/busses/i2c-hisi.c
+++ b/drivers/i2c/busses/i2c-hisi.c
@@ -339,7 +339,11 @@ static irqreturn_t hisi_i2c_irq(int irq, void *context)
 		hisi_i2c_read_rx_fifo(ctlr);
 
 out:
-	if (int_stat & HISI_I2C_INT_TRANS_CPLT || ctlr->xfer_err) {
+	/*
+	 * Only use TRANS_CPLT to indicate the completion. On error cases we'll
+	 * get two interrupts, INT_ERR first then TRANS_CPLT.
+	 */
+	if (int_stat & HISI_I2C_INT_TRANS_CPLT) {
 		hisi_i2c_disable_int(ctlr, HISI_I2C_INT_ALL);
 		hisi_i2c_clear_int(ctlr, HISI_I2C_INT_ALL);
 		complete(ctlr->completion);
-- 
2.39.2



