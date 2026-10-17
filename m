Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691803B19BA;
	Sat, 17 Oct 2026 17:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259049; cv=none; b=Hd2etbJGyS6T5/Ot5K/eGM3bMRt9qD6EjM3hZcRIx682zz2Z/+vJuUq0fnWZePdeEPSnFyNVfBgbX56klpnMaJWktAAOU3p4VXsOvhxbgQAHxBtP2S2VhQeVmMQEXuxP+Gd3XDMmoK7eNyDrswG3EQh2/Qa6c+UJ+IxIg/m70sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259049; c=relaxed/simple;
	bh=iDq6/U+1inhWvsWIAN3UWvODMxC/jzZGIt6iROj5Lyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmkUaYZK3jFfBol53FVCefImkwYIgUrAgm9NX07qlJEVzPgmBiBLS3mVZO72OxwTaTYcduheY+JiNekkA/stDOqB5S/CZWs1xLvRdVm1HOl1bz2+AxyAi+akq90QnYeQivgnhE0LOs4H4fLI8CxCp2QRsV/3RwJV86+OcphLOR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWi07Y9h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWi07Y9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F5E1F000C5;
	Sat, 17 Oct 2026 17:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259048;
	bh=d/Se/vqut9/GLOiQOqsRQdPCHqxGWYjE3yYxqQ4gzq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eWi07Y9h6av5686+ly0sZKq41LPtytbuYyrP3G2xx/aCxIYrnFef0UPPPIbjAw0hm
	 v99rz9xq8uJxfSabE3LqbJBYrrjFGkAeUqPe+ZNoHDdGfHF5kWL2FPyGlM89ZuZ5i/
	 8avnsztYVD5ATTyMrzxfOLGT19YmZKsMJqFgx5R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Alex Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1085/1674] net/mlx5: Fix MCIA register buffer overflow on 32 dword reads
Date: Sat, 17 Oct 2026 17:55:57 +0200
Message-ID: <20261017160458.979165407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 11c057d23465c7a5817a7284c896d19d54c0b616 ]

The MCIA register can return up to 32 dwords (128 bytes) when the device
advertises the mcia_32dwords capability, but struct
mlx5_ifc_mcia_reg_bits only defines dword_0..11, leaving room for just
12 dwords (48 bytes) of data.

mlx5_query_mcia() clamps the read size to mlx5_mcia_max_bytes() and then
memcpy()s that many bytes out of the register, potentially reading past
the end of the 'out' buffer. On kernels built with FORTIFY_SOURCE this
is caught as a buffer overflow while reading the module EEPROM via
ethtool:

  detected buffer overflow in memcpy
  kernel BUG at lib/string_helpers.c:1048!
  RIP: 0010:fortify_panic+0x13/0x20
  Call Trace:
   mlx5_query_mcia.isra.0+0x200/0x210 [mlx5_core]
   mlx5_query_module_eeprom_by_page+0x4a/0xa0 [mlx5_core]
   mlx5e_get_module_eeprom_by_page+0xbb/0x120 [mlx5_core]
   eeprom_prepare_data+0xf3/0x170
   ethnl_default_doit+0xf1/0x3b0

Extend the mcia_reg layout to 32 dwords.

Fixes: 271907ee2f29 ("net/mlx5: Query the maximum MCIA register read size from firmware")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Alex Lazar <alazar@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260717072338.1240582-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c |  4 ++--
 include/linux/mlx5/mlx5_ifc.h                  | 13 +------------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index a5622b44385eb..ec739b2f0adac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -316,7 +316,7 @@ static int mlx5_query_module_id(struct mlx5_core_dev *dev, int module_num,
 			      status);
 		return -EIO;
 	}
-	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dwords);
 
 	*module_id = ptr[0];
 
@@ -401,7 +401,7 @@ static int mlx5_query_mcia(struct mlx5_core_dev *dev,
 		return -EIO;
 	}
 
-	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dwords);
 	memcpy(data, ptr, size);
 
 	return size;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c59fd31719a13..573461c9dced5 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11320,18 +11320,7 @@ struct mlx5_ifc_mcia_reg_bits {
 
 	u8         reserved_at_60[0x20];
 
-	u8         dword_0[0x20];
-	u8         dword_1[0x20];
-	u8         dword_2[0x20];
-	u8         dword_3[0x20];
-	u8         dword_4[0x20];
-	u8         dword_5[0x20];
-	u8         dword_6[0x20];
-	u8         dword_7[0x20];
-	u8         dword_8[0x20];
-	u8         dword_9[0x20];
-	u8         dword_10[0x20];
-	u8         dword_11[0x20];
+	u8         dwords[0x400];
 };
 
 struct mlx5_ifc_dcbx_param_bits {
-- 
2.53.0



