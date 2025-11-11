Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E2A34D38E;
	Tue, 11 Nov 2025 01:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825410; cv=none; b=mTRBYEzHWTSQXUvVwP6JivV+CrulKHhmxAFxvHJh3TUg8juCbCcAq4AJed3wmLlGyZ7CytuRipL9MkmHXZHPhkiY7wmj3W4Z42Hax+8qP6N+6rrbuGPFcXqFyoouBcgshPC9PVczdzgLrMkRXaqEEkG1vp83TUIdkPei6+ipzEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825410; c=relaxed/simple;
	bh=YlXZWe0f/3ncuozE0Zuts+8iPBvxphA2C4Kk+NESomk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mimj7rh2SF9/KOzkiR/WouS9sVlVvW9wWf+7iZS4iEhs2iGyRgV62ihIK11EAhwLE4WWaUZvv4clzprPUq0aIu4lFxgMXDohAu+3x1W3oemHF8Gvp5wy9iYfXienHw5AxSoWEzbKxaqib/b7VVLTjxsgoRhbPnf4X+avy1auEbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtY0z+dK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtY0z+dK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D14C116B1;
	Tue, 11 Nov 2025 01:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825409;
	bh=YlXZWe0f/3ncuozE0Zuts+8iPBvxphA2C4Kk+NESomk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtY0z+dK8AViTAvoNUo88DCl2ycYgL9YK9Qh/cFloiOKzCHNk6BONknbQlC4hyCa6
	 bNTQOVGdcUdYHMw+rH3l+b/XI/lrOPkxmx22cfrmkdTTCYQK9KhHpFJWibqRt9PPsW
	 k06a0uVipqzmZY/DTQMuOG1t29fDRYua6DMTeMFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Alex Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 789/849] net/mlx5e: Fix return value in case of module EEPROM read error
Date: Tue, 11 Nov 2025 09:45:59 +0900
Message-ID: <20251111004555.509778853@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit d1c94bc5b90c21b65469d30d4a6bc8ed715c1bfe ]

mlx5e_get_module_eeprom_by_page() has weird error handling.

First, it is treating -EINVAL as a special case, but it is unclear why.

Second, it tries to fail "gracefully" by returning the number of bytes
read even in case of an error. This results in wrongly returning
success (0 return value) if the error occurs before any bytes were
read.

Simplify the error handling by returning an error when such occurs. This
also aligns with the error handling we have in mlx5e_get_module_eeprom()
for the old API.

This fixes the following case where the query fails, but userspace
ethtool wrongly treats it as success and dumps an output:

  # ethtool -m eth2
  netlink warning: mlx5_core: Query module eeprom by page failed, read 0 bytes, err -5
  netlink warning: mlx5_core: Query module eeprom by page failed, read 0 bytes, err -5
  Offset		Values
  ------		------
  0x0000:		00 00 00 00 05 00 04 00 00 00 00 00 05 00 05 00
  0x0010:		00 00 00 00 05 00 06 00 50 00 00 00 67 65 20 66
  0x0020:		61 69 6c 65 64 2c 20 72 65 61 64 20 30 20 62 79
  0x0030:		74 65 73 2c 20 65 72 72 20 2d 35 00 14 00 03 00
  0x0040:		08 00 01 00 03 00 00 00 08 00 02 00 1a 00 00 00
  0x0050:		14 00 04 00 08 00 01 00 04 00 00 00 08 00 02 00
  0x0060:		0e 00 00 00 14 00 05 00 08 00 01 00 05 00 00 00
  0x0070:		08 00 02 00 1a 00 00 00 14 00 06 00 08 00 01 00

Fixes: e109d2b204da ("net/mlx5: Implement get_module_eeprom_by_page()")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Alex Lazar <alazar@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1762265736-1028868-1-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d507366d773e1..2198c9e893da6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2121,14 +2121,12 @@ static int mlx5e_get_module_eeprom_by_page(struct net_device *netdev,
 		if (!size_read)
 			return i;
 
-		if (size_read == -EINVAL)
-			return -EINVAL;
 		if (size_read < 0) {
 			NL_SET_ERR_MSG_FMT_MOD(
 				extack,
 				"Query module eeprom by page failed, read %u bytes, err %d",
 				i, size_read);
-			return i;
+			return size_read;
 		}
 
 		i += size_read;
-- 
2.51.0



