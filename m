Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAC938BF6A;
	Thu, 30 Jul 2026 16:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427714; cv=none; b=O6BEp/CwmUdSsJdFAm2+jQtBVttGU3VOqvx+BViUDZ1lwQK7W2Sj2TgpGI0lIzwIg6p5titUXDENXw6cL1VfWDoZd28qLd3lXVHGz96/5hGUaEulMAV+AZwUzMWU9mCQo4BMLwn5UCHHe/2GXEKPnyfjHQMd0Hkaxi8jGk7H514=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427714; c=relaxed/simple;
	bh=Qx/1TTkCaW9LXZiG1hSBqF0Wt1EeyTRK7VBMIif131g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlHQTbzcJZl1JIIORTTwLfuhZsLUhzN82CpdWRxf1in9ekJrkfmkhAGUPDAtLa1EVay4OP6in9GBQAXL+yv1LcPwi1zBu8LA/9heV6onGMYX0Rwid9ovtclBgz75GJz2ibT2LXUfWhuOPMXh4pQU15+MOneN+UBAT5eaNDApe7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKrHKZoI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKrHKZoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746F51F000E9;
	Thu, 30 Jul 2026 16:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427713;
	bh=21Cs7aaBUbaDfbRiyyVRrw/CBTnlsoTldUcrjLXiENo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKrHKZoIdoki8kuJjdqKmyM9rcv6CrmljNcqCNRiLJPEdKRxFAeziMnjpsvhDwU5i
	 I+K1u/dW/v6s6DhE4SEkgjUyHN+62phxNwtsLD24VqeTg09UumBBoAXR8VNzu1DNIC
	 +kzP7/wvI8YSBghrag74SN5nDvlF1T7tZIJKiALg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 230/484] drm/amd/display: set new_stream to NULL after release
Date: Thu, 30 Jul 2026 16:12:07 +0200
Message-ID: <20260730141428.474216627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
@@ -9534,6 +9534,7 @@ skip_modeset:
 	/* Release extra reference */
 	if (new_stream)
 		dc_stream_release(new_stream);
+	new_stream = NULL;
 
 	/*
 	 * We want to do dc stream updates that do not require a


