Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC144C0420;
	Fri, 15 May 2026 16:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862536; cv=none; b=pXr18up9W85dWyvcmIyLIPiDspd0d47GtSdb9k7JbALX1K9qTY8oOOvj0qtbA+t9w+GgxfYxfQBjzFRnzN5Mb4uPxR62TPQnYe1ADBcNxZDoh2xpd8hD7q66uV8raJyu5zyZNDDuon5W2xrB+ZKT0EyzFSY3lXVIRCziWQV/NOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862536; c=relaxed/simple;
	bh=Es9OzjELDOOZiAUdFIcGacnL3lldSF4hpdz1OLcg7Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dulmkI98kMvNAxlvatxPmEVPNgOoYEw9K5XBYUboUWBDoZPyfOX46qttrUFFv3UV+DUlQI3Xqq/YKQeRJ855/0r3l6sYBzHBWHEnXdJQYIS4eJFjvydSO2gxD/FQ9B78Bsf19MGWx5fKS/Fwsx4x2VP+0XhqnAhunj0MThS8OLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWJsaxre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWJsaxre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B615C2BCB0;
	Fri, 15 May 2026 16:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862536;
	bh=Es9OzjELDOOZiAUdFIcGacnL3lldSF4hpdz1OLcg7Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mWJsaxrejYC7OAya0IVOTjQNXhAhXRVMcqAebJ8Ps/m39bKm7duzKHIZw7IQgviiF
	 NuY628pLdcV5SRqkollAagjx2QyFdqWjNf/5XUPf1/ZoAYpCoud1C+t+xpo5FuqHsr
	 wV6cAWaqymXYtrAX9dOa7IJbeGu2IKbXKEnD041c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 044/201] media: mali-c55: Fully reset the ISP configuration
Date: Fri, 15 May 2026 17:47:42 +0200
Message-ID: <20260515154659.488403161@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacopo Mondi <jacopo.mondi@ideasonboard.com>

commit 26ad493bea57efdccc32ffedbf731da2b7463b6c upstream.

The Mali C55 driver uses an auto-suspend delay of 2000 milli-seconds.

As the delay is quite large, it is certainly possible that two
consecutive calls to enable_streams() do not go through a suspend of the
peripheral, meaning we cannot rely on POW register values for the ISP
configuration.

To prevent a streaming session to be initialized with settings from the
previous one, reset the full ISP configuration to know state disabling or
bypassing all the ISP blocks the driver supports.

Cc: stable@vger.kernel.org
Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../platform/arm/mali-c55/mali-c55-params.c   | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/media/platform/arm/mali-c55/mali-c55-params.c b/drivers/media/platform/arm/mali-c55/mali-c55-params.c
index c84a6047a570..773e5b6a2b7e 100644
--- a/drivers/media/platform/arm/mali-c55/mali-c55-params.c
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-params.c
@@ -781,6 +781,43 @@ void mali_c55_params_init_isp_config(struct mali_c55 *mali_c55,
 				 MALI_C55_REG_BYPASS_3_SQUARE_BE,
 				 MALI_C55_REG_BYPASS_3_SQUARE_BE);
 
+	/* Bypass the sensor offset correction (BLS) module */
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_BYPASS_3,
+		MALI_C55_REG_BYPASS_3_SENSOR_OFFSET_PRE_SH,
+		MALI_C55_REG_BYPASS_3_SENSOR_OFFSET_PRE_SH);
+
+	/* Configure 1x digital gain. */
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_DIGITAL_GAIN,
+				 MALI_C55_DIGITAL_GAIN_MASK, 256);
+
+	/* Set all AWB gains to 1x. at both AWB configuration points*/
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_AWB_GAINS1,
+				 MALI_C55_AWB_GAIN00_MASK, 256);
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_AWB_GAINS1,
+				 MALI_C55_AWB_GAIN01_MASK,
+				 MALI_C55_AWB_GAIN01(256));
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_AWB_GAINS2,
+				 MALI_C55_AWB_GAIN10_MASK, 256);
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_AWB_GAINS2,
+				 MALI_C55_AWB_GAIN11_MASK,
+				 MALI_C55_AWB_GAIN11(256));
+
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_AWB_GAINS1_AEXP,
+				 MALI_C55_AWB_GAIN00_MASK, 256);
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_AWB_GAINS1_AEXP,
+				 MALI_C55_AWB_GAIN01_MASK,
+				 MALI_C55_AWB_GAIN01(256));
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_AWB_GAINS2_AEXP,
+				 MALI_C55_AWB_GAIN10_MASK, 256);
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_AWB_GAINS2_AEXP,
+				 MALI_C55_AWB_GAIN11_MASK,
+				 MALI_C55_AWB_GAIN11(256));
+
+	/* Bypass mesh shading corrections (LSC). */
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_MESH_SHADING_CONFIG,
+				 MALI_C55_MESH_SHADING_ENABLE_MASK,
+				 false);
+
 	/* Bypass the temper module */
 	mali_c55_ctx_write(mali_c55, MALI_C55_REG_BYPASS_2,
 			   MALI_C55_REG_BYPASS_2_TEMPER);
@@ -802,6 +839,19 @@ void mali_c55_params_init_isp_config(struct mali_c55 *mali_c55,
 
 	/* Disable the colour correction matrix */
 	mali_c55_ctx_write(mali_c55, MALI_C55_REG_CCM_ENABLE, 0);
+
+	/* Disable AWB stats. */
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_METERING_CONFIG,
+				 MALI_C55_AWB_DISABLE_MASK,
+				 MALI_C55_AWB_DISABLE_MASK);
+
+	/* Disable auto-exposure 1024-bin histograms at both tap points. */
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_METERING_CONFIG,
+				 MALI_C55_AEXP_HIST_DISABLE_MASK,
+				 MALI_C55_AEXP_HIST_DISABLE);
+	mali_c55_ctx_update_bits(mali_c55, MALI_C55_REG_METERING_CONFIG,
+				 MALI_C55_AEXP_IHIST_DISABLE_MASK,
+				 MALI_C55_AEXP_IHIST_DISABLE);
 }
 
 void mali_c55_unregister_params(struct mali_c55 *mali_c55)
-- 
2.54.0



