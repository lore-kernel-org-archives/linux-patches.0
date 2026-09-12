Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2EC3B42E7;
	Sat, 12 Sep 2026 07:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196791; cv=none; b=Ft7HEkaCzJL4+nKFa1gllGCisuiDCG4jqWBpjzj8lBvndyYGROPOPRRJv/FV/mZQhdsRTT3yzh8s2++BxhcxdioYhAcem9+zSJIx1G2mpvrwH9+SigEZSJK8D0PjbrHBJr9xSUgUw9wbLO9hlv1DgpaymoZcgk4gd8NGzL39STA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196791; c=relaxed/simple;
	bh=I4yvu6qvFnsP8UNyykwZ2JSHvR8QprSAU3E2rEIxkZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azMtFXYO4NuVoesm3bazoTFvnMUIicufzvQd7LcqQL7nxeKh3FKHIAUffNkYj1RJrYGpOzALaem0qbXDz0TxXc27zEHSiy+TmiBNMhi3R64jUgyzz32v9BSNAqpqnl00y1o4U39AHB7yVy3QKERJ1iBSmeiO6B0xb5ZW7YVlpIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEK5ouKV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEK5ouKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CD61F00898;
	Sat, 12 Sep 2026 07:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196787;
	bh=Z1EufiFXPWEkmMg3x+5Nl2PEFtU+Ap1S3BJWjneWXq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEK5ouKVkaw6P/NzLpM3GbTkUccWUtQdtcv/0s0PPdtVQMx/qwxaEsT6/xAZffsdo
	 OQZ70xfaWUoSnKMbtxVh4UI4t3A98IfrWVHRnLyvGzuVlmThxcWVZe1Zvg6mK+XMSe
	 //AzKVTeDMyU3HQLxKoGFd5HygjXDsWmRwvgeLWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0036/1815] drm/atomic: Drop drm_private_obj.state assignment from create_state
Date: Sat, 12 Sep 2026 08:29:46 +0200
Message-ID: <20260912065649.867931081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit dcf0292f4828341474428d016661b6c292d7211c ]

The initial intent of the atomic_create_state hook was to simply
allocate a proper drm_private_state and return it, without any side
effect.

However, __drm_atomic_helper_private_obj_create_state(), which most
atomic_create_state implementations call, introduces a side effect by
setting drm_private_obj.state to the newly allocated state.

This assignment defeats the purpose, but is also redundant since
drm_atomic_private_obj_init(), the only call site for the
atomic_create_state hook, will also set this pointer to the newly
allocated state.

Drop the assignment in __drm_atomic_helper_private_obj_create_state().

Fixes: e7be39ed1716 ("drm/atomic-helper: Add private_obj atomic_create_state helper")
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260526-drm-mode-config-init-v6-3-852346394200@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_state_helper.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_state_helper.c b/drivers/gpu/drm/drm_atomic_state_helper.c
index cc70508d4fdba..a82568d87e4f7 100644
--- a/drivers/gpu/drm/drm_atomic_state_helper.c
+++ b/drivers/gpu/drm/drm_atomic_state_helper.c
@@ -731,8 +731,6 @@ void __drm_atomic_helper_private_obj_create_state(struct drm_private_obj *obj,
 {
 	if (state)
 		state->obj = obj;
-
-	obj->state = state;
 }
 EXPORT_SYMBOL(__drm_atomic_helper_private_obj_create_state);
 
-- 
2.53.0



