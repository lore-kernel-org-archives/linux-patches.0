Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510671DEFD6;
	Wed, 19 Mar 2025 14:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394875; cv=none; b=erdchbT26RgVvEX2wKI3zcAEyhInZM9bpE0Mcdv6D5yzrXfqamEcDYjsOQambH/JaIIcCehvZ8icPV6fPzlU6/rDrH8/4Fn6wAJ6YgTA8geKfLeUV3Vnv6wrxaoyimfKH9Z8uuviYsJcUUeyC8G6/PHyN12ue6B7VRiZHcyBSKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394875; c=relaxed/simple;
	bh=1+dQhc/bWHcKfj1l2JbCuRr/y3sxVCeQ5FQSslXeJLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aw5axEenGlSJaT9MoQVs4YH0cnU+xlb4HH2urNV4qI0H4n/azZPAgm2Kohm3NvQrZL+tPAX96UAwa708qQ6XHhNW4s3AKMt5VCYTo3rhwZiRv0RykkJ6VeSSplrbvyHwKxVYPu86LKHj5Mu9koYtez3c7y3t6dBwvYwBIejyxNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKAbg56a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKAbg56a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0019C4CEE4;
	Wed, 19 Mar 2025 14:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394874;
	bh=1+dQhc/bWHcKfj1l2JbCuRr/y3sxVCeQ5FQSslXeJLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKAbg56aijG5EaTKHrrfWmbIQB771kOUqV4wCop8dB1ykzOFgHm9H5vWtjrBy/vhA
	 dcLbuqXNmgFDMeqSxms2A55cgYIz0kJbP1clKEmWNnjjI3EoPOrN+2oq3xfxwFEJD2
	 q+vv7Iq/IxHKWOUPG1GxSZ+EvsMlUj420u8GdF6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 021/241] net/mlx5: Fill out devlink dev info only for PFs
Date: Wed, 19 Mar 2025 07:28:11 -0700
Message-ID: <20250319143028.232075534@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit d749d901b2168389f060b654fdaa08acf6b367d2 ]

Firmware version query is supported on the PFs. Due to this
following kernel warning log is observed:

[  188.590344] mlx5_core 0000:08:00.2: mlx5_fw_version_query:816:(pid 1453): fw query isn't supported by the FW

Fix it by restricting the query and devlink info to the PF.

Fixes: 8338d9378895 ("net/mlx5: Added devlink info callback")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Link: https://patch.msgid.link/20250306212529.429329-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 98d4306929f3e..a2cf3e79693dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -46,6 +46,9 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	u32 running_fw, stored_fw;
 	int err;
 
+	if (!mlx5_core_is_pf(dev))
+		return 0;
+
 	err = devlink_info_version_fixed_put(req, "fw.psid", dev->board_id);
 	if (err)
 		return err;
-- 
2.39.5



