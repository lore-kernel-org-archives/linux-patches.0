Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159FA47124F;
	Wed, 30 Sep 2026 15:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783111; cv=none; b=E9VBv6NO2seHskDnor7QwGGrVbRbNs/sPrji5XaDGr589xuskcAlbOD9eVYfA1XcFbUYqWTK7ToL+44P/jb2rKGKHIyezldt65eY1mSlAOWri0hKXKwIBAIIjaGzmwTdddTdtoeKAPJ3PAHr5GNI1rCNPm7tTcK9XYzGEcm+cf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783111; c=relaxed/simple;
	bh=FltTk7UhXuIr8Ax9z+7UhsNCadnhRnJJaJrcOlw+vwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4pD8exwCe4J6/KgtY6RLjAFQznpeojQnu10ilRN70ApaJjfHeZaESs9RD16pQa1P3bMwU5og/EzZQ2UHvYVMN+V0nqLSYS9OfkLZHALkBXBAPq2Qrb+jze4fy5SjHAoyC3/XJVblwshTt/C1HaTIfPXBFgKl4oAStgRJAn1t6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3uUO2l9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3uUO2l9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F26D1F000FF;
	Wed, 30 Sep 2026 15:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783106;
	bh=n/fgamYDlCmMg7crBpaHfyYfeXO3E324pZ0KHHp9b/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3uUO2l9CHty1r5/r1cQHkId6oo9yrjesgmsulkmp1nNsDGcAGavDTHqGnZt99rPX
	 Jgt18z8FuzBVuR5jdJLB/AHAGKbXB7y57+wvkyo6NlhHGb5BOo8uoEJ9eLweT4fD/9
	 PXTR5qOvvw7mAKqg24fc3uoS30fZ9hL6RIrW9fjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 282/595] drm/amd/display: set new_stream to NULL after release
Date: Wed, 30 Sep 2026 17:22:55 +0200
Message-ID: <20260930152353.766614975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index bd15de4dee75e..b8dc14ea42032 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8448,6 +8448,7 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 	/* Release extra reference */
 	if (new_stream)
 		 dc_stream_release(new_stream);
+	new_stream = NULL;
 
 	/*
 	 * We want to do dc stream updates that do not require a
-- 
2.53.0



