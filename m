Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3893D994;
	Tue, 12 Aug 2025 19:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026398; cv=none; b=RbeD7HlfF7CQpW/rVEEjxj0aRanNZvroYq2gagvcYr9uRovG0ED9Qfz8sb1ChFd115tKA6/AzpsS5ldQyzEbd7cRMz0mADbkNOxiomGChj9ikrVNFSjghuYEgya75Z5+DSYmC2ZKXSyK6IsV9jcp43qiqh3Eo9g4SHqS+TqnGvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026398; c=relaxed/simple;
	bh=ynRRDTty2VZ84+v1LgUOM4bG8ce+RNEc8Fs/VC6Q16M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6zDtKVgknLAAhlZ2N20gXmsuy/fP42Wi5TgJzgMDmqJfY9y1xn0mwhBUucflx2XYCrEcyQq/TXorygjk2wJQp3Do83IOyJD+oEaZTDX1fiFv28FHje8ZeFeKu5GTxlYoDmSVTsyt8jySo4pN9FJY1q/NURTLMixyV+tupNZ8GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5PMj9hf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5PMj9hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0076C4CEF0;
	Tue, 12 Aug 2025 19:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026398;
	bh=ynRRDTty2VZ84+v1LgUOM4bG8ce+RNEc8Fs/VC6Q16M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5PMj9hftvX1QjR2H0thLjLWnS56+DZta6LOtHCno4miXGm4J8GYXuyR1/M502p6o
	 dT1AVSgbRbTMM70knn1YBEWsWK9rSBAapKhOWxc6chv3qSuFdaIgbyklZFwp79Qxjm
	 aj0AKhYrwB/biLS/NgbrROM6S9750HfA54K5DUFI=
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
Subject: [PATCH 6.15 324/480] vdpa/mlx5: Fix needs_teardown flag calculation
Date: Tue, 12 Aug 2025 19:48:52 +0200
Message-ID: <20250812174410.806214456@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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
index cccc49a08a1a..efb5fa694f1e 100644
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



