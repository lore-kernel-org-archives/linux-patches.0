Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACB83CF42;
	Wed, 21 Feb 2024 14:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524785; cv=none; b=fdrg/R8jlixg6C1AU+R5fohI9yfJtG1muZ3GOibGkCF2ndlYtZ7mQIWHu2+1tEXIpUeL8vfXJiUBSlYInnnLSIWoHfHQQyKmJRyif2oAMRk6p3T05UCd2yA0AxtjrdK0kb2bdXH/OO9laxsgGnb+9eBBZMFW47ZZQz0VjfDw5ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524785; c=relaxed/simple;
	bh=HfdF/b1L00uBkVyyVhzIFPhi1QxsdN5n120po4MUvwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgWaP8ePRk/pRydg9fDX5ITAv4od67QCTBcraeg98gRpyio7Fq5sFBZ0sQkDqMjLpAth+0msaTgjdQuDFoa5NdG6LaVIVJNUTODjRaQ3n5tJS4G03/0KI2WJwCBTw6zOTTJtQgw/zv+QvAZ5GXlUfsovcEYmogNs55wV9IuzjT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSEqs6t/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSEqs6t/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CC6C433F1;
	Wed, 21 Feb 2024 14:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524785;
	bh=HfdF/b1L00uBkVyyVhzIFPhi1QxsdN5n120po4MUvwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSEqs6t/BSHihC6OFFVs5b/CSFjUQ3SfWFjFbfRP80DcR4lBMBRNlWGt6D1u7hiQ9
	 NCFyJ8gEEGrvHd5xFJe7hifIL1RSOYYFWt1r7LgicaLbpxouUyfn3im8yaMC3HSnZE
	 yi5aDjxP8om5B5sksfd2llymVRUSktZ8ripk9JwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Piotr Zakowski <piotr.zakowski@intel.com>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 309/379] i2c: i801: Fix block process call transactions
Date: Wed, 21 Feb 2024 14:08:08 +0100
Message-ID: <20240221130004.068146212@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit c1c9d0f6f7f1dbf29db996bd8e166242843a5f21 ]

According to the Intel datasheets, software must reset the block
buffer index twice for block process call transactions: once before
writing the outgoing data to the buffer, and once again before
reading the incoming data from the buffer.

The driver is currently missing the second reset, causing the wrong
portion of the block buffer to be read.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Reported-by: Piotr Zakowski <piotr.zakowski@intel.com>
Closes: https://lore.kernel.org/linux-i2c/20240213120553.7b0ab120@endymion.delvare/
Fixes: 315cd67c9453 ("i2c: i801: Add Block Write-Block Read Process Call support")
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 15520d491140..d6b945f5b887 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -543,11 +543,10 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 	/* Set block buffer mode */
 	outb_p(inb_p(SMBAUXCTL(priv)) | SMBAUXCTL_E32B, SMBAUXCTL(priv));
 
-	inb_p(SMBHSTCNT(priv)); /* reset the data buffer index */
-
 	if (read_write == I2C_SMBUS_WRITE) {
 		len = data->block[0];
 		outb_p(len, SMBHSTDAT0(priv));
+		inb_p(SMBHSTCNT(priv));	/* reset the data buffer index */
 		for (i = 0; i < len; i++)
 			outb_p(data->block[i+1], SMBBLKDAT(priv));
 	}
@@ -563,6 +562,7 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 			return -EPROTO;
 
 		data->block[0] = len;
+		inb_p(SMBHSTCNT(priv));	/* reset the data buffer index */
 		for (i = 0; i < len; i++)
 			data->block[i + 1] = inb_p(SMBBLKDAT(priv));
 	}
-- 
2.43.0



