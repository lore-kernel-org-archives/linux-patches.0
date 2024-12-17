Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179581F8EE8;
	Tue, 17 Dec 2024 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456725; cv=none; b=huoD7igsFW/BQbKtmosW9eN5597FsPDbDU8PBMUwl2BzP+IgZ5wWNzs/k7qli82D0xFnNzhlNY0nWBMPZLgU/l/xgzZF+ZS2e0bzRa2lOLirOnhJ+RzV0pYbM4VTxs/APSTmTFsQcIjxPaK3CRUxZw3m9WhTx57QJ69/3rzBYxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456725; c=relaxed/simple;
	bh=xU78/m6yYehiIphW9PDlJNV3xbqnscOs7CCAffhcFzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLXjQ+duPgZPJhC8wiiVco2reciHQldI9WPko7Y2KkPK58Ozbh0KKMYBcyvBYmbmbFaOHNFaXVgFlqIQNvfHUTCD0E1GjtkKxd+J/ut9n5kWwboyQoeDqLZaclWjrB2fvqZqe9y4LeLVAuaaLiLg2eA9+RmYVGu5cW/VVG8bMVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bai5BILm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bai5BILm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B16C4CED3;
	Tue, 17 Dec 2024 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456724;
	bh=xU78/m6yYehiIphW9PDlJNV3xbqnscOs7CCAffhcFzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bai5BILmLQFlyDUWKp8WPqr963qPD9NlBHqs5JYW+00hW7Rf11Z0shkyduOLSu8nf
	 ccH+Laa2bvcye9J0E9iL1wGOuD89S6UVXV0dEJesQZVgsadbisq84wMxwxifQSMabm
	 WSq2QlXyH3XzgHAqX0ecfDvr23OVTwT1hBKkSGAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/172] spi: aspeed: Fix an error handling path in aspeed_spi_[read|write]_user()
Date: Tue, 17 Dec 2024 18:07:45 +0100
Message-ID: <20241217170550.844947115@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c84dda3751e945a67d71cbe3af4474aad24a5794 ]

A aspeed_spi_start_user() is not balanced by a corresponding
aspeed_spi_stop_user().
Add the missing call.

Fixes: e3228ed92893 ("spi: spi-mem: Convert Aspeed SMC driver to spi-mem")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/4052aa2f9a9ea342fa6af83fa991b55ce5d5819e.1732051814.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-aspeed-smc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-aspeed-smc.c b/drivers/spi/spi-aspeed-smc.c
index bbd417c55e7f..b0e3f307b283 100644
--- a/drivers/spi/spi-aspeed-smc.c
+++ b/drivers/spi/spi-aspeed-smc.c
@@ -239,7 +239,7 @@ static ssize_t aspeed_spi_read_user(struct aspeed_spi_chip *chip,
 
 	ret = aspeed_spi_send_cmd_addr(chip, op->addr.nbytes, offset, op->cmd.opcode);
 	if (ret < 0)
-		return ret;
+		goto stop_user;
 
 	if (op->dummy.buswidth && op->dummy.nbytes) {
 		for (i = 0; i < op->dummy.nbytes / op->dummy.buswidth; i++)
@@ -249,8 +249,9 @@ static ssize_t aspeed_spi_read_user(struct aspeed_spi_chip *chip,
 	aspeed_spi_set_io_mode(chip, io_mode);
 
 	aspeed_spi_read_from_ahb(buf, chip->ahb_base, len);
+stop_user:
 	aspeed_spi_stop_user(chip);
-	return 0;
+	return ret;
 }
 
 static ssize_t aspeed_spi_write_user(struct aspeed_spi_chip *chip,
@@ -261,10 +262,11 @@ static ssize_t aspeed_spi_write_user(struct aspeed_spi_chip *chip,
 	aspeed_spi_start_user(chip);
 	ret = aspeed_spi_send_cmd_addr(chip, op->addr.nbytes, op->addr.val, op->cmd.opcode);
 	if (ret < 0)
-		return ret;
+		goto stop_user;
 	aspeed_spi_write_to_ahb(chip->ahb_base, op->data.buf.out, op->data.nbytes);
+stop_user:
 	aspeed_spi_stop_user(chip);
-	return 0;
+	return ret;
 }
 
 /* support for 1-1-1, 1-1-2 or 1-1-4 */
-- 
2.39.5



