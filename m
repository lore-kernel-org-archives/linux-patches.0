Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD604F4754;
	Wed, 30 Sep 2026 16:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785399; cv=none; b=MwWEaFKavpkHFqE/IDIefDZBfRpO6TXz7XXbkQ+3VXJkwmYYxslkLarPMYtVqIFiqJU4CQqKibCbQoZsZ6oHIEiM+yOCiLbC2xVfAbEnH5aeD+v+Wfv/nse2rsfKUHMDNg7rLSyC4lsgfjTHG7VwY6GVpgs42KFdvMLFFdaontc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785399; c=relaxed/simple;
	bh=nW0CQT3hvppjMG8FKbLLAIZsmGLgM80xPomWr8ikAhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXVg8QjK844n+0+16MofqzuXOzArTJXSHt2giSvOKmh1jdgjmunx99JvLcDdEHalCbvjVFoZOxP+0m/9/eE+NdvqOEr2g5XX424QkJM8sKuMb2h7r++IvanCWnRx/XVwf3Flq/ByH2ORVVlrFTB+Y32hQTPHNSjzVgNW7RDFYPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGTWV6Ay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGTWV6Ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1BC1F000FF;
	Wed, 30 Sep 2026 16:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785387;
	bh=Kpygkz5ZW1SQWo1znmlypG/OyE9yoiVlsxVxyP15s58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jGTWV6AyDrTvvbE7PqfJuFR5vxrGZzQNXBksdOcD4PH+u64yjJhlft5XRAYKMWl9g
	 0XtBqq8vsOgO3KOcGHncXLESxM1TGYXq+BNLxdlLP7/JuSQSf0HtzCtfaB0SRUNeji
	 eHV1NV1gS+oPCLn1uJAm1eMsweeP045SkNNI0ja8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 489/982] drm/amd/display: set new_stream to NULL after release
Date: Wed, 30 Sep 2026 17:20:25 +0200
Message-ID: <20260930152427.285544727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bb5e3a6086f2e..deaf98957cb76 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9293,6 +9293,7 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 	/* Release extra reference */
 	if (new_stream)
 		 dc_stream_release(new_stream);
+	new_stream = NULL;
 
 	/*
 	 * We want to do dc stream updates that do not require a
-- 
2.53.0



