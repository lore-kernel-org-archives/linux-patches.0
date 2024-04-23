Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDD620B3E;
	Tue, 23 Apr 2024 21:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908489; cv=none; b=tI5pvb94U7gTZxoVoJWnWuyZ8D7ndy9ZePQLcWNbWMI8DLblxuL8zlEfBBNP2PUpSFgd7IvDFUjw+AaOcaVloDqAeQsNjx8CgkrqnVG1YMWKxA/aTqz1BP7IA/wMIBEj5uzFFQy4RyhsoXdb/xJYhN0dQz85LL2G+yq+vlxy8Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908489; c=relaxed/simple;
	bh=U1fcHeSEl2QQfNgrfqAoT3dJff74zP1ksVFkgTHr8lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+hEqnqirw1WxDuBAIUyUKM9MR/JbZMCXdEeHgvQMulDYONSBX2lIxx3YmJhJa8eu1lqFMEvNRJryUNqzk6ErA6cWP0nsuv4p+52hM0KX8QLWI25+zXx0hFjaTKMZZA6gcT9oLiZXPG8Hsl99kZiYSmOZyEZL2GVBLA9NYpdaIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRQxHR6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRQxHR6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6C3C3277B;
	Tue, 23 Apr 2024 21:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908489;
	bh=U1fcHeSEl2QQfNgrfqAoT3dJff74zP1ksVFkgTHr8lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRQxHR6Yemjql1aoJA3NLKDOzcPjH+auoUlErvoOKkobhJNaTkkx3ea0oPKZ5uj37
	 XIBhazBvCCOkUCrteVRfOEmiYm9r5D3MMqtveWbCEtJCvARSTL0MljORbG2+jbPJ25
	 oIxhH+7hotYDhoZz6ZqMtEM3SAjXgg6GMY3LeVuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 064/158] drm: nv04: Fix out of bounds access
Date: Tue, 23 Apr 2024 14:38:06 -0700
Message-ID: <20240423213858.038392446@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kobuk <m.kobuk@ispras.ru>

[ Upstream commit cf92bb778eda7830e79452c6917efa8474a30c1e ]

When Output Resource (dcb->or) value is assigned in
fabricate_dcb_output(), there may be out of bounds access to
dac_users array in case dcb->or is zero because ffs(dcb->or) is
used as index there.
The 'or' argument of fabricate_dcb_output() must be interpreted as a
number of bit to set, not value.

Utilize macros from 'enum nouveau_or' in calls instead of hardcoding.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 2e5702aff395 ("drm/nouveau: fabricate DCB encoder table for iMac G4")
Fixes: 670820c0e6a9 ("drm/nouveau: Workaround incorrect DCB entry on a GeForce3 Ti 200.")
Signed-off-by: Mikhail Kobuk <m.kobuk@ispras.ru>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240411110854.16701-1-m.kobuk@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_bios.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
index 479effcf607e2..79cfab53f80e2 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -23,6 +23,7 @@
  */
 
 #include "nouveau_drv.h"
+#include "nouveau_bios.h"
 #include "nouveau_reg.h"
 #include "dispnv04/hw.h"
 #include "nouveau_encoder.h"
@@ -1677,7 +1678,7 @@ apply_dcb_encoder_quirks(struct drm_device *dev, int idx, u32 *conn, u32 *conf)
 	 */
 	if (nv_match_device(dev, 0x0201, 0x1462, 0x8851)) {
 		if (*conn == 0xf2005014 && *conf == 0xffffffff) {
-			fabricate_dcb_output(dcb, DCB_OUTPUT_TMDS, 1, 1, 1);
+			fabricate_dcb_output(dcb, DCB_OUTPUT_TMDS, 1, 1, DCB_OUTPUT_B);
 			return false;
 		}
 	}
@@ -1763,26 +1764,26 @@ fabricate_dcb_encoder_table(struct drm_device *dev, struct nvbios *bios)
 #ifdef __powerpc__
 	/* Apple iMac G4 NV17 */
 	if (of_machine_is_compatible("PowerMac4,5")) {
-		fabricate_dcb_output(dcb, DCB_OUTPUT_TMDS, 0, all_heads, 1);
-		fabricate_dcb_output(dcb, DCB_OUTPUT_ANALOG, 1, all_heads, 2);
+		fabricate_dcb_output(dcb, DCB_OUTPUT_TMDS, 0, all_heads, DCB_OUTPUT_B);
+		fabricate_dcb_output(dcb, DCB_OUTPUT_ANALOG, 1, all_heads, DCB_OUTPUT_C);
 		return;
 	}
 #endif
 
 	/* Make up some sane defaults */
 	fabricate_dcb_output(dcb, DCB_OUTPUT_ANALOG,
-			     bios->legacy.i2c_indices.crt, 1, 1);
+			     bios->legacy.i2c_indices.crt, 1, DCB_OUTPUT_B);
 
 	if (nv04_tv_identify(dev, bios->legacy.i2c_indices.tv) >= 0)
 		fabricate_dcb_output(dcb, DCB_OUTPUT_TV,
 				     bios->legacy.i2c_indices.tv,
-				     all_heads, 0);
+				     all_heads, DCB_OUTPUT_A);
 
 	else if (bios->tmds.output0_script_ptr ||
 		 bios->tmds.output1_script_ptr)
 		fabricate_dcb_output(dcb, DCB_OUTPUT_TMDS,
 				     bios->legacy.i2c_indices.panel,
-				     all_heads, 1);
+				     all_heads, DCB_OUTPUT_B);
 }
 
 static int
-- 
2.43.0



