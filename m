Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594C03A6B6D;
	Wed, 20 May 2026 18:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300373; cv=none; b=SUu0ndqNCkiBi2NaignSjC8S9vBnHk1yAc4a8oI7kXdKfbHeW1FX10A8etT1DWkze1oLDmncNM7yaCP7xyc0Sms5ffI1vqiFncfsV7HxDR8fEZ4+8pIKsMG5ofE61dXH2L6O5PbGDIwB+wD+2S2pFp06x9t4Yq4MfGec63r8vxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300373; c=relaxed/simple;
	bh=PoeZznUwDOHp/GHLd5oRkjHUVnS6u/O8SGsRyOO02k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C16k9KenFxSB8n/hDS+5952LyIU67oqlPXtHRt+0CKJaWXA5oZRINGX0wX9nrtzZ/tXKaWgN1BvgzczB62ydKN0yI1r5L4PjH0XsJrBK1jbrK4dETI3mz2JYk0KiBc8uT5hI+g9/IWppJ18yhQZVqSdRYqxE8QVWedFYGlVMhqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+f0NPe3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+f0NPe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB8D1F00893;
	Wed, 20 May 2026 18:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300372;
	bh=hyrAlD3xi1RqfxV46vF2VWVudjHo14ibPQBg/bEQZLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+f0NPe3HaNl1QFpl/yhCeluaXgtyeqMzoEIbsdQgk6YFiKjUkO6JsG8IczLUQGic
	 4Bf9wb0x4J1jLNeF2eK91YuMeFn5kiVRHQualx2YEdn/UsNlLcl2C0F1bMJtAIJuRH
	 K1n82ogW45aLKvITyhhghtOsxJwwm/ud6J5AztCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/666] drm/sun4i: Fix resource leaks
Date: Wed, 20 May 2026 18:16:00 +0200
Message-ID: <20260520162114.438038215@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a7c256e2c632b..329e2a2384e89 100644
--- a/drivers/gpu/drm/sun4i/sun4i_backend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_backend.c
@@ -880,7 +880,8 @@ static int sun4i_backend_bind(struct device *dev, struct device *master,
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



