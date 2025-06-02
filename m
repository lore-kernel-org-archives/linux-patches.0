Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605D221B9C8;
	Mon,  2 Jun 2025 14:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873586; cv=none; b=ZJzroqAH00NpgQe10HozT81FX1vbYWeR2b0gGU32sFO/mzVhDcfrhMydvdGBuI9xlQK2hPZdIvF3L3bE1WK9HzgReBj+qQp/Fku6FI+Ev3ZvWWaYvxHrfbskPE1zCp8YzZRkHIyItK7Xen6z/+RzWrB0vVXP78BJXn2UT//fJEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873586; c=relaxed/simple;
	bh=9MJriZWZXcWbmSt8FZ179gbt+1wr/YGO0AktVFFwZFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mppQEBpatHkyu37pIUmopy/w/FezetM1LAxqWY6DFjkROabPRhMszj1oYlfVsARCedPn6Gbu3+QRYd4mA/1QxbkKtyyN9r4ldgGpvdcKxpm/62XxnF5RFMoH3aJXSzfrYJqr2XO/jfwiZt/V3ny/t71Iiz/tYtKvwescAsrSyig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lL2yjkeX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lL2yjkeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73544C4CEEB;
	Mon,  2 Jun 2025 14:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873584;
	bh=9MJriZWZXcWbmSt8FZ179gbt+1wr/YGO0AktVFFwZFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lL2yjkeX8Z/zo+ousSjmWjm6BWWkF7+xJHP8Cce9V4240U9Z7BIJqBLQEoVY01p+A
	 46QbGYx+YGI6y8ji+BEMzVxrO0P2JqP3avCf+P8LiS8EOMmLgl59hJ3lq5Pu0UZv0G
	 E96iOq5ePgEbD5W54ASHpJhEaGnc7tTi/9qCvh+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Shkolnyy <kshk@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/444] vdpa/mlx5: Fix mlx5_vdpa_get_config() endianness on big-endian machines
Date: Mon,  2 Jun 2025 15:44:12 +0200
Message-ID: <20250602134348.534672249@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Shkolnyy <kshk@linux.ibm.com>

[ Upstream commit 439252e167ac45a5d46f573aac1da7d8f3e051ad ]

mlx5_vdpa_dev_add() doesn’t initialize mvdev->actual_features. It’s
initialized later by mlx5_vdpa_set_driver_features(). However,
mlx5_vdpa_get_config() depends on the VIRTIO_F_VERSION_1 flag in
actual_features, to return data with correct endianness. When it’s called
before mlx5_vdpa_set_driver_features(), the data are incorrectly returned
as big-endian on big-endian machines, while QEMU then interprets them as
little-endian.

The fix is to initialize this VIRTIO_F_VERSION_1 as early as possible,
especially considering that mlx5_vdpa_dev_add() insists on this flag to
always be set anyway.

Signed-off-by: Konstantin Shkolnyy <kshk@linux.ibm.com>
Message-Id: <20250204173127.166673-1-kshk@linux.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index b56aae3f7be37..9b8b70ffde5a0 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3420,6 +3420,9 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	ndev->mvdev.max_vqs = max_vqs;
 	mvdev = &ndev->mvdev;
 	mvdev->mdev = mdev;
+	/* cpu_to_mlx5vdpa16() below depends on this flag */
+	mvdev->actual_features =
+			(device_features & BIT_ULL(VIRTIO_F_VERSION_1));
 
 	ndev->vqs = kcalloc(max_vqs, sizeof(*ndev->vqs), GFP_KERNEL);
 	ndev->event_cbs = kcalloc(max_vqs + 1, sizeof(*ndev->event_cbs), GFP_KERNEL);
-- 
2.39.5



