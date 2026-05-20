Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0571617A2FC;
	Wed, 20 May 2026 18:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302013; cv=none; b=XdvlrzSl5NkfiUqEg4F4nlQgI8B41RDPFWvvbjU0M9w/cZadpsZLinFwH7JN7KWzIJ4BuRMnoaLE7OXvixb+NHThbZ9EylhovasShYQvkUsIO6aW0rGg4kgDIYvgYEiruQxUdaB0lvpxCgFmpUiki7ll7+tk/QQJEVSUOQQVQgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302013; c=relaxed/simple;
	bh=x1wzJ0GVCL4DXwUXCVtyFN1aNSp7xniwnEbRv/z3zD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVGCejd4HAJGtntVcXq5SdWNTaFvDqOTXIJ5j1pH+lyPKaGoqw81+hFOL8PSohBk4h9Hl/XkcZd9XCpoMgKrylJ5bqxpd8XnnD03Tt5uuep31j8WtGE9GlVLDpWqQGcZRElFypp1EHZHibJGSfj1Uu1NaChHIRDlrOc/s7GGsWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocxZLUHs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocxZLUHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE191F000E9;
	Wed, 20 May 2026 18:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302011;
	bh=kHF+MYOVMp7a67gUksu0xzdZo2KHh6o0mF5COEJoWq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocxZLUHsMcYrT4PV+IQKZTYd5pQZzUzI9GqQPwdMhAn3NbDIoKWFANTwmy+7Wnh4w
	 dluhZwjgE29UlwuChNF1HK38bXFNQdzcDM/sNr0Wj803XyFYGY3tAnNsSUHkyPllj8
	 xCEb1ZlNxMPH/KCghbFMEiZ3gL6HRIqhDm+TLiNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/508] drm/sun4i: Fix resource leaks
Date: Wed, 20 May 2026 18:18:48 +0200
Message-ID: <20260520162100.896410421@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 6a2ffaa477ab8..4943577ec7fb8 100644
--- a/drivers/gpu/drm/sun4i/sun4i_backend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_backend.c
@@ -878,7 +878,8 @@ static int sun4i_backend_bind(struct device *dev, struct device *master,
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



