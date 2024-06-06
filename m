Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD8A19E7FF;
	Thu,  6 Jun 2024 14:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683543; cv=none; b=HIl+4nx96onm3wfr4OkIz/NUKzCXlelfwy3roUA1D2zl6AsyKzZSSx+HJVWpv+nnRhzYhlpI+YJMs6CSEwgZSuSxkA97EHtabmc5ivBXCzr9Yv2CY5cpX5lKoEIaVC6E3IvkF2M6v7ftWaV7Q6G7JV4jtIrwXiqq16H76mEs+ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683543; c=relaxed/simple;
	bh=whXzKEwc2o5sTlzPC+innY/yOdNCFO+Hpk796URxpX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mARgvxANQYwQTn8hdlARK9RyKdZwoX15yD8ozn3gOdJe7QY0XpFKmhD6GC+Cuk4VlTy3hGdLGj6p4tN1kZccNZ/Vv5kRoS54y5MCW9mXXEVZrOhmzUOUEr3Zoz+mo8ukhaARJr2/XDKowJttEfLdrbcxiCI8CWytY4klYaKNBt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5OdLkxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5OdLkxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C111C2BD10;
	Thu,  6 Jun 2024 14:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683543;
	bh=whXzKEwc2o5sTlzPC+innY/yOdNCFO+Hpk796URxpX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5OdLkxq2ecZCOohGOIeawcvV04cGd7LVOSYOswqg0chgcsvyf3pQP14Mc19uKnZ8
	 1Z+slc3DC2lwmNln7+a8F/CrhcjUSrr96O8XTN9ohqJEWAYjI1oyOYDnujC311chOc
	 ObYBJ3sxwQqxghDOi7NF8s8Vw0rTS5JyoG79ucFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 433/473] spi: Dont mark message DMA mapped when no transfer in it is
Date: Thu,  6 Jun 2024 16:06:02 +0200
Message-ID: <20240606131714.060388623@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1018feff468c9..50fe5aa450f84 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1147,6 +1147,7 @@ static int __spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
 	else
 		rx_dev = ctlr->dev.parent;
 
+	ret = -ENOMSG;
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		/* The sync is done before each transfer. */
 		unsigned long attrs = DMA_ATTR_SKIP_CPU_SYNC;
@@ -1176,6 +1177,9 @@ static int __spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
 			}
 		}
 	}
+	/* No transfer has been mapped, bail out with success */
+	if (ret)
+		return 0;
 
 	ctlr->cur_rx_dma_dev = rx_dev;
 	ctlr->cur_tx_dma_dev = tx_dev;
-- 
2.43.0



