Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9BC43AD7
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTe7GuS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAB2C4E777;
	Wed, 15 Nov 2023 20:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081715;
	bh=Ly3B6OvbaUOentggsG2Nz1cE5UQh3VTL/AdGbkaVKPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTe7GuS79EyujcbyKAK62v9OTZEImNYeeOYt9yd83pk+HK8v+uykFy9ViUK1YVKqw
	 M5+JcN04nViNEL0NkEwy35IEBu45reE9h9JD/uZ7qsIIAVp7hYxX8xrGN8o40cs8JV
	 Ks7gCXWsFLqpwK9iuVcyaXhVSG4bU3wSocJv7HFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/191] clk: npcm7xx: Fix incorrect kfree
Date: Wed, 15 Nov 2023 15:45:30 -0500
Message-ID: <20231115204647.901332870@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

[ Upstream commit bbc5080bef4a245106aa8e8d424ba8847ca7c0ca ]

The corresponding allocation is:

> npcm7xx_clk_data = kzalloc(struct_size(npcm7xx_clk_data, hws,
> 			     NPCM7XX_NUM_CLOCKS), GFP_KERNEL);

... so, kfree should be applied to npcm7xx_clk_data, not
npcm7xx_clk_data->hws.

Fixes: fcfd14369856 ("clk: npcm7xx: add clock controller")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Link: https://lore.kernel.org/r/20230923133127.1815621-1-j.neuschaefer@gmx.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-npcm7xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-npcm7xx.c b/drivers/clk/clk-npcm7xx.c
index 27a86b7a34dbf..c82df105b0a21 100644
--- a/drivers/clk/clk-npcm7xx.c
+++ b/drivers/clk/clk-npcm7xx.c
@@ -647,7 +647,7 @@ static void __init npcm7xx_clk_init(struct device_node *clk_np)
 	return;
 
 npcm7xx_init_fail:
-	kfree(npcm7xx_clk_data->hws);
+	kfree(npcm7xx_clk_data);
 npcm7xx_init_np_err:
 	iounmap(clk_base);
 npcm7xx_init_error:
-- 
2.42.0



