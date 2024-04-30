Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4686612B176;
	Tue, 30 Apr 2024 11:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474898; cv=none; b=P3Hg8N4tUMIIBZYtwMXzjpal7UpuQQlgOOt0iXm7pRYWZVCNKLutCEBgWHEqkfuJktg2YpkCpmdoD55rgRPNiUYtFzgACFaXgaymLVKPYILQ8ZvEnUQY7UnhmgJ00KiNWL83t9PFbgcHBRE9sZCdO8SYf3DM5uJZ0FDnDvwHEgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474898; c=relaxed/simple;
	bh=ysiiPAARKVaEcrrCtvDORgi838mxQJBzZr5gYqxW81o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dves7lSINVuwOn+olH2yUM+1Q3Sj51pFO6lMJfb/Etlwljp0En4ULXdY2F5f6qs6NoG6ZoOVZsugqZaZomIo/fqWZ1tsNd0rX5frUxEtYJnAehfyr16hRRwncMLBi3YNQSQ78yRZfZGpsQFlt/W4KZ3qbqZLToz6UmYTGJ6nabA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfkS1k+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfkS1k+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C536CC2BBFC;
	Tue, 30 Apr 2024 11:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474898;
	bh=ysiiPAARKVaEcrrCtvDORgi838mxQJBzZr5gYqxW81o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfkS1k+HNHTCUkYn6uTQdP0BQDY9TGQU0mqVTrdaVezr/l8ExznoA3QAR2k715aNf
	 pQZd+NTwCGGrnHwKx3YRYB0laI4okJKiKTpqPphKQBmzt6gEDrz8bXKkg9YHiWEbO7
	 NtukQLICP2LcaHuDF2T/jG/k/QYKjh+SuYRWqNc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/138] drm: nv04: Fix out of bounds access
Date: Tue, 30 Apr 2024 12:38:47 +0200
Message-ID: <20240430103050.670747331@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



