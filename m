Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78FD35BDDF;
	Wed,  3 Dec 2025 16:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779808; cv=none; b=jJbDxcH8C5ILT5aL/RiODQzmxjcIAsaeDSFG85H6Zl04x2GpV1sYZuRLNsJ4mcJUifkGrzcjrkaq7O9FlwCpFHXm0aP6Fl08k2psmeYFD7fp2BvjBkXpZkyYnDfkugMrEn98wfrkqz/8DPGqAGnNnn/0Vgju8NbOiQ7Gm7CS6uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779808; c=relaxed/simple;
	bh=GnlLKyYjmXqfy5bU83N3LHa9JrxyRlxPm/CmfRCsfCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeIXVdBdsIHvC32W4/pDqw84qbIdpq2a3SyTvEJQA/AyHV3fxjuapmxrzrFgC3CZo+tpbLZ0VSN8jOmFbXIG8iSEbYSSl9KAHCuXXDFa6uRLtAy0/zdvbBUHmZURsJmayE9lVJklzv/PSi9LGTQMs1xny6tSttKaJf4Ykglmk/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2v72yuyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2v72yuyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6A8C4CEF5;
	Wed,  3 Dec 2025 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779808;
	bh=GnlLKyYjmXqfy5bU83N3LHa9JrxyRlxPm/CmfRCsfCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2v72yuyxi4kvtiECTT80LPmIx07ZlkhfMFy/ZR1esCPjreqq48tCdfX+bn7zO0FSD
	 DyUkb16TZnaFPOoMzQEXo2FWPPcH/mBeJWUhPorFOtrqbTH6sp1XCbwL2pXtc0lg3a
	 P1NAbJwVGGIxuxO2tBOJzCR1kxotKm4vcE1X9VyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 368/568] net/mlx5: Expose shared buffer registers bits and structs
Date: Wed,  3 Dec 2025 16:26:10 +0100
Message-ID: <20251203152454.176795625@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 8d231dbc3b10155727bcfa9e543d397ad357f14f ]

Add the shared receive buffer management and configuration registers:
1. SBPR - Shared Buffer Pools Register
2. SBCM - Shared Buffer Class Management Register

Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 9fcc2b6c1052 ("net/mlx5e: Fix potentially misleading debug message")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/driver.h   |  2 ++
 include/linux/mlx5/mlx5_ifc.h | 61 +++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index b05f69a8306c9..9af7180eac9e3 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -100,6 +100,8 @@ enum {
 };
 
 enum {
+	MLX5_REG_SBPR            = 0xb001,
+	MLX5_REG_SBCM            = 0xb002,
 	MLX5_REG_QPTS            = 0x4002,
 	MLX5_REG_QETCR		 = 0x4005,
 	MLX5_REG_QTCT		 = 0x400a,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 271c5a87751fe..4df7b3d358607 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10930,6 +10930,67 @@ struct mlx5_ifc_pbmc_reg_bits {
 	u8         reserved_at_2e0[0x80];
 };
 
+struct mlx5_ifc_sbpr_reg_bits {
+	u8         desc[0x1];
+	u8         snap[0x1];
+	u8         reserved_at_2[0x4];
+	u8         dir[0x2];
+	u8         reserved_at_8[0x14];
+	u8         pool[0x4];
+
+	u8         infi_size[0x1];
+	u8         reserved_at_21[0x7];
+	u8         size[0x18];
+
+	u8         reserved_at_40[0x1c];
+	u8         mode[0x4];
+
+	u8         reserved_at_60[0x8];
+	u8         buff_occupancy[0x18];
+
+	u8         clr[0x1];
+	u8         reserved_at_81[0x7];
+	u8         max_buff_occupancy[0x18];
+
+	u8         reserved_at_a0[0x8];
+	u8         ext_buff_occupancy[0x18];
+};
+
+struct mlx5_ifc_sbcm_reg_bits {
+	u8         desc[0x1];
+	u8         snap[0x1];
+	u8         reserved_at_2[0x6];
+	u8         local_port[0x8];
+	u8         pnat[0x2];
+	u8         pg_buff[0x6];
+	u8         reserved_at_18[0x6];
+	u8         dir[0x2];
+
+	u8         reserved_at_20[0x1f];
+	u8         exc[0x1];
+
+	u8         reserved_at_40[0x40];
+
+	u8         reserved_at_80[0x8];
+	u8         buff_occupancy[0x18];
+
+	u8         clr[0x1];
+	u8         reserved_at_a1[0x7];
+	u8         max_buff_occupancy[0x18];
+
+	u8         reserved_at_c0[0x8];
+	u8         min_buff[0x18];
+
+	u8         infi_max[0x1];
+	u8         reserved_at_e1[0x7];
+	u8         max_buff[0x18];
+
+	u8         reserved_at_100[0x20];
+
+	u8         reserved_at_120[0x1c];
+	u8         pool[0x4];
+};
+
 struct mlx5_ifc_qtct_reg_bits {
 	u8         reserved_at_0[0x8];
 	u8         port_number[0x8];
-- 
2.51.0



