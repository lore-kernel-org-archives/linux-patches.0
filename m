Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832E63E9F6F;
	Thu, 15 Jan 2026 18:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500043; cv=none; b=oXq/w9caDcXwuoP8GH07v7lpnNBT+nL7WM1DIFvu1be6UACVmeeNc3J3lWwYmlun6x96Dh3OWGIKuhC/rM7qsyKcK6h6JXne70A8PK2OMHa7Od0ZyIlMs/5eAix5znnh9GqIKvLOxU+a66lpoSgjsuhmmEoUCPuuZINJpIaXi5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500043; c=relaxed/simple;
	bh=Wnn5WGeoCv3eaOUU+DPPUPmKFdGBtcsZBtGEiNMM0xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vbt+sJcT0fz3nQhDPsOqmHEDV5wG1hE4C1wFejsC9wBREKVvZ089dNdM/nbpz6+tri0g+kyZGOSZUlpBGtKEQ9n8nx15vPxJkUyubjcbBa2ibTLzq1bL8o8Oc4wuL0MJ7DvEFZeWqhFL7FIwNzVNKTUGdBPJHSAWsn2hXWs05xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olEDS1ie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olEDS1ie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9417C116D0;
	Thu, 15 Jan 2026 18:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500043;
	bh=Wnn5WGeoCv3eaOUU+DPPUPmKFdGBtcsZBtGEiNMM0xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olEDS1ieGGJV6TMFMOPJi9Y3jx64a1w7KkUj3W2wDBHUySM0ceVAuSPjqPSAeyJmE
	 pzF1W9ekYacMKZPDPCMUXgaDnMJRWv8HhlS5ugM9Ap4Nm/2pPheI1E/OL6Kp7cYp7H
	 cuzb421f5JITFO2RgzUXf0+mBHAw7bZ1ClaOQtNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 438/451] net/mlx5e: Dont print error message due to invalid module
Date: Thu, 15 Jan 2026 17:50:39 +0100
Message-ID: <20260115164246.791465985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 144297e2a24e3e54aee1180ec21120ea38822b97 ]

Dumping module EEPROM on newer modules is supported through the netlink
interface only.

Querying with old userspace ethtool (or other tools, such as 'lshw')
which still uses the ioctl interface results in an error message that
could flood dmesg (in addition to the expected error return value).
The original message was added under the assumption that the driver
should be able to handle all module types, but now that such flows are
easily triggered from userspace, it doesn't serve its purpose.

Change the log level of the print in mlx5_query_module_eeprom() to
debug.

Fixes: bb64143eee8c ("net/mlx5e: Add ethtool support for dump module EEPROM")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20251225132717.358820-5-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 4bb219565c58e..b62c3514ddf14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -381,7 +381,8 @@ int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
 		mlx5_qsfp_eeprom_params_set(&i2c_addr, &page_num, &offset);
 		break;
 	default:
-		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
+		mlx5_core_dbg(dev, "Module ID not recognized: 0x%x\n",
+			      module_id);
 		return -EINVAL;
 	}
 
-- 
2.51.0



