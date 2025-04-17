Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF25B2571CE;
	Thu, 17 Apr 2025 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912940; cv=none; b=OIWv4Hem4tFh9FxsdCw2BJojWfEf6iR0hcfB1W5c+ZTO1wwDDK1eHy5p18o60C9SrlIm/OCmZiAWsYkjdM2q8cuGXkRHxIADifZKPY25ffNS4iIlrSxf6Gj5Ohjw8dNoP9xHQJyiFKV0/PyOevKgT+ALwAq3AnPaf19W1n3wmII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912940; c=relaxed/simple;
	bh=EcBZOpU6OkekGpiK8H3G1RUXYQ50TL+x5Yz99qzP/lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X//opF4oI7B5DIeQyXKudym1tvlgx8xPF2sFT4W2RQqbtHc+DUCsC5yj4Pw/1PoQigcI0MM4tBhC/WmovNQNn5GnqBWi9Or9RcHYABwRPN41OKD+oJw68I73CQaIhqCWg6+HIT9BhHjUdCMuePbZsYitsBrF8r6RqH/cOeaJIUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feXszOUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feXszOUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA98C4CEE7;
	Thu, 17 Apr 2025 18:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912940;
	bh=EcBZOpU6OkekGpiK8H3G1RUXYQ50TL+x5Yz99qzP/lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feXszOUgRR4pNO7KW9+HqUq8r6uycqMb0+l6syCXvq9baLtP3Q38XFNOEstMHyzfP
	 DvYx+0Su8mMEok/dbRdJL4iPlqqPyG/3gP69NQtCKbNQU/zdb3JwfeddaFEcy/d0HG
	 jKF35dWHdxdJbNBrkcordswm1WtIyBkkwokheaQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Ryan Seto <ryanseto@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 175/449] drm/amd/display: Prevent VStartup Overflow
Date: Thu, 17 Apr 2025 19:47:43 +0200
Message-ID: <20250417175125.025131740@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Ryan Seto <ryanseto@amd.com>

[ Upstream commit 29c1c20496a7a9bafe2bc2f833d69aa52e0f2c2d ]

[Why]
For some VR headsets with large blanks, it's possible
to overflow the OTG_VSTARTUP_PARAM:VSTARTUP_START
register. This can lead to incorrect DML calculations
and underflow downstream.

[How]
Min the calcualted max_vstartup_lines with the max
value of the register.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Ryan Seto <ryanseto@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c  | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
index 8ed49a9df3780..c1ff869512f27 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -15,6 +15,7 @@
 //#define DML_MODE_SUPPORT_USE_DPM_DRAM_BW
 //#define DML_GLOBAL_PREFETCH_CHECK
 #define ALLOW_SDPIF_RATE_LIMIT_PRE_CSTATE
+#define DML_MAX_VSTARTUP_START 1023
 
 const char *dml2_core_internal_bw_type_str(enum dml2_core_internal_bw_type bw_type)
 {
@@ -3726,6 +3727,7 @@ static unsigned int CalculateMaxVStartup(
 	dml2_printf("DML::%s: vblank_avail = %u\n", __func__, vblank_avail);
 	dml2_printf("DML::%s: max_vstartup_lines = %u\n", __func__, max_vstartup_lines);
 #endif
+	max_vstartup_lines = (unsigned int)math_min2(max_vstartup_lines, DML_MAX_VSTARTUP_START);
 	return max_vstartup_lines;
 }
 
-- 
2.39.5



