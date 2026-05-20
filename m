Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654042D7386;
	Wed, 20 May 2026 18:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301965; cv=none; b=qicrEVU/Ks8Lop8L47AFLr0CSgkX23KAdVJfRqSQB9R3wc37YvIf9IpyK7qyMFtQIWDPo+F0qPWoe1hpxzE1JodaBdJFVSpgjrg0mnqjK18i5OS6wx6D54NqVQeksU+tRlVsHm9x9LDensom2oaMXSz6fKtObOVUpG5Z2I7tP4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301965; c=relaxed/simple;
	bh=cv4vzI+RC5DaQJE25PQrp5YtXm0CVyFIXhhvliKaG90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZapo20Sbmn4U/nm+Rkn0k/DvLFj47ABv6G8rUg+8uxFsXq6odKfwJDys/l7skhbZVkZvodhLhQdV0A/Re6ecVqKVp+0wjWZGzL0Txgvh6bZ4kHSs/uprcY30dAxn4dDV3Sm2Xay1LGHMy/UyKLjE66UilVtCxbGgmt244rU18M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKpq6IcV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKpq6IcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7BF1F000E9;
	Wed, 20 May 2026 18:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301964;
	bh=QzvbhjSoj94qXSvArTBywkk5h9aotRk/VZTglCTzUjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PKpq6IcV6G8f6eJe/tCEiivVG7Fo5kVF/tKp4tDzcfVQ3VNxS7D2fkFzw+c++5ZS8
	 WO/aHrv74VBTwY6yTId9gYsq93kVoYGPqWLnUH765sqrHk9xgpQn+hpIR/Ff+80S2h
	 WYFc6CHblC5ZaInU1t7krMzF6kH8f7sEQBi0Ulww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/508] drm/sun4i: backend: fix error pointer dereference
Date: Wed, 20 May 2026 18:18:31 +0200
Message-ID: <20260520162100.520029821@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 335fd0edb904c..6a2ffaa477ab8 100644
--- a/drivers/gpu/drm/sun4i/sun4i_backend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_backend.c
@@ -488,6 +488,9 @@ static int sun4i_backend_atomic_check(struct sunxi_engine *engine,
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



