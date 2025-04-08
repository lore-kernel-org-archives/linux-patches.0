Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EC7267F51;
	Tue,  8 Apr 2025 11:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110011; cv=none; b=Ret751xPiiqS/m0IgDhSMY+8yeFHqAcYlKm+pIosWW8XnkV0oAccSrlY00DfsumlmmaMrQ0eZDo7k3tgOZ+lHnmWttJftDzz4Z/Tl0R0bleLwGhqqKs5lOlRUFPXVEF1nlLLY8U4yhnbqTRMj0jNOlYXptCJ1b6ajKURWhdfIZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110011; c=relaxed/simple;
	bh=j5s14519z16s+b81jsP7B0IjF0hf8pMWBrgRgb4fWXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqCyNWczqME3q0/7itdyPe/613C53hfUG/hVjtBGx7QmcszqOTDgnNq4M2d/lYNn/rKYBtXUJ9xPN+gZVn+8s+j+lmvUQLZ55US726nErH2UMCh/NzXNDBkAt/IJBbszAnhlXMAA8lEv8ONsTZHss+7COt5bFu5X9m55nt3lW3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfjaWLBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfjaWLBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5CCC4CEE5;
	Tue,  8 Apr 2025 11:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110009;
	bh=j5s14519z16s+b81jsP7B0IjF0hf8pMWBrgRgb4fWXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yfjaWLBSRyDhb7L+Q7mXB3YnSSHszmky8eRrQxXIjOxZ9mU1g/i4TIR72cb9qBRRi
	 gZt+7CsUUTpdW9y8EkGJZ31FyukajW1D+JM3AdNyW9/evP0N1ZuRn35LpoPL/iWQkD
	 XEa7doUzqP1h7Onps5crUr1NsjTgaFDDslp/Z4h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/227] drm/amd/display: fix type mismatch in CalculateDynamicMetadataParameters()
Date: Tue,  8 Apr 2025 12:48:34 +0200
Message-ID: <20250408104824.394096133@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e5b1002d7f3f0..ed4e7f3728ab3 100644
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
@@ -3373,8 +3373,8 @@ static double CalculateWriteBackDelay(
 
 
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



