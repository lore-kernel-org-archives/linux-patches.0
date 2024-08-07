Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5951823DE;
	Wed,  7 Aug 2024 15:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043005; cv=none; b=hThrwkXYa91vH7bB+8fRBEFACf/GSuQyBorsil7t9it/jzw1RsX/+QSfRkTOVr4Uoqo0SrQVsqrkFnqe58caiz/B/Jofne+dlaYha40lfo3/bZpjp7KjQW4zhnJ+oQXTfHSU82UwwO/9tXfWohRNhbCeGsnF4XwKRj+6ubXr4TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043005; c=relaxed/simple;
	bh=8iIuAjNOFqq5giQbDAxeOfpDlQLvi/YlWkgeCN/M5ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XNEX4iukOMdpKQNOtw+SDN1Q6dyWgPjEWcs03dYaRkXxotgovUBon/zL1rW4Xdgd7JfSxTPjEKaF1lXAOZqVcihX1fmmXImLMD07XRWu3vHTzOEGoFdsDST4+rMPAZAiW8gSMRXMAB5SbtHHIeaDL77p5Hjdjy5y1mLXFTnbMFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S07h6//7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S07h6//7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DC5C32781;
	Wed,  7 Aug 2024 15:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043005;
	bh=8iIuAjNOFqq5giQbDAxeOfpDlQLvi/YlWkgeCN/M5ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S07h6//7Hb6kcP6jA2Wgufs/2+aJyet9zgvCH47kJ6w/a0vphzTHN1qms8o2rV8nb
	 EIY3cBlvhRQJaHVRdg+hB6Yxe/Trdf/XXiqOq2WBzHuScdbh0Ef05nKYpS5q3tggVJ
	 hExv+40CkWKrYv8yZLTwIneGilaZ14jkbOErqJ8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Simon Ser <contact@emersion.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 055/123] drm/atomic: Allow userspace to use explicit sync with atomic async flips
Date: Wed,  7 Aug 2024 16:59:34 +0200
Message-ID: <20240807150022.588543444@linuxfoundation.org>
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

[ Upstream commit e0fa4132bfae725a60c50d53bac80ec31fc20d89 ]

Allow userspace to use explicit synchronization with atomic async flips.
That means that the flip will wait for some hardware fence, and then
will flip as soon as possible (async) in regard of the vblank.

Fixes: 0e26cc72c71c ("drm: Refuse to async flip with atomic prop changes")
Signed-off-by: André Almeida <andrealmeid@igalia.com>
Reviewed-by: Simon Ser <contact@emersion.fr>
Signed-off-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20240702212215.109696-1-andrealmeid@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_uapi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_atomic_uapi.c b/drivers/gpu/drm/drm_atomic_uapi.c
index fc16fddee5c59..fef4849a4ec21 100644
--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -1066,7 +1066,9 @@ int drm_atomic_set_property(struct drm_atomic_state *state,
 			break;
 		}
 
-		if (async_flip && prop != config->prop_fb_id) {
+		if (async_flip &&
+		    prop != config->prop_fb_id &&
+		    prop != config->prop_in_fence_fd) {
 			ret = drm_atomic_plane_get_property(plane, plane_state,
 							    prop, &old_val);
 			ret = drm_atomic_check_prop_changes(ret, old_val, prop_value, prop);
-- 
2.43.0



