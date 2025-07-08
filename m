Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098D2217722;
	Tue,  8 Jul 2025 16:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992027; cv=none; b=UuKtAZuuqGuHECXjf4xL4IzWjOPXt8tDXTSTr4IUw6Ti2IGvtSbtgBDJJsCklgUtdoHNaew1SKe83Ed70qv12iTpG3V+rhizEs/uSZV9mhVwVlM7N1kmz0tgSMY5bOLlPWSs9siB1JPDb/6U0wg2VvTgkjOfYf0P23HHk/j/QDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992027; c=relaxed/simple;
	bh=bw8aTxkXz0YXkxFMgYqltlVozn/ZuqXXslEi50nTkXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ofd2BZtaqvo2U8Nd6zGfsXF37MdCsCxH70vlJFHHivo8exjUqskkVT4FQCAIvonEWDhHU/VRH5WiP4aTXtMV5xMQ07cPKnTDrihibrlLOEIMX3OpZhO2/sRH4l05hjeKHRi8lnnHGFauZh/CWCr8o7Zl9qimHCKjJrn/tSKZj+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVykRwnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVykRwnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1F4C4CEED;
	Tue,  8 Jul 2025 16:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992026;
	bh=bw8aTxkXz0YXkxFMgYqltlVozn/ZuqXXslEi50nTkXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVykRwnEYeKDSpkQiRFxto21Em/WJkkGFXxVA1P56rQhImbopueO7b3rWBRpR7I7M
	 UuEiGsYEe/bQQY0Y+KWNcn3Il5xH3lf7zgtHyVuQ6fAc59MJ5nN7V2vK9O3gNAKTzc
	 jOxLtyaAM+NhSbdRc549iG74NgTV3YxzvAtNVxcg=
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
Subject: [PATCH 6.1 35/81] drm/i915/gsc: mei interrupt top half should be in irq disabled context
Date: Tue,  8 Jul 2025 18:23:27 +0200
Message-ID: <20250708162226.080746784@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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
index 7af6db3194ddb..0f83e1cedf781 100644
--- a/drivers/gpu/drm/i915/gt/intel_gsc.c
+++ b/drivers/gpu/drm/i915/gt/intel_gsc.c
@@ -273,7 +273,7 @@ static void gsc_irq_handler(struct intel_gt *gt, unsigned int intf_id)
 	if (gt->gsc.intf[intf_id].irq < 0)
 		return;
 
-	ret = generic_handle_irq(gt->gsc.intf[intf_id].irq);
+	ret = generic_handle_irq_safe(gt->gsc.intf[intf_id].irq);
 	if (ret)
 		drm_err_ratelimited(&gt->i915->drm, "error handling GSC irq: %d\n", ret);
 }
-- 
2.39.5



