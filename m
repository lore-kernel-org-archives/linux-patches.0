Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FCD1170E
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7578BC433C8;
	Mon, 21 Aug 2023 19:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647653;
	bh=XxEp7jAuiCfYzzgVGvN9php2593EJmAcvg8pChy4cMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJfIyy1uogMbj/GoUFcjehLTSZyTaGZPNFas8p7t7JJjdtMRVVGitGDGcxCOVfQSP
	 Dyjn5Wj6k4lGfzdm4r0J0WA4yQNlm2kbesxAcIlaB1kvZ9IrZA9av61ohZlhPbX8kI
	 bquBVd6AxP4L2g158OBAg1ueNUL8Br/BzsYzNtuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.1 090/194] i2c: hisi: Only handle the interrupt of the drivers transfer
Date: Mon, 21 Aug 2023 21:41:09 +0200
Message-ID: <20230821194126.688607959@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
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

commit fff67c1b17ee093947bdcbac6f64d072e644159a upstream.

The controller may be shared with other port, for example the firmware.
Handle the interrupt from other sources will cause crash since some
data are not initialized. So only handle the interrupt of the driver's
transfer and discard others.

Fixes: d62fbdb99a85 ("i2c: add support for HiSilicon I2C controller")
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20230801124625.63587-1-yangyicong@huawei.com
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-hisi.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/i2c/busses/i2c-hisi.c
+++ b/drivers/i2c/busses/i2c-hisi.c
@@ -328,6 +328,14 @@ static irqreturn_t hisi_i2c_irq(int irq,
 	struct hisi_i2c_controller *ctlr = context;
 	u32 int_stat;
 
+	/*
+	 * Don't handle the interrupt if cltr->completion is NULL. We may
+	 * reach here because the interrupt is spurious or the transfer is
+	 * started by another port (e.g. firmware) rather than us.
+	 */
+	if (!ctlr->completion)
+		return IRQ_NONE;
+
 	int_stat = readl(ctlr->iobase + HISI_I2C_INT_MSTAT);
 	hisi_i2c_clear_int(ctlr, int_stat);
 	if (!(int_stat & HISI_I2C_INT_ALL))


