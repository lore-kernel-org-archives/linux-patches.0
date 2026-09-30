Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD8A345EDD;
	Wed, 30 Sep 2026 18:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791606; cv=none; b=aKOqnxwzRjEO7kXHaFWZdFY18ieb2q9pLdmYDryQhnjA0bt3wKfl6CF8kpGjLQDJPZ9C+7gGMjK9DfWB3Bv4HmtJ2ooKrcQ727X1tKWl5aUgPC8wngrf/okfNmaxe3jOVE8Tu43DtYCXOli2Oc1fywn3v1q/2AWRGw10ssaSBWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791606; c=relaxed/simple;
	bh=eBdgcYE8W/yUoO3oNhtL+8IDkPqmiXmTQc10PqNzNHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUQzQLujYp355cMII1ftT4fCtWosrry+PVOXevk+5mw9QslMG4B/B2/xUe5RVuB4AEdVcKngq90TG93JgAm90ZCZy6JF7zmYPIR9fsfrIbz4Uweuz6dhwnu329yzg85iTJ8NGBRAxucmVXDsYeKfd+jTCQiS9nUEd6g2r7YZk/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBSyudN9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBSyudN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E23E1F000FF;
	Wed, 30 Sep 2026 18:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791604;
	bh=KOY9HXEg6+QvY2p9OnXzqNByC/S8tlsYowPpO7S48hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBSyudN9drFdiXqKD/NkQusHQfg+dkzIWdaiiAHuRHc/r3J54Rse1tispDu9umvXl
	 G6G1N9M7HpqmLz0H/5joqBmmt4B1gYvyumSpo9nyzLgcpScwrdnjZ8W/yOD+8TDrOK
	 Jz1JacfoTqd5bOuZpESueazNqyvFSXtOzay8KXfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/752] drm/amd/display: set new_stream to NULL after release
Date: Wed, 30 Sep 2026 17:23:49 +0200
Message-ID: <20260930152406.051504264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9a6c0b17745e5..4530d22139355 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10484,6 +10484,7 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 	/* Release extra reference */
 	if (new_stream)
 		 dc_stream_release(new_stream);
+	new_stream = NULL;
 
 	/*
 	 * We want to do dc stream updates that do not require a
-- 
2.53.0



