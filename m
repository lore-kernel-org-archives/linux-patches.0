Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CD536D9FB;
	Sat, 28 Feb 2026 17:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301449; cv=none; b=iw224psIuOMM3NQVtly0KY9BcXMwgJnWtcuXVcITt5somDCP4oEg7X+7TiKL37HrYtL7itRqLX+GTXWgHjD+nPAZ5PR4pZHBJGBVQNEShk54YHWeqyrauaXvn63EVijShrFNZ7WRQM25JKrErhRipp69PwPIyt1X9yTBaSIVtRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301449; c=relaxed/simple;
	bh=tMR0jwUSTCfCgTboqHcqsTP5vZR4Ew9O/wiWKDWqn88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aty+od0nri7tuzTRSikizJZ/IWeni9OlJNAV7TZoKxFWCs1j3v0HG1SkVl5K9GnxbFw60e+lBNAL0nThNm+M+G72bkCWiwEzfTaGXik9t5CY/Cmme0G8AxK8gH7US+pzK5FAaoa3TGSofXHHuC0aW0BGNUJ7rEavrnAvWYl2Ak0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IcXKsaxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IcXKsaxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678DEC19425;
	Sat, 28 Feb 2026 17:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301449;
	bh=tMR0jwUSTCfCgTboqHcqsTP5vZR4Ew9O/wiWKDWqn88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcXKsaxPgH3RNh1ddTE0HMMgGCbtCo51+teN+M4U0Jbfj11taslUWsAnkrQ7Slp8Q
	 1y5BrcY/oOH3SWn77iu2Qa0e3SVib5qaOn6OE4Q7PoaTuiN+SQDg1vmJito+8eRZ5q
	 /mUMyg4qYPMzp4VlMyJ2qKdQwRamE8eTVc+LPPVj8AZBvWhsFEqlZIY19sxd7WWj5a
	 J1DpucbZ9lt6OrKa+RaQK6Q+UO8KfYjzXOuTIs/w0H2tx1zHFAHZUu2Rxq0G8gwt3v
	 gylfWSSfiDsTeRqqI27q9o42Q6hTxQf5uU8DhivZpHQ1l9KNZ0Zz6Qj9QFTQgbEHoC
	 PMEM87QFG08kQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	stable@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 635/752] vhost: move vdpa group bound check to vhost_vdpa
Date: Sat, 28 Feb 2026 12:45:46 -0500
Message-ID: <20260228174750.1542406-635-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index ddaa1366704bb..44062e9d68f00 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3640,9 +3640,6 @@ static int mlx5_set_group_asid(struct vdpa_device *vdev, u32 group,
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 	int err = 0;
 
-	if (group >= MLX5_VDPA_NUMVQ_GROUPS)
-		return -EINVAL;
-
 	mvdev->mres.group2asid[group] = asid;
 
 	mutex_lock(&mvdev->mres.lock);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index c1c6431950e1b..df9c7ddc5d782 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -606,12 +606,6 @@ static int vdpasim_set_group_asid(struct vdpa_device *vdpa, unsigned int group,
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
index b0179e8567aba..7e51eec842b8c 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -680,7 +680,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 	case VHOST_VDPA_SET_GROUP_ASID:
 		if (copy_from_user(&s, argp, sizeof(s)))
 			return -EFAULT;
-		if (s.num >= vdpa->nas)
+		if (idx >= vdpa->ngroups || s.num >= vdpa->nas)
 			return -EINVAL;
 		if (!ops->set_group_asid)
 			return -EOPNOTSUPP;
-- 
2.51.0

