Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A0D2253F3;
	Tue, 26 Aug 2025 13:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213420; cv=none; b=CxZIUdZqo4+hH1CfYpZ/aFiKGPxAJluWFh4Hwr7/pd8O35OrVFJVfXnoiVigEflibJ0jO7L1a93xwnQxhWjI+aSqUrp8ZNiToVjb1sY87moq+Itx1RGE6w8eVOGPyCfE3Py82+fRFcrsqvoCkCwrajoAf6NfU6XGnCzVtXM/Xxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213420; c=relaxed/simple;
	bh=IecXPk6HNNS9LqQbaVyye8jyznXEJtrBFlagQsCA9d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkN1J5O5fXgqDrAojQlTBVwMKVJQjDgkaTz1kK/2ihqyLQv2D2rTOgW5hoRgGc7kuZvzDwUpfAP2nZCh8iL5yoGQ8bHwgBaCy55y0NuUuAxKNAxEuwMorGgtgmG4wsUsTUvrBJy55znJ5Si0n0G9HksK6wAcpN/8itgth8fREdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uC8xIImc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uC8xIImc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FF4C4CEF1;
	Tue, 26 Aug 2025 13:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213419;
	bh=IecXPk6HNNS9LqQbaVyye8jyznXEJtrBFlagQsCA9d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uC8xIImc6rspXTIJNUT82RtpIJS8CvMIJ+uvESR4cftGm6CI2f7QxTea2Zmkbb309
	 n/6J6Bxq+XttLuME3D2bearOqEEyKxSut3PnkvAJUAk1dveQA51T9XWcCHq3gq0/wy
	 r+GP4q0k982YZnLRNyxR3cyzZqeitkD5OBtWCUe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 290/587] pNFS: Fix disk addr range check in block/scsi layout
Date: Tue, 26 Aug 2025 13:07:19 +0200
Message-ID: <20250826111000.305517953@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit 7db6e66663681abda54f81d5916db3a3b8b1a13d ]

At the end of the isect translation, disc_addr represents the physical
disk offset. Thus, end calculated from disk_addr is also a physical disk
offset. Therefore, range checking should be done using map->disk_offset,
not map->start.

Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250702133226.212537-1-sergeybashirov@gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/blocklayout/blocklayout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 6be13e0ec170..e498aade8c47 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -149,8 +149,8 @@ do_add_page_to_bio(struct bio *bio, int npg, enum req_op op, sector_t isect,
 
 	/* limit length to what the device mapping allows */
 	end = disk_addr + *len;
-	if (end >= map->start + map->len)
-		*len = map->start + map->len - disk_addr;
+	if (end >= map->disk_offset + map->len)
+		*len = map->disk_offset + map->len - disk_addr;
 
 retry:
 	if (!bio) {
-- 
2.39.5



