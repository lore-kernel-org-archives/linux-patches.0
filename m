Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E24FBF8
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB9CC433D2;
	Mon, 15 May 2023 17:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170790;
	bh=ivP3k2WFf+n9kzd7MuXC+9aumpovZM0r0BZvFDK/bM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQiygi1V38QEsX8UhQur46NTboFRRRZDymyVvNtb/onhfxtA2h0vCO58Fdfcf3YEh
	 MOJhYDHSI0nprSAmYv5EyHnXSKW5pL/jRKmQp2bqxBoDcLbUp/WYOkUjl07YdtoyT4
	 3AMeIClPI0349LD9KUS+n3EVSA4pk3atwigy8xgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
	Manasi Navare <navaremanasi@google.com>,
	Anusha Srivatsa <anusha.srivatsa@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 218/239] drm/dsc: fix drm_edp_dsc_sink_output_bpp() DPCD high byte usage
Date: Mon, 15 May 2023 18:28:01 +0200
Message-Id: <20230515161728.266117767@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 13525645e2246ebc8a21bd656248d86022a6ee8f ]

The operator precedence between << and & is wrong, leading to the high
byte being completely ignored. For example, with the 6.4 format, 32
becomes 0 and 24 becomes 8. Fix it, and remove the slightly confusing
and unnecessary DP_DSC_MAX_BITS_PER_PIXEL_HI_SHIFT macro while at it.

Fixes: 0575650077ea ("drm/dp: DRM DP helper/macros to get DP sink DSC parameters")
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Cc: Manasi Navare <navaremanasi@google.com>
Cc: Anusha Srivatsa <anusha.srivatsa@intel.com>
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230406134615.1422509-1-jani.nikula@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/display/drm_dp.h        | 1 -
 include/drm/display/drm_dp_helper.h | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/drm/display/drm_dp.h b/include/drm/display/drm_dp.h
index 9bc22a02874d9..50428ba92ce8b 100644
--- a/include/drm/display/drm_dp.h
+++ b/include/drm/display/drm_dp.h
@@ -286,7 +286,6 @@
 
 #define DP_DSC_MAX_BITS_PER_PIXEL_HI        0x068   /* eDP 1.4 */
 # define DP_DSC_MAX_BITS_PER_PIXEL_HI_MASK  (0x3 << 0)
-# define DP_DSC_MAX_BITS_PER_PIXEL_HI_SHIFT 8
 # define DP_DSC_MAX_BPP_DELTA_VERSION_MASK  0x06
 # define DP_DSC_MAX_BPP_DELTA_AVAILABILITY  0x08
 
diff --git a/include/drm/display/drm_dp_helper.h b/include/drm/display/drm_dp_helper.h
index ab55453f2d2cd..ade9df59e156a 100644
--- a/include/drm/display/drm_dp_helper.h
+++ b/include/drm/display/drm_dp_helper.h
@@ -181,9 +181,8 @@ static inline u16
 drm_edp_dsc_sink_output_bpp(const u8 dsc_dpcd[DP_DSC_RECEIVER_CAP_SIZE])
 {
 	return dsc_dpcd[DP_DSC_MAX_BITS_PER_PIXEL_LOW - DP_DSC_SUPPORT] |
-		(dsc_dpcd[DP_DSC_MAX_BITS_PER_PIXEL_HI - DP_DSC_SUPPORT] &
-		 DP_DSC_MAX_BITS_PER_PIXEL_HI_MASK <<
-		 DP_DSC_MAX_BITS_PER_PIXEL_HI_SHIFT);
+		((dsc_dpcd[DP_DSC_MAX_BITS_PER_PIXEL_HI - DP_DSC_SUPPORT] &
+		  DP_DSC_MAX_BITS_PER_PIXEL_HI_MASK) << 8);
 }
 
 static inline u32
-- 
2.39.2



