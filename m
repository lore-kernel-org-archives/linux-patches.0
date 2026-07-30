Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8908429802;
	Thu, 30 Jul 2026 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422131; cv=none; b=Xry1JXiQlHgv6vV4VlpQ2tmi1ud7RITYi3e6glNZu0eMQDosrtR4HF85a4NhSDw2azCZd6x1azOXFM8VS2IMM/girR/UsftxMFu3+9uFCWEWxMsFLD4qQy3j1s4UjEd11SYH1xi6b8z3BbetRNt0P7jm/RVUgZp8JEuUfoLOj4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422131; c=relaxed/simple;
	bh=mK6/u5zXe723hivjt43/tDkG7cNXbKIN5iBEOqjVrIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UE0u/KM/1IaTVLS9XbSG8vx0KKjg+9znePL50PuE1ZfJegoMe/7DfbrxxZfZ4j0AfUYKj07+ZiMz1bmnxURHe348XuXlFnSz+iUQsvT1eBCmZPIEFqzHoKworhxFxFCRc2kN3k10mGTRghfRygIiuvLsWf65w+4l2uUUayYT6S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DahJMdUk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DahJMdUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE4A1F000E9;
	Thu, 30 Jul 2026 14:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422130;
	bh=83DqI9c889qRolhg00F9Tpsul552rn1hswZfTJF4Lds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DahJMdUkLYZJGjlNylzGYn29Li3ecXRI5MEq+uCClyD3SW+/3/n7TJXNwfGdfPXDl
	 8tSHGPspaG4nlUUc/r1RKHGtPxphNyaNmlR54tng/zke4ekCHHH4dGSZ7aQhL7IjUg
	 9AMBsfv4z+y6MZAMi5CMbZEKUawThvz0aYIG1ZKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Alex Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 335/744] net/mlx5: Fix MCIA register buffer overflow on 32 dword reads
Date: Thu, 30 Jul 2026 16:10:08 +0200
Message-ID: <20260730141451.403391394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index ee8b9765c5bafd..2cba370a01d468 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -314,7 +314,7 @@ static int mlx5_query_module_id(struct mlx5_core_dev *dev, int module_num,
 		return -EIO;
 	}
 
-	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dwords);
 
 	*module_id = ptr[0];
 
@@ -399,7 +399,7 @@ static int mlx5_query_mcia(struct mlx5_core_dev *dev,
 		return -EIO;
 	}
 
-	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dwords);
 	memcpy(data, ptr, size);
 
 	return size;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 49f3ad4b1a7c54..dfd98e17fe688d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -12203,18 +12203,7 @@ struct mlx5_ifc_mcia_reg_bits {
 
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



