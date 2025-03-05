Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D622528FD;
	Wed,  5 Mar 2025 17:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197169; cv=none; b=bNXzjQsYutxhVmhmznaq+xQGCbXwOggRGQwbrlV34cDC6pc5c/7WCegK9bPMATw/l5ICCH3w2yqYTOhiLuZ9StQBva3MW6rQlUduXI7P1dORTi/2+n6G57MK3WgvPqdAxeLBbN0llO14cvOJQAMriMpwKVUsv/J239emFzppPj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197169; c=relaxed/simple;
	bh=OsPcmZrH+NuArXVEKbe8mGxWtrOvteWCI1wjdD2ZB18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKHDhEO+CShydQHh7hY0nOO9EEX6D+5IadF2GcmTS5ad+HHsO2NP2jim7+YXb60QiXVD3kr0tCq1WKmAbkGnnoI2hZnLFBiQAIdLG8aCaIH7W7XtVIMP+wIEinRHZzBuAjxDfDdn3ey8xivth8cgrZio4sJK5oc0jEQO5KYe+ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhtQe5g6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhtQe5g6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E407DC4CEE2;
	Wed,  5 Mar 2025 17:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197169;
	bh=OsPcmZrH+NuArXVEKbe8mGxWtrOvteWCI1wjdD2ZB18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhtQe5g6YR/85Gjj6Yx9kyzeEvgA68ZKw6Va8tE9KFz1qXc/CoY7dIsrtzmcviITv
	 6q03Vl67JnPhQ0WONm/OVdMS3Bu9Y7DJCC+ZNOdej16j92hpE8/8RtdQgE7aLoPr5d
	 1lkgiVoIfAaGfZxDFJD+Y/tJjJrOxUHIp6weidm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devarsh Thakkar <devarsht@ti.com>,
	Jonathan Cormier <jcormier@criticallink.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/176] drm/tidss: Fix race condition while handling interrupt registers
Date: Wed,  5 Mar 2025 18:47:11 +0100
Message-ID: <20250305174507.945040817@linuxfoundation.org>
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

From: Devarsh Thakkar <devarsht@ti.com>

[ Upstream commit a9a73f2661e6f625d306c9b0ef082e4593f45a21 ]

The driver has a spinlock for protecting the irq_masks field and irq
enable registers. However, the driver misses protecting the irq status
registers which can lead to races.

Take the spinlock when accessing irqstatus too.

Fixes: 32a1795f57ee ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Cc: stable@vger.kernel.org
Signed-off-by: Devarsh Thakkar <devarsht@ti.com>
[Tomi: updated the desc]
Reviewed-by: Jonathan Cormier <jcormier@criticallink.com>
Tested-by: Jonathan Cormier <jcormier@criticallink.com>
Reviewed-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241021-tidss-irq-fix-v1-6-82ddaec94e4a@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c | 4 ++++
 drivers/gpu/drm/tidss/tidss_irq.c   | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index d3e57e6de5dbb..38b2ae0d7ec1d 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -2661,8 +2661,12 @@ static void dispc_init_errata(struct dispc_device *dispc)
  */
 static void dispc_softreset_k2g(struct dispc_device *dispc)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&dispc->tidss->wait_lock, flags);
 	dispc_set_irqenable(dispc, 0);
 	dispc_read_and_clear_irqstatus(dispc);
+	spin_unlock_irqrestore(&dispc->tidss->wait_lock, flags);
 
 	for (unsigned int vp_idx = 0; vp_idx < dispc->feat->num_vps; ++vp_idx)
 		VP_REG_FLD_MOD(dispc, vp_idx, DISPC_VP_CONTROL, 0, 0, 0);
diff --git a/drivers/gpu/drm/tidss/tidss_irq.c b/drivers/gpu/drm/tidss/tidss_irq.c
index 0c681c7600bcb..f13c7e434f8ed 100644
--- a/drivers/gpu/drm/tidss/tidss_irq.c
+++ b/drivers/gpu/drm/tidss/tidss_irq.c
@@ -60,7 +60,9 @@ static irqreturn_t tidss_irq_handler(int irq, void *arg)
 	unsigned int id;
 	dispc_irq_t irqstatus;
 
+	spin_lock(&tidss->wait_lock);
 	irqstatus = dispc_read_and_clear_irqstatus(tidss->dispc);
+	spin_unlock(&tidss->wait_lock);
 
 	for (id = 0; id < tidss->num_crtcs; id++) {
 		struct drm_crtc *crtc = tidss->crtcs[id];
-- 
2.39.5



