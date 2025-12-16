Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D63734106A;
	Tue, 16 Dec 2025 12:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888427; cv=none; b=RkqsBffeBEAaD/vTaLAAO0wN3sTElt3xuQqG+IQjm/4Qe6ax8MQZCSZjAp8JYsxUDXguc4LOoEziK8AfiuCMfNYFSM4prw8uKWZGAmcRVQ3rhRJ9N9q9SIon+HRX0Lt/ZAqAunXCIQieGT5BgJcJLR4GJJueVOiu40hEIwXiZng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888427; c=relaxed/simple;
	bh=Xci+LabOWJqUSEH9M4qdoPtaDe3Hl0emJE8NgWarRAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLDuse3kujLWAZyu8NzNC1gf/UaR2Xxki9+3doe4wOa4Ucn6bTURxT02v5ziBANC4eUDr1Jy4Q/dYe7oHwQTJpvuiU2bi+JLjvYMDXmt9jerEQkrMTea57AXapT98bJ5n9eJFUMGsN9dyor1UJU+rrd7CA5N66XilaEueQfeEyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CN6rh2BM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CN6rh2BM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B305C4CEF1;
	Tue, 16 Dec 2025 12:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888427;
	bh=Xci+LabOWJqUSEH9M4qdoPtaDe3Hl0emJE8NgWarRAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CN6rh2BM8J7pJlUqIFOTabtFpDxck87h8/Df5PgJfZl2TJvvOI5Yxwq/M6ozTWOuF
	 3D1qnEV3uIk1ca+Y1OqYVngjdOrz+jcLpeHfWntjWJaTTzKFmdGaKcHD83ik/BRi9j
	 fjwdk37R4/9M5JQug8KOHxRbKwjtzU/AkNE7z7fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 488/614] spi: ch341: fix out-of-bounds memory access in ch341_transfer_one
Date: Tue, 16 Dec 2025 12:14:15 +0100
Message-ID: <20251216111419.050852685@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



