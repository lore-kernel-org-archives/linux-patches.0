Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93F935FC30;
	Tue, 26 Aug 2025 14:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219138; cv=none; b=uCGZUxHUpbeYMweAubn55q0ud1fI5l53AHlcM13N8bySDguyc0ULuHRYKYwvqEWggzpidiSGbfE5gk8dsCSh2+8c8gSuWGJdMmPVOqH8Q0aypC3TaSR1yDQNAhNfGROfgGBR6IlWvNXYUui2yX57uH7fBv7LwRLmJ947PX4OY00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219138; c=relaxed/simple;
	bh=hoCC3uoU/a6AxJO9LKaV1vXbe3aYDu7kZA0abMfw3YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOXNLM5saQ9YA+FV7JUhL4OEptFz9IEpA2LALQj1CNeUgL8BbfJNK3t0bWECtsEFgtc0Ou8e/e5CAuP8pm/hqe6trS3gZFzY5Uc5KFYLeKO8AYXX/WfH4E9YRc0rs/eFUspOwrs/TClMk9ybSfweqS8Of0tC3cyDEasYwIC+n6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zg+HG3Gd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zg+HG3Gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3C2C4CEF1;
	Tue, 26 Aug 2025 14:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219138;
	bh=hoCC3uoU/a6AxJO9LKaV1vXbe3aYDu7kZA0abMfw3YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zg+HG3GdeceVGRbiP1NGq0koBgnbcj+5Kqfj7kzdWdElqPvUKA+cAmQHsz/js23xv
	 wxXy2xcgjDQnJdnnkgbSLo58LnmW3X5fMt5/QEDJToxzjY0VGY1edS/GyS+VGw6/3w
	 x76vaNxwbjFYCu0AbKdpeFfEWKJmzu1XpsZoRRog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 268/403] pNFS: Fix disk addr range check in block/scsi layout
Date: Tue, 26 Aug 2025 13:09:54 +0200
Message-ID: <20250826110914.207585041@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9f10b90debec..4f929134fc63 100644
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



