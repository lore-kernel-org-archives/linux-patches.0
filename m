Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD7C1CAA68;
	Wed, 19 Feb 2025 08:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953989; cv=none; b=Js1cfbcUlJEMouVWtXv11ap9Y3TKE6FGFdtCwEtS2TYQXFBULIj/gWzVjwSD4tQYPXpYqu6mMUhnfUvnDApm8DDHE7xegrUT874Ttk7uyCdKG3ZZ+T8RA+v84jCRccfseJKOcNkAQmwZo+fsAmzPZqxtHBLxMSdLlj6dC0qOEs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953989; c=relaxed/simple;
	bh=mvKfRS2fT2j6ay+zIun5UTGCNIJT+9ycAyhIcVxyyWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAnwq7jOjnddWx7T1YmaV5RK3EyTJgfHDEsohUFiV9GZf/8HfBZ5NTh58z1WHRVOvVQ85j4w2mqTso+kVn8XR0bY1sUeUiZLQxhiuD7MyCM9CywaNmRJDxsBmj7VkTpNNw7SJ6Ih2aoz8PPx5g8wNK/mrEmPirEyB+Q+FCYBGzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCnr0l5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCnr0l5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A01C4CED1;
	Wed, 19 Feb 2025 08:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953989;
	bh=mvKfRS2fT2j6ay+zIun5UTGCNIJT+9ycAyhIcVxyyWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCnr0l5XA0DZ+W/uZxjH10oOXGhZZRDesbV3WUmwBMKXlzogJZe0TB73Owe4+kO/W
	 ZWHRzbfxFLaW6wztNbsU0zUnp1SRjRRHbJ5QSJFFpWG7CA+DNry7EMW/DIGHKAQMQD
	 W+Z6u1bwX31uxWGZs2fvO4o5AF5wH98emv4v3tH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 060/274] drm: Fix DSC BPP increment decoding
Date: Wed, 19 Feb 2025 09:25:14 +0100
Message-ID: <20250219082611.975454675@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit e00a2e5d485faf53c7a24b9d1b575a642227947f ]

Starting with DPCD version 2.0 bits 6:3 of the DP_DSC_BITS_PER_PIXEL_INC
DPCD register contains the NativeYCbCr422_MAX_bpp_DELTA field, which can
be non-zero as opposed to earlier DPCD versions, hence decoding the
bit_per_pixel increment value at bits 2:0 in the same register requires
applying a mask, do so.

Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Fixes: 0c2287c96521 ("drm/display/dp: Add helper function to get DSC bpp precision")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250212161851.4007005-1-imre.deak@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c | 2 +-
 include/drm/display/drm_dp.h            | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/display/drm_dp_helper.c
index 6ee51003de3ce..9fa13da513d24 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -2421,7 +2421,7 @@ u8 drm_dp_dsc_sink_bpp_incr(const u8 dsc_dpcd[DP_DSC_RECEIVER_CAP_SIZE])
 {
 	u8 bpp_increment_dpcd = dsc_dpcd[DP_DSC_BITS_PER_PIXEL_INC - DP_DSC_SUPPORT];
 
-	switch (bpp_increment_dpcd) {
+	switch (bpp_increment_dpcd & DP_DSC_BITS_PER_PIXEL_MASK) {
 	case DP_DSC_BITS_PER_PIXEL_1_16:
 		return 16;
 	case DP_DSC_BITS_PER_PIXEL_1_8:
diff --git a/include/drm/display/drm_dp.h b/include/drm/display/drm_dp.h
index a6f8b098c56f1..3bd9f482f0c3e 100644
--- a/include/drm/display/drm_dp.h
+++ b/include/drm/display/drm_dp.h
@@ -359,6 +359,7 @@
 # define DP_DSC_BITS_PER_PIXEL_1_4          0x2
 # define DP_DSC_BITS_PER_PIXEL_1_2          0x3
 # define DP_DSC_BITS_PER_PIXEL_1_1          0x4
+# define DP_DSC_BITS_PER_PIXEL_MASK         0x7
 
 #define DP_PSR_SUPPORT                      0x070   /* XXX 1.2? */
 # define DP_PSR_IS_SUPPORTED                1
-- 
2.39.5



