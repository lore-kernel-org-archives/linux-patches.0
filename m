Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3293E3115A6;
	Thu, 27 Nov 2025 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255788; cv=none; b=UrBAKy0cWPMWEQgK2i6Xzu1042pwSEaFtPT7mY+iDSH+fzik1yihWaxbFVelWrzoFf96FXg8wmRDY18pdeBoedK5ysYaUy19InSHEaOTVqdzHOjpW4f3AjJP7yYsT+FdB+CeA7rcQn23AnuyNVKR6mwvERysaGAkEEwExM/bp1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255788; c=relaxed/simple;
	bh=u1DHXa8xAougz9TzNfL6kxFzdqmOzQ+nC0LccNy4+1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIqQYBe1cneCdE0qcddWvxCxOUimOiUBJmhIrysHJRgZExHp8YYvlC/psoRMettwHk01AjNMoEyPae8K+f9slyAfuGzMjgt9Wyg/lJyeUeVZ06YL1EEaaYwBgQwbti0R8gFPhvpnCIWOpSBYrcp2wQVpT2Ci+ujKD1u7lUhGoU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epoeIJBb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epoeIJBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11F9C4CEF8;
	Thu, 27 Nov 2025 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255788;
	bh=u1DHXa8xAougz9TzNfL6kxFzdqmOzQ+nC0LccNy4+1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epoeIJBbeimpyIOJNZJW0N789MznK2Tj904l8YJDJVHGF7HjKKIJbEnu3i9MSEAdG
	 Feiboqetbgr0ORG5l631JO7emZ4TROFgMaNEkpAdH+nv2oWqQGAzk0ABLknujMy5Nv
	 xD6eck84rsICc26aqyoR9z4GzvkZPc9X6b+EBhm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 115/175] drm/i915/xe3: Restrict PTL intel_encoder_is_c10phy() to only PHY A
Date: Thu, 27 Nov 2025 15:46:08 +0100
Message-ID: <20251127144047.160308754@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>

[ Upstream commit 5474560381775bc70cc90ed2acefad48ffd6ee07 ]

On PTL, no combo PHY is connected to PORT B. However, PORT B can
still be used for Type-C and will utilize the C20 PHY for eDP
over Type-C. In such configurations, VBTs also enumerate PORT B.

This leads to issues where PORT B is incorrectly identified as using the
C10 PHY, due to the assumption that returning true for PORT B in
intel_encoder_is_c10phy() would not cause problems.

>From PTL's perspective, only PORT A/PHY A uses the C10 PHY.

Update the helper intel_encoder_is_c10phy() to return true only for
PORT A/PHY on PTL.

v2: Change the condition code style for ptl/wcl

Bspec: 72571,73944
Fixes: 9d10de78a37f ("drm/i915/wcl: C10 phy connected to port A and B")
Signed-off-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://lore.kernel.org/r/20250922150317.2334680-4-dnyaneshwar.bhadane@intel.com
(cherry picked from commit 8147f7a1c083fd565fb958824f7c552de3b2dc46)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_cx0_phy.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_cx0_phy.c b/drivers/gpu/drm/i915/display/intel_cx0_phy.c
index 801235a5bc0a3..a2d2cecf71217 100644
--- a/drivers/gpu/drm/i915/display/intel_cx0_phy.c
+++ b/drivers/gpu/drm/i915/display/intel_cx0_phy.c
@@ -39,14 +39,12 @@ bool intel_encoder_is_c10phy(struct intel_encoder *encoder)
 	struct intel_display *display = to_intel_display(encoder);
 	enum phy phy = intel_encoder_to_phy(encoder);
 
-	/* PTL doesn't have a PHY connected to PORT B; as such,
-	 * there will never be a case where PTL uses PHY B.
-	 * WCL uses PORT A and B with the C10 PHY.
-	 * Reusing the condition for WCL and extending it for PORT B
-	 * should not cause any issues for PTL.
-	 */
-	if (display->platform.pantherlake && phy < PHY_C)
-		return true;
+	if (display->platform.pantherlake) {
+		if (display->platform.pantherlake_wildcatlake)
+			return phy <= PHY_B;
+		else
+			return phy == PHY_A;
+	}
 
 	if ((display->platform.lunarlake || display->platform.meteorlake) && phy < PHY_C)
 		return true;
-- 
2.51.0



