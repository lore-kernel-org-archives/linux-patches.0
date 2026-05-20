Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43ED63D810C;
	Wed, 20 May 2026 16:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295087; cv=none; b=Jsjjnz42cr70abkSd4zEINQORdBZD7tPSxVlQmWjsRGyTkUE96shtNLx/g89McdAg/cfxXbDnb4i8zujxfCqjh98LgISnBFYQm0WSHrDEl5YmrgB5qnbbzBlnwpA05xGECFf3SFMVOM+S8m2bvht/YuGg8wqFT2yPDa5Pcd6iNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295087; c=relaxed/simple;
	bh=+QDuyROuEIyNMj5uiL8c7VJG2rMpllNfF7qafdFtzqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwixaWKAt43p6JWmEjnDd/XK+t1TvHkp6InEgQEBuH8O0VyMc57GDdfyRhRoKURBLAfABX1no/DvhMm1ThqqR3lN3HqY8UYnVX/Xfa73AKW4rNW1rLpEXDLAjEWqGK7T2vjmChuNxGp7eVdc+Wzr6bmCtyRwLRweqGG7vE51L+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGEm1eXa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGEm1eXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6406E1F00893;
	Wed, 20 May 2026 16:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295084;
	bh=e1e/QeySaPwSUXHPmMs//uUJ+kyHL7ol7wuEpUdR4Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGEm1eXapsQUqBwI18NHm13OSoy6qPkJcq8raOEB7NXJKI0+hX8Jhxt506d0HbEPK
	 P/swNFW2ozI3el4D0euQb6Wd5trnwIABx37Drl8nsuXfa8qHgefkinANfQMARSgztE
	 2aKdqoVyBQ1TCieqkkzcr5d8K6PmsePyKOCSajMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0284/1146] drm/sun4i: Fix resource leaks
Date: Wed, 20 May 2026 18:08:54 +0200
Message-ID: <20260520162154.644614418@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 6391bdc94a5c2..e989f75c09b7d 100644
--- a/drivers/gpu/drm/sun4i/sun4i_backend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_backend.c
@@ -881,7 +881,8 @@ static int sun4i_backend_bind(struct device *dev, struct device *master,
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



