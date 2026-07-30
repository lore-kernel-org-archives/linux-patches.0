Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C999143B3F8;
	Thu, 30 Jul 2026 14:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422488; cv=none; b=EF9h2qNNrDWWdtK/29dgtNfGCeq64vAwuF7cB3y93Tg4EBO3pE+RQtoK3xzMMgoBgvyLWBjyPtVIqwwVM1ul2a0kl6RNDeWEDtNDVa2QuU7Kwllid4eWWF5MetXxpKD5PriReV+vjE25klTW4qNAF1KKAZrZ6e+ZPOCa0F4lWkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422488; c=relaxed/simple;
	bh=CCORwOGTaIS+kCc3U+dKzh1lndNTagZtaq86/qHzM9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ig5Xw3crHKxnSJSQJT6ddD2lcjlIzvHRdoZZhVrNqEHZNbUM/WJ9LkDOxV2xLwL9MjFO/CyxKPD6rYKkpIsv7HuwSQoe/kdE4HiHgNLZMi4Gn0MLZsfUvLMdzymmrPUwYHIeFutS0WCLLzXORK7CWY6MYPLsGsnf7JjVmLilXxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lm0wDBLI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lm0wDBLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318831F000E9;
	Thu, 30 Jul 2026 14:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422487;
	bh=BoSCxLZNa/Dm0w1wjEBveudcJCO8bxArv5aOIqHvTdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lm0wDBLInlBhxW7bHf0MHbCAMO5PjEdhG4wAfU0CP62LwRAxJAlT3aG0sb4jYbTyG
	 ZDc9KI64YwNG4Oz7XiFT4wruKstdxHn19itE8gIcaqYo4VHwsJzkftDHS5Tw73rV3q
	 by+TSDcG+e0/dXeF2I2RMWkYFNmka0PTg+12rzj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 454/744] drm/amd/display: set new_stream to NULL after release
Date: Thu, 30 Jul 2026 16:12:07 +0200
Message-ID: <20260730141453.947030448@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WenTao Liang <vulab@iscas.ac.cn>

commit 9fa26b9eed6195bf840f39ac183b9a6237548755 upstream.

In dm_update_crtc_state(), the skip_modeset path releases new_stream
via dc_stream_release() but does not set the pointer to NULL.

If a later error (e.g., color management failure) triggers the fail
label, the error path calls dc_stream_release() again on the same
dangling pointer, causing a double release and potential use-after-free.

Fix this by setting new_stream to NULL after the initial release.

Fixes: 9b690ef3c704 ("drm/amd/display: Avoid full modeset when not required")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 99f3af19073b3ddbfd96e789124cce12c4277b28)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -11715,6 +11715,7 @@ skip_modeset:
 	/* Release extra reference */
 	if (new_stream)
 		dc_stream_release(new_stream);
+	new_stream = NULL;
 
 	/*
 	 * We want to do dc stream updates that do not require a


