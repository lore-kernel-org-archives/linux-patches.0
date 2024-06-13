Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430391459FA;
	Thu, 13 Jun 2024 12:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281416; cv=none; b=fqjMDMPGIU2XKrbszeSCHumi1/NXi9+7MYoTneq0TovLJh63I9yxLZhc9wPlLvT/lUoR42jNtwVImwvBa/9G24GcIFW0pqiFLOkR0ZLajmUyImMlyd//9okxAsUR3lZAtSNUpPZlVI+SyoAqrs0qKngaR1ecUSsupoZ+wOLXZQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281416; c=relaxed/simple;
	bh=U9ezX8TGvRcvjEeSsYXdNB4NYqFB1GDlSSBOuFrvO5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMHgE0d2wq3HuK7wBm+iAOamfWnIs5qAF3WQdgQZAWOIVrFN3GHPVHb2SD2YPvpqokuI+3xVngvZi3+1cnB5xTJxPTxE8KdHCrf45j370YulFSlSA3numCJ/uvizT6ZcxpmbZiIJc8ZDQQ0Fas77S8LyCAkx8xviWVlewUdNyrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJY1E1G3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJY1E1G3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA51C2BBFC;
	Thu, 13 Jun 2024 12:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281416;
	bh=U9ezX8TGvRcvjEeSsYXdNB4NYqFB1GDlSSBOuFrvO5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJY1E1G3oArC1a82wtJoSFs4acVEXwQgc+NbXfQtJFkFYrdS/uxPXqN2mbiSKD/of
	 Gql9Kbf4oS2kAKPrdg5/6DNmxJDY2pM6i6TBGhkh66JL3qvoD5Wp0ITAql4BaMhtPJ
	 pTtRvmGRTlTtdLdeyfapvcKDP09NCTgisrMFrU0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/317] spi: Dont mark message DMA mapped when no transfer in it is
Date: Thu, 13 Jun 2024 13:34:25 +0200
Message-ID: <20240613113257.106498073@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 857a1399850c3..e84494eed1c11 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -970,6 +970,7 @@ static int __spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
 	else
 		rx_dev = ctlr->dev.parent;
 
+	ret = -ENOMSG;
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		if (!ctlr->can_dma(ctlr, msg->spi, xfer))
 			continue;
@@ -993,6 +994,9 @@ static int __spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
 			}
 		}
 	}
+	/* No transfer has been mapped, bail out with success */
+	if (ret)
+		return 0;
 
 	ctlr->cur_msg_mapped = true;
 
-- 
2.43.0



