Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC8F33097;
	Tue, 23 Jan 2024 00:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969656; cv=none; b=bwVMV7SDarPkgRMOnqa/Kz2dAREYx375+f66Wx6ad1rp2STQqRLubaZMM24tUSEPoibytTeol/ewpVpZEN+GVvKKM5ShBaKPkL4qRngy+D5JiVVMVRUG4zxViYLlVxVTtyYgIAJ0TeH52sMr+nUMmKeKuJPF3mN8f9iQss3fT14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969656; c=relaxed/simple;
	bh=g8wZzSA+8kCGnNtCfKutOGnhHwK+5yaxU6cJguthez0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DajZKZ2bRxSzrKV+2AJ4JSTk3ZviAydpNmaP7i7La2s3YURbSIzCPzz3WTFWjY6wnIEL14q74amEfKgZ4m0gyi4u2a2dcqRTaphex9Fizm7jcNkrHTIWHi9Pl1gzFYaizvkGjtRqRQbENYywBfriu9Dt/U0wDGDrHGCSRz9wc3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=beHT0KzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="beHT0KzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82C7C433F1;
	Tue, 23 Jan 2024 00:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969655;
	bh=g8wZzSA+8kCGnNtCfKutOGnhHwK+5yaxU6cJguthez0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beHT0KzE/kN/tAwOM0CQHk4Cgs1Pg4+psm0kqK8137EWQLOsFXJjYW6+pGwCwHf+H
	 jTRKbV7wLfSvgtOoxzKZ4x3XQBD+isr0VGH8JjUhAEm0FL+GhYgVw/0YnjV+m8+MQT
	 2+FOfAYGiWNY71UsS4sU7Q/k3wEd3qDRB4QRP8sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 369/641] drm/amd/display: avoid stringop-overflow warnings for dp_decide_lane_settings()
Date: Mon, 22 Jan 2024 15:54:33 -0800
Message-ID: <20240122235829.497882288@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c966dc0e9d96dc44423c404a2628236f1200c24e ]

gcc prints a warning about a possible array overflow for a couple of
callers of dp_decide_lane_settings() after commit 1b56c90018f0 ("Makefile:
Enable -Wstringop-overflow globally"):

drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c: In function 'dp_perform_fixed_vs_pe_training_sequence_legacy':
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c:426:25: error: 'dp_decide_lane_settings' accessing 4 bytes in a region of size 1 [-Werror=stringop-overflow=]
  426 |                         dp_decide_lane_settings(lt_settings, dpcd_lane_adjust,
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  427 |                                         lt_settings->hw_lane_settings, lt_settings->dpcd_lane_settings);
      |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c:426:25: note: referencing argument 4 of type 'union dpcd_training_lane[4]'

I'm not entirely sure what caused this, but changing the prototype to expect
a pointer instead of an array avoids the warnings.

Fixes: 7727e7b60f82 ("drm/amd/display: Improve robustness of FIXED_VS link training at DP1 rates")
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/link/protocols/link_dp_training.c    | 2 +-
 .../gpu/drm/amd/display/dc/link/protocols/link_dp_training.h    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
index 90339c2dfd84..5a0b04518956 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
@@ -807,7 +807,7 @@ void dp_decide_lane_settings(
 		const struct link_training_settings *lt_settings,
 		const union lane_adjust ln_adjust[LANE_COUNT_DP_MAX],
 		struct dc_lane_settings hw_lane_settings[LANE_COUNT_DP_MAX],
-		union dpcd_training_lane dpcd_lane_settings[LANE_COUNT_DP_MAX])
+		union dpcd_training_lane *dpcd_lane_settings)
 {
 	uint32_t lane;
 
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.h b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.h
index 7d027bac8255..851bd17317a0 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.h
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.h
@@ -111,7 +111,7 @@ void dp_decide_lane_settings(
 	const struct link_training_settings *lt_settings,
 	const union lane_adjust ln_adjust[LANE_COUNT_DP_MAX],
 	struct dc_lane_settings hw_lane_settings[LANE_COUNT_DP_MAX],
-	union dpcd_training_lane dpcd_lane_settings[LANE_COUNT_DP_MAX]);
+	union dpcd_training_lane *dpcd_lane_settings);
 
 enum dc_dp_training_pattern decide_cr_training_pattern(
 		const struct dc_link_settings *link_settings);
-- 
2.43.0



