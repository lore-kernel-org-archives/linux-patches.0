Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3F63750CF;
	Thu, 30 Jul 2026 15:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424183; cv=none; b=UEKnSsnnQ9wI6OFtxbgczndclvHOC6etlah4iWaQxNBZeZCvcfjPsuUGwOUjtitPgr07iiFDce8E/x6fN7uTZlRRxgsdr1KTSXm9+cNVMDiN/d81+NmZGQ3ceMuj3AJlJhzkw6ag6fcXd13rTJGJ9RuaokRsZrhOTVZGP8RmymU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424183; c=relaxed/simple;
	bh=eYUCB+Q2bQGLZvr+meeWPYU92pgJfqmbUtQc8JkCNB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAB9Iui89nrMX+ZkrKiiF0iHri7mWV7MtOsbQZINaIze4LSRQw4nii7FJiZQVB39sXqinJEDMLUPYkBjoBibenoN6iS7uQEmOVJJ4J/pdTg/WWkkCttYNNMV4673p+bSuC8ZtPLcJ3EJiQOWnBRB07Acps6a71dlALIXAxu67xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkLnfzze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkLnfzze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731091F000E9;
	Thu, 30 Jul 2026 15:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424182;
	bh=osX95v0gpDtXQ1BcyJzaqVUAwcwsjbSjQA+FVVhP+X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkLnfzzexDZeYL6s3iUKF8Te+p6Ry43aVB9YvdKZipoPG9jIrR7QtTQCNvQzgHwVk
	 hzUBhB2GFi07XN4D6T2bmFcN2KnekkLys60ikVb28xNhD4xs1TyuCC7tXsNRgdGfsE
	 ioNFM4NUYqjWBD9GROfHv5/Nx3NXxk3J9BgEuFHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Alex Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 303/675] net/mlx5: Fix MCIA register buffer overflow on 32 dword reads
Date: Thu, 30 Jul 2026 16:10:33 +0200
Message-ID: <20260730141451.562425741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5fa06f69943dff..d25713ce65b6d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -314,7 +314,7 @@ static int mlx5_query_module_id(struct mlx5_core_dev *dev, int module_num,
 		return -EIO;
 	}
 
-	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dwords);
 
 	*module_id = ptr[0];
 
@@ -397,7 +397,7 @@ static int mlx5_query_mcia(struct mlx5_core_dev *dev,
 	if (*status)
 		return -EIO;
 
-	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dwords);
 	memcpy(data, ptr, size);
 
 	return size;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1b0b36aa2a767a..61257b866fb24e 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -12141,18 +12141,7 @@ struct mlx5_ifc_mcia_reg_bits {
 
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



