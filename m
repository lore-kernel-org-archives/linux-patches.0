Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D592B9A6;
	Thu,  3 Jul 2025 15:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555044; cv=none; b=bWUc4bRvaFvL050dKtBksRUJ/rxc4HpNZJiT69I9p5BQQK/3iMx6tGhKd1OF+EGAxrUeoL9+1b1kGvDyKZKNuqulklMWjy1BzBIZV8FsAwnWIrJWhpwk1s5UV0iZb9bDWfdpU9lGEi3+gNevL7y3hhMz4VXST8rxqbhbM0bKINw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555044; c=relaxed/simple;
	bh=avWKnBlLTsaS4oAMPUhEISgI7fft+uOTiVY1ZxqkQVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aq4RY9EZzxFxfr2M/WGhsp1KzI76UhfVuv9v3AcykPB2f4AeCWS1+Z4V1DetAVyz9kRWSOi/YtaJmJ8eQhoQwv8VHrm6v4InivcmbKhUXr0jSnHR4S0ikiSg3imvuvSPG0LdIM56ngHDTLhtBCKcOwvlf7KhGp4zIAooYzIX7Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BETy8CVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BETy8CVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99385C4CEE3;
	Thu,  3 Jul 2025 15:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555043;
	bh=avWKnBlLTsaS4oAMPUhEISgI7fft+uOTiVY1ZxqkQVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BETy8CVtiJftcQlGuzgiRZ4T/7Y2aGRfSBcRbCKgpN/ubB9mj4+V9Pn64z/hNfxcU
	 CbXMyYker2xuWFi8F1IWePweNSm8W6WsZbcC/7YYLZBjys95t8uESngela0fmnV7nJ
	 NJCLsmTiF8CwHABPiisEdO5qkM/mrVtxijdY3Q/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vas Novikov <vasya.novikov@gmail.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.15 128/263] drm/i915/snps_hdmi_pll: Fix 64-bit divisor truncation by using div64_u64
Date: Thu,  3 Jul 2025 16:40:48 +0200
Message-ID: <20250703144009.488031117@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

commit 9205999e9f13a07cb29d5a8836c25afdca186007 upstream.

DIV_ROUND_CLOSEST_ULL uses do_div(), which expects a 32-bit divisor.
When passing a 64-bit constant like CURVE2_MULTIPLIER, the value is
silently truncated to u32, potentially leading to incorrect results
on large divisors.

Replace DIV_ROUND_CLOSEST_ULL with DIV64_U64_ROUND_CLOSEST which correctly
handles full 64-bit division.

v2: Use DIV64_U64_ROUND_CLOSEST instead of div64_u64 macro. (Jani)

Fixes: 5947642004bf ("drm/i915/display: Add support for SNPS PHY HDMI PLL algorithm for DG2")
Reported-by: Vas Novikov <vasya.novikov@gmail.com>
Closes: https://lore.kernel.org/all/8d7c7958-9558-4c8a-a81a-e9310f2d8852@gmail.com/
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Suraj Kandpal <suraj.kandpal@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Vas Novikov <vasya.novikov@gmail.com>
Cc: stable@vger.kernel.org # v6.15+
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://lore.kernel.org/r/20250618130951.1596587-2-ankit.k.nautiyal@intel.com
(cherry picked from commit b300a175a11e6a934d728317dc39787723cc7917)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_snps_hdmi_pll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_snps_hdmi_pll.c b/drivers/gpu/drm/i915/display/intel_snps_hdmi_pll.c
index 74bb3bedf30f..5111bdc3075b 100644
--- a/drivers/gpu/drm/i915/display/intel_snps_hdmi_pll.c
+++ b/drivers/gpu/drm/i915/display/intel_snps_hdmi_pll.c
@@ -103,8 +103,8 @@ static void get_ana_cp_int_prop(u64 vco_clk,
 			    DIV_ROUND_DOWN_ULL(curve_1_interpolated, CURVE0_MULTIPLIER)));
 
 	ana_cp_int_temp =
-		DIV_ROUND_CLOSEST_ULL(DIV_ROUND_DOWN_ULL(adjusted_vco_clk1, curve_2_scaled1),
-				      CURVE2_MULTIPLIER);
+		DIV64_U64_ROUND_CLOSEST(DIV_ROUND_DOWN_ULL(adjusted_vco_clk1, curve_2_scaled1),
+					CURVE2_MULTIPLIER);
 
 	*ana_cp_int = max(1, min(ana_cp_int_temp, 127));
 
-- 
2.50.0



