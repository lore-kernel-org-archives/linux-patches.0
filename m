Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACE6627F2;
	Tue, 23 Jan 2024 00:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971076; cv=none; b=pdMFDOdTRr/mYpLJ3cFYuGDeFSPEU/DePLDBySsEor2mRss+YbzND//zjZkY335CoWwlqQ+Or6+DnL/BoeKFnHH1fktGkSDoS0N7cZD7bSDSEDTRRi2vBfcLBTGbO8cAZlTn/H9uhdX0YA67HywIQh/td/XyMT6nvYon0uGRj84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971076; c=relaxed/simple;
	bh=+g68MuJTVUXTF0O4P+dcnzxSo+9ZhDPlE78XYbn1mX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOqW9Eu0Zf/302s3Q799Oz1Gxx1RnFXvP4+2gxob3isJjSMCcY5J/4tIf/q9doRwr/u2cMcdzA3vrsgNm+6FwHdMoWrfJ+ppPSCs/EVEVQWbNY7k3GB4Gtm7nVRJkdpqHPlwV42hgwzgFBtj54OFSUrHCdr5aLLUcvC/qMachAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLghE5Tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLghE5Tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C7BC433F1;
	Tue, 23 Jan 2024 00:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971076;
	bh=+g68MuJTVUXTF0O4P+dcnzxSo+9ZhDPlE78XYbn1mX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLghE5TlhKiA5P/arfIZAnTGvs7gGRD0YsShQzcVUv/SXj8rRqmVSDrbfOWixLzgE
	 HuRSTCA0pkXJaqB2tPQgsbF86K0w40p9xFSUknxlgY4V72uVTaEHAZxYy34JpJ9P0K
	 1ylCbRn8/i9TbQcw20jYijDA4uUlBu6YkMpuWcw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/417] drm/tidss: Return error value from from softreset
Date: Mon, 22 Jan 2024 15:55:44 -0800
Message-ID: <20240122235757.959392619@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9ce452288c9e..591f0606f7f8 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -2653,7 +2653,7 @@ static void dispc_init_errata(struct dispc_device *dispc)
 	}
 }
 
-static void dispc_softreset(struct dispc_device *dispc)
+static int dispc_softreset(struct dispc_device *dispc)
 {
 	u32 val;
 	int ret = 0;
@@ -2663,8 +2663,12 @@ static void dispc_softreset(struct dispc_device *dispc)
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
@@ -2775,8 +2779,11 @@ int dispc_init(struct tidss_device *tidss)
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



