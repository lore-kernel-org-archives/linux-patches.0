Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5595F28CF5E;
	Tue, 16 Dec 2025 11:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886303; cv=none; b=Vc4eikyupsr1iDwthMqwzZ6l+G6RxdHDDAB2/vTcSeypC+rYeni9djtCN3gyGrHriwX8l4ySyoloc/24Ltlpc7hpeq1F+YekNSyxx3+t7ZCXj7tYFGte+6AQO4ThVWL8zO3t8beTaLzqS65UD+aJe2Xgvmnl/3XvPTQS2CLM7RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886303; c=relaxed/simple;
	bh=6twb6plnL4wm62GwJ0BhnqQV+yKuZElM107XeRb2qbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMKDmaVMVU41mmX1YE6pjBdned25hEH+KHYs8CGOGLWVjEiGSniVkXFGO766obEgT+Bb9oT9sfImNCa+FVVgcqC92xz5TLEv7pB55tHSTAB0GRPjyvN3cPGRqe6gl3chtQfQ541yeeVLShtBBG8ay9SQcsEYWXw38w9Fs7ef5Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ycetp2ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ycetp2ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B34C4CEF1;
	Tue, 16 Dec 2025 11:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886303;
	bh=6twb6plnL4wm62GwJ0BhnqQV+yKuZElM107XeRb2qbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ycetp2ge0sDNtegdl8lhkY2amqdTwtlBFc5MqAHzQ0Fvs5mJXn+nNanw3SvLjo3d8
	 ifRa81UcvMfjF4EA7Uq+17viugmmwB0QeHTQAL+iTuZb668Q/F8uBFO/Ab/+zy8JJf
	 VapNEg8eJ0oBQsvq/x9CbDHgG4pIZEJXvzZn5ZY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 398/507] spi: ch341: fix out-of-bounds memory access in ch341_transfer_one
Date: Tue, 16 Dec 2025 12:13:59 +0100
Message-ID: <20251216111359.872974778@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchu Chen <flynnnchen@tencent.com>

[ Upstream commit 545d1287e40a55242f6ab68bcc1ba3b74088b1bc ]

Discovered by Atuin - Automated Vulnerability Discovery Engine.

The 'len' variable is calculated as 'min(32, trans->len + 1)',
which includes the 1-byte command header.

When copying data from 'trans->tx_buf' to 'ch341->tx_buf + 1', using 'len'
as the length is incorrect because:

1. It causes an out-of-bounds read from 'trans->tx_buf' (which has size
   'trans->len', i.e., 'len - 1' in this context).
2. It can cause an out-of-bounds write to 'ch341->tx_buf' if 'len' is
   CH341_PACKET_LENGTH (32). Writing 32 bytes to ch341->tx_buf + 1
   overflows the buffer.

Fix this by copying 'len - 1' bytes.

Fixes: 8846739f52af ("spi: add ch341a usb2spi driver")
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Link: https://patch.msgid.link/20251128160630.0f922c45ec6084a46fb57099@linux.dev
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ch341.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-ch341.c b/drivers/spi/spi-ch341.c
index 46bc208f2d050..79d2f9ab4ef03 100644
--- a/drivers/spi/spi-ch341.c
+++ b/drivers/spi/spi-ch341.c
@@ -78,7 +78,7 @@ static int ch341_transfer_one(struct spi_controller *host,
 
 	ch341->tx_buf[0] = CH341A_CMD_SPI_STREAM;
 
-	memcpy(ch341->tx_buf + 1, trans->tx_buf, len);
+	memcpy(ch341->tx_buf + 1, trans->tx_buf, len - 1);
 
 	ret = usb_bulk_msg(ch341->udev, ch341->write_pipe, ch341->tx_buf, len,
 			   NULL, CH341_DEFAULT_TIMEOUT);
-- 
2.51.0



