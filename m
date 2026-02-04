Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFBF2D5C91;
	Wed,  4 Feb 2026 15:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219229; cv=none; b=T++NOf4tPfsR4U8ZuvXGBpcVwc9tW3vm+HboFJXPpUx0K5sQ5fegoFDU2vsuNopveU591/f5EHyAUVit97mqlhAx1f3rJjBx0bkq15w2Wwyt9PxjSpQMPNa9bLq0W5Dh/WnC3exQzLYQm91ZCuRAOkAWqu8teoQ7LTudg//G1zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219229; c=relaxed/simple;
	bh=l0T3UvOEw+xfOOJBTFjTQKZF+somh4cklrfwusi17KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Is9OvRDcuV7i+/J1h6P/EOUqAxWhDuvvaL5lX6K+STFYnsXXLkT5GNM66znx4UuIEG8q8uSJuHMn4ZIp76o4l/H6uUpi1CSdrWmxxhpOy1McAtPudmoG6/cjz9yG5s6BfoO0La/Ls+t4a37m71lSkl+MTy742C+Te3Pxqr1GE6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hS89E5qa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hS89E5qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE05C4CEF7;
	Wed,  4 Feb 2026 15:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219229;
	bh=l0T3UvOEw+xfOOJBTFjTQKZF+somh4cklrfwusi17KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hS89E5qaJlrKoY1FmCP0kyIEuKLvGhBAfC+gwEOP3vfVRe6ZVU1UgIRUcfrH0PmDb
	 5kHFB73F4hABn2C/JCwPqyNhGLqn/m+YwbRjA2kYisbVTGOFLZ5lMuquNBTSMS6xOz
	 WYvBt6uv7AQlTiei/o7xO8SXO99iVB7JT+IwUChM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 106/122] drm/amd/pm: fix smu v14 soft clock frequency setting issue
Date: Wed,  4 Feb 2026 15:41:28 +0100
Message-ID: <20260204143855.666965856@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit 239d0ccf567c3b09aed58eb88cd3376af37aaf14 upstream.

v1:
resolve the issue where some freq frequencies cannot be set correctly
due to insufficient floating-point precision.

v2:
patch this convert on 'max' value only.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 53868dd8774344051999c880115740da92f97feb)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h   |    1 +
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h
@@ -57,6 +57,7 @@ extern const int decoded_link_width[8];
 
 #define DECODE_GEN_SPEED(gen_speed_idx)		(decoded_link_speed[gen_speed_idx])
 #define DECODE_LANE_WIDTH(lane_width_idx)	(decoded_link_width[lane_width_idx])
+#define SMU_V14_SOFT_FREQ_ROUND(x)	((x) + 1)
 
 struct smu_14_0_max_sustainable_clocks {
 	uint32_t display_clock;
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
@@ -1178,6 +1178,7 @@ int smu_v14_0_set_soft_freq_limited_rang
 		return clk_id;
 
 	if (max > 0) {
+		max = SMU_V14_SOFT_FREQ_ROUND(max);
 		if (automatic)
 			param = (uint32_t)((clk_id << 16) | 0xffff);
 		else


