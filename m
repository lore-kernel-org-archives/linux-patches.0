Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C6436D4E1;
	Wed, 30 Sep 2026 18:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791521; cv=none; b=Gr4gtQgzZIk4ITcpRHsno8T3tM5fVrsFFP8RNMljgCY5hBdW5HjbCMPKglNqWSQG7Gy6OiHm295+4frbt3jEuUiOP0Pm64knRbiS91VlwG01J1Wn+QMoCB3DitrVcec737G/j1zW6Dk8RY5luXdaVi8KLlmhUm49LyAHOe4+d2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791521; c=relaxed/simple;
	bh=vSpzkJjeHvtnB3HPmNHbs+3UJisJUaajUMmaPR3YLzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZifuHqn9vg1I6n+3C/83llHCV3uYZXLe0TMiGJczn37IySqjzv1JCkX5mIQrqZblMj78qr58geYGIV/Z9+Mo2YxTyJFvOAE/NK9co1fqemJvTqYRUaR41hmbJsMHOQEr8h1ECkydTb5DcF0o3BWkOaUEe/ClmIR/ckMCC0Wwb9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lvrrz5UM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lvrrz5UM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F671F000FF;
	Wed, 30 Sep 2026 18:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791519;
	bh=LciV1twpilZ/ZOjLrJj5bR890uwKFvcNjdqvor9TPmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lvrrz5UMVY0I4a3zwqlntsr7BY2G6RLtbZHmhJxQ6u6NdQ+gm+Sgxo6Qgarxtpmp5
	 NGEj+KbY7lqE373wX3n80fVeWIJGUPhPzI55Jk82x2+kYuNFcvPTPUoSPgzYWx688l
	 dPOq4ZEy/+SFaFWqdL+/6/ZNU9LJqwepxTdebjk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 332/752] vdpa_sim_blk: make vdpasim_blk_check_range usable by other requests
Date: Wed, 30 Sep 2026 17:23:22 +0200
Message-ID: <20260930152405.479650692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit ac926e1b468e03818e31568f6e520390b945b038 ]

Next patches will add handling of other requests, where will be
useful to reuse vdpasim_blk_check_range().
So let's make it more generic by adding the `max_sectors` parameter,
since different requests allow different numbers of maximum sectors.

Let's also print the messages directly in vdpasim_blk_check_range()
to avoid duplicate prints.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Message-Id: <20220811083632.77525-3-sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 0a8693f00c40 ("vdpa_sim_blk: reject out-of-range sector starts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 38 +++++++++++++++++-----------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index faaf9cac4aaac..1ee6e486f0bbe 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -38,18 +38,28 @@
 
 static char vdpasim_blk_id[VIRTIO_BLK_ID_BYTES] = "vdpa_blk_sim";
 
-static bool vdpasim_blk_check_range(u64 start_sector, size_t range_size)
+static bool vdpasim_blk_check_range(struct vdpasim *vdpasim, u64 start_sector,
+				    u64 num_sectors, u64 max_sectors)
 {
-	u64 range_sectors = range_size >> SECTOR_SHIFT;
-
-	if (range_size > VDPASIM_BLK_SIZE_MAX * VDPASIM_BLK_SEG_MAX)
-		return false;
+	if (start_sector > VDPASIM_BLK_CAPACITY) {
+		dev_dbg(&vdpasim->vdpa.dev,
+			"starting sector exceeds the capacity - start: 0x%llx capacity: 0x%x\n",
+			start_sector, VDPASIM_BLK_CAPACITY);
+	}
 
-	if (start_sector > VDPASIM_BLK_CAPACITY)
+	if (num_sectors > max_sectors) {
+		dev_dbg(&vdpasim->vdpa.dev,
+			"number of sectors exceeds the max allowed in a request - num: 0x%llx max: 0x%llx\n",
+			num_sectors, max_sectors);
 		return false;
+	}
 
-	if (range_sectors > VDPASIM_BLK_CAPACITY - start_sector)
+	if (num_sectors > VDPASIM_BLK_CAPACITY - start_sector) {
+		dev_dbg(&vdpasim->vdpa.dev,
+			"request exceeds the capacity - start: 0x%llx num: 0x%llx capacity: 0x%x\n",
+			start_sector, num_sectors, VDPASIM_BLK_CAPACITY);
 		return false;
+	}
 
 	return true;
 }
@@ -109,10 +119,9 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
 
 	switch (type) {
 	case VIRTIO_BLK_T_IN:
-		if (!vdpasim_blk_check_range(sector, to_push)) {
-			dev_dbg(&vdpasim->vdpa.dev,
-				"reading over the capacity - offset: 0x%llx len: 0x%zx\n",
-				offset, to_push);
+		if (!vdpasim_blk_check_range(vdpasim, sector,
+					     to_push >> SECTOR_SHIFT,
+					     VDPASIM_BLK_SIZE_MAX * VDPASIM_BLK_SEG_MAX)) {
 			status = VIRTIO_BLK_S_IOERR;
 			break;
 		}
@@ -132,10 +141,9 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
 		break;
 
 	case VIRTIO_BLK_T_OUT:
-		if (!vdpasim_blk_check_range(sector, to_pull)) {
-			dev_dbg(&vdpasim->vdpa.dev,
-				"writing over the capacity - offset: 0x%llx len: 0x%zx\n",
-				offset, to_pull);
+		if (!vdpasim_blk_check_range(vdpasim, sector,
+					     to_pull >> SECTOR_SHIFT,
+					     VDPASIM_BLK_SIZE_MAX * VDPASIM_BLK_SEG_MAX)) {
 			status = VIRTIO_BLK_S_IOERR;
 			break;
 		}
-- 
2.53.0



