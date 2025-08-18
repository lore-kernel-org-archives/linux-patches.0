Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D9A1E8836;
	Mon, 18 Aug 2025 13:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525379; cv=none; b=Y8dYLvc2fExHD3flWa9vm3+MXuav6Dx0hB9R7wT0spKPmPofKo8pkHiji6m60AjmTzNZfYm7LeaTeG2b8kLzip3R+WWLgOd+A/WnMysvW5++taDfDZ1EkVihRPrbmMH3syDFTaLnfR2+lejjgtQY8wFhljSOtWDgCNMsdFHzu5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525379; c=relaxed/simple;
	bh=vp4/3FEQfUUymALL8XAtQhmEwbpeUjkOdXk8RUQrEaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bI1uRyApGHrmvbFDsxw5h1M/BTDsLV/1Do22aY7Ppme4aMwpGOmLqT0vrEOSJEQSHDpFuBsLoMjEhW9hFn1r3PVSUFbAuWCQ5Rlo9XoGECTKBsJePIXo/6da5j+vJlAOFiJLClgL7awnn/bOQg4fmq/FanTbZwus0tcwWRYYd0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3/oSfQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3/oSfQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCD3C4CEF1;
	Mon, 18 Aug 2025 13:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525378;
	bh=vp4/3FEQfUUymALL8XAtQhmEwbpeUjkOdXk8RUQrEaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3/oSfQF1zRZRpuCt8SIuTZPyQjj4lRaac0hZ9hkUrV+9cOOrYopXktUl1yfXiGss
	 NPgxsc73pJymQqvhMqSUyYviQXBXdG6rPm7X+QvRdw56yaJE9EGwy2AUayJZI0fsSW
	 Uygrf/cOfI01vnd2DQ51mLrjveErRPEYo0UjEh/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Syed Hassan <syed.hassan@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 237/570] drm/amd/display: limit clear_update_flags to dcn32 and above
Date: Mon, 18 Aug 2025 14:43:44 +0200
Message-ID: <20250818124514.954341918@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit f354556e29f40ef44fa8b13dc914817db3537e20 ]

[why]
dc has some code out of sync:
dc_commit_updates_for_stream handles v1/v2/v3,
but dc_update_planes_and_stream makes v1 asic to use v2.

as a reression fix: limit clear_update_flags to dcn32 or newer asic.
need to follow up that v1 asic using v2 issue.

Reviewed-by: Syed Hassan <syed.hassan@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index b34b5b52236d..3dd7e2b6d530 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -5439,8 +5439,7 @@ bool dc_update_planes_and_stream(struct dc *dc,
 	else
 		ret = update_planes_and_stream_v2(dc, srf_updates,
 			surface_count, stream, stream_update);
-
-	if (ret)
+	if (ret && dc->ctx->dce_version >= DCN_VERSION_3_2)
 		clear_update_flags(srf_updates, surface_count, stream);
 
 	return ret;
@@ -5471,7 +5470,7 @@ void dc_commit_updates_for_stream(struct dc *dc,
 		ret = update_planes_and_stream_v1(dc, srf_updates, surface_count, stream,
 				stream_update, state);
 
-	if (ret)
+	if (ret && dc->ctx->dce_version >= DCN_VERSION_3_2)
 		clear_update_flags(srf_updates, surface_count, stream);
 }
 
-- 
2.39.5



