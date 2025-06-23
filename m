Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCDC2550A3;
	Mon, 23 Jun 2025 13:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685290; cv=none; b=EoKJiq45DZcP15/tMZ3BotVN/JtM2cqRG/7X7F2wqv22nZD2OQ0cFeacti+w1Cua5Egga/8OWb78Qt3E2lLFZA3jB9DFVQTw2dPcxY8RcOoBLQERaeFbIbw+1BMGV0S+mcfgBSdOuzaCFJpaSGXzNM72qnPxnitvJDuwzo3HQ2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685290; c=relaxed/simple;
	bh=5DYlTrIl/jeFHk7RjDGyyUOO/rAtx8N46F+bOHuJk9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NckKnmvRtEfjZK4if5p08Q6IeuL89aF9jHjSgmOZCuw4P1vbbOmEIbjIQFednor389FiTRG2vEV+R+Ef1RoLYHTOHxX/pS9NkJ8Vzh2nmeN/jHfufzFx+NXVfMpjXEa4qIoezEu7dnzgNcSzh41wCEZCI4I0NvMRhQBWFZ5YAT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRDtR0JI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRDtR0JI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E12BC4CEEA;
	Mon, 23 Jun 2025 13:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685290;
	bh=5DYlTrIl/jeFHk7RjDGyyUOO/rAtx8N46F+bOHuJk9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRDtR0JIK6smt13R7U+S3LEwSK8h/a3NFZuPKEGHX64lFhmhRU5TOrg/U9XB/UsT6
	 yMICUTVcEQAfxKRipIsrOD1H+SzSZcmK3n9p35hY4KYZa0tHFaCkqoms2CrOe2ZDV5
	 zz+dTcL0ThQT1j6Au7RSGonGYTQ19buHgHyGhOv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/355] clk: bcm: rpi: Add NULL check in raspberrypi_clk_register()
Date: Mon, 23 Jun 2025 15:04:03 +0200
Message-ID: <20250623130628.087125067@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 73c46d9a93d071ca69858dea3f569111b03e549e ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
raspberrypi_clk_register() does not check for this case, which results
in a NULL pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: 93d2725affd6 ("clk: bcm: rpi: Discover the firmware clocks")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20250402020513.42628-1-bsdhenrymartin@gmail.com
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-raspberrypi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index 969227e2df215..f6e7ff6e9d7cc 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -199,6 +199,8 @@ static struct clk_hw *raspberrypi_clk_register(struct raspberrypi_clk *rpi,
 	init.name = devm_kasprintf(rpi->dev, GFP_KERNEL,
 				   "fw-clk-%s",
 				   rpi_firmware_clk_names[id]);
+	if (!init.name)
+		return ERR_PTR(-ENOMEM);
 	init.ops = &raspberrypi_firmware_clk_ops;
 	init.flags = CLK_GET_RATE_NOCACHE;
 
-- 
2.39.5



