Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2881386BF;
	Wed,  7 Aug 2024 15:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043008; cv=none; b=oVNyHn4RSi2ozc4FAx/L3GPLTAxIYJRzN7yeRG+JclaMGVY5Fkumq+JNzDk44Jjrn50n9+LKFzhHsvkL1LHdgfylNoi60V7BrmZEvfO4dbGGNmciODi7VTCQ3XY4jf0PZm/np0L+BCPql6DqoKDEM624eEl3kUCbzYFTsJMydbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043008; c=relaxed/simple;
	bh=GD0kS9ImEO2TufM/xbtg0+8g1HcST8XDbSbKHqs39Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aIHUsjm6zs9d4MsfhWLPyAF8mpJSZ64uzliT/nhMqPAVNd8y/YpN+wEPasvbBXY5BkMyXtuPDnkxEyRv7IriUeY38CJGRd+tmdcQmWXPHQHpTCEjLSsqIcqbRJQ4xUYBYIXN9qqL0mHh6TnwzEtU/SsNmrZSZW2yWi7h1UdGZXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLAV+fAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLAV+fAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D69C4AF0B;
	Wed,  7 Aug 2024 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043008;
	bh=GD0kS9ImEO2TufM/xbtg0+8g1HcST8XDbSbKHqs39Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLAV+fALaKFmV5z5FzDo4ld0TVEIBU3CKu3DlvAzZFBlxBplHje/naCqmCh11Hz4r
	 Phad8vw3J/YqpWXoD1jpkPMWW1qBOUZuEdvAVJN9S2KI9lV6wunra9Z8S26hXijUyT
	 R1DPjYtX9y1N6eDCREFRJ7AHcNXG66xe7MXU/f6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Simon Ser <contact@emersion.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 056/123] drm/atomic: Allow userspace to use damage clips with async flips
Date: Wed,  7 Aug 2024 16:59:35 +0200
Message-ID: <20240807150022.627441729@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Almeida <andrealmeid@igalia.com>

[ Upstream commit f85de245c6a8e2654e1e9158588bcf78e38cd5a5 ]

Allow userspace to use damage clips with atomic async flips. Damage
clips are useful for partial plane updates, which can be helpful for
clients that want to do flips asynchronously.

Fixes: 0e26cc72c71c ("drm: Refuse to async flip with atomic prop changes")
Signed-off-by: André Almeida <andrealmeid@igalia.com>
Reviewed-by: Simon Ser <contact@emersion.fr>
Signed-off-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20240702212215.109696-2-andrealmeid@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_uapi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_atomic_uapi.c b/drivers/gpu/drm/drm_atomic_uapi.c
index fef4849a4ec21..02b1235c6d619 100644
--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -1068,7 +1068,8 @@ int drm_atomic_set_property(struct drm_atomic_state *state,
 
 		if (async_flip &&
 		    prop != config->prop_fb_id &&
-		    prop != config->prop_in_fence_fd) {
+		    prop != config->prop_in_fence_fd &&
+		    prop != config->prop_fb_damage_clips) {
 			ret = drm_atomic_plane_get_property(plane, plane_state,
 							    prop, &old_val);
 			ret = drm_atomic_check_prop_changes(ret, old_val, prop_value, prop);
-- 
2.43.0



