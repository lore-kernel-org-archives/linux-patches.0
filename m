Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7553917A31C;
	Mon, 20 Apr 2026 15:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700736; cv=none; b=Fr62mPT8ff7GqYYP1H0+NnzLZJSpbMyFinJHfbT+8Vo7CAxfKuyviMhBYelaHfmFgWz2Bt2oFfYvzvnbESg4YUMJxijnZS1biwU9E1i6LAnGaerh0eXcnwXUWX7CU4DRG8Um18Teg/IdPj4Bv1pa4blFapy3YlvftCpCMt0BMIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700736; c=relaxed/simple;
	bh=zl1vlMzaSN4qOE+81RQpu459HzRgtWGYdbUgv3ZvSa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=up4W+2aWEl2mSXLfZo7jg7RWEUagHVReqCq5U+iRqWCM4sztR+fbPOp7EsPxiklz+7HZOiM9TbyKv0/CzyZoho60JITJuuO2UsB2rk8HmCQgBrylyks5yGD+LUGI5jdijs3x7/8VV94nrtkKkwMc840b1NSuD6cExPmSMFi4Z7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9IDDBNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9IDDBNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFE9C19425;
	Mon, 20 Apr 2026 15:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700736;
	bh=zl1vlMzaSN4qOE+81RQpu459HzRgtWGYdbUgv3ZvSa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O9IDDBNVRGAIrU6vDSkfhDO8so8o1TLgQw1ivcCA4nKHxjGlApfBqeFX65ItU3Qbj
	 ldhENsJ1++78RvZYONis87obU2+rCVHX1GwRfRlBg+1R55Y8jY0CbnDotNC37sBnmn
	 RZcNHkf3bA4A6iMJG0xn2kuBt7cOTawXHR2yCdPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/198] drm/vc4: Fix memory leak of BO array in hang state
Date: Mon, 20 Apr 2026 17:40:45 +0200
Message-ID: <20260420153937.989102810@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit f4dfd6847b3e5d24e336bca6057485116d17aea4 ]

The hang state's BO array is allocated separately with kzalloc() in
vc4_save_hang_state() but never freed in vc4_free_hang_state(). Add the
missing kfree() for the BO array before freeing the hang state struct.

Fixes: 214613656b51 ("drm/vc4: Add an interface for capturing the GPU state after a hang.")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Link: https://patch.msgid.link/20260330-vc4-misc-fixes-v1-2-92defc940a29@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_gem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_gem.c b/drivers/gpu/drm/vc4/vc4_gem.c
index 255e5817618e3..6238630e46793 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -61,6 +61,7 @@ vc4_free_hang_state(struct drm_device *dev, struct vc4_hang_state *state)
 	for (i = 0; i < state->user_state.bo_count; i++)
 		drm_gem_object_put(state->bo[i]);
 
+	kfree(state->bo);
 	kfree(state);
 }
 
-- 
2.53.0



