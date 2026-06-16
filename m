Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D186478E4A;
	Tue, 16 Jun 2026 16:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627756; cv=none; b=RIHrgBykWcoZJf4F4EINh0IzYAklD7ZynZk8AnuxS/ngfH8zF8n2dPfq4MVj1lkhAgybjKqpM/FUbnBseFoDGZTeyJDLVNSkzlcpqExRCtBYPoqgScBGU5LdL3CZDRm/q15th622VisIQ8CvbIEQ1KIqQrdEMnwQHt3W7orjBMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627756; c=relaxed/simple;
	bh=Kj9Nuf0kim976PMIrBRQroghWTn2LkiGTEH/EWggFA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vv4eIdzrts7zEiBwJT1kBnkJHU+wPeEktCsoBvWhj5UWGD5KxvW+N0OA8Laqbg+iaeb9CIhtOCmWUGNDabZfb46JZv11yXpdWUpKqUJZFkNi0HCnZkKA2M2eBwb35KeEgLr9FgDC0pTKgQURORtL3GDrTimNcB19PHSwdY7moco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMKYCQ6z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMKYCQ6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2891F000E9;
	Tue, 16 Jun 2026 16:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627755;
	bh=/ULKUy5GLa2kv8MveiPkkjj8AoXc9C9rrLb08JbGZj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMKYCQ6zv+HXyu8NzQYUbIdM0TezeY/KXqbb3wmzmkOJ9i1djSjr6HKt9RSln75tz
	 KM7rfZCP/ESThLnJyL3pScOc9zov927AEEhZKpqdZxJUf9GS3FujC94uGdxBU0xJDd
	 5PiR+whGjcjUHiZTQyjk5Bc+j+/UmrXGP0zuFaj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priya Hosur <Priya.Hosur@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 222/261] drm/amd/pm: smu_v14_0_0: use SoftMin for gfxclk in set_soft_freq_limited_range
Date: Tue, 16 Jun 2026 20:31:00 +0530
Message-ID: <20260616145055.308762135@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priya Hosur <Priya.Hosur@amd.com>

commit 03b70e0d8aa26bab89a0f1394c1c80a871925e42 upstream.

In smu_v14_0_0_set_soft_freq_limited_range(), the gfxclk floor is
programmed via SetHardMinGfxClk together with SetSoftMaxGfxClk. Under
power_dpm_force_performance_level=high this pins HardMin to peak gfxclk.

In PMFW arbitration HardMin has higher priority than SoftMax, so the
firmware thermal/PPT throttler cannot clamp gfxclk via SoftMax once
HardMin is set to peak. Replace SetHardMinGfxClk with SetSoftMinGfxclk
so the driver still requests peak performance but the firmware
throttler retains the ability to clamp gfxclk under thermal/PPT
pressure. SoftMax handling is unchanged and no other clock domains
are affected.

Signed-off-by: Priya Hosur <Priya.Hosur@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3ea273267fd29cbf6d83ee72329f59eb5042605b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c
@@ -1219,7 +1219,8 @@ static int smu_v14_0_0_set_soft_freq_lim
 	switch (clk_type) {
 	case SMU_GFXCLK:
 	case SMU_SCLK:
-		msg_set_min = SMU_MSG_SetHardMinGfxClk;
+		/* SoftMin lets PMFW throttle gfxclk; HardMin would override SoftMax. */
+		msg_set_min = SMU_MSG_SetSoftMinGfxclk;
 		msg_set_max = SMU_MSG_SetSoftMaxGfxClk;
 		break;
 	case SMU_FCLK:


