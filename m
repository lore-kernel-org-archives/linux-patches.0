Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105C39446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3EAC433C8;
	Sun, 13 Aug 2023 21:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962683;
	bh=WKYGZvP+RDpkQQNauPhCCbLd8rfqw1pF9hIFynEuYyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erOSa7/sU1A4V80T4EaduSglm2z9DlTX0mbjR1V07uUY3fi0qU1BhEn2zFs4CrbSS
	 KN5gOPMTvGw0zPG1baDOOvL/i8qwgDhF6gNnVCIC2+Uy52yiRhdUzdpDuBz5qmCKi2
	 6heem+f/ZLrLgcOkkbvDpxiUWUnvA0UxrpwZJbzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Aya Levin <ayal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Ganesh G R <ganeshgr@linux.ibm.com>
Subject: [PATCH 6.1 118/149] net/mlx5: Skip clock update work when device is in error state
Date: Sun, 13 Aug 2023 23:19:23 +0200
Message-ID: <20230813211722.272975414@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Moshe Shemesh <moshe@nvidia.com>

commit d006207625657322ba8251b6e7e829f9659755dc upstream.

When device is in error state, marked by the flag
MLX5_DEVICE_STATE_INTERNAL_ERROR, the HW and PCI may not be accessible
and so clock update work should be skipped. Furthermore, such access
through PCI in error state, after calling mlx5_pci_disable_device() can
result in failing to recover from pci errors.

Fixes: ef9814deafd0 ("net/mlx5e: Add HW timestamping (TS) support")
Reported-and-tested-by: Ganesh G R <ganeshgr@linux.ibm.com>
Closes: https://lore.kernel.org/netdev/9bdb9b9d-140a-7a28-f0de-2e64e873c068@nvidia.com
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -198,10 +198,15 @@ static void mlx5_timestamp_overflow(stru
 	clock = container_of(timer, struct mlx5_clock, timer);
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
 
+	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+		goto out;
+
 	write_seqlock_irqsave(&clock->lock, flags);
 	timecounter_read(&timer->tc);
 	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
+
+out:
 	schedule_delayed_work(&timer->overflow_work, timer->overflow_period);
 }
 


