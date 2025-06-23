Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FAA22577C;
	Mon, 23 Jun 2025 22:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717404; cv=none; b=o8A/ma4AAHAzv3eTc5FnPA7OcP7VYNYNFMUgch5IlJLMTPX298s/OolroTzb3ZsKx+iKE4lwfN5AneYgni9f7gPZSFjfNBYNeZSxEYwWBIo22moRLjW+eNv4oTAN23mIZBzWbihqgCgBNsqvLxAsv4bfLRIxCBAPIayGF6niV90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717404; c=relaxed/simple;
	bh=fxfVKLWsEf8OkA1nIuvKZvvW9Lj45jZSKkOP56qWuIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdcU0uzdT+3qjr08M+WNPUmt/gmOU+pLFtktZB1/3gzAWBsSEwpmHMKTN+PVS9c69GrCnkHydkHujHhIm1T1lasQgK/oc4/ap+Ep3a/YVC7qON+fEk9k9jhSCXMA05beMWinOtL1TUEG1u1PdI901yaKd9/nPjUNYZEoSUp9K9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQlL2Rnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQlL2Rnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E506BC4CEED;
	Mon, 23 Jun 2025 22:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717404;
	bh=fxfVKLWsEf8OkA1nIuvKZvvW9Lj45jZSKkOP56qWuIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQlL2RnqMQlVJqKXKhu8wSEo8YPxCFDsx8icSb4Iph/czv+T382g9F1jrSA+v0A9j
	 2IkgOr7z7GkmckHUwaH4xAbmFigtOvFtln/Ff9IfJ6ykLtACYaW5m9p9U2ulRF9Ylc
	 UZofSRh2PpEDLBIoH6lLX1pKg9xRGwvWUeHlTvfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 397/508] i2c: tegra: check msg length in SMBUS block read
Date: Mon, 23 Jun 2025 15:07:22 +0200
Message-ID: <20250623130655.027896004@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit a6e04f05ce0b070ab39d5775580e65c7d943da0b ]

For SMBUS block read, do not continue to read if the message length
passed from the device is '0' or greater than the maximum allowed bytes.

Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20250424053320.19211-1-akhilrajeev@nvidia.com
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-tegra.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index f7b4977d66496..b8726167cf739 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1425,6 +1425,11 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			ret = tegra_i2c_xfer_msg(i2c_dev, &msgs[i], MSG_END_CONTINUE);
 			if (ret)
 				break;
+
+			/* Validate message length before proceeding */
+			if (msgs[i].buf[0] == 0 || msgs[i].buf[0] > I2C_SMBUS_BLOCK_MAX)
+				break;
+
 			/* Set the msg length from first byte */
 			msgs[i].len += msgs[i].buf[0];
 			dev_dbg(i2c_dev->dev, "reading %d bytes\n", msgs[i].len);
-- 
2.39.5



