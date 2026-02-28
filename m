Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEC63451A7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301778; cv=none; b=FtMEhYr2NqQhuweXXxNVDdtwTzMQGhwDKpc8T6r005WgzIi9G0aqN5pBKXOVQxxQtH57+1H5SZLP586+aDQ9byGhl/P0tO6C3UdmQaGGntqgSGmuNx6L8gXayd4c32AXYfuk2tNAvCeKAgApapyLRM0ci6qz5CSr0tYkHkItF6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301778; c=relaxed/simple;
	bh=yjCtKJ2DQfdkjV2oKIQbcVTMcZ1x018/79RnLk7hZOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7icdDwlOa/vANb3DKbXYdFKRo/3W1Uomu8L6dsOThvWkj8mjzg9dMcqxsiaDUF+HzDBy7Ev1reQxg/BF1UINQ6h8HK22dPYNIsQNCAAiBFXGh3k768wsa9w27zFuyDz9DKamRYCdug3Nsz/1sChvx6Nx9GwwrhP2GcDroe7IXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yf7X8E61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yf7X8E61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A38BC116D0;
	Sat, 28 Feb 2026 18:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301778;
	bh=yjCtKJ2DQfdkjV2oKIQbcVTMcZ1x018/79RnLk7hZOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yf7X8E61vdyeZNrKBkv4YQSJ5XlkRDUCdDEbEIEVcQCwSA3rxoKdIc87z7o8abW1p
	 VeB75en89eBthmkZQQxCxBLlRhcD2Uct9aQEdj9O6PD/34qzJAp8P8N2UuzW+D3Rmn
	 hfkHS2u0f6I7x/jLgBzK5KKEfeBKnBQDY0H6hL8BlAzm20oEf7d+644xa7hTrwsFAa
	 qQ+BRgvM+rU+oXYBhd5W6znxXok7wgrI+tcRb8fAFbeXCEEoGKAnoLMZqSqq3TzHT5
	 QK8KPdSiHu+tLS+wtUG9YVaXyhKthH9s7x7aVgARFZ1eX0jtCleJYdP2xAJx6l7OL/
	 RyRdLzeyMBkrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/385] mctp i2c: initialise event handler read bytes
Date: Sat, 28 Feb 2026 12:56:49 -0500
Message-ID: <20260228180011.1568201-187-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 2a14e91b6d76639dac70ea170f4384c1ee3cb48d ]

Set a 0xff value for i2c reads of an mctp-i2c device. Otherwise reads
will return "val" from the i2c bus driver. For i2c-aspeed and
i2c-npcm7xx that is a stack uninitialised u8.

Tested with "i2ctransfer -y 1 r10@0x34" where 0x34 is a mctp-i2c
instance, now it returns all 0xff.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://patch.msgid.link/20260113-mctp-read-fix-v1-1-70c4b59c741c@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 8a30d0559d60d..617333343ca00 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -244,7 +244,10 @@ static int mctp_i2c_slave_cb(struct i2c_client *client,
 
 	switch (event) {
 	case I2C_SLAVE_READ_REQUESTED:
+	case I2C_SLAVE_READ_PROCESSED:
+		/* MCTP I2C transport only uses writes */
 		midev->rx_pos = 0;
+		*val = 0xff;
 		break;
 	case I2C_SLAVE_WRITE_RECEIVED:
 		if (midev->rx_pos < MCTP_I2C_BUFSZ) {
-- 
2.51.0

