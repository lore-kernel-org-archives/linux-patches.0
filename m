Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B8A4BEE5E;
	Sat, 12 Sep 2026 14:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225130; cv=none; b=HOQ+z1QRGY9kqMpIiRaVj+WfFlSCmyf3v0pFF6aoaXYn91a8uI7DtNG47IR02wvibZNySMOKDDBUoF1aC9C7josQcsgIMV8EIrpsVlluGfgl7aax2mwGZwW7hnVKydOec5rJYp4HoMuX0O5br/vyud732lSO5QBfYpFeOPtoCSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225130; c=relaxed/simple;
	bh=KYlCB96/l8EfSSxvi1tEWSQZX0E4MuuOIwmRoY6OJlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3WRR/eaeMaNMLfgkUdbxYsucgg6z9O5R/PnoYxZYIQfmAKiBSoHhzT4c6z4Z9muuG5+BuYNn9TFTfBODFbLhw6cgXx2XyRPKwgm/SDufDifZd/PeAvmKnL5OzUEhsCsQuwNeC6N7Wk2nmXArmIwdJCDQ0cn1CfHAsaDmv8m/44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1O0O0Tl4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1O0O0Tl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C381F000FF;
	Sat, 12 Sep 2026 14:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225129;
	bh=AALFs6DepdJT5wK0/k3ep/gN7u+7DWTMm61x15FnDI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1O0O0Tl4j60bsg7Cd3B0gsXJiLuAFhA98CacbxDBtr4k/1Gw8XnIlu0F9by/Z5TY4
	 /1JCGMWwAIxjIwrcl8GExtuzkdcD7Qk6kLDUAgjD3pX+sLLUmFlvuc3vrZ3IFLlMpc
	 n/HiLqszmQfRiBoIsC7HEirjQcV7JTEpkjrQxJIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1133/1424] iio: light: gp2ap002: re-enable irq if runtime suspend fails
Date: Sat, 12 Sep 2026 08:59:25 +0200
Message-ID: <20260912065632.673640104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 13ca9d5acb052..4c90949378234 100644
--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -651,6 +651,7 @@ static int gp2ap002_runtime_suspend(struct device *dev)
 	/* Disable chip and IRQ, everything off */
 	ret = regmap_write(gp2ap002->map, GP2AP002_OPMOD, 0x00);
 	if (ret) {
+		enable_irq(gp2ap002->irq);
 		dev_err(gp2ap002->dev, "error setting up operation mode\n");
 		return ret;
 	}
-- 
2.53.0



