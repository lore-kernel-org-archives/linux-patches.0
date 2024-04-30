Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EEE12C805;
	Tue, 30 Apr 2024 11:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476079; cv=none; b=Cm9Be3bZXuVKkDKEWNc+nJN7LspMW4yr24CP1gLntqi5Xnq7VjBkEqFeIgN4TVkvMNaNXj1J5RKI14FiynqSWJs/avvDw/tBttJBzidN7WCpZTj9ls6x+JElBATWLcj2upLHZi+LbWa7RzlvLibSRxmNtwgP8fDS9fww7dcgYak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476079; c=relaxed/simple;
	bh=Hn7U/fLLqEEW8OTEm25vjMLbc8eeBq1ISRQ48U8Ae9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aegoS3Nm9/AYLb936YSW7ZAO0mzEmt4evDLjbCE9NYYCp/n4+jQFaG4bMvqnY63pUMfzs+82ixQmqVLjX6BtIlyUPYLjkJr0GoTpucp5sflcXXT9EFYeqNQJPeOTZSawHSy8aBs594CUxIkl80+BPBzEMo/pPTz0Am9anlvsbhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZM70Cp08; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZM70Cp08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B60AC4AF1A;
	Tue, 30 Apr 2024 11:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476078;
	bh=Hn7U/fLLqEEW8OTEm25vjMLbc8eeBq1ISRQ48U8Ae9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZM70Cp08ZtzCR+Xon7EbazkrKp3insmVPIPn0yGvxhOL0hJuYeKFMtSMAHHqFVqx3
	 x5RKrLZE4q58Z2nkK+luooPmC2l2/khxJIURE48SwqXVJXNW1sntWLxUEosYTlFdG8
	 dl2l1yXamvGp7NLokNxa6f5DGk+ecQtcf3B4vIkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/107] drm: nv04: Fix out of bounds access
Date: Tue, 30 Apr 2024 12:39:47 +0200
Message-ID: <20240430103045.464531298@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d204ea8a5618e..5cdf0d8d4bc18 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -23,6 +23,7 @@
  */
 
 #include "nouveau_drv.h"
+#include "nouveau_bios.h"
 #include "nouveau_reg.h"
 #include "dispnv04/hw.h"
 #include "nouveau_encoder.h"
@@ -1672,7 +1673,7 @@ apply_dcb_encoder_quirks(struct drm_device *dev, int idx, u32 *conn, u32 *conf)
 	 */
 	if (nv_match_device(dev, 0x0201, 0x1462, 0x8851)) {
 		if (*conn == 0xf2005014 && *conf == 0xffffffff) {
-			fabricate_dcb_output(dcb, DCB_OUTPUT_TMDS, 1, 1, 1);
+			fabricate_dcb_output(dcb, DCB_OUTPUT_TMDS, 1, 1, DCB_OUTPUT_B);
 			return false;
 		}
 	}
@@ -1758,26 +1759,26 @@ fabricate_dcb_encoder_table(struct drm_device *dev, struct nvbios *bios)
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



