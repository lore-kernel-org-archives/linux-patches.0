Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4751419AD92;
	Thu,  6 Jun 2024 14:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683048; cv=none; b=dgKNCJO8z601yInBUMp2jZF6oU+gBS14gyII0B41k2mghyzMGFSdp0YOkl8NJAefHiNrpxAry1vFma6w30CNCdsBIPrMUPc9MI9EEiGHpnNMscBgOLM3z1tmUGAVN11kkN/0FvU9nMl85Y9wgFjDNBOLRnFIcj4yNZdCm0Fao7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683048; c=relaxed/simple;
	bh=HPqJ9b9+jsE+fDR7D6xFZPCprs2Lb/R+CAelJPYCfcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6p1vknLWD6lRoUTpNXvd9nWmzAdHTx5eT8Pd1+g7Te6z6IxtG2i2fC6fhQHy8jCKKJn/RcrL5Rkp3sgyGDW9gwFHNlgyTzjnrxI+r1UQiCinQgAHJNWSYGfgtcOLCQDdSycL+2CVceXmxSbAnXYZLY0GXhE4HzPbNVKyT8OzNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKz/4ZiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKz/4ZiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF32C32786;
	Thu,  6 Jun 2024 14:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683048;
	bh=HPqJ9b9+jsE+fDR7D6xFZPCprs2Lb/R+CAelJPYCfcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKz/4ZiILMWlIAfMBnMQ6vt8J7qcooYar7PZNKTLhqyZOXnR7BSNcZJJ08+GJMYOY
	 BhOj0e82o+P6aGCOaFfFo7pO9ZzCtvRjVOb6oRkmGpbBI+IABRnnaktXmiHCkZQsf5
	 0SVzUR/pd32op3vxeBGbsZa2FI7N+PNFvNmmlVbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 286/374] spi: Dont mark message DMA mapped when no transfer in it is
Date: Thu,  6 Jun 2024 16:04:25 +0200
Message-ID: <20240606131701.471073232@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index a2c467d9e92f5..2cea7aeb10f95 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1242,6 +1242,7 @@ static int __spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
 	else
 		rx_dev = ctlr->dev.parent;
 
+	ret = -ENOMSG;
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		/* The sync is done before each transfer. */
 		unsigned long attrs = DMA_ATTR_SKIP_CPU_SYNC;
@@ -1271,6 +1272,9 @@ static int __spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
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



