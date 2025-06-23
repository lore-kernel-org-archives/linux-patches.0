Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB372628C;
	Mon, 23 Jun 2025 21:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713528; cv=none; b=LvjazGiMGu48t/2YhwPTV74V34li/fbI1aaEiJQiJFKe1xIg/w8aiktdcnG6yIQxRpy4psMpxo4Pp6KtvHqS1wdJPLB1VqC354JvDRxgHZtNqX1swC8lgeM3/zImoxn/1QBh7r/LkQ3fg/LOSMWTu5Pfm8CzNMZ01XgurgiM2KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713528; c=relaxed/simple;
	bh=1vEo3528gqoYA2sXidg9QHflznVKys2GO4/3v7zVFdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQRz2Au8cFR1W7p/F548xfVI8jmWXeREo5krLU4RHuTUk/XLN+wOsgrJl7doGsfUTTF7CQh104Smp3VduSQx2KxKlZDFCII4UsqYnSUIPDfI3OdRDMxV3naLF/8u5ns4j908BG0BUDluRo2c2uz4MIlBy1W8Qn32Yh+32L59C0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsxgK1gO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsxgK1gO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669DFC4CEEA;
	Mon, 23 Jun 2025 21:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713528;
	bh=1vEo3528gqoYA2sXidg9QHflznVKys2GO4/3v7zVFdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsxgK1gOgeVC3Mf6GXdxgPfMbSAQHyxwy/WYM9hdTzbPZPk901UjnuVe36GVJcqWJ
	 M62hfRuPcxriiWjG9Z4E1pSMpVtdgMzT9kqqi07Y/Mh7gSE5Wehm5rSklXp4uMzDKw
	 NHZCa6eABhQqZTz85in4loWhf+1/dC3eTf/nlfis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 332/592] i2c: tegra: check msg length in SMBUS block read
Date: Mon, 23 Jun 2025 15:04:50 +0200
Message-ID: <20250623130708.352836415@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 87976e99e6d00..049b4d154c233 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1395,6 +1395,11 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
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



