Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD5C143895;
	Thu, 13 Jun 2024 12:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280124; cv=none; b=lrIJroc5G8AUDjxgo6c1eduUQUY8dxLghxi0k5oeCwXocVRQSgc+Xegf19vpbnOcEizVxVRVuIH4gR1kjTQ4L5g1cyp89iNTU393ywCc+qVSfBtPNgRH4UcdipRRnPOzZffNtK8sI7i0EPUvE5cHK3U9QF7vkXCLjvFU0WXRGpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280124; c=relaxed/simple;
	bh=iqez1KOF8wrCSpJmPmIYOCwF5V0Jfr76IANTi42csxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNoUEy7IoPGxnQOFkmOJgxrrtNwnw8TS6U1/2tKPS1iimc4E5yuS/zn1ZlOPz2imDP1cJOgHOIZ01l0qY6Ufk03V63yXPwtQRSLwgZTTXKWy8olenZLey+/znXC5eLyB3auWWjWwpGAY+mHjDnLmMT44mW7ycReE8F5k05/l2d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLbAdBFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLbAdBFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3B5C2BBFC;
	Thu, 13 Jun 2024 12:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280124;
	bh=iqez1KOF8wrCSpJmPmIYOCwF5V0Jfr76IANTi42csxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLbAdBFbYrSWMWCbyHUyME1eU47BSAl1EbMGKtBbOe4R3+XhenWhlqab22yjPQmlt
	 FaCQ+z7knxpKTo2QfhyByyOThXDkgQP+UDRx2vPTVRJc4lCDrTt1/bgIT1laM0LOZf
	 ky2q13S0bNH9cLNNc+drhaFzSo5Imaz/YQIK9dA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 149/202] spi: Dont mark message DMA mapped when no transfer in it is
Date: Thu, 13 Jun 2024 13:34:07 +0200
Message-ID: <20240613113233.504462028@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b18ae50db1f52..0f9410ed48290 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -931,6 +931,7 @@ static int __spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
 	else
 		rx_dev = ctlr->dev.parent;
 
+	ret = -ENOMSG;
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		if (!ctlr->can_dma(ctlr, msg->spi, xfer))
 			continue;
@@ -954,6 +955,9 @@ static int __spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
 			}
 		}
 	}
+	/* No transfer has been mapped, bail out with success */
+	if (ret)
+		return 0;
 
 	ctlr->cur_msg_mapped = true;
 
-- 
2.43.0



