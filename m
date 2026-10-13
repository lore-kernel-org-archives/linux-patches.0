Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FA44EBAD7;
	Tue, 13 Oct 2026 12:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895556; cv=none; b=E5CDJF2gRGIiw9hOIyVWoIct5dR3ws8R2gW8GCh6jFqOj7XpLrH1pHsBtyjx+X09sIJRnI8cVoy/Lb4cutqYuV8jFCRNUoFb1kxm97hRGUV80RWz5yE9xPIN0MT7S9wsHc57cG6UAAjixn6IaMbxQTVNVSX7mEZhsiRdGm07wQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895556; c=relaxed/simple;
	bh=4yaIqiEV4F3f80+kXhN35stdaeAo3sxL8M4bCA/PgtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ubqcs3n+xemw6GVpFSBor1D0B+F4p9VIzAvKfH+Fm/z7xQ99OtApQIOiFDi87wv1038+8ibMbpBxj74H9aabrOQweiLCoaBdFV9wZGNX6cZCGJpbUl25eSGGMzPYKCuuIl0b20qiIWFUFrdi0++deRgIqGm5wlbEpCU8aUHoNAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYxPsDPI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYxPsDPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA161F000FF;
	Tue, 13 Oct 2026 12:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895555;
	bh=ZahKHi1QgGjE8X4Z+b8jl74wbHD+7C9BhaefyVStDZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYxPsDPIc2L2lsSKqwp2r7yMdBBjRM+naXVxREy5BYA62AHexb+ZSxLXq8YXQrYUN
	 Wj+quFVVzO5fXh6KLgwvlxurNpYsXWKwW8cJlvbTB7weumV4wgTuHbnQPpl4UAcl2J
	 eC27OkmofyvPwQpCvsi0SamksWbJQd+QferxBw7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/497] nvme-multipath: set BLK_FEAT_ZONED only after the zone info is known
Date: Tue, 13 Oct 2026 13:37:59 +0200
Message-ID: <20261013112915.307901269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 4a5e49ba0abb8b4328d6318c9aef0c0121f95507 ]

The namespace head is marked zoned at allocation time based only on the
command set identifier.  If the zone info query reports a zero zone size,
the path namespace is registered without zoned limits while the head
still advertises the zoned capability with a zone size of zero, and
reporting zones or writing to the head then shifts by ilog2(0).

Drop the zoned feature from the head allocation and let the head limits
refresh stack it in from the path namespace instead.

Fixes: 28982ad73d6a ("nvme: set BLK_FEAT_ZONED for ZNS multipath disks")
Fixes: 3838e80fcfb3 ("nvme: skip the zoned limits update if the zone info query failed")
Cc: stable@vger.kernel.org
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ sashal: Made the existing `max_zone_append_sectors = 0` assignment unconditional to satisfy queue-limit validation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 43f6991f964df..d2ab2413dbdc7 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -647,10 +647,7 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 	blk_set_stacking_limits(&lim);
 	lim.dma_alignment = 3;
 	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT | BLK_FEAT_POLL;
-	if (head->ids.csi == NVME_CSI_ZNS)
-		lim.features |= BLK_FEAT_ZONED;
-	else
-		lim.max_zone_append_sectors = 0;
+	lim.max_zone_append_sectors = 0;
 
 	head->disk = blk_alloc_disk(&lim, ctrl->numa_node);
 	if (IS_ERR(head->disk))
-- 
2.53.0



