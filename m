Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BA61119B
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8990BC433C8;
	Thu, 24 Aug 2023 14:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888870;
	bh=FaOWZLGiRjPQavYsvPo2Vf4R34o4Jnpj4hKZJ5GdDvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hj8Sm+F9+rTJlvB99fyrou15HzvY1U4muOXZLTGkOFC0Bpk8thDZLQGC1pOkLmEdh
	 up/KnhOnXJN57I+sKPcp76XGtjqtrvZb1zWyxCGjSmWAo7W9IERFxmoG03na4gszDJ
	 0Pa/IyE1mZ35rQHJW8gR6YWrCIfpnWezfS2HV6p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 071/139] i2c: hisi: Only handle the interrupt of the drivers transfer
Date: Thu, 24 Aug 2023 16:49:54 +0200
Message-ID: <20230824145026.759952845@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
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
@@ -329,6 +329,14 @@ static irqreturn_t hisi_i2c_irq(int irq,
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


