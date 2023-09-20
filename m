Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD1C18654
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4B1C433CA;
	Wed, 20 Sep 2023 11:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210431;
	bh=lF5yFKyyVLJX9Qo4oYZf5VpIzqN834U5ErogKXYBo3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n47XELZEO2WOgsTGV58878MhtuoarLjuY/eVUtzrS+tflhSVbFTqOCQYaurgeO1tt
	 W/mA/TDmtmEjcaNb9eOvo83jFrHjF13rWoN0dBsG9XlNj6QL9gvtIL7RthakCQOOP3
	 XEtfg0UYqFpFX2O77CqvwT5Yg0J5JIZW8HbfEUIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Leo Ma <hanghong.ma@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 075/211] drm/amd/display: Fix underflow issue on 175hz timing
Date: Wed, 20 Sep 2023 13:28:39 +0200
Message-ID: <20230920112848.124076949@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Ma <hanghong.ma@amd.com>

[ Upstream commit 735688eb905db529efea0c78466fccc1461c3fde ]

[Why]
Screen underflows happen on 175hz timing for 3 plane overlay case.

[How]
Based on dst y prefetch value clamp to equ or oto for bandwidth
calculation.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Leo Ma <hanghong.ma@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dml/dcn32/display_mode_vba_util_32.c    | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
index a50e7f4dce421..f74e5fc8218f5 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
@@ -3459,6 +3459,7 @@ bool dml32_CalculatePrefetchSchedule(
 	double TimeForFetchingMetaPTE = 0;
 	double TimeForFetchingRowInVBlank = 0;
 	double LinesToRequestPrefetchPixelData = 0;
+	double LinesForPrefetchBandwidth = 0;
 	unsigned int HostVMDynamicLevelsTrips;
 	double  trip_to_mem;
 	double  Tvm_trips;
@@ -3888,11 +3889,15 @@ bool dml32_CalculatePrefetchSchedule(
 			TimeForFetchingMetaPTE = Tvm_oto;
 			TimeForFetchingRowInVBlank = Tr0_oto;
 			*PrefetchBandwidth = prefetch_bw_oto;
+			/* Clamp to oto for bandwidth calculation */
+			LinesForPrefetchBandwidth = dst_y_prefetch_oto;
 		} else {
 			*DestinationLinesForPrefetch = dst_y_prefetch_equ;
 			TimeForFetchingMetaPTE = Tvm_equ;
 			TimeForFetchingRowInVBlank = Tr0_equ;
 			*PrefetchBandwidth = prefetch_bw_equ;
+			/* Clamp to equ for bandwidth calculation */
+			LinesForPrefetchBandwidth = dst_y_prefetch_equ;
 		}
 
 		*DestinationLinesToRequestVMInVBlank = dml_ceil(4.0 * TimeForFetchingMetaPTE / LineTime, 1.0) / 4.0;
@@ -3900,7 +3905,7 @@ bool dml32_CalculatePrefetchSchedule(
 		*DestinationLinesToRequestRowInVBlank =
 				dml_ceil(4.0 * TimeForFetchingRowInVBlank / LineTime, 1.0) / 4.0;
 
-		LinesToRequestPrefetchPixelData = *DestinationLinesForPrefetch -
+		LinesToRequestPrefetchPixelData = LinesForPrefetchBandwidth -
 				*DestinationLinesToRequestVMInVBlank - 2 * *DestinationLinesToRequestRowInVBlank;
 
 #ifdef __DML_VBA_DEBUG__
-- 
2.40.1



