Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD63264A76;
	Tue,  8 Apr 2025 11:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111138; cv=none; b=XLqzgIqYaGZaj40VZEzQXFN79GPEGnAheB532Wi7u99Ul0OkX6g7GE0AwjCdckUIm1pMiJWY75vQ2FuoBWyTS2ObK2Mwl1PuSxU2nXTrnfelx6fwdLGiwnadRBKdzzWbO4r+aPMl2l2MbsOn99OyDntU+3zKo8qRj1ntkNNq6L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111138; c=relaxed/simple;
	bh=1MHrx65dVcpGZu52KNEAd/4B8voyAtmbCkh6jByvC0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8y1WnXlrvJr9MSwmuWDdCKSn39nJ5bgtpC4Z2Yzz4w98QEqdVKHOUaN9unDpHBl5KzcOYi6RpptdArvMoiJKENUxGtw+4jzYQyz1lkf94OVYJjmbKey46tAO8yUbglY+FLq5JsABwLbEZVHFL4orAmoIZRA3Ur5DzML6u/Pb44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7gm8n9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7gm8n9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2D2C4CEE5;
	Tue,  8 Apr 2025 11:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111138;
	bh=1MHrx65dVcpGZu52KNEAd/4B8voyAtmbCkh6jByvC0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y7gm8n9v6uBUuRH6JLadvGPtZNCtngW5xVGnxg94UXk4odUqoXuOSXW657nPiPxh7
	 s8MXDAY9WD3879ULbS6h6CM5ztHNtzIs5RFd2UlylDMNNk4wnqn6pyMoWjrVGuCe/v
	 bI2tyrT3XVDAmCIrmMhdv/jxZz2yCq56zc3WFQBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 322/731] drm/amd/display: fix type mismatch in CalculateDynamicMetadataParameters()
Date: Tue,  8 Apr 2025 12:43:39 +0200
Message-ID: <20250408104921.765449861@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index cee1b351e1058..f1fe49401bc0a 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
@@ -281,10 +281,10 @@ static void CalculateDynamicMetadataParameters(
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
@@ -3265,8 +3265,8 @@ static double CalculateWriteBackDelay(
 
 
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



