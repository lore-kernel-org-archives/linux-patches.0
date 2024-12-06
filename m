Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D32D32C8B;
	Fri,  6 Dec 2024 14:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496679; cv=none; b=hFfnZshz1zhXDRZmJMJKVsJV+UnDtCdcdn8NOYSJfwuvl9bY2ZEdJXFcE/VEit+FosERJ7I40QfbYtEPP5uYVC3oGA+vPoFwUI5q7zawDFOTU6J+hBaRp3DOc/2UoYUg6TiilBz4AqD9AqXr7vguKZfNH1UDsZGHCq/m6bYUSnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496679; c=relaxed/simple;
	bh=IZQXDEEM4oYvVEWUxw9qKP0WTErRUHgOVYZ7wxGNXGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUFRRRblUS96QVky5GXy67OWjwnRsfpTAGv5WCtur6Cn2Cmk8sK7YylEKkFzRpGlp7OSR5+O+4oDBuCqxm7gt89YYnoM513GmZxbN20P/dseqnWreYXZYBsU6xcAPMX6BQPhlKv6/Vo3ct5hrP3UsXFIocj7KoIFgZeDEOw61Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzxnB0U5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzxnB0U5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56D6C4CED1;
	Fri,  6 Dec 2024 14:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496678;
	bh=IZQXDEEM4oYvVEWUxw9qKP0WTErRUHgOVYZ7wxGNXGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GzxnB0U5N1W48/CcTvZE92Mnoju4rnSxJn/1nTut/xU3F0MGLQdAYjWY6UDXB/vyE
	 Kq+KjzOZAUinN1HHFkIi0vnomZfgFXy4m8mUs1uITv3ZWlByY6575Lpo6oESS3+IhZ
	 h0XH19d++FyQv2v62mS6oaz7an3nYKFYkjWvMOzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Zuo <jerry.zuo@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/676] drm/amd/display: Dont refer to dc_sink in is_dsc_need_re_compute
Date: Fri,  6 Dec 2024 15:27:41 +0100
Message-ID: <20241206143654.997133189@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wayne Lin <wayne.lin@amd.com>

[ Upstream commit fcf6a49d79923a234844b8efe830a61f3f0584e4 ]

[Why]
When unplug one of monitors connected after mst hub, encounter null pointer dereference.

It's due to dc_sink get released immediately in early_unregister() or detect_ctx(). When
commit new state which directly referring to info stored in dc_sink will cause null pointer
dereference.

[how]
Remove redundant checking condition. Relevant condition should already be covered by checking
if dsc_aux is null or not. Also reset dsc_aux to NULL when the connector is disconnected.

Reviewed-by: Jerry Zuo <jerry.zuo@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ Resolve minor conflicts ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index d390e3d62e56e..9ec9792f115a8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -179,6 +179,8 @@ amdgpu_dm_mst_connector_early_unregister(struct drm_connector *connector)
 		dc_sink_release(dc_sink);
 		aconnector->dc_sink = NULL;
 		aconnector->edid = NULL;
+		aconnector->dsc_aux = NULL;
+		port->passthrough_aux = NULL;
 	}
 
 	aconnector->mst_status = MST_STATUS_DEFAULT;
@@ -487,6 +489,8 @@ dm_dp_mst_detect(struct drm_connector *connector,
 		dc_sink_release(aconnector->dc_sink);
 		aconnector->dc_sink = NULL;
 		aconnector->edid = NULL;
+		aconnector->dsc_aux = NULL;
+		port->passthrough_aux = NULL;
 
 		amdgpu_dm_set_mst_status(&aconnector->mst_status,
 			MST_REMOTE_EDID | MST_ALLOCATE_NEW_PAYLOAD | MST_CLEAR_ALLOCATED_PAYLOAD,
-- 
2.43.0



