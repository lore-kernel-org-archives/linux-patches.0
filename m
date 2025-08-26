Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13EE34F490;
	Tue, 26 Aug 2025 14:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217945; cv=none; b=Xfx5GQ0HcZklELjShmGVUuBnaypiAc3ydEEFVV9n23QlCODtzKZkxliZcTZVGPE7uEtJWmLGmhKs+rQRcEdmIr035cAmX5Y3nYfNXeJ0oZFGDHtAPoXTvQL4/eiex+568YjOa/AR1LNOMKDYP+hmaUogCc4qk1RrW+dCS3Qd65I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217945; c=relaxed/simple;
	bh=WCC9EAZqJk3NllHWFAAntXEKHwp2Wo5WEaJFl+gRDBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYE+VyPP0JOigupoQkBrimhO6QJwrNKq00KW3tMm5SDnLYJk77i8HSZLXzrge1HEkmghu67t0Tm8hpP1NnvNUvSDXrg7a9NEyr520Sqn+D0RFiG+vgmT+hFTPvcl2cWPAuYZ51dDatWjVRJfyayNW62CtUNo+fzejHkdZVLxd6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVgem2Fs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVgem2Fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B48C4CEF1;
	Tue, 26 Aug 2025 14:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217944;
	bh=WCC9EAZqJk3NllHWFAAntXEKHwp2Wo5WEaJFl+gRDBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVgem2FshpGjOJDpCifTcO/AlxDd4BvD157PVPdrj5bMlldehPxjZtX8t4HAmP2A8
	 rpo4P1KjmvS4Nm43BvurmCmdamJuPamEYzeA8928HfDJOU4AVtUs+AbENIglnCH8yN
	 gnofht5/QGDSf6nCi7CoF8XFp+KXK06YKoZv94G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 333/523] pNFS: Fix disk addr range check in block/scsi layout
Date: Tue, 26 Aug 2025 13:09:03 +0200
Message-ID: <20250826110932.691070981@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a9e563145e0c..a853711bcad2 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -171,8 +171,8 @@ do_add_page_to_bio(struct bio *bio, int npg, int rw, sector_t isect,
 
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



