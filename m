Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7041428F8;
	Wed,  3 Jul 2024 11:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005957; cv=none; b=Ig3vyI/R79aXOaHDc7rULf4GLpDRhXt/JDDbnnU54rHdTaeX+PwN97oZWV5Wt1skRHcrmxht1/KAScQx2c2VgffKkUSs5jf9brzM3oNds31o3Jpi0b/jd/YYYs2BT+4XcEfwukPsNOb8TK1+dh6vJ8pIMR2wnT3iMR16MpywbPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005957; c=relaxed/simple;
	bh=FIrxTOfiYlbexu1AG+veljIrvF72t2xIfNBGAYJ14VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cixiBXhMFifhvKQBHxbu7fgEgodEcSvB8mMBryDrYj5fyz6XrHv1S6NLFlBSfasucM0jqu0kmKwRFfNQQBuCYrv2CUCcIxbXmcLyPwsNJr78X/vmurvL7Mpoo+uIIHbf5joEgNSuTCwoaZN16eTe6fxCOJirgxkVc7E/oAGKzoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTSoUYXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTSoUYXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6317FC2BD10;
	Wed,  3 Jul 2024 11:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005956;
	bh=FIrxTOfiYlbexu1AG+veljIrvF72t2xIfNBGAYJ14VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTSoUYXqkSatceycIfqk0rt6IX2h20r8W/0px32AeWSOPUoyYwR/UO1otWwoKX4DM
	 PaOu1xyUVLGP4CEW0C/AexSvG5yawOu3urfNxK8VgXCnymKh4VifkU7JH11OyuBeco
	 77Z5ec4PcR0105oMdp5ocGTnUICP6vvvo3jOQbB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Karolina Drobnik <karolina.drobnik@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 245/356] drm/i915/gt: Only kick the signal worker if theres been an update
Date: Wed,  3 Jul 2024 12:39:41 +0200
Message-ID: <20240703102922.383032303@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit c877bed82e1017c102c137d432933ccbba92c119 ]

One impact of commit 047a1b877ed4 ("dma-buf & drm/amdgpu: remove
dma_resv workaround") is that it stores many, many more fences. Whereas
adding an exclusive fence used to remove the shared fence list, that
list is now preserved and the write fences included into the list. Not
just a single write fence, but now a write/read fence per context. That
causes us to have to track more fences than before (albeit half of those
are redundant), and we trigger more interrupts for multi-engine
workloads.

As part of reducing the impact from handling more signaling, we observe
we only need to kick the signal worker after adding a fence iff we have
good cause to believe that there is work to be done in processing the
fence i.e. we either need to enable the interrupt or the request is
already complete but we don't know if we saw the interrupt and so need
to check signaling.

References: 047a1b877ed4 ("dma-buf & drm/amdgpu: remove dma_resv workaround")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Karolina Drobnik <karolina.drobnik@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/d7b953c7a4ba747c8196a164e2f8c5aef468d048.1657289332.git.karolina.drobnik@intel.com
Stable-dep-of: 70cb9188ffc7 ("drm/i915/gt: Disarm breadcrumbs if engines are already idle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
index 209cf265bf746..e8cd7effea2b0 100644
--- a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
+++ b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
@@ -398,7 +398,8 @@ static void insert_breadcrumb(struct i915_request *rq)
 	 * the request as it may have completed and raised the interrupt as
 	 * we were attaching it into the lists.
 	 */
-	irq_work_queue(&b->irq_work);
+	if (!b->irq_armed || __i915_request_is_complete(rq))
+		irq_work_queue(&b->irq_work);
 }
 
 bool i915_request_enable_breadcrumb(struct i915_request *rq)
-- 
2.43.0



