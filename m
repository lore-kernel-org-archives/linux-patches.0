Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B941E0E1A;
	Wed, 19 Feb 2025 08:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954595; cv=none; b=XFc/TKTDx925qZ77hvGAcPdHBgzjdHsotlhq1F8zwxs/qyu+JkQ5XHl75i32pM/5TM74tTkzbWeFrBUaI7RSB+iQIHdNX9D0hGVH2jeRlRtQgzbQqAWKAYNi3x1vwvYri4CGatdP6hGJf1irxqayeT1g/ARIHN3Fn6Ze89i2Vis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954595; c=relaxed/simple;
	bh=tqmETMwfvdz13DCQIimpH8b4sUnW+FnFOOWKEEzoX5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eM7tB0BLx9mH1QWSrWO+IgKN9Fr/xcu6MGVWdKu6Kt/eBJKEfpSxw+RC+6c1fVaodA5K4djXMtejACuWEhhf6q/ej+42G9qVhRj7ahco/bAOualZBHgMZhniMgEcRSVLZC+RpQorBIsimDwrd5FOr/5F8ST0DOnSAfMFMPlOmck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7j5I1s1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7j5I1s1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44554C4CED1;
	Wed, 19 Feb 2025 08:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954595;
	bh=tqmETMwfvdz13DCQIimpH8b4sUnW+FnFOOWKEEzoX5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7j5I1s1LD5toS8WgTIk/4F4M0F0ZphH1rn5zYoySl+KFqD2mXT14zD5Di6Vc1eef
	 JK3NTfNeFm0jItG37hmD8lNjVPQgUBqsstLylZtx5vMqNYC9PKhMURWYppeNJ84oTd
	 xG2s34BOjyGvEewjveB09/MmndGPVH1PAaoC9ulc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devarsh Thakkar <devarsht@ti.com>,
	Jonathan Cormier <jcormier@criticallink.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.13 253/274] drm/tidss: Fix race condition while handling interrupt registers
Date: Wed, 19 Feb 2025 09:28:27 +0100
Message-ID: <20250219082619.481963519@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devarsh Thakkar <devarsht@ti.com>

commit a9a73f2661e6f625d306c9b0ef082e4593f45a21 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c |    4 ++++
 drivers/gpu/drm/tidss/tidss_irq.c   |    2 ++
 2 files changed, 6 insertions(+)

--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -2763,8 +2763,12 @@ static void dispc_init_errata(struct dis
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
--- a/drivers/gpu/drm/tidss/tidss_irq.c
+++ b/drivers/gpu/drm/tidss/tidss_irq.c
@@ -60,7 +60,9 @@ static irqreturn_t tidss_irq_handler(int
 	unsigned int id;
 	dispc_irq_t irqstatus;
 
+	spin_lock(&tidss->wait_lock);
 	irqstatus = dispc_read_and_clear_irqstatus(tidss->dispc);
+	spin_unlock(&tidss->wait_lock);
 
 	for (id = 0; id < tidss->num_crtcs; id++) {
 		struct drm_crtc *crtc = tidss->crtcs[id];


