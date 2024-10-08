Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF6F1DE89A;
	Tue,  8 Oct 2024 12:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391934; cv=none; b=LqqlnS7AMJI6v9pdHj8lcKQvv3f1v4nBTSWVZztqYhtDDDUmxbHKAdtyoCT8xcCL3V30kN7kXmxVkylBUiCm/f7NUNaK+hz3z844wIzy30z6H3PijJwFnidJxp0BMJ58z0lTlD/yOaqNmrdlmM5b7aKi9gylxp3srgKELtUdqew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391934; c=relaxed/simple;
	bh=T6Ny+cLFUL0C6qcjXVE+tab/sQMvu3h4vsVmj0bTS94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBrv6zalfltChOqw/hVDu5wFU/c2W5jFpNr1tkLiuGSsVXuey07HgyUCMu9E1kZj3Ci0YrVe+9G6ll5J/pWRx+FlmEUXhu4LuPyC/2wOyiC2vapJ8f/xcIxHYsNMSGIfMrM7ukV2Z6Or72w0YYHVdiZLPX5cJNqKE0+Niz/rxC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztbnhuU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztbnhuU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF350C4CEC7;
	Tue,  8 Oct 2024 12:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391934;
	bh=T6Ny+cLFUL0C6qcjXVE+tab/sQMvu3h4vsVmj0bTS94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ztbnhuU/G9O2grnlBGYx3DP3YQOLxxQRPucIf+olkewnfN3EMY2TF8U3tamELWcpe
	 cxW/eb4SNp8vL1SnHSHDNY+gwVmoDEhHbSLghKck8EEjTd38sp2DbYaIJccVl11Gx/
	 Yb4FHNpZ6QV/BvM/8sY2i4aD3eOATAkKWudLdA+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 266/558] drm/amd/display: Avoid overflow assignment in link_dp_cts
Date: Tue,  8 Oct 2024 14:04:56 +0200
Message-ID: <20241008115712.799902866@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit a15268787b79fd183dd526cc16bec9af4f4e49a1 ]

sampling_rate is an uint8_t but is assigned an unsigned int, and thus it
can overflow. As a result, sampling_rate is changed to uint32_t.

Similarly, LINK_QUAL_PATTERN_SET has a size of 2 bits, and it should
only be assigned to a value less or equal than 4.

This fixes 2 INTEGER_OVERFLOW issues reported by Coverity.

Signed-off-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h                  | 2 +-
 drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c | 3 ++-
 drivers/gpu/drm/amd/display/include/dpcd_defs.h               | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
index 519c3df78ee5b..95c275bf649bd 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
@@ -727,7 +727,7 @@ struct dp_audio_test_data_flags {
 struct dp_audio_test_data {
 
 	struct dp_audio_test_data_flags flags;
-	uint8_t sampling_rate;
+	uint32_t sampling_rate;
 	uint8_t channel_count;
 	uint8_t pattern_type;
 	uint8_t pattern_period[8];
diff --git a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
index df3781081da7a..32d5a4b143333 100644
--- a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
+++ b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
@@ -775,7 +775,8 @@ bool dp_set_test_pattern(
 			core_link_read_dpcd(link, DP_TRAINING_PATTERN_SET,
 					    &training_pattern.raw,
 					    sizeof(training_pattern));
-			training_pattern.v1_3.LINK_QUAL_PATTERN_SET = pattern;
+			if (pattern <= PHY_TEST_PATTERN_END_DP11)
+				training_pattern.v1_3.LINK_QUAL_PATTERN_SET = pattern;
 			core_link_write_dpcd(link, DP_TRAINING_PATTERN_SET,
 					     &training_pattern.raw,
 					     sizeof(training_pattern));
diff --git a/drivers/gpu/drm/amd/display/include/dpcd_defs.h b/drivers/gpu/drm/amd/display/include/dpcd_defs.h
index aee5170f5fb23..c246235e4afec 100644
--- a/drivers/gpu/drm/amd/display/include/dpcd_defs.h
+++ b/drivers/gpu/drm/amd/display/include/dpcd_defs.h
@@ -76,6 +76,7 @@ enum dpcd_phy_test_patterns {
 	PHY_TEST_PATTERN_D10_2,
 	PHY_TEST_PATTERN_SYMBOL_ERROR,
 	PHY_TEST_PATTERN_PRBS7,
+	PHY_TEST_PATTERN_END_DP11 = PHY_TEST_PATTERN_PRBS7,
 	PHY_TEST_PATTERN_80BIT_CUSTOM,/* For DP1.2 only */
 	PHY_TEST_PATTERN_CP2520_1,
 	PHY_TEST_PATTERN_CP2520_2,
-- 
2.43.0



