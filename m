Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9357186B;
	Tue, 23 Jan 2024 00:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969478; cv=none; b=GK4wLf9nissXQOkv8MU6SpZm6hqVaVnJeXmXjcqBZgRi6YZLb6S4L6jz/jVqJHrxIaQr33AkaVzZCZttjD3EhXJvAe9hkjybruiQKIjyH0qPhcKyEi6EzgJPtyS/lB+SUm3IBEWbtNVAcGZaCR1b6JWu0KnMvwdcu76KQMd7CHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969478; c=relaxed/simple;
	bh=AJydT7JHr0oBQw1ZoHDEIjKrLJQGxhzj2Nx7gDgPnks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frbjtz6j9iAKe3Yynio/uNevgHvGH7dvodPMA2RTQ8ATiOj+7BWVnymxKi1KxAwc77kwPMRyTyNVSp/PaavyMzABzWhLFn10XB6wcT8rmDACl++crpCIrqVDcRyh6KiVm0Ht6bbH+yQPvmDx91M5DDepshvJPh5yWMtSH3siND0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbnLvxQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbnLvxQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72803C43394;
	Tue, 23 Jan 2024 00:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969478;
	bh=AJydT7JHr0oBQw1ZoHDEIjKrLJQGxhzj2Nx7gDgPnks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbnLvxQa3tYtAqbYxRVU+XKP6WwwAMDwDaATq9QElo1uawJU1MKnAm9uZJ1VFkzFv
	 EnKl8KxFeMff+ZgZAFypfTavXc1P1kNJlDJwKo71ttBKw/wjrXWxS02CllrrYezyPO
	 377FP02Sw3agHdf2Xpij93mU2EFJ0bhDwxdu8ULM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 272/641] drm/tidss: Return error value from from softreset
Date: Mon, 22 Jan 2024 15:52:56 -0800
Message-ID: <20240122235826.433110269@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit aceafbb5035c4bfc75a321863ed1e393d644d2d2 ]

Return an error value from dispc_softreset() so that the caller can
handle the errors.

Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Link: https://lore.kernel.org/r/20231109-tidss-probe-v2-5-ac91b5ea35c0@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Stable-dep-of: bc288a927815 ("drm/tidss: Fix dss reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index 8d822372bf94..9a29f5fa8453 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -2702,7 +2702,7 @@ static void dispc_init_errata(struct dispc_device *dispc)
 	}
 }
 
-static void dispc_softreset(struct dispc_device *dispc)
+static int dispc_softreset(struct dispc_device *dispc)
 {
 	u32 val;
 	int ret = 0;
@@ -2712,8 +2712,12 @@ static void dispc_softreset(struct dispc_device *dispc)
 	/* Wait for reset to complete */
 	ret = readl_poll_timeout(dispc->base_common + DSS_SYSSTATUS,
 				 val, val & 1, 100, 5000);
-	if (ret)
-		dev_warn(dispc->dev, "failed to reset dispc\n");
+	if (ret) {
+		dev_err(dispc->dev, "failed to reset dispc\n");
+		return ret;
+	}
+
+	return 0;
 }
 
 int dispc_init(struct tidss_device *tidss)
@@ -2826,8 +2830,11 @@ int dispc_init(struct tidss_device *tidss)
 			     &dispc->memory_bandwidth_limit);
 
 	/* K2G display controller does not support soft reset */
-	if (feat->subrev != DISPC_K2G)
-		dispc_softreset(dispc);
+	if (feat->subrev != DISPC_K2G) {
+		r = dispc_softreset(dispc);
+		if (r)
+			return r;
+	}
 
 	tidss->dispc = dispc;
 
-- 
2.43.0



