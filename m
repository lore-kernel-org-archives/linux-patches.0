Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27496313E34;
	Sat, 30 May 2026 18:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166294; cv=none; b=jvw6mjXt1QgqXulQ81QrLlTSNgWzpSAoMAhY3rv9Ec8DdAXo4Y6Rzkponqvu0DUxE+ZeH3IRWFubvAPZ5mfxu8ryIhENkWiaIgLe1sWuEyJPkdpcVWfkjAmwPx8On7c7SGQdYyt7N8rFiw9+AZS5uizGPZKvwF8y5fmTSdBZO7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166294; c=relaxed/simple;
	bh=WRJysgl5DVGo1w9FEK8MqXuFHebqYv7u+vJXonU1QNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BN464lfjwdk1FIHS3MmSxTnLPbrB1CTWwBOZH6fUnyTX2LVebE3yLUfNr74U8WDicRxKBczPhHjoD+8pM9Sm7h04Y6S12m54GcUCkZM9QWv/TCW9DG6O7o+NdZgjslcYV04rZv2mXOo9TP7K3Jd/+jKqtJTBOnW1HXfIDSk3r0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fwjIBSA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fwjIBSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608261F00899;
	Sat, 30 May 2026 18:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166293;
	bh=TVRVT/UDM+//9nU6zmNKctYueSRhl44xyMv5JlLhlC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fwjIBSAd8FKSnKFOv/2+39rreBkU2qjts1bl1jFw/iDXeXj0i2BhEzoxapeQKUfb
	 S26eFOkGfYXIzt0ou24omqcncnMcK5QDvxHm96mOfEevnyicwMYZ8pG1WttYbrLxEV
	 zHrtXn8tyuzs0rure1/sy0PxG06Qo/0S5gcrm1BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 331/589] drm/sun4i: Fix resource leaks
Date: Sat, 30 May 2026 18:03:32 +0200
Message-ID: <20260530160233.610556239@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 127367ad2e0f4870de60c6d719ae82ecf68d674c ]

Three clocks are not being released in devm_regmap_init_mmio() error
path.

Add proper goto and set ret to the error code.

Fixes: 8270249fbeaf0 ("drm/sun4i: backend: Create regmap after access is possible")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20260226163836.10335-1-ethantidmore06@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_backend.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_backend.c b/drivers/gpu/drm/sun4i/sun4i_backend.c
index c65b10d413879..b3741827c6c3a 100644
--- a/drivers/gpu/drm/sun4i/sun4i_backend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_backend.c
@@ -900,7 +900,8 @@ static int sun4i_backend_bind(struct device *dev, struct device *master,
 						     &sun4i_backend_regmap_config);
 	if (IS_ERR(backend->engine.regs)) {
 		dev_err(dev, "Couldn't create the backend regmap\n");
-		return PTR_ERR(backend->engine.regs);
+		ret = PTR_ERR(backend->engine.regs);
+		goto err_disable_ram_clk;
 	}
 
 	list_add_tail(&backend->engine.list, &drv->engine_list);
-- 
2.53.0



