Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171B51FCCF8;
	Tue, 30 Sep 2025 14:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244160; cv=none; b=LmlnQfMIOYU5JMB6us9h0WPBPWXyXi5kR4PAsjO1YXQH/OPkAjCHNkIaYNNbnPS/fTNPZY3YwhiX9if51nuJq/OGXVaa6+Z8hLnRiYeuzrB2vBWZ3OjvBu7QuONibMiFaCPjq6e/w+a6/zudb64/0tzI/XLxVS2Rz1k3WO8Sqz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244160; c=relaxed/simple;
	bh=39Se7AoEBtCE0nhMI6h5n2Ae9/NK9K4i2jtC7mVghQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tWg516El4J1E4gBni0rcl7vJh73cB0qm1YKqqu4cgYFE0dv++hv2fx2Us/IH9I4QG51IAHCpjKOuLnvRj+o3ZwbyN9QpqwSGss0x9iNchFptVfIoCO1tSDRsg8+ET/rv5ScZR7UbnKCl505xb78qBe5sNggUznfdX0Io1+kaBQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Et3dLHPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Et3dLHPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76200C4CEF0;
	Tue, 30 Sep 2025 14:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244160;
	bh=39Se7AoEBtCE0nhMI6h5n2Ae9/NK9K4i2jtC7mVghQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Et3dLHPxSxmtBxZmNu/6hU2P6Cn/V6geaoKChSqF0N95E0tvOMAu42PGpnRXSHRD9
	 4iL7MGIrrCoECrWPYWnMEBd8gdmNmoq1qHUPTdl1adStKW0yyCupo/LmA10+kbRydr
	 CBxEB7zzHgDjLROwZ92bhPaFEPo71iWDmjU/tim0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/122] drm/i915/power: fix size for for_each_set_bit() in abox iteration
Date: Tue, 30 Sep 2025 16:46:15 +0200
Message-ID: <20250930143824.806276818@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit cfa7b7659757f8d0fc4914429efa90d0d2577dd7 ]

for_each_set_bit() expects size to be in bits, not bytes. The abox mask
iteration uses bytes, but it works by coincidence, because the local
variable holding the mask is unsigned long, and the mask only ever has
bit 2 as the highest bit. Using a smaller type could lead to subtle and
very hard to track bugs.

Fixes: 62afef2811e4 ("drm/i915/rkl: RKL uses ABOX0 for pixel transfers")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: stable@vger.kernel.org # v5.9+
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://lore.kernel.org/r/20250905104149.1144751-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 7ea3baa6efe4bb93d11e1c0e6528b1468d7debf6)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
[ adapted struct intel_display *display parameters to struct drm_i915_private *dev_priv ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_power.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display_power.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power.c
@@ -4780,7 +4780,7 @@ static void icl_mbus_init(struct drm_i91
 	if (IS_GEN(dev_priv, 12))
 		abox_regs |= BIT(0);
 
-	for_each_set_bit(i, &abox_regs, sizeof(abox_regs))
+	for_each_set_bit(i, &abox_regs, BITS_PER_TYPE(abox_regs))
 		intel_de_rmw(dev_priv, MBUS_ABOX_CTL(i), mask, val);
 }
 
@@ -5277,11 +5277,11 @@ static void tgl_bw_buddy_init(struct drm
 	if (table[config].page_mask == 0) {
 		drm_dbg(&dev_priv->drm,
 			"Unknown memory configuration; disabling address buddy logic.\n");
-		for_each_set_bit(i, &abox_mask, sizeof(abox_mask))
+		for_each_set_bit(i, &abox_mask, BITS_PER_TYPE(abox_mask))
 			intel_de_write(dev_priv, BW_BUDDY_CTL(i),
 				       BW_BUDDY_DISABLE);
 	} else {
-		for_each_set_bit(i, &abox_mask, sizeof(abox_mask)) {
+		for_each_set_bit(i, &abox_mask, BITS_PER_TYPE(abox_mask)) {
 			intel_de_write(dev_priv, BW_BUDDY_PAGE_MASK(i),
 				       table[config].page_mask);
 


