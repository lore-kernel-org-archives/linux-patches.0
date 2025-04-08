Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6CB25F97B;
	Tue,  8 Apr 2025 12:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114410; cv=none; b=Qg3ZKRcEqkLyIFZgOjKpiY3W2HDHdx9iXEQ5uqTWPvEq3qWn9UDTu/8wnznyypV1PYIv7OZAmnocCwxNIWJHXEkFywm/d6KFKqdvGx//MSDFep7mCf68QPo4xUb4oeVm6b4eKzPNccziusSmej8pK4qlrbhQMGKWBTsHA2OYogg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114410; c=relaxed/simple;
	bh=6cOSF0TtVBkHNNSpZv7DzD23ugd3FRv13kvtWF4kqQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUX+cDHHYg/GD54EESa+X0Rgm1dsUpopzO0z4kwaLYCm3dcvyj9Z+h8jOOy6fJbN+5cwb7nmt+ffhnHtMBzm74ZR0Ckqa3OTCnP9SNSy+d+YqXu+DXjLdrVaN6SYs3UZTlCrwZCnJK+VxTHxGZX1jkuzXkqKkH79CI35nwAts+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwz97NLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwz97NLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0722BC4CEE5;
	Tue,  8 Apr 2025 12:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114410;
	bh=6cOSF0TtVBkHNNSpZv7DzD23ugd3FRv13kvtWF4kqQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwz97NLC5a10K32c57CTNo1LKg4Hm9Fh8qrIAdZarymluVECBm8ex8Hru6guxwh4U
	 L2N+/ooWKf+ibJ82uXBNkbcFzKGqfefxWBSxwdHJe8ZSK7Ah12/7Zhd5q2Qc9qxRAy
	 Nfon8NCp1O3ITDNt5wDP1Dr2nr+IMLRQHsgVk0mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 097/499] drm/amd/display: fix type mismatch in CalculateDynamicMetadataParameters()
Date: Tue,  8 Apr 2025 12:45:09 +0200
Message-ID: <20250408104853.636759062@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



