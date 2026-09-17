Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D536B584964;
	Thu, 17 Sep 2026 15:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659715; cv=none; b=uiHkj0C7zpaY0FEtv7P5jP9USZv35Jo3V50CWQIMlDBSwN9wpCGivm9o/sqMOdIbuttghjtYg8Efuh+eE8oTxjEM4YwjpovatiRHdEkh0ynAc3NbStzll+Nf8h4O/15QqZKxzPSxFN1w3iYQfozU3gu9UuB6jKrYV/MhFZTGsbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659715; c=relaxed/simple;
	bh=KHe4slQOuAOiob9Vkb7zpzt/3810qg1pmgfM8DFfEEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTWcgUxrDrw0qaN1B0dhJHomxWnLgccwkdPPGDv6v+A23q+OcenBaro/gn9c+rBPw7462jupC3VaahErcrKbOUIR/J5ymEWSl1WN3ACkGwk5k2ZYf9jjVoZroWqLteKvFg8DLc67wO4mXK+UdRQFNTB58+cMmMqlctMkzyvJcEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qpBrBvs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qpBrBvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CC71F000FF;
	Thu, 17 Sep 2026 15:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659708;
	bh=nwjhXMy3TBRdnndiA0MHm4xbVRIezsoVv+LDWZ2zotM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2qpBrBvsjFxJCzzfpO87SeYYxsQPKfOlu8dV0oUcJ9Q7F1nE6yAgeJ6c6rFHoH63y
	 X8CbucWIvq7RDUCOrxWB1JDWv1X72dh4IfQOGNfKGsGao+LyZ6tBEKK26IKyE842J1
	 5zpBeRVsLzi/PwZ2B5tNaqDzGg+bw8GriaLMs8hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 347/733] vdpa_sim_blk: reject out-of-range sector starts
Date: Thu, 17 Sep 2026 16:10:55 +0100
Message-ID: <20260917151400.212843011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f70f454dde8eb..76dd5b0828d7a 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -79,10 +79,11 @@ static void vdpasim_blk_buffer_unlock(struct vdpasim_blk *blk)
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



