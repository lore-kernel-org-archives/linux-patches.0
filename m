Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5D92D12ED;
	Fri,  7 Aug 2026 15:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117081; cv=none; b=nZTWU03SB/XMrY6caEsBr9xEbdjMQPfGCFYJ9xbCPto5x7O7AqeSpgHkqLj2/GF7d5AHmy/jpH9g22+C03SY041363u/Y+eTvEvBO649vyNrP0cRZh+N71z7AkzU59Aaw8Yst9W48wF/rm10CzTFW9HtWeP4Vyqug/yunwR+h1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117081; c=relaxed/simple;
	bh=vy4jdTqlnblTYP8zmpnEtMkQlPe1fZMEezRioJ3fPwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s0mtl8X66Y6xL4fwxkdD660okUf+Fg8AkjYORRG5mIMYYLGDWUHQr5OSpOoGalsPkQXeO3hzB7pW3CdwLuYo0rkekdEJX35i3meGO+4TbTfI6FTgbaAM/TjOgjogVBh1frkuAR2kKS57EZtgK3gGIdAyPE4ZTVNX0rO4dsediWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZoyTy/a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZoyTy/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CEA1F000E9;
	Fri,  7 Aug 2026 15:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117080;
	bh=3J7bIGuj8Gm2rPrxecKJXRsAnW2aBi6wQ6hXEEuOdl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZoyTy/anHApZs5dXsvH8E99b0Wycv+QCTHPwvAROJvPaeyaG04vWWUeDtatuZjpT
	 +3TBGt/Lb28xOk/ZGx5xZMRipZkPnsHZlafGsI1Teb/H+m2HDedBLAT4t0JGP/Lmym
	 oXgEIW3gn62i/Q6EObKuj9nHTnftxl+sgRLXXBmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 192/438] mshv: Fix level-triggered check on uninitialized data
Date: Fri,  7 Aug 2026 16:36:28 +0200
Message-ID: <20260807143432.121737754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

[ Upstream commit 0289a67cd70bf9d3807e289f4efd643e16a6c6b4 ]

In mshv_irqfd_assign(), the level-triggered validation for resample
irqfds checks irqfd_lapic_irq.lapic_control.level_triggered before
mshv_irqfd_update() has populated the field. Since the irqfd struct is
zero-allocated, level_triggered is always 0 at that point, causing the
check to always reject resample irqfds with -EINVAL. This makes
level-triggered interrupt resampling — used to avoid interrupt storms
with assigned devices — completely non-functional.

Move the check after the mshv_irqfd_update() call, which resolves the
IRQ routing entry and populates irqfd_lapic_irq with the actual trigger
mode.

Fixes: 621191d709b14 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Reviewed-by: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_eventfd.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/hv/mshv_eventfd.c b/drivers/hv/mshv_eventfd.c
index 5995a62aff8d8..047e5bd432381 100644
--- a/drivers/hv/mshv_eventfd.c
+++ b/drivers/hv/mshv_eventfd.c
@@ -473,6 +473,19 @@ static int mshv_irqfd_assign(struct mshv_partition *pt,
 	init_poll_funcptr(&irqfd->irqfd_polltbl, mshv_irqfd_queue_proc);
 
 	spin_lock_irq(&pt->pt_irqfds_lock);
+	ret = 0;
+	hlist_for_each_entry(tmp, &pt->pt_irqfds_list, irqfd_hnode) {
+		if (irqfd->irqfd_eventfd_ctx != tmp->irqfd_eventfd_ctx)
+			continue;
+		/* This fd is used for another irq already. */
+		ret = -EBUSY;
+		spin_unlock_irq(&pt->pt_irqfds_lock);
+		goto fail;
+	}
+
+	idx = srcu_read_lock(&pt->pt_irq_srcu);
+	mshv_irqfd_update(pt, irqfd);
+
 #if IS_ENABLED(CONFIG_X86)
 	if (args->flags & BIT(MSHV_IRQFD_BIT_RESAMPLE) &&
 	    !irqfd->irqfd_lapic_irq.lapic_control.level_triggered) {
@@ -481,22 +494,12 @@ static int mshv_irqfd_assign(struct mshv_partition *pt,
 		 * Otherwise return with failure
 		 */
 		spin_unlock_irq(&pt->pt_irqfds_lock);
+		srcu_read_unlock(&pt->pt_irq_srcu, idx);
 		ret = -EINVAL;
 		goto fail;
 	}
 #endif
-	ret = 0;
-	hlist_for_each_entry(tmp, &pt->pt_irqfds_list, irqfd_hnode) {
-		if (irqfd->irqfd_eventfd_ctx != tmp->irqfd_eventfd_ctx)
-			continue;
-		/* This fd is used for another irq already. */
-		ret = -EBUSY;
-		spin_unlock_irq(&pt->pt_irqfds_lock);
-		goto fail;
-	}
 
-	idx = srcu_read_lock(&pt->pt_irq_srcu);
-	mshv_irqfd_update(pt, irqfd);
 	hlist_add_head(&irqfd->irqfd_hnode, &pt->pt_irqfds_list);
 	spin_unlock_irq(&pt->pt_irqfds_lock);
 
-- 
2.53.0



