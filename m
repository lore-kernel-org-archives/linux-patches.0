Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4872E2F0D;
	Tue,  8 Jul 2025 16:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992671; cv=none; b=h2ervmDI7T36OrAUUxC6OLRkfyhzzp+CYdtY5shgvuMpdERYRHAcvMVzSS+RXRz3sgVrxoC/qgPayJLTslRq6HjITRlQz5XxNUTFgSplymQ3dXh+P1FciZ13w3j0pTPUITP+jdIDiDhxFFwKU5EPpWQI0K9dqxe1pfX1Iyl7Dh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992671; c=relaxed/simple;
	bh=Sr1/NNQD8LP+3RQomEyPMi8gNQmrA1b7HHxx6deuN98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8/qMqZL3WA6JBywvGfOgrMjNxrUdCdw0kys34eXlrcrsc/p+F3dWJcpnsQyB55n+aTGdMj1CHjIvCxEqbUJqw6EyUz0jPwT/rYSEiaLDS3gdM+k4X/ONDW1Ly4SDLJpbeo5zEH/20kJ6lKhG5iu/FpKPAGk2GB+v3zW6nq1svk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcPne4LD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcPne4LD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA6EC4CEED;
	Tue,  8 Jul 2025 16:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992670;
	bh=Sr1/NNQD8LP+3RQomEyPMi8gNQmrA1b7HHxx6deuN98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcPne4LDntCTSXVu+Ua5Q0WapPTO1j89ZyN2vCmKBvlrcqzF7AoAmBy3C+ilqeg8I
	 F1JA4qPN2+bqnBJ4IEF9LnekDwC2PKaG4Vq16lWxMooYEM8qNKPAEJdlEBmMQfNmwJ
	 zUIRJJKzLxqDWrzeol/thOJgM6KxCe7mFEhWNYJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/232] RDMA/mlx5: Fix HW counters query for non-representor devices
Date: Tue,  8 Jul 2025 18:20:37 +0200
Message-ID: <20250708162242.506200281@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 81cfa74147a18..fbabc5ac9ef27 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -391,7 +391,7 @@ static int do_get_hw_stats(struct ib_device *ibdev,
 		return ret;
 
 	/* We don't expose device counters over Vports */
-	if (is_mdev_switchdev_mode(dev->mdev) && port_num != 0)
+	if (is_mdev_switchdev_mode(dev->mdev) && dev->is_rep && port_num != 0)
 		goto done;
 
 	if (MLX5_CAP_PCAM_FEATURE(dev->mdev, rx_icrc_encapsulated_counter)) {
-- 
2.39.5



