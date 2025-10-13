Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8B0279DCE;
	Mon, 13 Oct 2025 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367793; cv=none; b=NEWKJY2g3taBPiA+MKAY0mnz29/aXU10VlU/SngHvwoLpVOPn1zJvo5RUvrYkZwBJoo3ZEx9oeC2Zwi+MSuLU+jqolM/AWysJo9ZmLrecq8yu9gVNyMxYrEn2T3bp+CvyE/DxGDQBNNIguiRmu2JjBLl/YBenNq3nFLlUQuhHGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367793; c=relaxed/simple;
	bh=UhaXPcoo8x+unNZ9BaoQhwuKTbL1brSRATr9HOROGkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2O3DbAhqBy9V1e80I80YcG7XEqfxV5Ex2ulfNPF5+NBSMG0Eq8arJk7DDZStyBbb1J6/kQc0vhe9Ov3BzTB932a7KrVotlCDvg5y47Bdb+qzSDqwPEl4+VeAyP73zTgoL+hEVHjKPy7gwHTYYoVPgZIw25wH8I4HmVRkS75wwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgqt2QrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgqt2QrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEF1C4CEE7;
	Mon, 13 Oct 2025 15:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367792;
	bh=UhaXPcoo8x+unNZ9BaoQhwuKTbL1brSRATr9HOROGkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgqt2QrL/Yj4aps3ib1fNddtLmWHaUR0ol5tqfKgn6vIDOT7ZfwRUNRJ4UNadfc3z
	 S7J0k7zIaOZShL01tuR9zNsojSPZqMGJ7A6FcfjK1PstEs1KqASFntY6DtMDeKcARA
	 QWxNm2DM+d55OcawKrdwLL6NEprq6x3bI6rsbZrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Brett Creeley <brett.creeley@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/196] vfio/pds: replace bitmap_free with vfree
Date: Mon, 13 Oct 2025 16:45:25 +0200
Message-ID: <20251013144320.163166897@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit acb59a4bb8ed34e738a4c3463127bf3f6b5e11a9 ]

host_seq_bmp is allocated with vzalloc but is currently freed with
bitmap_free, which uses kfree internally. This mismach prevents the
resource from being released properly and may result in memory leaks
or other issues.

Fix this by freeing host_seq_bmp with vfree to match the vzalloc
allocation.

Fixes: f232836a9152 ("vfio/pds: Add support for dirty page tracking")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Link: https://lore.kernel.org/r/20250913153154.1028835-1-zilin@seu.edu.cn
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/pds/dirty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index 27607d7b9030a..6adc5f1ae2eb9 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -81,7 +81,7 @@ static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_dirty *dirty,
 
 	host_ack_bmp = vzalloc(bytes);
 	if (!host_ack_bmp) {
-		bitmap_free(host_seq_bmp);
+		vfree(host_seq_bmp);
 		return -ENOMEM;
 	}
 
-- 
2.51.0



