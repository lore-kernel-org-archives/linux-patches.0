Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D15A251785;
	Wed,  5 Mar 2025 17:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197166; cv=none; b=dS9M5KunxFGsCWenlm02NfODlAfQAw5Y43572ehsBctbchTCS6Kz9uxUh8yvPPS8UmqjaztsID5tVzDnBpTJawEd8nvZv1PJvKl0dX8qNl4QTlGwoPA/xOuPaOzWGG/BsPs5LJExuQV4SGO1gfyCbvkQVm5Zhad+pckqnuyikzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197166; c=relaxed/simple;
	bh=xff0l+Lgl/NXoT7fvj7At6nRL2ioc9OaDrq0R4VB5Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQFfE8MNve+N6ZCvFifT9hV0rsYQOSXgHAvnHvSVAqc3+mHwLsGbcjEtD3oXaFEX3acgV4PbCHDcBaM9BR/DB0tGL9j4k7Kpy+9Vif1MbNWpdDxRB/tQI5jqYWUk7p9kcDTRV29FOAnGRDVihbEzFPzz9Qv5lsmz1UK3zsIyJNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NadOfeL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NadOfeL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E6EC4CED1;
	Wed,  5 Mar 2025 17:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197166;
	bh=xff0l+Lgl/NXoT7fvj7At6nRL2ioc9OaDrq0R4VB5Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NadOfeL4eZbYLolx8ckEUVfdClOtCEdrZL2mFMcNKfTHwaihevQNu5Zra1RSrZ8h+
	 5XzPh6xFwfi1V97sb3U/F1qOHIVnAUu5TnZmJCo6BQWvto7igIO+3IbJdOB2skHLD5
	 wX4k1In8yB7JOa1dW/9Xyw9T16UTRAelEBV6kK8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/176] drm/tidss: Add simple K2G manual reset
Date: Wed,  5 Mar 2025 18:47:10 +0100
Message-ID: <20250305174507.906318083@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 576d96c5c896221b5bc8feae473739469a92e144 ]

K2G display controller does not support soft reset, but we can do the
most important steps manually: mask the IRQs and disable the VPs.

Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Link: https://lore.kernel.org/r/20231109-tidss-probe-v2-7-ac91b5ea35c0@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Stable-dep-of: a9a73f2661e6 ("drm/tidss: Fix race condition while handling interrupt registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index c986d432af507..d3e57e6de5dbb 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -2655,14 +2655,28 @@ static void dispc_init_errata(struct dispc_device *dispc)
 	}
 }
 
+/*
+ * K2G display controller does not support soft reset, so we do a basic manual
+ * reset here: make sure the IRQs are masked and VPs are disabled.
+ */
+static void dispc_softreset_k2g(struct dispc_device *dispc)
+{
+	dispc_set_irqenable(dispc, 0);
+	dispc_read_and_clear_irqstatus(dispc);
+
+	for (unsigned int vp_idx = 0; vp_idx < dispc->feat->num_vps; ++vp_idx)
+		VP_REG_FLD_MOD(dispc, vp_idx, DISPC_VP_CONTROL, 0, 0, 0);
+}
+
 static int dispc_softreset(struct dispc_device *dispc)
 {
 	u32 val;
 	int ret = 0;
 
-	/* K2G display controller does not support soft reset */
-	if (dispc->feat->subrev == DISPC_K2G)
+	if (dispc->feat->subrev == DISPC_K2G) {
+		dispc_softreset_k2g(dispc);
 		return 0;
+	}
 
 	/* Soft reset */
 	REG_FLD_MOD(dispc, DSS_SYSCONFIG, 1, 1, 1);
-- 
2.39.5



