Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831F72236FA;
	Mon, 23 Jun 2025 21:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714570; cv=none; b=r9urBJQ+PTLcY8mzwhqzaW0k6bjtr1VzzH2tarxACNadYCfillxdu51zHv7kpMY9diY2p0QJ5Cp1hZcogTy+DM4dzv7i/KDypgLXekWy/XiiePxyGG8cZNzibUcd5+T6KkQONrdNgCJ9QncJLhM5d5jGWzoxUdycHert2Y41vhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714570; c=relaxed/simple;
	bh=B4firUipvnfULHElf7u1LRZUjlBIF+CXd7KNmujRmP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pebQSi1NVCEa4S1XyoFAXPdQMpKPuJzWzw3nFyNTW5kb4HVacTWyX9YC+Vagg2eRfu7u6zn8mabO+Ml992hX14z5iRXy87sRjj5o5nMlfP+N+2fQ7cJQAIwP2+xb8ZI5LfTF4f1p0D+W/O4ySL1Pk+EPVa7DW9mhLkFMPUcYWFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhLvsd5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhLvsd5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4D5C4CEED;
	Mon, 23 Jun 2025 21:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714570;
	bh=B4firUipvnfULHElf7u1LRZUjlBIF+CXd7KNmujRmP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhLvsd5WZpjOHlqQqe4myTEGYuawucmoS/G763BH83uvopVVHaZwODEvVBxw1wJx1
	 00TWG2897s6RRuu1RkAonhsdnSFVT8ujUnYHJN6151iubu3PidnxrtJdrL8M5rAzzy
	 c+7yqHCoUlT/Lj5KB3je3MwXU4jjab7EpetufcHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/290] i2c: tegra: check msg length in SMBUS block read
Date: Mon, 23 Jun 2025 15:06:46 +0200
Message-ID: <20250623130631.258318249@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 91be04b534fe6..08a81daedc115 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1397,6 +1397,11 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
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



