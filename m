Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521901A072D;
	Tue, 27 Aug 2024 15:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772137; cv=none; b=Sbd0FRzhMe3b+ICCTpEPIR7Vu4B9LsdQoZ7Ksi0S7iwIF+EdX47KWp7dkA4db9DpxOC70ySxgbNo5cF8C6HM7nEJ3JafcDfGEJwFesHE/v/ipVwS9V7IpAENY+Tm4SejBzbfLXpQZg5gBlVuyjCbL99ifHkQ8DKpyECIh1KpDeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772137; c=relaxed/simple;
	bh=4bycJUamGySMqe06CCdML3ORkIyJbxoPKa5BQNTpQdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUcYUqjS0bzOxQ7Al/a6gSW6j2i2c6ilsyNI7Q/WiY1RrXpSB55DgOz+8NjHfvpZNTWdQQR1B/w/fJgpZPyKZi4UmW8X91LKhu5EDpdmMl9XBIKWQnMSn0f3Ruv/ahkweugf/AbVjxavfvspOpNZ1nm1h/W/FjCKgFyZNY1eG5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0xvuaH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0xvuaH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC830C4FE08;
	Tue, 27 Aug 2024 15:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772137;
	bh=4bycJUamGySMqe06CCdML3ORkIyJbxoPKa5BQNTpQdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0xvuaH0b/dNMmFQ0m2hhW+b9pBRAykBO6eRVQ4r6MyklUJjknR7vpvjSX/E1VdLk
	 USJwd3W1dfrAJECWdu/VWmgfr/9qvwOD0nAo6r4sazY+iE17obXJ9wqgGooQ6xJ89j
	 gVycgiPLfSkGVPIElN4E4k42VlTZWG+A8a+yFBsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/321] i3c: mipi-i3c-hci: Do not unmap region not mapped for transfer
Date: Tue, 27 Aug 2024 16:37:12 +0200
Message-ID: <20240827143842.964490784@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit b8806e0c939f168237593af0056c309bf31022b0 ]

Fix following warning (with CONFIG_DMA_API_DEBUG) which happens with a
transfer without a data buffer.

	DMA-API: i3c mipi-i3c-hci.0: device driver tries to free DMA memory it has not allocated [device address=0x0000000000000000] [size=0 bytes]

For those transfers the hci_dma_queue_xfer() doesn't create a mapping and
the DMA address pointer xfer->data_dma is not set.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20230921055704.1087277-10-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index a28ff177022ce..337c95d43f3f6 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -345,6 +345,8 @@ static void hci_dma_unmap_xfer(struct i3c_hci *hci,
 
 	for (i = 0; i < n; i++) {
 		xfer = xfer_list + i;
+		if (!xfer->data)
+			continue;
 		dma_unmap_single(&hci->master.dev,
 				 xfer->data_dma, xfer->data_len,
 				 xfer->rnw ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
-- 
2.43.0



