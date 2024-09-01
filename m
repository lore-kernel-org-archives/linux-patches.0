Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0527F1E87B;
	Sun,  1 Sep 2024 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209977; cv=none; b=l6HHQ/Dksh2UrkALe6yUgwikyFjdibMNVxmeXa4+lMr6fOIvuF7Tp295jnXvUkkSwIhWZPio7AScSG0IsFoCW1afPMNYTkA6UNeYrC8VbbKtRunj0rbSiWhsbBhkz7JWauVtXvp38iyyjyLLv36siEtR5atT63+fL/PF2LbmXzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209977; c=relaxed/simple;
	bh=MUBygpJZHA0gg/F3FRXNKGYdgj+0CB8gnP0agb9l8tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDSv/Mg+07xgEQDyNwxRCnI8zsZV+69FRNs19bjAJZ+2eRleZPzXQIj15bKW6Kj2FkVwk7gFmSrOAaQrzs25+qM7muvGHtEBodduOwb+rdyPxiMRCDwNQpcnxuQoAKJ3Fr4MWq7T9clzRFJvyz/MZExps7FboHuTJ+kbF4eOp+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlbCz6im; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlbCz6im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6741FC4CEC3;
	Sun,  1 Sep 2024 16:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209976;
	bh=MUBygpJZHA0gg/F3FRXNKGYdgj+0CB8gnP0agb9l8tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wlbCz6im2BO3Epo7nZ+MJZlMZiYy/4zOmmCL4w+4Hk8/CGJro0NjAuC9sv0uWkJMY
	 X0gn8HHbhrkgRWarvHPtxs9L89R52Ub3BHs6+m2a/VU6IvtvKmN1ECE24x7BmTtitu
	 VSTj57QiGkFlh3DnECEYyvOhVrn6Epz5skSTAMts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/215] i3c: mipi-i3c-hci: Do not unmap region not mapped for transfer
Date: Sun,  1 Sep 2024 18:16:03 +0200
Message-ID: <20240901160825.282156361@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7ad2edd479157..5e3f0ee1cfd0e 100644
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



