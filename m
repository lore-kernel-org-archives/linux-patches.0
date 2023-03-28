Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BD58BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E34C433EF;
	Tue, 28 Mar 2023 15:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015920;
	bh=Tn9J1rkF8CqebWI3HPjC16L/ibAVABXU/64SeSXTrBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObHa2NMG5i4BL8aLIK/LjOHL0R8ibYiC3RDolXB/P2u5cU95Lvr9dsHuX8JW5u9Cj
	 N04M0JJOXZa3QOlqEuHgkwjVAp+kxCEeM+HOHyhvy3fsYH5hxN4WoebKjAsYMm2eNK
	 rg8VdT5gm6VCEHrRwA0QZWhyupYzgiOFukScBh7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Chen <harperchen1110@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.1 215/224] i2c: xgene-slimpro: Fix out-of-bounds bug in xgene_slimpro_i2c_xfer()
Date: Tue, 28 Mar 2023 16:43:31 +0200
Message-Id: <20230328142626.293592911@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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
@@ -308,6 +308,9 @@ static int slimpro_i2c_blkwr(struct slim
 	u32 msg[3];
 	int rc;
 
+	if (writelen > I2C_SMBUS_BLOCK_MAX)
+		return -EINVAL;
+
 	memcpy(ctx->dma_buffer, data, writelen);
 	paddr = dma_map_single(ctx->dev, ctx->dma_buffer, writelen,
 			       DMA_TO_DEVICE);


