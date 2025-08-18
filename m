Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D112327A3;
	Mon, 18 Aug 2025 14:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526125; cv=none; b=glCIGxtQZHhmZk1hPgFO191S1BBj3/eIeoQX8TS91jo2mO3LbXG5KACKzNadShLo1rR6nuyIsmNKAqcnieCeO5+Heb7SeSPQFSVC4v8JIak3NuS1cBDh+9jKaoVXp2jJdVaTTVRzxAQ8rXtu2XF+tFk1aBKnzUYpbbmSo6TrPuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526125; c=relaxed/simple;
	bh=S1mL5ufWMPXrGfq5tLNZHdrncDCEakHY3+mmyXd7JEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWPhIodxBUO1eUj3IDaVN9nDN4OVfKmiW37HyDfSBc2hbO2119wyRw+6cnNZ+0yu4pfo4f9MB/Z4Am/KJR33/Z6mmXon3CYV1r2ImA6GqLRdm3OmlbhxXn0CAviOQocR+NFtXfAVyZ/TAhVa6js9B/bktmxfNJ+L9ffjMRW3QSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6ywNX0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6ywNX0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C62AC4CEEB;
	Mon, 18 Aug 2025 14:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526125;
	bh=S1mL5ufWMPXrGfq5tLNZHdrncDCEakHY3+mmyXd7JEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6ywNX0LP0nCkEkdoqPoPhIfJri9a+lAVnOpknLFkkMxtjw/VqBOlKV97IIBHYLy2
	 s6LYxGSkkXB/HBU+DKq+PMlkOqg9OoTKSKDKCmYKEtDvzerAXYBKNE9ZUjLTtF+YHU
	 LYb6vUpbOTQJM5zbqfLyWwW6SyiHfByAwE1AWxuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 465/570] pNFS: Fix disk addr range check in block/scsi layout
Date: Mon, 18 Aug 2025 14:47:32 +0200
Message-ID: <20250818124523.778418032@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



