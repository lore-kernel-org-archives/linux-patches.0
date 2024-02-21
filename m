Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF13B4D5B7;
	Wed, 21 Feb 2024 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523229; cv=none; b=rBhjUK+ifPqxpE4CfmTV5JOiHR1p5G/ccbpbhjvatwJyO2eNknt6x4TV/m9OrDzyNtTb6dpeLwzx5KB6hfs/rtqNZHEhDQNdHFT5cNoFN2ss89Pn5ChN59Gh+9jMOFQdX5+QMrtoaek/Y/Z7Eplu9ofXHK1Jto4HVt4MGI5bD2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523229; c=relaxed/simple;
	bh=phkmQbiJ7rSiVv/9/cG9pgqSdj5eLxXkAFuntwOAo+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amnviw38NBpV+pPwZApMnUAhcKx97inHbmWN86AnyyYPXddD6yYCpZQhHcbthSXQ1O8kSQHxqMyD/5QzWPpi5CjZ3IoJ+Rsc3RPp08tHYEY/WlxyfzDeR7sM5+bhFYVdLZ9Mq6IswxZtaiMx3nyGLI3aT5yEjAk+BH4Ofq1GrJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v47rjpcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v47rjpcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D29C433C7;
	Wed, 21 Feb 2024 13:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523228;
	bh=phkmQbiJ7rSiVv/9/cG9pgqSdj5eLxXkAFuntwOAo+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v47rjpccRUqoL3hCseJqEzpzYU0m4V2x3JQ0pJ6AdVv4QSJQAe9n1QS42KugsQuPT
	 wFv3My6fVEPpgDiwCAGav7YIaHsgjseesGD6GaXGNDdgBNM3GsdFt2ybqfnnbNncXD
	 DlmToFzE+NY91xXwCjoxcQQtrh7mirQTGbv5AE0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Piotr Zakowski <piotr.zakowski@intel.com>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 373/476] i2c: i801: Fix block process call transactions
Date: Wed, 21 Feb 2024 14:07:04 +0100
Message-ID: <20240221130021.819058122@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
index 8ecba1ca9236..87c2c7c84736 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -522,11 +522,10 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
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
@@ -542,6 +541,7 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 			return -EPROTO;
 
 		data->block[0] = len;
+		inb_p(SMBHSTCNT(priv));	/* reset the data buffer index */
 		for (i = 0; i < len; i++)
 			data->block[i + 1] = inb_p(SMBBLKDAT(priv));
 	}
-- 
2.43.0



