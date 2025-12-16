Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0159E33BBC8;
	Tue, 16 Dec 2025 11:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884693; cv=none; b=X0Ib15X5kmeXOxeqzfFaBez3SHx6PNqpE2puHOCB9dIZV4etfWcROvx1zS2qVJug6LLKPvvoXmW0sSu/rrrNBlamFBPURzAhyT9fT+AX88SXGXVu8JhXkfc9D7PK/dqXutIGoGkkP/f9/nooILTTUhIfNRIUITZod5KjXkDzLFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884693; c=relaxed/simple;
	bh=yiKdaCVs/vHCw8yQiEa9EBHf1t9hc9rCINXzEMWFwYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIAM9+AdJOsb4O7V1pQoqBpY5Hq0iDOn/uCTvarYfI8Xda8QuDzbqWZm9hPb7jpZ/VGWMYjirxLDY9G6g8/CBppUoeoD36n6Mx1XO0mzIIBK525LMUDUIXiFCZqMNH4TQFloGsuEKY7PTyRVtDV+ZVqnXVx3IYmcfmFHVG/zD3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DkqteNmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DkqteNmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68145C4CEF1;
	Tue, 16 Dec 2025 11:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884692;
	bh=yiKdaCVs/vHCw8yQiEa9EBHf1t9hc9rCINXzEMWFwYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DkqteNmxZdiKDRKrZBq5eXDJNkYhqZ4mZgZq8Hdo6e6RVXaeC4mtGApuAPJf9gVvc
	 lF8S2ZE0mlfvTWGrwPs7Iq4314Xu+DDsmAlfolMeWPGY0MQ1zLS0fD4uMf7SH24HXs
	 Pv62+uGJSJ08C8L180cnjm7cV9bacwiE76mlR/pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 270/354] spi: ch341: fix out-of-bounds memory access in ch341_transfer_one
Date: Tue, 16 Dec 2025 12:13:57 +0100
Message-ID: <20251216111330.698234149@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d2351812d310d..0db74e95552f9 100644
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



