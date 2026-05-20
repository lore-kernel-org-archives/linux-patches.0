Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81A73A6B6D;
	Wed, 20 May 2026 18:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300370; cv=none; b=oH2TL299GyDZu6ektD6jIomZ3GX/g1f44BY2r8gQfyPIRSXfEOVP+6xHKHOxUuKwMCmHw5Exdhd+Gar3cXrBDr5Kg4xNg+rzKInoHreRyuayq0a6sP48piC0M8BqcqRdu3MXoqY1H4e68WViBUs068icZxo+b91t0hqYPRMv/50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300370; c=relaxed/simple;
	bh=g4yBgNbakceQEpSegLmwK8jkxr1MUmvhE7j70wwmdr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAFQ/XrRg5MyNcMtk1ViHz1AVif/m/ozOD2/phMGpvGzMVH+n/b5q28ocvaLv+oYTpSAMvZBWA33FK+c38H0VuF3OaT6MSZ0n6U64snfW5nKzCAzmD+RW8/d4YhFK/5EpqS1zSTOtbzYYlR8YglmyLa5WQ0XZaTOO7LU1bORGOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xY3ORxPw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xY3ORxPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2564A1F000E9;
	Wed, 20 May 2026 18:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300369;
	bh=uJn1KePT1vx3VOV/+fWqbvtQ1twjbpWQ+kguB9gt2Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xY3ORxPwXLhk8GddZBGzqy2BsKzVl3BcQu2kQ0NLJDIJaEU1GnrRrkgFFcUTIiw/j
	 Vsjs9/YY3MUcn/d/3Csg9S+Hk5aAN1JHm4l/X3BHJ4pzbDnBVTg67uCcSFdQSrAWGZ
	 rLbDEfw0BYViYq+TgD7lRcvApYPO9F9vPjQHYCUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/666] drm/sun4i: backend: fix error pointer dereference
Date: Wed, 20 May 2026 18:15:33 +0200
Message-ID: <20260520162113.861868090@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 06277983eca4a31d3c2114fa33d99a6e82484b11 ]

The function drm_atomic_get_plane_state() can return an error pointer
and is not checked for it. Add error pointer check.

Detected by Smatch:
drivers/gpu/drm/sun4i/sun4i_backend.c:496 sun4i_backend_atomic_check() error:
'plane_state' dereferencing possible ERR_PTR()

Fixes: 96180dde23b79 ("drm/sun4i: backend: Add a custom atomic_check for the frontend")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/20260217014801.60760-1-ethantidmore06@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_backend.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_backend.c b/drivers/gpu/drm/sun4i/sun4i_backend.c
index e89eb96d31317..a7c256e2c632b 100644
--- a/drivers/gpu/drm/sun4i/sun4i_backend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_backend.c
@@ -490,6 +490,9 @@ static int sun4i_backend_atomic_check(struct sunxi_engine *engine,
 	drm_for_each_plane_mask(plane, drm, crtc_state->plane_mask) {
 		struct drm_plane_state *plane_state =
 			drm_atomic_get_plane_state(state, plane);
+		if (IS_ERR(plane_state))
+			return PTR_ERR(plane_state);
+
 		struct sun4i_layer_state *layer_state =
 			state_to_sun4i_layer_state(plane_state);
 		struct drm_framebuffer *fb = plane_state->fb;
-- 
2.53.0



