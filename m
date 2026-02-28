Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8187D371458;
	Sat, 28 Feb 2026 17:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301466; cv=none; b=RXKL0xgrVqTDQXXL+nDAQ6L7+gJB+8Gxb11UJKg52vBJS0LwAMEV+byx/ta3PbajsofTHqifnk0Xba9RXKQ3nDWTK421Z5fr+1ac6pmWY4cacVdN0ddgHh4mcyT11J35FoLa69w3WeMkazybHvMoDOHhWD71xVFbFfHxN1rLZC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301466; c=relaxed/simple;
	bh=Mu0YetehpSMSEnsfyji6J7/9tlJ/cVtHgFo5QB5cRj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2puO3k16wWPI24tiB1ls+AZLNmPaN6zsS0ncP+tlnEhEXBMozPC2mNr94a/B73lHB+0WjKUZS02ztQ5lDMp8Vl56EWFvwXN5uBCBuupHuA48W+xFuj7nP/aTVwptMKob3iwKOEw00seP4AVS8qShwVm86qiXfVR3zXIi0ETGRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J6P/zVRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J6P/zVRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8367C19423;
	Sat, 28 Feb 2026 17:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301466;
	bh=Mu0YetehpSMSEnsfyji6J7/9tlJ/cVtHgFo5QB5cRj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6P/zVRs5tRp+Te0CGBCjlR/8+Sj5kRGpqPIa1sUiBlXQc5z6rF/4EcX4Sr49gjYf
	 8P5E8gOpVLBIDv0ZHqmqsS8LwZGcqCt8hAU7gRSJigeCi1hyJ0ose4d8bscBNdgkcZ
	 2cvULyR2LA4lIHKsjdAQjM2qCFbyQdBMetkF/hUk/uwYW7fruom6GOQd1duzxh8rPN
	 pE1onXUDkfW5hVaEfrtEIM6PA+QFAMKQKnz3YtzyGtOUOqm4NUV6MiqXYcbeN3Xu8n
	 QUfwhmRRi2ZnQkDlXfbwXpfIEPluREn8GnnmT3331iMVWSsVY/p0NlSRuFI6xI+hS7
	 O7t48ffaZ2QPg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Marek Vasut <marek.vasut+renesas@mailbox.org>,
	stable@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 651/752] clk: rs9: Reserve 8 struct clk_hw slots for for 9FGV0841
Date: Sat, 28 Feb 2026 12:46:02 -0500
Message-ID: <20260228174750.1542406-651-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 5ec820fc28d0b8a0f3890d476b1976f20e8343cc ]

The 9FGV0841 has 8 outputs and registers 8 struct clk_hw, make sure
there are 8 slots for those newly registered clk_hw pointers, else
there is going to be out of bounds write when pointers 4..7 are set
into struct rs9_driver_data .clk_dif[4..7] field.

Since there are other structure members past this struct clk_hw
pointer array, writing to .clk_dif[4..7] fields corrupts both
the struct rs9_driver_data content and data around it, sometimes
without crashing the kernel. However, the kernel does surely
crash when the driver is unbound or during suspend.

Fix this, increase the struct clk_hw pointer array size to the
maximum output count of 9FGV0841, which is the biggest chip that
is supported by this driver.

Cc: stable@vger.kernel.org
Fixes: f0e5e1800204 ("clk: rs9: Add support for 9FGV0841")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Closes: https://lore.kernel.org/CAMuHMdVyQpOBT+Ho+mXY07fndFN9bKJdaaWGn91WOFnnYErLyg@mail.gmail.com
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-renesas-pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-renesas-pcie.c b/drivers/clk/clk-renesas-pcie.c
index 4c3a5e4eb77ac..f94a9c4d0b670 100644
--- a/drivers/clk/clk-renesas-pcie.c
+++ b/drivers/clk/clk-renesas-pcie.c
@@ -64,7 +64,7 @@ struct rs9_driver_data {
 	struct i2c_client	*client;
 	struct regmap		*regmap;
 	const struct rs9_chip_info *chip_info;
-	struct clk_hw		*clk_dif[4];
+	struct clk_hw		*clk_dif[8];
 	u8			pll_amplitude;
 	u8			pll_ssc;
 	u8			clk_dif_sr;
-- 
2.51.0

