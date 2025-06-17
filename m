Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0BD285049;
	Tue, 17 Jun 2025 16:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177007; cv=none; b=nnGhmPT3KhG89dLo51ym/nc8ezy2zRBRrCoBz4kGhTk7c1Tr1NACwVhFetR1UOFETyK/Nk0iaO5EHZQ4LSrg/ZkL+o3RZActW75BpG5sMx3riSz3c+snHkX0cch67E23PJIDXBeUkIc5u6/FiseLXkQ3g1lWvGD2TuzkLQeo3UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177007; c=relaxed/simple;
	bh=q0XLe6NPCUD4TBxWUVZiL/k89ipae0OVyXskYRjIl0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MW7NplXxrRF98HPYqTjq/98Ld9iHFrB9F9DtqW9IhcQWey49XvIimykrY1c7depNEqScT0Gc4buos/4HW25IfW82XOMpFoBxeQeCPIIZQHOVcm8A3D9fwKE2Sy4KRn0vWrEwrOvO5XsbWAM+JFz0vtf5LcocruSdOQj0h/jSJsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWSa1z/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWSa1z/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB46EC4CEE3;
	Tue, 17 Jun 2025 16:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177007;
	bh=q0XLe6NPCUD4TBxWUVZiL/k89ipae0OVyXskYRjIl0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWSa1z/hn8BX5iW5kEY+HfTJG+CxMPebMaVpbTdjkrAU8klIV8U9/5Unlf3mgMByO
	 N+Jb2bKwDi1jIKrruNPU5ORuQcnAHnu+/i/Aw9Wsb79znEOk4EMLURHT8AgY6WeLeN
	 TcSRxViymISH+87BCenziRaCDIAmVRzoOCQJyYO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 248/780] clk: bcm: rpi: Add NULL check in raspberrypi_clk_register()
Date: Tue, 17 Jun 2025 17:19:16 +0200
Message-ID: <20250617152501.550078246@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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
index 0e1fe3759530a..720acc10f8aa4 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -286,6 +286,8 @@ static struct clk_hw *raspberrypi_clk_register(struct raspberrypi_clk *rpi,
 	init.name = devm_kasprintf(rpi->dev, GFP_KERNEL,
 				   "fw-clk-%s",
 				   rpi_firmware_clk_names[id]);
+	if (!init.name)
+		return ERR_PTR(-ENOMEM);
 	init.ops = &raspberrypi_firmware_clk_ops;
 	init.flags = CLK_GET_RATE_NOCACHE;
 
-- 
2.39.5



