Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E18914A4E2;
	Tue, 20 Feb 2024 21:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462875; cv=none; b=bnFnsplA4cLTXXjOSQFZyffkjl0tlQYI9EM8eglvUNvSllU63T9UvqiryWaKcjqfJmm7zgyapS8JqznWXAicJKHrEb4b61lCOqCbmsCg1FkvPIhTIGsoR+ju419mdRuga3w2pc/dbfNpy8Wk8iOSvFvx1LDszlEF8RAKiQScOxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462875; c=relaxed/simple;
	bh=4IgQ/efQt93zbuUk7vrtuVHg1FSqZKLaYAnJKDHqOC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeuMYbk8BRs5nLaJnZeBS0o/hCCtJmFYCpoNLBo7sXltCyuzOHC2QG6vC7BdCjiFp7MhksUI7ZWnA8SKMjfSlfU0jfk0mKrapPtmIB6pXlYvqAKV9/drZrvwSGZsVdhclsqMENI/bbZmLdbOn/nqdIxbhuoTR2GRVz4ss3zO2FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1il4BvNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1il4BvNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFF4C433F1;
	Tue, 20 Feb 2024 21:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462875;
	bh=4IgQ/efQt93zbuUk7vrtuVHg1FSqZKLaYAnJKDHqOC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1il4BvNrixQoOJmwinNZ3XUq6lzEcVnAb/K+2krq9n+OqtgfZJonfqQxsY8OZ4W18
	 StDHLAKYjvJRWVagTblOMnohrX2Uj2lWp0gItx1ii2DaSKRe9b/HHTAoYLmlwh4oPZ
	 xAwQMJLouzOM3fBCfCkMKbBNKmCBi8LjILgI/BIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Piotr Zakowski <piotr.zakowski@intel.com>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/197] i2c: i801: Fix block process call transactions
Date: Tue, 20 Feb 2024 21:50:23 +0100
Message-ID: <20240220204842.997511343@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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
index 3159ffbb77a2..9a4e9bf304c2 100644
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
@@ -520,6 +519,7 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 			return -EPROTO;
 
 		data->block[0] = len;
+		inb_p(SMBHSTCNT(priv));	/* reset the data buffer index */
 		for (i = 0; i < len; i++)
 			data->block[i + 1] = inb_p(SMBBLKDAT(priv));
 	}
-- 
2.43.0



