Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD5A46D577;
	Wed, 30 Sep 2026 16:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785263; cv=none; b=jWdjZd1fFQF8+bjA1+laLWpkgMFTZMYYEQxIoiG1toaIjrNhgrm/rGk9VyNjnW5nRQNGAUJnA1/CeLXMQDI0jZGBP6NFnog/kBdqHqluPVTgotmyBxtjtl2pJMVFcGx2FOD2FHEzyQUvHUy5FqgrKX2nCTGjWqO+zuzB9lSG8HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785263; c=relaxed/simple;
	bh=h4ijwx041hOL3M7lbFWiDZOs5M7oAJz22FbumbctlHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXHUzKScwvJvHKHnEN92/8q5Po2+i/JW4pdkBSQAYhyM/uGcHaUMQIbj69XV5pZ3viHPM9AcNLSa+IQDKv7UIofsG5NWXWgdysdz7GRjTrlexlHyArxqhS7Ag5AffKUMrFLBBL4wQbhL63uiRPxJ/h1+Q3yHVn15jAMVePmSHtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18akoHvx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18akoHvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40CE1F00893;
	Wed, 30 Sep 2026 16:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785254;
	bh=9Jf5mZWwCud0qLSzqNZ8vAQFJOsin+WVJljOCxZh5gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18akoHvxM4rIYhwyKg8/pAJOd7mLHoXTQEHC5PDD37tETYWmH630/+/oaZRpU48P8
	 wRIJIY7JRBKmeNH+fpF63sqeqD49MhuzrtVxyCnAeXb8rJPAs4MJeUUxPHsq5vDBgV
	 NelAnZo782TwbJvlyHS7TtJ8MwnYNwQt9zu2e0Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 442/982] vdpa_sim_blk: reject out-of-range sector starts
Date: Wed, 30 Sep 2026 17:19:38 +0200
Message-ID: <20260930152426.287175379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit 0a8693f00c408d85f086ad85d29e7030bf1e2055 ]

vdpasim_blk_check_range() logs an invalid start sector but continues
validating the request.  The subsequent unsigned capacity subtraction can
underflow and let an out-of-range buffer offset reach the data path.

The invalid offset is used by three request paths.  VIRTIO_BLK_T_OUT
copies guest data to blk->buffer + offset through
vringh_iov_pull_iotlb(), causing an out-of-bounds write in
_copy_from_iter() or memcpy().  VIRTIO_BLK_T_IN copies from
blk->buffer + offset to the guest through vringh_iov_push_iotlb(),
causing an out-of-bounds read in _copy_to_iter().
VIRTIO_BLK_T_WRITE_ZEROES passes blk->buffer + offset to memset(),
causing an out-of-bounds write.

Reject starts at or beyond the capacity before the subtraction.  Treat the
capacity boundary as invalid because the IN and OUT paths round byte counts
down to sectors for validation but later copy the original byte counts.  A
sub-sector request at the capacity boundary would otherwise still access
past the end of the buffer.

I found this bug myself, though the patch was written with AI assistance.

Fixes: 7d189f617f83 ("vdpa_sim_blk: implement ramdisk behaviour")
Assisted-by: OpenAI-Codex:GPT-5
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260901094800.25475-1-linfeng.sun.dev@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index f745926237a88..8b5b04a0b85ce 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -49,10 +49,11 @@ static char vdpasim_blk_id[VIRTIO_BLK_ID_BYTES] = "vdpa_blk_sim";
 static bool vdpasim_blk_check_range(struct vdpasim *vdpasim, u64 start_sector,
 				    u64 num_sectors, u64 max_sectors)
 {
-	if (start_sector > VDPASIM_BLK_CAPACITY) {
+	if (start_sector >= VDPASIM_BLK_CAPACITY) {
 		dev_dbg(&vdpasim->vdpa.dev,
 			"starting sector exceeds the capacity - start: 0x%llx capacity: 0x%x\n",
 			start_sector, VDPASIM_BLK_CAPACITY);
+		return false;
 	}
 
 	if (num_sectors > max_sectors) {
-- 
2.53.0



