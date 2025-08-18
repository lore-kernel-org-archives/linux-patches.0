Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECD331E0F8;
	Mon, 18 Aug 2025 13:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522114; cv=none; b=iN4gSRT+ZRMwNWIHh4U91o2b91URETWXvQ9QIsFNJxUciWO5xft/OFJ7iLFi9F7y0u/qksjf2nNHpji7T704u7sm0hWK+YX7t/XXNtjjQKPGrcrE9SBMCHydOjHqjoXDSr/fnZ3jo75JDbjQHGqAb6xJZHq/dQdCEoKpTsTTmzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522114; c=relaxed/simple;
	bh=9kxBc5HJRVpe35Nuw6rCCF8aZnHwasBNFE1tYbruvVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfTgaAPn6UPvTCCV7eSrgpmag5IMxn7WZZQoAOklvrp011RJfko/icewqRgNB2qQKR3k0AjWlfJQ/0z6kEq4MNkB468pm6rOtYytg3kVFUct3tZCdT/gi+PZeb4n4EpQYqvVr5zRsv59KlLQF/tbyTHFqSR7RVGrrggpic7BQbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3+wWr0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3+wWr0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BF8C113D0;
	Mon, 18 Aug 2025 13:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522114;
	bh=9kxBc5HJRVpe35Nuw6rCCF8aZnHwasBNFE1tYbruvVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3+wWr0NA3XhR+Yaa8vPca1H8PimczP+0K2rGqqeHyZySHwjnIiU3XdLZ8JPNAGw0
	 BVibTkrwEMHcMEQcWu4mi34ncsnE7qzE7tn3sEpapgTDraGAXAgi2xyMiB0ePckPUM
	 ibIeRFN2zmD2h9i6KYLmBuPQX4MNtNJ58veeZkIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Syed Hassan <syed.hassan@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/444] drm/amd/display: limit clear_update_flags to dcn32 and above
Date: Mon, 18 Aug 2025 14:43:32 +0200
Message-ID: <20250818124455.846336247@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a99d3e2256f1..b87f3e2d5117 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -5121,8 +5121,7 @@ bool dc_update_planes_and_stream(struct dc *dc,
 	else
 		ret = update_planes_and_stream_v2(dc, srf_updates,
 			surface_count, stream, stream_update);
-
-	if (ret)
+	if (ret && dc->ctx->dce_version >= DCN_VERSION_3_2)
 		clear_update_flags(srf_updates, surface_count, stream);
 
 	return ret;
@@ -5153,7 +5152,7 @@ void dc_commit_updates_for_stream(struct dc *dc,
 		ret = update_planes_and_stream_v1(dc, srf_updates, surface_count, stream,
 				stream_update, state);
 
-	if (ret)
+	if (ret && dc->ctx->dce_version >= DCN_VERSION_3_2)
 		clear_update_flags(srf_updates, surface_count, stream);
 }
 
-- 
2.39.5



