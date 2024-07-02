Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929921514DC;
	Tue,  2 Jul 2024 17:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941232; cv=none; b=J6VCOVdrS0NypLLV253w7Tue3025d2VAjKs2xvwJ7NqtSIIBO744rzi6uO6xEXov54LMJBg6NsskfCytt2gleFQE+jSEeJRm4BTnUtvR2EyCAIQawLjwyY/+0ErFnG2l7HKZnUrwVsRTxNRhf63KyxcHg4DxE+wRD1Mg39MNT10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941232; c=relaxed/simple;
	bh=DzrzmuicDvTk7sQyURiR4pEWTzgBqgQ2E24KzjpIIPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRyeRV9Y0p2Iht5EIsTqGsW8bvvmyItqa/6s+LQHn8ZZMSamN5bZ9LqmfR6s/7b2XL6oGfXkQZjoVVL/1ASHwrd6QnRwWXytDQBRUTLUSBkDTuxM1cUDk5T8iCAW5RRxX/7EM83aLuMN8BVkAyjqpywtMoUOTxY6Ww7sGr6CaOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJfJrmyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJfJrmyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4AAC116B1;
	Tue,  2 Jul 2024 17:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941232;
	bh=DzrzmuicDvTk7sQyURiR4pEWTzgBqgQ2E24KzjpIIPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJfJrmyZw8ploLXjVrn5sak4CI3wo6aymeZ5pKNc3BtDlrr0yJmwif62JhOtHcCaj
	 Mh3giTFMzJKpWMKj4yN1AiNVkoze+Fgyzf45JVHHqNFKAeRJagut909febY6gnV1lt
	 axaq2Zqd1Voaaqw/TwNRu3UTxT/+c7cuRMUkHbvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Michael Strauss <michael.strauss@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.6 141/163] drm/amd/display: Send DP_TOTAL_LTTPR_CNT during detection if LTTPR is present
Date: Tue,  2 Jul 2024 19:04:15 +0200
Message-ID: <20240702170238.390502441@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Strauss <michael.strauss@amd.com>

commit 2ec6c7f802332d1eff16f03e7c757f1543ee1183 upstream.

[WHY]
New register field added in DP2.1 SCR, needed for auxless ALPM

[HOW]
Echo value read from 0xF0007 back to sink

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c |   10 +++++++++-
 drivers/gpu/drm/amd/display/include/dpcd_defs.h                    |    5 +++++
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -1584,9 +1584,17 @@ static bool retrieve_link_cap(struct dc_
 			return false;
 	}
 
-	if (dp_is_lttpr_present(link))
+	if (dp_is_lttpr_present(link)) {
 		configure_lttpr_mode_transparent(link);
 
+		// Echo TOTAL_LTTPR_CNT back downstream
+		core_link_write_dpcd(
+				link,
+				DP_TOTAL_LTTPR_CNT,
+				&link->dpcd_caps.lttpr_caps.phy_repeater_cnt,
+				sizeof(link->dpcd_caps.lttpr_caps.phy_repeater_cnt));
+	}
+
 	/* Read DP tunneling information. */
 	status = dpcd_get_tunneling_device_data(link);
 
--- a/drivers/gpu/drm/amd/display/include/dpcd_defs.h
+++ b/drivers/gpu/drm/amd/display/include/dpcd_defs.h
@@ -177,4 +177,9 @@ enum dpcd_psr_sink_states {
 #define DP_SINK_PR_PIXEL_DEVIATION_PER_LINE     0x379
 #define DP_SINK_PR_MAX_NUMBER_OF_DEVIATION_LINE 0x37A
 
+/* Remove once drm_dp_helper.h is updated upstream */
+#ifndef DP_TOTAL_LTTPR_CNT
+#define DP_TOTAL_LTTPR_CNT                                  0xF000A /* 2.1 */
+#endif
+
 #endif /* __DAL_DPCD_DEFS_H__ */


