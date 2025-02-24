Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304EC17579;
	Mon, 24 Feb 2025 14:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408067; cv=none; b=UDSwBADN4XIW2DCvCsbgXVwBXSPU5fGa1UgACBdjSgOJBEIPG0hnzIZKTDsA5W2/HJpXVjiNdr4vqpFR9W8uZEpCeqDgWGUDrM08OFSN07KfV5pc9tq5LMR8pXgOYM9R0BBXdawjYKjd9EMChqAO5a9ZyAhA0eneCIMyXn+Bkj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408067; c=relaxed/simple;
	bh=RtF70ZZWzRSqLfMMzr1OG5S8UWc+1JMWGm1v3d1/iEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPDOz5apsfmnJzRl436dK3nbbPz2OMr2loT6B0yGYN5UDskWAGkFXZ9E31EOkEi3cc/j0gkYtcdZ6pKmFh8C1h3TzVSt9ttCye5FhdVukELoqp71YBQrW/q7t228mfZa1TaX4COoZ+n34kj7zIVNS+v/Kqzppu0Hc61VBYC+hu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVoETij5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVoETij5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EE2C4CED6;
	Mon, 24 Feb 2025 14:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408067;
	bh=RtF70ZZWzRSqLfMMzr1OG5S8UWc+1JMWGm1v3d1/iEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVoETij5gmMJthqIbRGafTlI0+18MdCRQt+lPrtwHvzAssFpeXLZm5u9cvDn4rIsh
	 wPB/PPjbL5XbhTpgXiAfII3Rc9juEnzSVJ6EOhJtrXP8EtLNYRFmFwX1wCOEpuk5gU
	 Ydl3Fp+ibHVDoUOi/cuUCMFgCyPM+YgMx20r5mhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/140] drm/tidss: Add simple K2G manual reset
Date: Mon, 24 Feb 2025 15:34:49 +0100
Message-ID: <20250224142606.549899803@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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
index ee3531bbccd7d..4327e1203c565 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -2704,14 +2704,28 @@ static void dispc_init_errata(struct dispc_device *dispc)
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



