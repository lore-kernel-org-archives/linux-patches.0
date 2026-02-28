Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1507636DA10;
	Sat, 28 Feb 2026 17:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301445; cv=none; b=DpcFzDEgQNGrJARaVpm5ICJe340EE9KLGYM1cJTbtx9F8zDAG3AKx5qvjDTq6eIqsCPKQ2lyvak5enQhfzPvOkGQpaYhTtHm4s+CCdzqe86VBmnJJAz0Uj4KNHP2u7Fzk5DjP4JL7XBudiV0Ob1/cQjsFT7/wkWy0gn59xKe7sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301445; c=relaxed/simple;
	bh=u2kxPBOwOLkphVOpPpRhqeDwmrywy8m72tKElHpBxYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rI2rhXQeCW0xJ78aqBJQJCkyeNMXdtCSM1lAH2KuXBP0HBTecRtlDWuuX0Umo/q1eOUSH189172fjiIfnlJSKiKFmPAzGODj6OF7zTrlaJSvDFASsxZ5xYrnArfmpTa9a3bY1DChi3D/cXatM71oC9mTwMV6B6InT5jNOCJKivc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+Iewy2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+Iewy2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBD8C19424;
	Sat, 28 Feb 2026 17:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301445;
	bh=u2kxPBOwOLkphVOpPpRhqeDwmrywy8m72tKElHpBxYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+Iewy2+OVs3COAj8jDz78ggQ56atrWCjJuwrdbjZ4+EtgCYIlXLVHQ7EKWDgELRP
	 Yc7li3/XaeIq3NHNcHdnYQajMRt1buk7R0WL+CurpfW32nZmgIFQoU+H8GCW4dSI5e
	 50cYPCMYPsJRvTS2p8OxrGojQiSODAkOZWH4Irdl7BqEHkk5TVE36vDnAviIEtpH2L
	 dacwjp2UuhqsCBhqofcZrO8OUrs8r9L9x5s4qx0NB3D99u+qI0HIe+jeSZQN11lKya
	 6vdxcGenuPA1zSfo1hwt71NTEn+UIl/2FBurficTiQfCWVvcqrP3poirJUB5Dov/pG
	 SoqXHc80HQRCA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	stable@vger.kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Su Hui <suhui@nfschina.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 631/752] bus: fsl-mc: fix an error handling in fsl_mc_device_add()
Date: Sat, 28 Feb 2026 12:45:42 -0500
Message-ID: <20260228174750.1542406-631-sashal@kernel.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 52f527d0916bcdd7621a0c9e7e599b133294d495 ]

In fsl_mc_device_add(), device_initialize() is called first.
put_device() should be called to drop the reference if error
occurs. And other resources would be released via put_device
-> fsl_mc_device_release. So remove redundant kfree() in
error handling path.

Fixes: bbf9d17d9875 ("staging: fsl-mc: Freescale Management Complex (fsl-mc) bus driver")
Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/b767348e-d89c-416e-acea-1ebbff3bea20@stanley.mountain/
Signed-off-by: Su Hui <suhui@nfschina.com>
Suggested-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20260124102054.1613093-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index a97baf2cbcdd5..eb7b6c0ba9e7c 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -909,11 +909,7 @@ int fsl_mc_device_add(struct fsl_mc_obj_desc *obj_desc,
 	return 0;
 
 error_cleanup_dev:
-	kfree(mc_dev->regions);
-	if (mc_bus)
-		kfree(mc_bus);
-	else
-		kfree(mc_dev);
+	put_device(&mc_dev->dev);
 
 	return error;
 }
-- 
2.51.0

