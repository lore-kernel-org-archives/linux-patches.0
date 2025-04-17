Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8C0256C6A;
	Thu, 17 Apr 2025 18:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914249; cv=none; b=tPL//IBQ9+VQ0tD/XUyjeKcN7L5crN08QZ0JkrCyThp3qY3xu7M2KO39w6/v890Qyt6xXCiRxm13FkiA0HQhWtWAaKsq2DeMI9MTtdXJ/OzsCUgbrRNdkrVhtwBnvLklpGERcs7QNmfv9V4TilvIgs6sauu+zS4mNdJ8/XAKBts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914249; c=relaxed/simple;
	bh=apQDOrFOWUFZ5SIBfnEQM8ZvjabGNdZ57jXBsWR5WAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mprdqjxTV3snMoidsfCMzCEBUF/VWqKEN84VcoHrXeTqMBaAOfvKFhkPxXUh6GnSyPeTQxpheVkHKKFaDqHKLZxImdA9gRZZoXjL7xvdXCmF/m34pRUOSOrUE3Ilct52Ojq8fy0rFOZ2LYEZcrdDB8lhezR9gfwvcolirAmREqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLe1xKAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLe1xKAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6F5C4CEE4;
	Thu, 17 Apr 2025 18:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914249;
	bh=apQDOrFOWUFZ5SIBfnEQM8ZvjabGNdZ57jXBsWR5WAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLe1xKALRTj/1+EAEfcthVEi6uB1F8ipEMoGLvwtZ9VNBSHBlWcjG/X0Vz6RDIH4S
	 n8hHxklhtwLvBYit/IEwueU/Nc6/Vi7CdMwjj90lUQlM3GtZb78Usjh4DYkjVAWac/
	 OxEVzmG7vPeNXwKDS+31pW+8gn/PBSlnwnY8Afhk=
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
Subject: [PATCH 6.13 155/414] drm/amd/display: Prevent VStartup Overflow
Date: Thu, 17 Apr 2025 19:48:33 +0200
Message-ID: <20250417175117.672563556@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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
index ecfa3c898e09d..4285cb7fcbe71 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -12,6 +12,7 @@
 #define DML2_MAX_FMT_420_BUFFER_WIDTH 4096
 #define DML_MAX_NUM_OF_SLICES_PER_DSC 4
 #define ALLOW_SDPIF_RATE_LIMIT_PRE_CSTATE
+#define DML_MAX_VSTARTUP_START 1023
 
 const char *dml2_core_internal_bw_type_str(enum dml2_core_internal_bw_type bw_type)
 {
@@ -3648,6 +3649,7 @@ static unsigned int CalculateMaxVStartup(
 	dml2_printf("DML::%s: vblank_avail = %u\n", __func__, vblank_avail);
 	dml2_printf("DML::%s: max_vstartup_lines = %u\n", __func__, max_vstartup_lines);
 #endif
+	max_vstartup_lines = (unsigned int)math_min2(max_vstartup_lines, DML_MAX_VSTARTUP_START);
 	return max_vstartup_lines;
 }
 
-- 
2.39.5



