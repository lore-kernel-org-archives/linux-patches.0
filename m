Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D4334DCF5;
	Tue, 26 Aug 2025 13:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216495; cv=none; b=YjK7npUO7LiJPQnUwjzHIglCrTcjDZsJQ7QVRsr0scfKB2q3Fphbp6DFuywWAVjhpGFnKYo5kqrr0l48A3/MIYaM92K4UdN8s+FIV/98BImcL0FvlPuV0v+lYCdRcCTzqF/QeUPqqoqQvL+HwoVmpzMDgu0Nf9crk04ME2j9ABE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216495; c=relaxed/simple;
	bh=p4ifRfDZX8HlTiIhQd136p4tAvo4lwKlquhFwv8+1+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s53tHYSaVuXckduhXnHHHdC0MBpTtPj3O2S4eKt6bCF1pmX/i87ABA4YBM/0TW2cCkFAMrEJjtOpJQEROu41iAQ4Yjku8KXLW6G25EhbW6DJuUT/QBdXw4X8j3Q1ejKwhaeYuzQeBiZWjgzje7MDUfaHkyBK2y5RtMGm7B7pD/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lsNZm4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lsNZm4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14294C4CEF1;
	Tue, 26 Aug 2025 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216494;
	bh=p4ifRfDZX8HlTiIhQd136p4tAvo4lwKlquhFwv8+1+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1lsNZm4ZhigNdLrzkOIXth6muUAjH4JfKH67YFsHNykMKdRNQF8/DilVwdQ4bXN+Y
	 sbRnJ1eDxL1lLcucsQQTHOy9OdpH8YHUcTS33U8e9rJEwPKnd5/PUGZCuxcX/jlbQB
	 np22BNYUZ4JeF3YOhfR8Qufaxa2mAvwju79Ls5d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 431/644] pNFS: Fix disk addr range check in block/scsi layout
Date: Tue, 26 Aug 2025 13:08:42 +0200
Message-ID: <20250826110957.141931221@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dc657b12822d..76423557f5b3 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -166,8 +166,8 @@ do_add_page_to_bio(struct bio *bio, int npg, int rw, sector_t isect,
 
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



