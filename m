Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E0526B098;
	Tue,  8 Apr 2025 12:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115622; cv=none; b=k+svSWsFd9/nEuqj6MsxB1QKPOrjFda1hp4jG6Rdz6g9Q53YhdxyLnS9lWsztPmwioHQDUd5vjb1PQHPKpYQEWrab3TnaU+aHrh5ww+M2Dk/jq4kl9B+VIpzgQOmB0OCUluQ4dxOdRcRraPOlMbkGML23WvpVCCSthkgG1oLZtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115622; c=relaxed/simple;
	bh=6yg+WlKSH2nT4xuTSfe+dJwInjQTwAKf82ASh5GhcqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIIGyWuNPQoOEZQG2W1T2U4CbEQz4AeiSlNEbBI5rOFWwG5VLaVCYU8lJJR7/pNS9GCYCXzmpQ2MPR86QzUsYJVdXkWISy4Clfleb7VB2zb8oJFH1MzL3YNRsyYAfEPK/mKc96X0vkJ+K+HA4GhU77znLwfyTbBxrLzw0YC71Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxXrzNI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxXrzNI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F5FC4CEE5;
	Tue,  8 Apr 2025 12:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115621;
	bh=6yg+WlKSH2nT4xuTSfe+dJwInjQTwAKf82ASh5GhcqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxXrzNI/spM4CNFmKx6cS0P29Zt1cKs0nb9+ZEpU0bXGyZe6bQvNzyrdxF7kyIyqy
	 aJd27kkM8JMg6CMufmLK6ZuDNYfArPrBV3MzDtxeBcMB1wTARIeLN0CSKnd9DTpCtG
	 RvU54b+XrAdkhOosoh7oBJLM6l7W8jFH3IacJCRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/204] drm/amd/display: fix type mismatch in CalculateDynamicMetadataParameters()
Date: Tue,  8 Apr 2025 12:49:33 +0200
Message-ID: <20250408104821.609529249@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>

[ Upstream commit c3c584c18c90a024a54716229809ba36424f9660 ]

There is a type mismatch between what CalculateDynamicMetadataParameters()
takes and what is passed to it. Currently this function accepts several
args as signed long but it's called with unsigned integers and integer. On
some systems where long is 32 bits and one of these unsigned int params is
greater than INT_MAX it may cause passing input params as negative values.

Fix this by changing these argument types from long to unsigned int and to
int respectively. Also this will align the function's definition with
similar functions in other dcn* drivers.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 6725a88f88a7 ("drm/amd/display: Add DCN3 DML")
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dml/dcn30/display_mode_vba_30.c   | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
index 861f32b3248e7..69521368ddb61 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
@@ -283,10 +283,10 @@ static void CalculateDynamicMetadataParameters(
 		double DISPCLK,
 		double DCFClkDeepSleep,
 		double PixelClock,
-		long HTotal,
-		long VBlank,
-		long DynamicMetadataTransmittedBytes,
-		long DynamicMetadataLinesBeforeActiveRequired,
+		unsigned int HTotal,
+		unsigned int VBlank,
+		unsigned int DynamicMetadataTransmittedBytes,
+		int DynamicMetadataLinesBeforeActiveRequired,
 		int InterlaceEnable,
 		bool ProgressiveToInterlaceUnitInOPP,
 		double *Tsetup,
@@ -3280,8 +3280,8 @@ static double CalculateWriteBackDelay(
 
 
 static void CalculateDynamicMetadataParameters(int MaxInterDCNTileRepeaters, double DPPCLK, double DISPCLK,
-		double DCFClkDeepSleep, double PixelClock, long HTotal, long VBlank, long DynamicMetadataTransmittedBytes,
-		long DynamicMetadataLinesBeforeActiveRequired, int InterlaceEnable, bool ProgressiveToInterlaceUnitInOPP,
+		double DCFClkDeepSleep, double PixelClock, unsigned int HTotal, unsigned int VBlank, unsigned int DynamicMetadataTransmittedBytes,
+		int DynamicMetadataLinesBeforeActiveRequired, int InterlaceEnable, bool ProgressiveToInterlaceUnitInOPP,
 		double *Tsetup, double *Tdmbf, double *Tdmec, double *Tdmsks)
 {
 	double TotalRepeaterDelayTime = 0;
-- 
2.39.5



