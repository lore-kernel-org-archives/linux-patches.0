Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E7E3939B3;
	Sat, 12 Sep 2026 19:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239889; cv=none; b=GRIXHDNKyMWhlk+iEg7579NfsrQCoNvhufO4m31oOcxaK4vCP1/o7694F6H+9nQNZ1Qf5IlYx3tGxIy5Hw+J3oNV/X7LD1un7pvROQGS3UPpAwU8LkoaDxJ9nX6jXbjB8reZcd39JREs6HbyqEQrdUpgVr2JpNy3LFsDt+l/L+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239889; c=relaxed/simple;
	bh=Yag8wxP7jp9qrjOcEUW9E7Ki4UpYxrkpkHmwGZNNBlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pmo2qmcDUUQoWcXRpk4PWIx7wBwNwPmJbXzy3glj8xrW6bmTUoCbM7mHCH3xxdKzhpHYqs8ZTLQHi8ktttY5oaFh9Sf20bT2MKkjGSwJrJy3zmbL/tY7GCMgAaMxF0uG6kkUm0SSofIMmBmYxHsyzgdo+59arIS2wfFCzKI6gJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hncpAvFV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hncpAvFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F2A1F000FF;
	Sat, 12 Sep 2026 19:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239887;
	bh=3MDXsNnBnNyf9NXU2zSs5rF+kYy9O48fWtKz4o9aIUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hncpAvFVKd6N9ZiqDIhqK3NWEUzBpBgzGoWI9vp0vqMUT2n4893N+LtcvIp+74wic
	 Q4rN6lMV0b0ccdJq447DP8N9B835m2rPKzC2VwAYDor5fL/wvdZ+Ww9orwOBQXndM+
	 iGzt/RumiaGWV58kd0mIMXzoKqIr7XBUTvcwkNoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 755/935] iio: light: gp2ap002: re-enable irq if runtime suspend fails
Date: Sat, 12 Sep 2026 09:03:05 +0200
Message-ID: <20260912065544.149066760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Nikhil Gautam <nikhilgtr@gmail.com>

[ Upstream commit 5d89e7cbac40057f5241a0832a86ce0fe97e4818 ]

gp2ap002_runtime_suspend() disables the irq before writing OPMOD. If
the write fails, the callback returns an error with the irq still
disabled while the PM core marks the device active again.

re-enable the irq before returning the error so the irq state matches
the active state the PM core restores.

Fixes: 97d642e23037c ("iio: light: Add a driver for Sharp GP2AP002x00F")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/gp2ap002.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/light/gp2ap002.c b/drivers/iio/light/gp2ap002.c
index 430edce1057e2..b3a290011110c 100644
--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -658,6 +658,7 @@ static int __maybe_unused gp2ap002_runtime_suspend(struct device *dev)
 	/* Disable chip and IRQ, everything off */
 	ret = regmap_write(gp2ap002->map, GP2AP002_OPMOD, 0x00);
 	if (ret) {
+		enable_irq(gp2ap002->irq);
 		dev_err(gp2ap002->dev, "error setting up operation mode\n");
 		return ret;
 	}
-- 
2.53.0



