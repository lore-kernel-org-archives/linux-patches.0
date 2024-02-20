Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA8414AD0F;
	Tue, 20 Feb 2024 21:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464715; cv=none; b=hozcTzW9IUrRuXgEB8gHSURz1l7w/rImaInNhijGN7w/Twsj7+p09v0vRDf2rO2HoeZd3uXOzc0/tTNKZNEqDTiyUC/laBcMUAf3zq0LjG39fXM/yZC/oiloKzjn0zEAeTmVp33OOozc5QdeamUJX+cDTmQxyf1C8fvmtlqGZe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464715; c=relaxed/simple;
	bh=05rDaWPbkhJ1OPnViRast9VU/pnkoXttk46gdWDgBUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBN8j6eMgxqMHmrtW4PA1gRyABbU6Ulyc+yXh/p2M+ZG9j7gH4Cd0E+r2JJGgONf+a+y8Tn9j6U5eua1PVaP9TVzhoQ9cXFTkT2Ry7k57qmXx7clzn6H69pXzG6kEfZvyLvN1ezAH9e8zrMKoAw1VBTIchHiGGJmQJCGRIJBusA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kr/yN4B/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kr/yN4B/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DF5C433F1;
	Tue, 20 Feb 2024 21:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464714;
	bh=05rDaWPbkhJ1OPnViRast9VU/pnkoXttk46gdWDgBUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kr/yN4B/aUn3tWU/kIlaRD+vJ5kujIoWRs2GMfhF8bIn07FmFHxuO+Bxq4E9ugCnG
	 vPOiznO9r72I9sa2uHx9BWdEgBPK+SmI8/oXzJn2n+LwgikVbzulW32D9ZBAY1O21M
	 Zk+3V5MXmpE14VbNZdUwukj9LJDaTci5hOloOwRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Piotr Zakowski <piotr.zakowski@intel.com>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 113/309] i2c: i801: Fix block process call transactions
Date: Tue, 20 Feb 2024 21:54:32 +0100
Message-ID: <20240220205636.725779095@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 070999139c6d..6a5a93cf4ecc 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -498,11 +498,10 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
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
@@ -520,6 +519,7 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 		}
 
 		data->block[0] = len;
+		inb_p(SMBHSTCNT(priv));	/* reset the data buffer index */
 		for (i = 0; i < len; i++)
 			data->block[i + 1] = inb_p(SMBBLKDAT(priv));
 	}
-- 
2.43.0



