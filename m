Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A08289E2C;
	Tue,  8 Jul 2025 16:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992776; cv=none; b=dm07ffTpJGG34u9DhjCjhYLVd9kyXYAKZvA3z7uPp16oCVQ2jJEJY/z83DQRIPNtXj8PncsCiP1R76hv7b7XqTPJlFtKAwl2q2sbikmbMro4mPjqA6LfRmNVxyIGPuH62W1+rFHa0MgJ/zc07aUKrnjLVZxgKJms32+Fdx6z7AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992776; c=relaxed/simple;
	bh=TEspSTppyO+fmvD3G6mEAfBFtYEeCi8Eoi66xMBfs80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMj8PzjpK26oHTUWSEmMGpEkt4gTvRDiiPVOPf1/RxPob1ZevK17vvkK/d1NuUiVG8W1cFP0XS510U8QhtSIqMRAjkagXcOc53iij7XpTwwaBich08RqqHEQ//ZTXo66xELo2re3oMPcJIshITTOt9RoczCQIDqUGCGnWaBW7Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uN7QY+DT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uN7QY+DT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C62C4CEED;
	Tue,  8 Jul 2025 16:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992776;
	bh=TEspSTppyO+fmvD3G6mEAfBFtYEeCi8Eoi66xMBfs80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uN7QY+DTlfqo72jPY6rnWViJoyB3vAmuXL4aukyXUUJc2Z9xZoyGJ7pnDoxzLqNjY
	 GRfdtlTOmQR74E0Bw7LiSfGw5UJfd44eGeT4mP5FY/FbAE7X7UMSzatnSm9i1M7QSj
	 Uj2gGpHmLDZJZ3Oi/Itpz8clqeXttqgap28SOJsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furong Zhou <furong.zhou@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Junxiao Chang <junxiao.chang@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/232] drm/i915/gsc: mei interrupt top half should be in irq disabled context
Date: Tue,  8 Jul 2025 18:21:13 +0200
Message-ID: <20250708162243.466655174@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Chang <junxiao.chang@intel.com>

[ Upstream commit 8cadce97bf264ed478669c6f32d5603b34608335 ]

MEI GSC interrupt comes from i915. It has top half and bottom half.
Top half is called from i915 interrupt handler. It should be in
irq disabled context.

With RT kernel, by default i915 IRQ handler is in threaded IRQ. MEI GSC
top half might be in threaded IRQ context. generic_handle_irq_safe API
could be called from either IRQ or process context, it disables local
IRQ then calls MEI GSC interrupt top half.

This change fixes A380/A770 GPU boot hang issue with RT kernel.

Fixes: 1e3dc1d8622b ("drm/i915/gsc: add gsc as a mei auxiliary device")
Tested-by: Furong Zhou <furong.zhou@intel.com>
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
Link: https://lore.kernel.org/r/20250425151108.643649-1-junxiao.chang@intel.com
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit dccf655f69002d496a527ba441b4f008aa5bebbf)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gsc.c b/drivers/gpu/drm/i915/gt/intel_gsc.c
index 1e925c75fb080..c43febc862dc3 100644
--- a/drivers/gpu/drm/i915/gt/intel_gsc.c
+++ b/drivers/gpu/drm/i915/gt/intel_gsc.c
@@ -284,7 +284,7 @@ static void gsc_irq_handler(struct intel_gt *gt, unsigned int intf_id)
 	if (gt->gsc.intf[intf_id].irq < 0)
 		return;
 
-	ret = generic_handle_irq(gt->gsc.intf[intf_id].irq);
+	ret = generic_handle_irq_safe(gt->gsc.intf[intf_id].irq);
 	if (ret)
 		gt_err_ratelimited(gt, "error handling GSC irq: %d\n", ret);
 }
-- 
2.39.5



