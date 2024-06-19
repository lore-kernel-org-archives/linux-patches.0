Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8291459F2;
	Wed, 19 Jun 2024 13:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803551; cv=none; b=I7vD+9JliEOU+mdXoGEM+6/j9nJHOgGtMrUAXksfI4145e1q6fAWf224Z8D/LkXvaYVRKtbNtG7fvkAm22Imk8VcmyRgD45nuzfuqxagv8PuhsBWSQco4JUZCcm34WkzjWENEo7cAvCOOSWQFWiTSi0jJCkwUA8eHVxF3MtemIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803551; c=relaxed/simple;
	bh=Cl85Pvd7TzNn/L5+co9eAJ6TDtnNiVozvL4yAtG4kPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWx5Ltdb9Jx70lwkxU0CqOU/T05buqfXb1LJaMT3hrEKDf635Zcm2RPcVh45qpMdkdoJIPh2OTQ8qAzqhVgwopb6FVLgMDO0ZrQNTQZJljNRcxbEcOkBHhcxSoRmRtR4q+HpIof0PeXbExnDZu6X/d6hWNXkgUO0QDsjS9Uhftc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xseuCOq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xseuCOq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA23C4AF1A;
	Wed, 19 Jun 2024 13:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803551;
	bh=Cl85Pvd7TzNn/L5+co9eAJ6TDtnNiVozvL4yAtG4kPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xseuCOq0pV3AwWLLJz85TKi2ekH7qQ9Uw/ZAyh5WeLWqr/zPvVWqxjBkbuCYOwPFT
	 E4G0zCSR8Yt2ueaFMfc1tPC3nyuZ9txLVIyZ0M6Z8U+hKBYMZ4oZrun+ZIADd40D6H
	 BlvLGpYK9DwLeYyGabYCEn64Pw6lsDWy6O8yRR7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@mellanox.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/217] net/mlx5: Stop waiting for PCI up if teardown was triggered
Date: Wed, 19 Jun 2024 14:54:26 +0200
Message-ID: <20240619125557.542685731@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit 8ff38e730c3f5ee717f25365ef8aa4739562d567 ]

If driver teardown is called while PCI is turned off, there is a race
between health recovery and teardown. If health recovery already started
it will wait 60 sec trying to see if PCI gets back and it can recover,
but actually there is no need to wait anymore once teardown was called.

Use the MLX5_BREAK_FW_WAIT flag which is set on driver teardown to break
waiting for PCI up.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20230314054234.267365-3-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 33afbfcc105a ("net/mlx5: Stop waiting for PCI if pci channel is offline")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index e42e4ac231c64..e9462de771fd3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -325,6 +325,10 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
 	while (sensor_pci_not_working(dev)) {
 		if (time_after(jiffies, end))
 			return -ETIMEDOUT;
+		if (test_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state)) {
+			mlx5_core_warn(dev, "device is being removed, stop waiting for PCI\n");
+			return -ENODEV;
+		}
 		msleep(100);
 	}
 	return 0;
-- 
2.43.0



