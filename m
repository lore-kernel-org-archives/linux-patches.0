Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2221218733E;
	Mon, 12 Aug 2024 16:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480127; cv=none; b=l9cjwJ0XKDluEjLuQXcslzcuDb3wWS1k66TW1bjLw5p5C2/SP8u8dEnEBEUjNXfwli7pypsjPGtge0VRRSjN8cNgQR4PGOC9tRSwbDAhwqlPkPw+8y/LfRM+LUWY6yPLDPpZN8dGrCvYDm5Fu2sKPYzoOPQewzMtIl/KN9dKPCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480127; c=relaxed/simple;
	bh=haWARogmQOKl9HJRefy3pBmbggN5NdLHwg9Hcbka02Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZPr1lYEcGjSMMVJfHgRJSAYe78SrWR7af7J03XysvtgWQAvn1NMWoKgL5LFPILBY6Cr9cWzljUnLUuh51EOryoINM7V6GdaDgCjU4X6shOD1n4BGpooJqN4a4rox7mY7b7GEJ+Y4si+KguYmsgpCOPcdkOTqAE5IESSdKSOrPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtXJAhee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtXJAhee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816F7C32782;
	Mon, 12 Aug 2024 16:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480127;
	bh=haWARogmQOKl9HJRefy3pBmbggN5NdLHwg9Hcbka02Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtXJAheekwWLR08E/Psm+l00WkouFMHzHfZDTHMU9UaqB6gnwZ/vWw6vpAipyot68
	 2+NLMky0pVOGagvQWsSumEM2U8zMt8OZzkCFVJnVUoxpeuQBkO4Q1A6FAgpnf94Ijb
	 BMJI+d1w60BQNX6wGzX3kjx3KuevT3AtSHltV53A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Zuo <jerry.zuo@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 104/263] drm/amd/display: Dont refer to dc_sink in is_dsc_need_re_compute
Date: Mon, 12 Aug 2024 18:01:45 +0200
Message-ID: <20240812160150.525643338@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c  | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index e90f9d6975111..7c405ffae1a3d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -182,6 +182,8 @@ amdgpu_dm_mst_connector_early_unregister(struct drm_connector *connector)
 		dc_sink_release(dc_sink);
 		aconnector->dc_sink = NULL;
 		aconnector->edid = NULL;
+		aconnector->dsc_aux = NULL;
+		port->passthrough_aux = NULL;
 	}
 
 	aconnector->mst_status = MST_STATUS_DEFAULT;
@@ -494,6 +496,8 @@ dm_dp_mst_detect(struct drm_connector *connector,
 		dc_sink_release(aconnector->dc_sink);
 		aconnector->dc_sink = NULL;
 		aconnector->edid = NULL;
+		aconnector->dsc_aux = NULL;
+		port->passthrough_aux = NULL;
 
 		amdgpu_dm_set_mst_status(&aconnector->mst_status,
 			MST_REMOTE_EDID | MST_ALLOCATE_NEW_PAYLOAD | MST_CLEAR_ALLOCATED_PAYLOAD,
@@ -1233,14 +1237,6 @@ static bool is_dsc_need_re_compute(
 		if (!aconnector || !aconnector->dsc_aux)
 			continue;
 
-		/*
-		 *	check if cached virtual MST DSC caps are available and DSC is supported
-		 *	as per specifications in their Virtual DPCD registers.
-		*/
-		if (!(aconnector->dc_sink->dsc_caps.dsc_dec_caps.is_dsc_supported ||
-			aconnector->dc_link->dpcd_caps.dsc_caps.dsc_basic_caps.fields.dsc_support.DSC_PASSTHROUGH_SUPPORT))
-			continue;
-
 		stream_on_link[new_stream_on_link_num] = aconnector;
 		new_stream_on_link_num++;
 
-- 
2.43.0



