Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F61274650;
	Thu, 30 Jul 2026 15:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424402; cv=none; b=nFD6Lqe8+77Ux+6mUUsoKZSzqUKQM3Q4EVUv8Whav9nruV2YKF+EiLO5MhOsc8s80rUY2h/72nO0h3A2aF/5B3QAxMV0Y91tpZfjv8gZJHfdChsw4PNO8KlNIbTyPvw6Nwr2QfjEvDDFY/eSygBFnXgckGBxpbJR1ilvd4rG8Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424402; c=relaxed/simple;
	bh=UsQa8o2oBCQPIiNfeThx/eumuA+PnjVhVwCYjpBxYLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYkL6ObDZLQFKZ0o231KxmcshsIaWPfhM3KGWgxfuQCoIvg934pYTjNPwpTXLAC8c7PMvIZJSiVV9QYTGqA5yiVJJDaTD9/5CTfc2mOliGuIFbmosvw1om04faSjzi+t29yHBjwqQrBMg8JA4xJZ6JJVr0/NtLLvN6aqyyY5mEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFQbgKSk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFQbgKSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F531F000E9;
	Thu, 30 Jul 2026 15:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424398;
	bh=DMKNiJOvQ3z5hLbGQ0sEzyFBALVvwt2wm17tYwqOJYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFQbgKSkOGENuk/6Zp+5gVY7SR0YFc5hs2QN35nDBhhRM/aisk+RgiYB6fKl5ysAI
	 VKpzQCjgLEI9qq1O/nKPdncyPw54e4z6pv+P7o3auAcZ8RVsXYfXbO8dgnPBPwEAoE
	 rkNFZEcvwLhwNcz02w0kxblRoDDJBUXLv/6VdOjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 380/675] drm/amd/display: set new_stream to NULL after release
Date: Thu, 30 Jul 2026 16:11:50 +0200
Message-ID: <20260730141453.213200361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -11383,6 +11383,7 @@ skip_modeset:
 	/* Release extra reference */
 	if (new_stream)
 		dc_stream_release(new_stream);
+	new_stream = NULL;
 
 	/*
 	 * We want to do dc stream updates that do not require a


