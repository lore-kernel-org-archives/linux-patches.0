Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9519411C92
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12564C433C9;
	Mon, 28 Aug 2023 10:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218648;
	bh=qtAiBPEXeYW0ltUF6YKwNt3QnacbAfL7RxEGaN/ybKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOxnzBrWXKL/ltVCjsRXi367p05EXiODp4RtvQ+TjzMAmebFELSvG5ozlWPdRzSi0
	 zCLoZzMN/GMPxrlc38jbkJ5wqjUV6wuBYkS8bNRxJHgRllCEb2hrVN6BszpP3UUtNF
	 ZZYRzAtSQdziShBmySI4lBo8XlL0U//8N5c74Pss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/122] mlxsw: reg: Fix SSPR register layout
Date: Mon, 28 Aug 2023 12:12:29 +0200
Message-ID: <20230828101157.549727596@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 0dc63b9cfd4c5666ced52c829fdd65dcaeb9f0f1 ]

The two most significant bits of the "local_port" field in the SSPR
register are always cleared since they are overwritten by the deprecated
and overlapping "sub_port" field.

On systems with more than 255 local ports (e.g., Spectrum-4), this
results in the firmware maintaining invalid mappings between system port
and local port. Specifically, two different systems ports (0x1 and
0x101) point to the same local port (0x1), which eventually leads to
firmware errors.

Fix by removing the deprecated "sub_port" field.

Fixes: fd24b29a1b74 ("mlxsw: reg: Align existing registers to use extended local_port field")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/9b909a3033c8d3d6f67f237306bef4411c5e6ae4.1692268427.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 0777bed5bb1af..a34ff19c58bd2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -97,14 +97,6 @@ MLXSW_ITEM32(reg, sspr, m, 0x00, 31, 1);
  */
 MLXSW_ITEM32_LP(reg, sspr, 0x00, 16, 0x00, 12);
 
-/* reg_sspr_sub_port
- * Virtual port within the physical port.
- * Should be set to 0 when virtual ports are not enabled on the port.
- *
- * Access: RW
- */
-MLXSW_ITEM32(reg, sspr, sub_port, 0x00, 8, 8);
-
 /* reg_sspr_system_port
  * Unique identifier within the stacking domain that represents all the ports
  * that are available in the system (external ports).
@@ -120,7 +112,6 @@ static inline void mlxsw_reg_sspr_pack(char *payload, u16 local_port)
 	MLXSW_REG_ZERO(sspr, payload);
 	mlxsw_reg_sspr_m_set(payload, 1);
 	mlxsw_reg_sspr_local_port_set(payload, local_port);
-	mlxsw_reg_sspr_sub_port_set(payload, 0);
 	mlxsw_reg_sspr_system_port_set(payload, local_port);
 }
 
-- 
2.40.1



