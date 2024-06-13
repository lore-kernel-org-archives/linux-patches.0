Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A19A143C6B;
	Thu, 13 Jun 2024 11:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278973; cv=none; b=dLJRoFMUzwlTKoHTLSPOYSTzKvgMssS68LSZOb/vMdK6gBuI5FbFQ0azH5uUTtJqZkAqXbI52EOeTatwuiaEzifJGiMAdj+n2eaWDH4ICcGuf9u0wJO6IRdVqdXEOPIAPl5wiDwzWB6Yo4xFHf9Gp/js98iRqV/R+WTJBBRZsrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278973; c=relaxed/simple;
	bh=XvKIgsAYK9E3m/qb5Idyf1NqIvZz++t5kQSaos1t4FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=po0xq6+1vHBN2wk1c9donMtK7oC7RwAxIqIA9s+zxGVzOipFp+XTfg+rx0He0f1uZsPV4lv1DNWQxTxGl3ROwFT0sdeMr0W+hRbO3Am4/l6tcHS/yuJd0f89bIJTZYAckh06ZZsWxbeabhv8RxtSGl67tLwGz15d8tUjWAwEU6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HW0Nxrd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HW0Nxrd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA22C4AF1C;
	Thu, 13 Jun 2024 11:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278973;
	bh=XvKIgsAYK9E3m/qb5Idyf1NqIvZz++t5kQSaos1t4FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HW0Nxrd+XzZ4DLVdBvUe7M5R96DEU+AI05is/W4K+MPkg1DK4SVBdIAc0C93TKszk
	 KzKT3zb1nkgJGy+l98oocVYgNTh6Kdml2sJU8ccU4EggT379gzgzrzvXMMknjOvEVu
	 0rg259RkddzfBdeRd7G6e31omF7oXgQzJ0BtctUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/213] spi: Dont mark message DMA mapped when no transfer in it is
Date: Thu, 13 Jun 2024 13:33:00 +0200
Message-ID: <20240613113233.089340000@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 9f788ba457b45b0ce422943fcec9fa35c4587764 ]

There is no need to set the DMA mapped flag of the message if it has
no mapped transfers. Moreover, it may give the code a chance to take
the wrong paths, i.e. to exercise DMA related APIs on unmapped data.
Make __spi_map_msg() to bail earlier on the above mentioned cases.

Fixes: 99adef310f68 ("spi: Provide core support for DMA mapping transfers")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://msgid.link/r/20240522171018.3362521-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 3bcd6f178f73b..a15545cee4d2e 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -866,6 +866,7 @@ static int __spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
 	else
 		rx_dev = ctlr->dev.parent;
 
+	ret = -ENOMSG;
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		if (!ctlr->can_dma(ctlr, msg->spi, xfer))
 			continue;
@@ -889,6 +890,9 @@ static int __spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
 			}
 		}
 	}
+	/* No transfer has been mapped, bail out with success */
+	if (ret)
+		return 0;
 
 	ctlr->cur_msg_mapped = true;
 
-- 
2.43.0



