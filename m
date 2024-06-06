Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B921C95D3;
	Thu,  6 Jun 2024 14:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683727; cv=none; b=mcZ/ZTf+1GkC7vh0TEo/zpZjJDxAsfZAkaPoaAyW2gV0Zev69SI2X0pGE0R4XhR+luOFf8+kE6Re7ApGu7Iz2rUGzBuYrPVqb10NUjF7ei0ZEQPXvVgDrdjkgHWRkxvRyVWahQhchKozHh5cVpTji6UunsgxTcyfW0X0WveAZuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683727; c=relaxed/simple;
	bh=eMpnVSxVIZ594OS0VZJsSYouvSFuf84YAcr+HgZhq08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzJLcacUGE7WXpiWfCcQPgZ4xSrNP+bulNI4E7A/WagQ7kLasvnYf9Mf8nbOr7spyMhujSResNvIipeN08Eoyn2xeN21lQVhtNXDl4XO9ChX1LmheUvaHmfSHk2UlycfbbK5UuwDZY2AZCPCMg1kv4RlNQVQw7EwQrHMlQJTThM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWwQ7amU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWwQ7amU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45076C32781;
	Thu,  6 Jun 2024 14:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683727;
	bh=eMpnVSxVIZ594OS0VZJsSYouvSFuf84YAcr+HgZhq08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWwQ7amU0FSWVhac3jYUWUMqW7PxEWXEMmvnyqeIgze/LQQ8kVNtLVYI5c+AyUhZU
	 rC3+A/v8GuYJlLqap5stQ1RqryUEpKESpFkkJI32ePEhs2DGmRZ+dcB6hrZRPLFG2J
	 C+c7SBKh6bCBGqUOd5NceFnS6PZSqF7L/Y6zj+c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 675/744] spi: Dont mark message DMA mapped when no transfer in it is
Date: Thu,  6 Jun 2024 16:05:47 +0200
Message-ID: <20240606131754.141420699@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 76383ddbd6a6f..da15c3f388d1f 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1128,6 +1128,7 @@ static int __spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
 	else
 		rx_dev = ctlr->dev.parent;
 
+	ret = -ENOMSG;
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		/* The sync is done before each transfer. */
 		unsigned long attrs = DMA_ATTR_SKIP_CPU_SYNC;
@@ -1157,6 +1158,9 @@ static int __spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
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



