Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DFA50C28B;
	Wed, 30 Sep 2026 18:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791523; cv=none; b=M6gPNHjBF9iWECp7dyg9YVS6+8QgknvWrf72vF8iccNySo8ocHWouqIhJyCZZkfuziO/wLUEXO9XdzPEWccX85D+m+AIJx5wTY7dtF8/xaxlBKFcqYfF1qbtzH0XA7/75y4i3VjC2Zus/nl7pttsocZ7gQWexU7ihskd4FhXn9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791523; c=relaxed/simple;
	bh=0C1VkztOg8aHjZC1b/oWoOv6gVlBUPPzGRj5mpre/zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlCIMhpVcpQFGmneyGA/uBIvrMEEp/nluKodOeS9oE7aC+6yrizE66jQsRpKQef1VyBztANejzXXEMQ4rKMGk9taCJ2lmoPUnm06AbsNwA9OT/dsxfuggbWj04vm0FT3TY0Rxu7f3LaE9HZd1fl6EX0s+m9goBTIWptc33WznW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nt8pQZwf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nt8pQZwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7F71F000FF;
	Wed, 30 Sep 2026 18:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791522;
	bh=VuwgqJqJoQDJZqMAIVDDNeL/mxrIMcxGaQyMsDR9VSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nt8pQZwfyRsYEdtsvjrwnjJZ3M6MfS+nm4YVWwNsZqZxfkQb+SaLSQY93iEqkLwhV
	 wd4TgAbql35BvMpjcFQace7NjiN0UgfvWOLcYy7f5VlnaTlcaMFQV3bQJXgsHMYhf+
	 qSrNpaaI9x+Fo8plMbexlRQhcCOY+L36RfvPYzCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 333/752] vdpa_sim_blk: reject out-of-range sector starts
Date: Wed, 30 Sep 2026 17:23:23 +0200
Message-ID: <20260930152405.500621370@linuxfoundation.org>
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
index 1ee6e486f0bbe..3585017338230 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -41,10 +41,11 @@ static char vdpasim_blk_id[VIRTIO_BLK_ID_BYTES] = "vdpa_blk_sim";
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



