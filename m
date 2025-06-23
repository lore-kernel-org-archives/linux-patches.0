Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780E43FB1B;
	Mon, 23 Jun 2025 21:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715802; cv=none; b=VkvxRdF4B1M1vRjORyk2q3tP3eEndyDbMVqYgpHrdQtXlgIHxakUp6SC/G8ZROzdHXcKhsXsM9C+B3KRlLvecbi2zKaKqW046OOJvGorm26xayfQtOA0tXEbZ1EXsyLv4XdzsvCgSzHmy6lfZlqNOBlk5ZSqQRv9mlGrBeri99I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715802; c=relaxed/simple;
	bh=tpyeOkEuoCAIGF9uGTdJK7wsSe1akNM+SceL4/HcwD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGKq+kkKqdk4XaV+t/OQbo7w1Rd2KNFdQUWEjdTwRc5aGODjAMJ2YIAh7uanRYpKlqMcGT6EVPCP5/BaniX7NusdtquYJZv7ZXBMdxCA6sQOWY3eDbo/mFVLGeQekNDYpSo57vBTdECAKQr36WYFe+SfaeeGA8R3KYyYUnbdEy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGEqyYtL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGEqyYtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101C1C4CEEA;
	Mon, 23 Jun 2025 21:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715802;
	bh=tpyeOkEuoCAIGF9uGTdJK7wsSe1akNM+SceL4/HcwD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGEqyYtLp2eFTMPtqoJDfiWbR2ufrescNZXYjZCf6YB7cNJOrF1qJJ+6llyTu1MD+
	 MWN4Z1VIyu9pL/1W+hVuUjpvKK4bMDG6y/MWBsUQVal9tpZGaayZaphTzzyx+1RHWR
	 Rq8cFO70GSzIsgm8ETCJS0ho5yDD8enNe/8Xl+i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/414] i2c: tegra: check msg length in SMBUS block read
Date: Mon, 23 Jun 2025 15:05:45 +0200
Message-ID: <20250623130647.206078201@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1df5b42041427..89ce8a62b37c6 100644
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



