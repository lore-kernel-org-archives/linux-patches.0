Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCE9151CC8;
	Tue, 20 Feb 2024 21:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463625; cv=none; b=NWGMRz4lY8M99dBNFbU5W+n/vPdfaOrp3Xp9V5y04CzjUQPWpXGKSL6AFryd32bAkkc44ZBhR6iDuRetzbjQfzOr7bYv6Aaf8od0yFAAB61P/RLWNSzJ5bJ/CqxEUceJLwWJa2f0lwjCivfvK5Px+jqf8LRl0AeMWQ96Bjqsltk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463625; c=relaxed/simple;
	bh=tQhdOadVr7txc8VFZeBIy/dBggt3IZ/F5G1hzBlav0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRPiqNAoJk1MFpDkKkxCTYjo+ItZVPVeQ8sazHYOH3cWyWukcSiHr2MJv/p4GNxo5JPIDY5NRiXpWpxLzROFNKYrYzkYeiqGfvgaOMrFv4aqMZgvbu8kXGPvIP7zSA8nl4my/1dn6I/Zrwh2pKqVku1aNoU+BwdZUpK1lIiv+Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxTycj91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxTycj91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3798C433F1;
	Tue, 20 Feb 2024 21:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463624;
	bh=tQhdOadVr7txc8VFZeBIy/dBggt3IZ/F5G1hzBlav0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxTycj91bQqoW7r9MvgNdsVxwb6a9yHku/ZpdWdbOvOoBI8K9Syz5A1BvmIAKISGm
	 fY7TeEjDsWafVOLjYpwCM3Vk9IGc9c2xwwgoie6H2PyJBV5sUG5ni19tKgERus2jIV
	 CP4J8QAal7fdo3GwiA47+Yzbql2/m5i927jTUQUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Piotr Zakowski <piotr.zakowski@intel.com>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/331] i2c: i801: Fix block process call transactions
Date: Tue, 20 Feb 2024 21:53:38 +0100
Message-ID: <20240220205640.796969873@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a87e3c15e5fc..f1c82b2016f3 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -500,11 +500,10 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
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
@@ -522,6 +521,7 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 		}
 
 		data->block[0] = len;
+		inb_p(SMBHSTCNT(priv));	/* reset the data buffer index */
 		for (i = 0; i < len; i++)
 			data->block[i + 1] = inb_p(SMBBLKDAT(priv));
 	}
-- 
2.43.0



