Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA291514F6;
	Mon,  6 Jan 2025 15:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176972; cv=none; b=Zr8ojwGGxElEZMdZSlaRnKGJHaaMScBgSqB8L1/i8dJPYq3jaacUvOo0zNthkj2tO4cBGeA4RKGwT7vh2UK+MXiBf9EnGASTIZ7iFa315er4unSu+OkUbFi951DaSLSC9V30Ea/QmiFbdlZ0mmadYXkjQDJVuMLeCV6ZKoe85qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176972; c=relaxed/simple;
	bh=e66OccoO4nNkOsSADb3bDNJOTMEhD+hZ0i1Ang4i+EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0hHTfPoMh43+acX/SYYB4RMrhwdx3sB1tEWi/8pmyxpanHOfRXAltIRKigQt0Vc9vZ8MtqgWd1QHUmV31n5yhQM1cvbVMkS4GNY2P3G2zYzhmxsQabk1KW2iY9GcoXa/kMXnMu0URN33T73QS3hpw/VNWQeu7X/jHqI71jhOlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdsD3SWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdsD3SWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92828C4CED6;
	Mon,  6 Jan 2025 15:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176972;
	bh=e66OccoO4nNkOsSADb3bDNJOTMEhD+hZ0i1Ang4i+EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdsD3SWOcgq7NuIxpmf2yjMUUNXzmZAeJxn1goGYoagFqGbKrnCaqWboLFYB9Y2Kz
	 dlHG3x3nd1l/FFRPFg+y1mNKa5g8VmeFhoJeVSakZYxQXQB12zxegaiNE43VVKtZkB
	 EwnP4FZZoV5jw1FaKvp9MWaQttCpLwJK8rocCxhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Swapnil Patel <swapnil.patel@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Agustin Gutierrez <agustin.gutierrez@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/222] drm/amd/display: Fix DSC-re-computing
Date: Mon,  6 Jan 2025 16:13:25 +0100
Message-ID: <20250106151150.648368871@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Agustin Gutierrez <agustin.gutierrez@amd.com>

[ Upstream commit b9b5a82c532109a09f4340ef5cabdfdbb0691a9d ]

[Why]
This fixes a bug introduced by commit c53655545141 ("drm/amd/display: dsc
mst re-compute pbn for changes on hub").
The change caused light-up issues with a second display that required
DSC on some MST docks.

[How]
Use Virtual DPCD for DSC caps in MST case.

[Limitations]
This change only affects MST DSC devices that follow specifications
additional changes are required to check for old MST DSC devices such as
ones which do not check for Virtual DPCD registers.

Reviewed-by: Swapnil Patel <swapnil.patel@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Agustin Gutierrez <agustin.gutierrez@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 4641169a8c95 ("drm/amd/display: Fix incorrect DSC recompute trigger")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c    | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 9ec9792f115a..b4bbd3be35a6 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1219,10 +1219,6 @@ static bool is_dsc_need_re_compute(
 	if (dc_link->type != dc_connection_mst_branch)
 		return false;
 
-	if (!(dc_link->dpcd_caps.dsc_caps.dsc_basic_caps.fields.dsc_support.DSC_SUPPORT ||
-		dc_link->dpcd_caps.dsc_caps.dsc_basic_caps.fields.dsc_support.DSC_PASSTHROUGH_SUPPORT))
-		return false;
-
 	for (i = 0; i < MAX_PIPES; i++)
 		stream_on_link[i] = NULL;
 
@@ -1240,7 +1236,19 @@ static bool is_dsc_need_re_compute(
 			continue;
 
 		aconnector = (struct amdgpu_dm_connector *) stream->dm_stream_context;
-		if (!aconnector)
+		if (!aconnector || !aconnector->dsc_aux)
+			continue;
+
+		/*
+		 *	Check if cached virtual MST DSC caps are available and DSC is supported
+		 *	this change takes care of newer MST DSC capable devices that report their
+		 *	DPCD caps as per specifications in their Virtual DPCD registers.
+
+		 *	TODO: implement the check for older MST DSC devices that do not conform to
+		 *	specifications.
+		*/
+		if (!(aconnector->dc_sink->dsc_caps.dsc_dec_caps.is_dsc_supported ||
+			aconnector->dc_link->dpcd_caps.dsc_caps.dsc_basic_caps.fields.dsc_support.DSC_PASSTHROUGH_SUPPORT))
 			continue;
 
 		stream_on_link[new_stream_on_link_num] = aconnector;
-- 
2.39.5



