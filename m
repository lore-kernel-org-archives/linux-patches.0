Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDED936E46C;
	Tue, 16 Jun 2026 15:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625438; cv=none; b=eozr9xvQDsxdJxxwTyR0OacF1Xsl+7AQlp0hyAZKTMJMDfE0GD9XRlhqOLn1yLtaX3+f4hiFrfyJqWF7yOHL/8pK7dWxVfjr8SKuuLvs2hm1GwTLf3ftxGlSJFwCX6J+GWFWS7/FfqXYsuDMdbB2PPgq5mgCxVbwCTNPxirL5j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625438; c=relaxed/simple;
	bh=sNteZ4JFuKDKqJw/FpzkGZk4onfAmK10wZlsnPit25o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTIfUIKYeymIT58M1pOHrhkbjcj5vGSW3wUt6k1Snwl8rg3MfnRc/RQSkB7q+eRLf/OQYabX9EU1jedGC2wSprZGnO8FLbUmzW6v3mmWDPgptwZMyg0NjQXnB/5mMKobJt4csy7gP1F86C79rR2rf7RDKImTR3Vr4IjUaLRQqaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihdCgk9L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihdCgk9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020F11F000E9;
	Tue, 16 Jun 2026 15:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625437;
	bh=GmXv6WV4zV1P8ldGF85o1sYQU9vTHL8mnDryduucjs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihdCgk9L3LGhmYKYWLxCZbPxoiqcuSeIOwAkp6jSapT2SWzNzVbRxtkjoPftjSkzP
	 OGQ4pP/hRsfyrjunCYY5t78VzaJVEb8XhD8Q7nUDbLtVWggQQGKp1AjeBkgROyu8NW
	 opxCzy8Iy9hdXKt0cXxXkPZhJD6zw1iALzldpOjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Jani Nikula <jani.nikula@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 142/325] drm/i915/edp: Check supported link rates DPCD read
Date: Tue, 16 Jun 2026 20:28:58 +0530
Message-ID: <20260616145104.812163893@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 2673cefa99ca918e7ac5b0388ff578a83656c896 ]

intel_edp_set_sink_rates() reads DP_SUPPORTED_LINK_RATES into a local
stack array and then parses the array unconditionally. If the read
fails, the array contents are not valid and may result in bogus sink
link rates being used.

Use drm_dp_dpcd_read_data() and clear the sink rate array on failure,
so the existing parser falls back to the default sink rate handling.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 68f357cb7347 ("drm/i915/dp: generate and cache sink rate array for all DP, not just eDP 1.4")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patch.msgid.link/20260529145759.1640646-1-n.zhandarovich@fintech.ru
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit bd61c7756b34157e093028225a69383b4b1203cc)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index a44fbac1e5e272..c7886b36477067 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -4372,10 +4372,17 @@ intel_edp_set_sink_rates(struct intel_dp *intel_dp)
 
 	if (intel_dp->edp_dpcd[0] >= DP_EDP_14) {
 		__le16 sink_rates[DP_MAX_SUPPORTED_RATES];
+		int ret;
 		int i;
 
-		drm_dp_dpcd_read(&intel_dp->aux, DP_SUPPORTED_LINK_RATES,
-				 sink_rates, sizeof(sink_rates));
+		ret = drm_dp_dpcd_read_data(&intel_dp->aux,
+					    DP_SUPPORTED_LINK_RATES,
+					    sink_rates, sizeof(sink_rates));
+		if (ret < 0) {
+			drm_dbg_kms(display->drm,
+				    "Unable to read eDP supported link rates, using default rates\n");
+			memset(sink_rates, 0, sizeof(sink_rates));
+		}
 
 		for (i = 0; i < ARRAY_SIZE(sink_rates); i++) {
 			int rate;
-- 
2.53.0



