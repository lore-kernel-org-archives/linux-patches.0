Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E593921ED;
	Sat, 12 Sep 2026 07:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196648; cv=none; b=E11IjsF6TpAa8KlcNbhx39Bkr9AniAJCB7O3o5SN34EHok6iNVn12pJzDTme3X5ltyW08FYYmFIfJ1p+JWI7BnjOsm5vHZNiCMLbkE+fq7zctM++WM/MeDsny8HccS86qmzCSNme4CfvxdJyeMP+yduij0UBYBbUw2ag2Mn0dD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196648; c=relaxed/simple;
	bh=ZcYwDcqXG693MVEwpT3WsOnEJeqiF2LVfJb5Ga7vjhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMGTVy9YzkDGBElAy/X/88Qe0dQxxMGOT6YRW0vFLKNKr+nS2XsPTNmkV1hZLs8Jw2ChKTe4AxANQDyU3OpBDY4c81UB+UMSs9ml926g8/Huv+5TNdDZsGLqxB7Lg/ReSwXD7NJ75Y5IjNY6HUSB5nAq3PNKTg5o7uL1xfBDnAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7RWa2sl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7RWa2sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BF11F000FF;
	Sat, 12 Sep 2026 07:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196644;
	bh=LFNACF2oaICFMPQ4NeLnJKrz2I2xiAreE26Y8i7zbJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7RWa2sluqZ6uvk3yx3EKA+aSeEUOfEiCyofJ0k6jd+lPFncAyEWmAbA4pbStRY+O
	 D+ohtsj7gq235Bi8w+2vN6BAZ0rbUX0Nz+S5zUb7l6clSiIjXQA7fOlmgUal4EiJnr
	 OtD7fsvX3bKkD2EHqVZCR3MxejlV/XwXfXPm14LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhmed Zhitaev <zhitaevakh@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0001/1815] drm/amd/display: Scale custom brightness curve from full range
Date: Sat, 12 Sep 2026 08:29:11 +0200
Message-ID: <20260912065649.043637711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhmed Zhitaev <zhitaevakh@gmail.com>

[ Upstream commit 6fd83a1c2cdea48c396f600795217fbdfb8124f6 ]

Custom brightness curves use an 8-bit input signal.  After exporting the
full PWM range to userspace, the curve normalizer still divides requests
by the physical PWM span.  On panels with a nonzero minimum PWM level,
this can produce a curve input greater than 255 and send an invalid
backlight level to DC.

Scale the userspace [0..max] range to the curve's [0..255] range
instead.  This retains the full advertised range and keeps the reverse
readback conversion unchanged.

Fixes: 8dbd72cb7900 ("drm/amd/display: Export full brightness range to userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Akhmed Zhitaev <zhitaevakh@gmail.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
(Move to amdgpu_dm_backlight.c)
Link: https://patch.msgid.link/20260813170959.22073-1-zhitaevakh@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index f059bed728f0a..69d12377f6817 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5271,10 +5271,10 @@ static int get_brightness_range(const struct amdgpu_dm_backlight_caps *caps,
 	return 1;
 }
 
-/* Rescale from [min..max] to [0..AMDGPU_MAX_BL_LEVEL] */
-static inline u32 scale_input_to_fw(int min, int max, u64 input)
+/* Rescale userspace [0..max] to the firmware curve's [0..255]. */
+static inline u32 scale_input_to_fw(int max, u64 input)
 {
-	return DIV_ROUND_CLOSEST_ULL(input * AMDGPU_MAX_BL_LEVEL, max - min);
+	return DIV_ROUND_CLOSEST_ULL(input * AMDGPU_MAX_BL_LEVEL, max);
 }
 
 /* Rescale from [0..AMDGPU_MAX_BL_LEVEL] to [min..max] */
@@ -5287,7 +5287,7 @@ static void convert_custom_brightness(const struct amdgpu_dm_backlight_caps *cap
 				      unsigned int min, unsigned int max,
 				      uint32_t *user_brightness)
 {
-	u32 brightness = scale_input_to_fw(min, max, *user_brightness);
+	u32 brightness = scale_input_to_fw(max, *user_brightness);
 	u8 lower_signal, upper_signal, upper_lum, lower_lum, lum;
 	int left, right;
 
-- 
2.53.0



