Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEC6190663;
	Tue,  8 Oct 2024 12:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391152; cv=none; b=j5wZV11pn16b62opzMj/ltNC2pBcV8FWmZzPAhYb4/113F0WDdFR3J/IUxeuP6yBDMANwa5M2avwKEK5G250/rSCXkyhj3zWOcHkViny9KBKtDfXo6q2AKWTQCZ4rhKliI+a6hymUq+eVVFhfiH5SMCOwdjhGDPG9fpQ3WzGqM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391152; c=relaxed/simple;
	bh=Qn3Ozo8rwbsK6jzopD+yGB8XOD3HXymrRUoDoU5xobs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9bOTZlaZG/cEok33rN31+4VietPonCUITYTE1HmEpubxw24shYfvRRBuPq2JYIEkhxOlnR4He+jF0a0QQqSyE9iEN8UaV3GgRxKQDWJWr0zvChvnHiObw/Q7biQ8W8D0OwyX8SBQ+UxXOugNUUCqscS5NZsuTjdaQ0afiwky8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cphrodh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cphrodh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8C1C4CEC7;
	Tue,  8 Oct 2024 12:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391151;
	bh=Qn3Ozo8rwbsK6jzopD+yGB8XOD3HXymrRUoDoU5xobs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cphrodh24mK/BnhMVysV/30GI96mfbuidH0p8KEvCZ3PQ/swuL6qxvoZYmGeNwWiB
	 LmeGbRMOGQOFHRlWVBTNmuOM269Cw7I2mEscbq2c3piLw2ODgq0b01lT6Mn6qpvZKy
	 g7SVEAya8pYKJg0NI6VTsswijf3sRj8uu8PCqmdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 023/558] net/mlx5e: SHAMPO, Fix overflow of hd_per_wq
Date: Tue,  8 Oct 2024 14:00:53 +0200
Message-ID: <20241008115703.136011130@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 023d2a43ed0d9ab73d4a35757121e4c8e01298e5 ]

When having larger RQ sizes and small MTUs sizes, the hd_per_wq variable
can overflow. Like in the following case:

$> ethtool --set-ring eth1 rx 8192
$> ip link set dev eth1 mtu 144
$> ethtool --features eth1 rx-gro-hw on

... yields in dmesg:

mlx5_core 0000:08:00.1: mlx5_cmd_out_err:808:(pid 194797): CREATE_MKEY(0x200) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x3bf6f), err(-22)

because hd_per_wq is 64K which overflows to 0 and makes the command
fail.

This patch increases the variable size to 32 bit.

Fixes: 99be56171fa9 ("net/mlx5e: SHAMPO, Re-enable HW-GRO")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index d9e241423bc56..6cff0c45ff981 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -627,7 +627,7 @@ struct mlx5e_shampo_hd {
 	struct mlx5e_dma_info *info;
 	struct mlx5e_frag_page *pages;
 	u16 curr_page_index;
-	u16 hd_per_wq;
+	u32 hd_per_wq;
 	u16 hd_per_wqe;
 	unsigned long *bitmap;
 	u16 pi;
-- 
2.43.0



