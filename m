Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C862EBDCC;
	Tue, 17 Jun 2025 15:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174808; cv=none; b=rnbecIYHcZ3dvagVcebK7JuEaWKdNDmu2YvDsDgQe05/kfTEu69lMG/rYa6eqYlbS/xKl4zRtpYsZZmWShmfRUwdP5FKGhKVmnnQw+pU0ghhGDjQ2zEW6UQvSoJbccm8tiw6PokT241WIBIM+EexLeVqesaKYL8K96mYJnVOteE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174808; c=relaxed/simple;
	bh=gn1nI8nXDPCppWdDXW6Klavs0mgG17SrCDlZBPSg4XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fy/MtlyHLK0XDlTpb6DbbCfw7d81y9op5vjBmZS3atgDPuULYZ0Gg01ga01uPXILrs9ObbCcDoZF7SZXily7qesJliAXZatTlRcFMcYG5fvqq7edfdO5p32dXISuSJ0DOkVspiTqFCLP3nYoi6bc22WSPotUpaFoFdi78pseWDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+5k1Wqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+5k1Wqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4B2C4CEE3;
	Tue, 17 Jun 2025 15:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174807;
	bh=gn1nI8nXDPCppWdDXW6Klavs0mgG17SrCDlZBPSg4XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+5k1WqgiXjZ4dLd/kzyoosueJ9zJkH9fMJF7RYjvs68D4BbUria2I+eOP0XNofz2
	 evdnedGLKJ42bPLG+G4/QvhJGKZpyXNgFJ9Y6TQpwJOduTMn6dZ0shWc5rWcZoWRON
	 hW8pQrf83qOOKyeE9g6sakkDTSQQgF9a9GxqgPTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/356] clk: bcm: rpi: Add NULL check in raspberrypi_clk_register()
Date: Tue, 17 Jun 2025 17:23:50 +0200
Message-ID: <20250617152342.856652545@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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
index 4d411408e4afe..cc4ca336ac13a 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -271,6 +271,8 @@ static struct clk_hw *raspberrypi_clk_register(struct raspberrypi_clk *rpi,
 	init.name = devm_kasprintf(rpi->dev, GFP_KERNEL,
 				   "fw-clk-%s",
 				   rpi_firmware_clk_names[id]);
+	if (!init.name)
+		return ERR_PTR(-ENOMEM);
 	init.ops = &raspberrypi_firmware_clk_ops;
 	init.flags = CLK_GET_RATE_NOCACHE;
 
-- 
2.39.5



