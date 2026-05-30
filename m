Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C279B3469FC;
	Sat, 30 May 2026 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162637; cv=none; b=ooKbRs4lBU83hfj8oEkuIGxDcPjYqU6oJ6nevwZJeB3fvSpA6dOW18sbmZv6veO6h+VqOsKQZXSeZ9zpVi/feVsvuPD+2FExQLBjDI7xAJpjBprDq5Oo1QvuaJfd3BMfKb/QzvDC+rZejE/sO09yPXDSBJ7CImH8qJVhFsbwZ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162637; c=relaxed/simple;
	bh=MwmqgOCUfZW2kCireG6zp6KL1XsSyQMgEmtKVI141cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OTIbjU135F5IPMzWoIjvhp4ie2oDqy+89yQQMGx9wVn2DyxWMDL17SucAuFABRXZ3maSexOIMjcxlUNdgV0gQDF3sBAuJpiZb9VpE9JXh6abOSPqsP60qJuZz5pkxRg2qvnv/c6ml2oR+n+mIHyinUNHXppRMMudeqhHGJrY54w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWsevauz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWsevauz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123751F00893;
	Sat, 30 May 2026 17:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162636;
	bh=u54sG+XqeOQkZ0LgRCO+G6O0LSuy6rS0UYTc3lCR3sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWsevauzEwfnEEfLW6eyGkPgpYzWT5tz7rKzVVb3n0EGiJWrVFd3MUTVatFDL01F6
	 6hkuf+mRmK4X4r+Mj/PCKq/hOj2d30u+Cw/cl8rkxIagNFs/jKgQCO81FPU3dRxKYP
	 ZExRGa2ho5Dryrz5/LpC17ak2XU+xD+xJFjc5ZqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/776] drm/vc4: Fix memory leak of BO array in hang state
Date: Sat, 30 May 2026 17:55:34 +0200
Message-ID: <20260530160240.786130178@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 445d3bab89e0a..87900248d9f8d 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -60,6 +60,7 @@ vc4_free_hang_state(struct drm_device *dev, struct vc4_hang_state *state)
 	for (i = 0; i < state->user_state.bo_count; i++)
 		drm_gem_object_put(state->bo[i]);
 
+	kfree(state->bo);
 	kfree(state);
 }
 
-- 
2.53.0



