Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A642C134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE5DC433EF;
	Mon, 12 Jun 2023 10:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566798;
	bh=MaCiYC8us4E1K6czgWqmYlgjJ/SGB8Z7jdGM6pXE8SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJWnCZlUs4ru8Ku/W7NATso/B0Q4s3HrEVF7tFyRVf7bBG+cHsSdRbc8UNFnENeP4
	 XIjwXRKAKDPDZiv8C6EoYZTjeBAy70qNKx+NYYLMSRxT6zv8UA+qH1S6qBDAjQfdux
	 JtuNDeXJvHuTgQ/TUdUSlsklOT7pF0+BjehvnJzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 018/160] drm/i915: Explain the magic numbers for AUX SYNC/precharge length
Date: Mon, 12 Jun 2023 12:25:50 +0200
Message-ID: <20230612101715.902293702@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 26bfc3f36f2104c174dfc72415547d5c28ef3f1c ]

Replace the hardcoded final numbers in the AUX SYNC/precharge
setup, and derive those from numbers from the (e)DP specs.

The new functions can serve as the single point of truth for
the number of SYNC pulses we use.

Cc: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230329172434.18744-2-ville.syrjala@linux.intel.com
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Stable-dep-of: 2d6f2f79e065 ("drm/i915: Use 18 fast wake AUX sync len")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp_aux.c | 32 +++++++++++++++++++--
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux.c b/drivers/gpu/drm/i915/display/intel_dp_aux.c
index 30c98810e28bb..2ffd68b07984b 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
@@ -117,6 +117,32 @@ static u32 skl_get_aux_clock_divider(struct intel_dp *intel_dp, int index)
 	return index ? 0 : 1;
 }
 
+static int intel_dp_aux_sync_len(void)
+{
+	int precharge = 16; /* 10-16 */
+	int preamble = 16;
+
+	return precharge + preamble;
+}
+
+static int intel_dp_aux_fw_sync_len(void)
+{
+	int precharge = 16; /* 10-16 */
+	int preamble = 8;
+
+	return precharge + preamble;
+}
+
+static int g4x_dp_aux_precharge_len(void)
+{
+	int precharge_min = 10;
+	int preamble = 16;
+
+	/* HW wants the length of the extra precharge in 2us units */
+	return (intel_dp_aux_sync_len() -
+		precharge_min - preamble) / 2;
+}
+
 static u32 g4x_get_aux_send_ctl(struct intel_dp *intel_dp,
 				int send_bytes,
 				u32 aux_clock_divider)
@@ -139,7 +165,7 @@ static u32 g4x_get_aux_send_ctl(struct intel_dp *intel_dp,
 	       timeout |
 	       DP_AUX_CH_CTL_RECEIVE_ERROR |
 	       (send_bytes << DP_AUX_CH_CTL_MESSAGE_SIZE_SHIFT) |
-	       (3 << DP_AUX_CH_CTL_PRECHARGE_2US_SHIFT) |
+	       (g4x_dp_aux_precharge_len() << DP_AUX_CH_CTL_PRECHARGE_2US_SHIFT) |
 	       (aux_clock_divider << DP_AUX_CH_CTL_BIT_CLOCK_2X_SHIFT);
 }
 
@@ -163,8 +189,8 @@ static u32 skl_get_aux_send_ctl(struct intel_dp *intel_dp,
 	      DP_AUX_CH_CTL_TIME_OUT_MAX |
 	      DP_AUX_CH_CTL_RECEIVE_ERROR |
 	      (send_bytes << DP_AUX_CH_CTL_MESSAGE_SIZE_SHIFT) |
-	      DP_AUX_CH_CTL_FW_SYNC_PULSE_SKL(24) |
-	      DP_AUX_CH_CTL_SYNC_PULSE_SKL(32);
+	      DP_AUX_CH_CTL_FW_SYNC_PULSE_SKL(intel_dp_aux_fw_sync_len()) |
+	      DP_AUX_CH_CTL_SYNC_PULSE_SKL(intel_dp_aux_sync_len());
 
 	if (intel_tc_port_in_tbt_alt_mode(dig_port))
 		ret |= DP_AUX_CH_CTL_TBT_IO;
-- 
2.39.2



