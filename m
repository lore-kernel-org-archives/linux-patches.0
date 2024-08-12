Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE55515C127;
	Mon, 12 Aug 2024 16:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480672; cv=none; b=q9Kyo3wI7HCRZ7mC47hTr9qEPxZkYdeq+AWy5ZQmaNYDeYJVuwC9ZRgytoygWEVx2sAoixuwBv8PeN9SvGSjhvNB/fCdnMWpY0KhuWVenHSkaWcqTdBANTMn/TrOzJqoZctlk05s9OLbGOfOek9ytFYL1ST4OPJRZjLKx587TEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480672; c=relaxed/simple;
	bh=V+lyD9PUka1dFCus5eGc/d5LL+/hKkANUX8ataPVOro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvSMsRyUTLPhGhYxvkYBIVwborhyw7x0UL+LSeCURUoZT5kDgehwMkbLgNS6gWyEDJQ9xVnMKuWmCufg86Fkx0byFt5xVfwCQRWuEJPKcakIWqrPZAcFxtiYPh3h9kebsnWaMBNX8mxYUaQ6cL2+v3MpBlpg4BCdAK8xgDq5OXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDI1KZlW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDI1KZlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E263C32782;
	Mon, 12 Aug 2024 16:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480672;
	bh=V+lyD9PUka1dFCus5eGc/d5LL+/hKkANUX8ataPVOro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDI1KZlW2z4Tn7jvp6nBjqSzmJ5JJzGfVJDpDxA4HjB565+DgdiyL5VHlBzac641S
	 YVjKBCnGfFZ163krfE5qdA3d5JPZpo71YicLcUgFfsvW22dqBIUbfMMiHFUAFWzL0y
	 AQjYP/ESFOW8lM2Fv8kiASb1z7YNTOt3O696p0SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.10 257/263] drm/amd/display: Defer handling mst up request in resume
Date: Mon, 12 Aug 2024 18:04:18 +0200
Message-ID: <20240812160156.489958533@linuxfoundation.org>
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

commit 202dc359addab29451d3d18243c3d957da5392c8 upstream.

[Why]
Like commit ec5fa9fcdeca ("drm/amd/display: Adjust the MST resume flow"), we
want to avoid handling mst topology changes before restoring the old state.
If we enable DP_UP_REQ_EN before calling drm_atomic_helper_resume(), have
changce to handle CSN event first and fire hotplug event before restoring the
cached state.

[How]
Disable mst branch sending up request event before we restoring the cached state.
DP_UP_REQ_EN will be set later when we call drm_dp_mst_topology_mgr_resume().

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2418,7 +2418,6 @@ static void resume_mst_branch_status(str
 
 	ret = drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL,
 				 DP_MST_EN |
-				 DP_UP_REQ_EN |
 				 DP_UPSTREAM_IS_SRC);
 	if (ret < 0) {
 		drm_dbg_kms(mgr->dev, "mst write failed - undocked during suspend?\n");


