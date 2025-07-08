Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F402045B5;
	Tue,  8 Jul 2025 16:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993381; cv=none; b=jCUco+0bDafne5p5OwFq31KOEpKv02SXFOzjJ9eJEgPtSCiP1AHsAX46EV16msc5CLQC8mKZhfyRepl0mplpiE2CjvR03cFhp9/rf9P32t62KmiSH4C9DSw0aoHbzp1Ew7lY9PSNpaZxIpQkxlT0KkUKakG/BIzXcUPou2J2TLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993381; c=relaxed/simple;
	bh=pyjkkLDF0va/s1vvaxkh0Tz0ElR/GiXeMu1ah+oThk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FytEUu3mwlXPl04FEOLjLh1n8lhpg0SlUx8aKcLrioOmEWWSQhK8Dhkb0ubEkN5ewUPj9pw7JyKMZkWDLKhLQPZ6h56MldGTtyQ2yz4eHaWxhaH7UWlA2G8/dKKedGogVmdekCJROPO677pWW+KhlTDQhwkNqT+V58voxcuY0WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnQB8Slc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnQB8Slc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3EFC4CEED;
	Tue,  8 Jul 2025 16:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993381;
	bh=pyjkkLDF0va/s1vvaxkh0Tz0ElR/GiXeMu1ah+oThk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnQB8SlcCor7MQBbfA81BXaZ4vs6WJkj/lVCj/vzrW5j4J7E70td1mEjWybYvUkCZ
	 tJBl/YcqzR7DRIH64vt7P+WtCnlGWJ7UsWOcF6APfKPKhKpXNcSWIMSeX5iNbypl7p
	 CUVKOtKPy4xzbzSu3i2D7LmfyG3oipm+SD5ELElg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 055/178] RDMA/mlx5: Fix HW counters query for non-representor devices
Date: Tue,  8 Jul 2025 18:21:32 +0200
Message-ID: <20250708162238.119222621@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 3cc1dbfddf88dc5ecce0a75185061403b1f7352d ]

To get the device HW counters, a non-representor switchdev device
should use the mlx5_ib_query_q_counters() function and query all of
the available counters. While a representor device in switchdev mode
should use the mlx5_ib_query_q_counters_vport() function and query only
the Q_Counters without the PPCNT counters and congestion control counters,
since they aren't relevant for a representor device.

Currently a non-representor switchdev device skips querying the PPCNT
counters and congestion control counters, leaving them unupdated.
Fix that by properly querying those counters for non-representor devices.

Fixes: d22467a71ebe ("RDMA/mlx5: Expand switchdev Q-counters to expose representor statistics")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Link: https://patch.msgid.link/56bf8af4ca8c58e3fb9f7e47b1dca2009eeeed81.1750064969.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index b847084dcd998..943e9eb2ad20d 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -398,7 +398,7 @@ static int do_get_hw_stats(struct ib_device *ibdev,
 		return ret;
 
 	/* We don't expose device counters over Vports */
-	if (is_mdev_switchdev_mode(dev->mdev) && port_num != 0)
+	if (is_mdev_switchdev_mode(dev->mdev) && dev->is_rep && port_num != 0)
 		goto done;
 
 	if (MLX5_CAP_PCAM_FEATURE(dev->mdev, rx_icrc_encapsulated_counter)) {
-- 
2.39.5



