Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059CD3F9D2;
	Tue, 12 Aug 2025 18:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022696; cv=none; b=OdYQW1JnSdrA7IwPbM8qNPm+DKEazHSJmKiPz2fbFQmxMz9aZ69k0jsk4/rq2nELNMehpXlTi69udJwRmc18yqsqfkEYZkkaV+WuaD9572N9h83/ygNu9ThCSYsT0i5jZ2DraL7YxiretmJAYV+oK7r7cAta9/KBNGHRx9BaOsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022696; c=relaxed/simple;
	bh=2YUwfGu5XSX6DgVEg9zIIHf3sYdYN1J1qnF0k4MEb+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bk3q2OUGcy/MLKnLZIZr2n7XwmicTJTP0drW5a/Hapqka5G77uKkPwo+bXnywNkTFJvBHGmiWRT+zSB2424imeLDJjDYzoj2eOeQ+Udk7yNsI5A0TgBEMpfUJhE24tYCAGvO/eT85ewNEExPbfE/Pb7GwyaZEYZqjT+6Kvga3so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkmPq68Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkmPq68Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15018C4CEF0;
	Tue, 12 Aug 2025 18:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022695;
	bh=2YUwfGu5XSX6DgVEg9zIIHf3sYdYN1J1qnF0k4MEb+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkmPq68Z6UZJlpR0iw2FydF900W4JGjT9RaKVElxptPj4/L+YoehxqcekICUc+B8F
	 PuRwTcKjYFpIXPSknV9vgzTNW8/SFjictDpZAphQBVIRJEcdTIOtWT8fcgNLpzCjnz
	 3VMVdRuPm6whJegnc5tx1/aXbCvdsS67saO6LkEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 231/369] vdpa/mlx5: Fix needs_teardown flag calculation
Date: Tue, 12 Aug 2025 19:28:48 +0200
Message-ID: <20250812173023.463775173@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 6f0f3d7fc4e05797b801ded4910a64d16db230e9 ]

needs_teardown is a device flag that indicates when virtual queues need
to be recreated. This happens for certain configuration changes: queue
size and some specific features.

Currently, the needs_teardown state can be incorrectly reset by
subsequent .set_vq_num() calls. For example, for 1 rx VQ with size 512
and 1 tx VQ with size 256:

.set_vq_num(0, 512) -> sets needs_teardown to true (rx queue has a
                       non-default size)
.set_vq_num(1, 256) -> sets needs_teardown to false (tx queue has a
                       default size)

This change takes into account the previous value of the needs_teardown
flag when re-calculating it during VQ size configuration.

Fixes: 0fe963d6fc16 ("vdpa/mlx5: Re-create HW VQs under certain conditions")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Tested-by: Si-Wei Liu<si-wei.liu@oracle.com>
Message-Id: <20250604184802.2625300-1-dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 76aedac37a78..0e7b5147ffba 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2491,7 +2491,7 @@ static void mlx5_vdpa_set_vq_num(struct vdpa_device *vdev, u16 idx, u32 num)
         }
 
 	mvq = &ndev->vqs[idx];
-	ndev->needs_teardown = num != mvq->num_ent;
+	ndev->needs_teardown |= num != mvq->num_ent;
 	mvq->num_ent = num;
 }
 
-- 
2.39.5



