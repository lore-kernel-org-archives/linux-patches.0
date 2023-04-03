Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27BE5683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A27C433D2;
	Mon,  3 Apr 2023 14:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531147;
	bh=4GCkObMrr4oLaY37tc06JFmZC2v0RJotv/GIFtSHgd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqsUkp44PxCAZcwXMu3pZdiV4YGzxYHb/tzwndvx0Dwsc612ffAM195rBmIosg90V
	 Fpyl0NFsI6O/18sFOV+sYrVep3XsIR7GPDBde5bAFRyB71W7CDoCr+e3pV6VBbIeDB
	 /Asl3ExMTheJPagsUOCoVSNQOL7VTN9AjgGq5IeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Chen <harperchen1110@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 4.14 37/66] i2c: xgene-slimpro: Fix out-of-bounds bug in xgene_slimpro_i2c_xfer()
Date: Mon,  3 Apr 2023 16:08:45 +0200
Message-Id: <20230403140353.186808032@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Chen <harperchen1110@gmail.com>

commit 92fbb6d1296f81f41f65effd7f5f8c0f74943d15 upstream.

The data->block[0] variable comes from user and is a number between
0-255. Without proper check, the variable may be very large to cause
an out-of-bounds when performing memcpy in slimpro_i2c_blkwr.

Fix this bug by checking the value of writelen.

Fixes: f6505fbabc42 ("i2c: add SLIMpro I2C device driver on APM X-Gene platform")
Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-xgene-slimpro.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/i2c/busses/i2c-xgene-slimpro.c
+++ b/drivers/i2c/busses/i2c-xgene-slimpro.c
@@ -316,6 +316,9 @@ static int slimpro_i2c_blkwr(struct slim
 	u32 msg[3];
 	int rc;
 
+	if (writelen > I2C_SMBUS_BLOCK_MAX)
+		return -EINVAL;
+
 	memcpy(ctx->dma_buffer, data, writelen);
 	paddr = dma_map_single(ctx->dev, ctx->dma_buffer, writelen,
 			       DMA_TO_DEVICE);


