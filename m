Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B423597C;
	Tue, 26 Aug 2025 13:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213259; cv=none; b=dVkDlJ807tSCyt73MTyv13CoR4HQ9ofkQWXq9LCL65egXLpMv3KC5WE9qSmFWucmXOhYy08MKq3b0Owbigh2Rn8szCJatMljX5K+omqSwmrZv8LF8IZm2yQeSzPITMqtCedgOe7bG7WLDJLxG52ipff5Xr/hTvqAWzyWkHMh9rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213259; c=relaxed/simple;
	bh=y0FtBEhQ/meJaHU2mjDHPDDuwPYwBCJT0zx5P9LOofU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Io8KRdJtd5WzDt1BzOAhtVzXw2Vooy4qOi9Wv5bLz78CJI0P6Wv6iL8xZ/3bUtWol2qZGjdsJl2MESs4zAk/lu9A33BEgRQt/dToJO1TQc5jsc4YfftEBnnGp43MIodVAtTIUKctYNfw1WebJrNhzkWhhXOVvW2ZKsO1kUyyOUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wt11Zchv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wt11Zchv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E6EC4CEF1;
	Tue, 26 Aug 2025 13:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213259;
	bh=y0FtBEhQ/meJaHU2mjDHPDDuwPYwBCJT0zx5P9LOofU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wt11Zchv2SZCnx7x2UJ0QWtIOj/GVumCF4bNx/thxiLJc3RzT2Yv0YPaD7TAjP5nA
	 UtC/Qc4E0Z96Kdhnim4v6Udb/j9ufNGNyh04yUKNVGBnmFusyjamf7N4SiV1n/xVNk
	 OuR0EKBPI86n+HNXvAHFoAKgl75PPbbLhbIZ8beY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Artem Sadovnikov <a.sadovnikov@ispras.ru>,
	Yishai Hadas <yishaih@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 280/587] vfio/mlx5: fix possible overflow in tracking max message size
Date: Tue, 26 Aug 2025 13:07:09 +0200
Message-ID: <20250826111000.056226348@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Sadovnikov <a.sadovnikov@ispras.ru>

[ Upstream commit b3060198483bac43ec113c62ae3837076f61f5de ]

MLX cap pg_track_log_max_msg_size consists of 5 bits, value of which is
used as power of 2 for max_msg_size. This can lead to multiplication
overflow between max_msg_size (u32) and integer constant, and afterwards
incorrect value is being written to rq_size.

Fix this issue by extending integer constant to u64 type.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Artem Sadovnikov <a.sadovnikov@ispras.ru>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://lore.kernel.org/r/20250701144017.2410-2-a.sadovnikov@ispras.ru
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/mlx5/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 2d996c913ecd..82558fa7712e 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1389,8 +1389,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_msg_size);
 	max_msg_size = (1ULL << log_max_msg_size);
 	/* The RQ must hold at least 4 WQEs/messages for successful QP creation */
-	if (rq_size < 4 * max_msg_size)
-		rq_size = 4 * max_msg_size;
+	if (rq_size < 4ULL * max_msg_size)
+		rq_size = 4ULL * max_msg_size;
 
 	memset(tracker, 0, sizeof(*tracker));
 	tracker->uar = mlx5_get_uars_page(mdev);
-- 
2.39.5



