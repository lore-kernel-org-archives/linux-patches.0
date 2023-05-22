Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A3F168B6
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A967C4339B;
	Mon, 22 May 2023 19:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684782793;
	bh=ShXMDo/Cm+yn9OtbinjrTZQeJkB1C7gNGJkp2umDGvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q45whb0N01sQfCyWdVY2L2zm9WbOhKzEEnrKoS6TcPCOcbQxDIypDbcLWZV9nHmju
	 OHlol5iFjX2o8Y2Wfwg3aoTwp+mKtTP4tJHZwBH+vHSCNbAmUaCWijFuuDihuI1OEu
	 gZXqdlIWMZyHUgnysQ5kzxyw5ndAKWcL1GSy+a8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/203] drm/i915/dp: prevent potential div-by-zero
Date: Mon, 22 May 2023 20:07:26 +0100
Message-Id: <20230522190355.573887245@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 0ff80028e2702c7c3d78b69705dc47c1ccba8c39 ]

drm_dp_dsc_sink_max_slice_count() may return 0 if something goes
wrong on the part of the DSC sink and its DPCD register. This null
value may be later used as a divisor in intel_dsc_compute_params(),
which will lead to an error.
In the unlikely event that this issue occurs, fix it by testing the
return value of drm_dp_dsc_sink_max_slice_count() against zero.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: a4a157777c80 ("drm/i915/dp: Compute DSC pipe config in atomic check")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230418140430.69902-1-n.zhandarovich@fintech.ru
(cherry picked from commit 51f7008239de011370c5067bbba07f0207f06b72)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 64a15b636e8d4..6cc1258578088 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1231,6 +1231,11 @@ static int intel_dp_dsc_compute_config(struct intel_dp *intel_dp,
 		pipe_config->dsc.slice_count =
 			drm_dp_dsc_sink_max_slice_count(intel_dp->dsc_dpcd,
 							true);
+		if (!pipe_config->dsc.slice_count) {
+			drm_dbg_kms(&dev_priv->drm, "Unsupported Slice Count %d\n",
+				    pipe_config->dsc.slice_count);
+			return -EINVAL;
+		}
 	} else {
 		u16 dsc_max_output_bpp;
 		u8 dsc_dp_slice_count;
-- 
2.39.2



