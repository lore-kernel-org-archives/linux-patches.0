Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E2E1D8E01;
	Mon, 18 Aug 2025 13:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522706; cv=none; b=Si/7LF6+NRUgAMxmZXi37wIFifhZnEfV5XlrhxSHv7IS9WY5/m9ilqSQNsPdxMSKX5Eih+MrZC4rvnPP+TpdjtRT/X+LVlMO3/bxC5b2nP/s6Z44L5A2YUBUnabIhgpotpRWRBc24wszN8C9HPZqxTEIpLGY977HD7TcQqrOvCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522706; c=relaxed/simple;
	bh=Xk4eI0eYAaABZflnE/NAmbjFbxnBkLG+A4ZhoQ/Cufs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SeLkqDzNZnkRrQ3gvYUkz5fuXJFY7BxCiaBzaQcoGPKb9/YCgvMJ7F0BjIaMiVQO1CVL5lPYOEH6CiMwHBzLTO5nYbYl9GIhR0ShNy+qlciB4+QTtDFykk++QVkbLEN4d0JyoDalVbcr10EkygMD7D9o8OwW/UFSmcqYhHC2x3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUtT7tRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUtT7tRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF749C4CEEB;
	Mon, 18 Aug 2025 13:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522706;
	bh=Xk4eI0eYAaABZflnE/NAmbjFbxnBkLG+A4ZhoQ/Cufs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUtT7tRSMo41dHWpYBFh3uJKfF/5JIdHaJLYsWPo9jDaHauvF793oGXRF31A+J26G
	 KxeqH2Z5FKkVIodVDJ5jVS3IXuSTj5nnj41UIEoWVeQ7Wbv5l+2PPvUuPPlUP0l1P6
	 KIGI2fcNXQIjlEHtEnpQplDwZeUcTpF3VlKMUwTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 364/444] pNFS: Fix disk addr range check in block/scsi layout
Date: Mon, 18 Aug 2025 14:46:30 +0200
Message-ID: <20250818124502.553479335@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 47189476b553..5d6edafbed20 100644
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



