Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88903A1E92;
	Sat, 17 Oct 2026 17:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258722; cv=none; b=JmS+5KarlkP7PFIMKYLHXUYd3rO0jp1APQ0UribfymrFF+cUPUuNhCIaIS2oE5VDXp+oQZqQC1PeCxq7vaKytZkAcdnXD3YRKxWPppMfPeXQVpsUYM9IQPfFlGkjjf2ygfHqst1boRV0PjVfsL7Ns7gQ5mKPN/YTf9mXjqx8wMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258722; c=relaxed/simple;
	bh=Qw1AaeFfWe2DxzY89QRkFzBKSGM/yOEp5m/fOexMF08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=afWbhUPtS0g08EjYjy93pgw245tSNMieT619o32FyXPNHATekZZWKPHunC8wzWJKxJjWJLRTUD/wKnqCOMywaHD17jTj8gc6YtpjnQVzBMvfkoQMsjbVHiZTc0fIMXHmJUmTZIQOUdt0FAgAuojm3aBKtL/FKoAvlgChpJ7uNsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xosf7+C7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xosf7+C7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6CA1F000C4;
	Sat, 17 Oct 2026 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258721;
	bh=HcpiUAZhBXhF6GixgT63q1DLN6V4shI15yuV4/6USVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xosf7+C7ac/oB1As84KDIzQgJobhbK+7/eNDObhR+FHCsCqnd66FTN+MDO+86ZNFg
	 BQwaM+cJfTPgdr1sYl3SRQ7FawViHaPKHVlqZmtuDul8lK+UwHDH0pJKAlVd12Hm5b
	 b0grKHKMaeUfLgi6LFpNR6aPatu7qYZPwrlsWpq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0927/1674] vhost: move vdpa group bound check to vhost_vdpa
Date: Sat, 17 Oct 2026 17:53:19 +0200
Message-ID: <20261017160454.928051188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Eugenio Pérez <eperezma@redhat.com>

[ Upstream commit cd025c1e876b4e262e71398236a1550486a73ede ]

Remove duplication by consolidating these here.  This reduces the
posibility of a parent driver missing them.

While we're at it, fix a bug in vdpa_sim where a valid ASID can be
assigned to a group equal to ngroups, causing an out of bound write.

Cc: stable@vger.kernel.org
Fixes: bda324fd037a ("vdpasim: control virtqueue support")
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20260119143306.1818855-2-eperezma@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 ---
 drivers/vdpa/vdpa_sim/vdpa_sim.c  | 6 ------
 drivers/vhost/vdpa.c              | 2 +-
 3 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index d3f4c87cf5b63..822c23e73053b 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3178,9 +3178,6 @@ static int mlx5_set_group_asid(struct vdpa_device *vdev, u32 group,
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 
-	if (group >= MLX5_VDPA_NUMVQ_GROUPS)
-		return -EINVAL;
-
 	mvdev->group2asid[group] = asid;
 	return 0;
 }
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 58cb711e981d3..d6aeaeb6c17b5 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -587,12 +587,6 @@ static int vdpasim_set_group_asid(struct vdpa_device *vdpa, unsigned int group,
 	struct vhost_iotlb *iommu;
 	int i;
 
-	if (group > vdpasim->dev_attr.ngroups)
-		return -EINVAL;
-
-	if (asid >= vdpasim->dev_attr.nas)
-		return -EINVAL;
-
 	iommu = &vdpasim->iommu[asid];
 
 	mutex_lock(&vdpasim->mutex);
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index d2442063423c7..846c70b6942d4 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -663,7 +663,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 	case VHOST_VDPA_SET_GROUP_ASID:
 		if (copy_from_user(&s, argp, sizeof(s)))
 			return -EFAULT;
-		if (s.num >= vdpa->nas)
+		if (idx >= vdpa->ngroups || s.num >= vdpa->nas)
 			return -EINVAL;
 		if (!ops->set_group_asid)
 			return -EOPNOTSUPP;
-- 
2.53.0



