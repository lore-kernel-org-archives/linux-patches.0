Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D1133A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301921; cv=none; b=HYBj4W6pbFtaKbgWvS+tn3XknqfLmc+k8Gex+vTBEmjzPTELg2KuFP7rX58q+aKl2Me0cNPtEOpkCzk8CdyEaPKNkcFcYIBSz2FrTfEGiid9w59U259ygDDmXbYZDG4mgQzTfMVJofilalOR1Gp5llsZ7XaMrS2G78jbPC58T08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301921; c=relaxed/simple;
	bh=0h5BFdsqQpUnGVxiqeAi4PsCQPIVIiY4i+4A280pHVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oebDgHjHTXU1qK6kZlYo6sGYnjX5Bp3RWpN7ivgoCrnsx+/FpDn6wIcEoq2FG09rjtTk0BVMaYXbkbKTwX3ZmAuCEZIRnwFSh/3rvxmDBS9Y4ocD2zQB56eVxomUqOno5JPWnaWvouEJ2w+dnQhGsWGwHBBc3ByO6ArOcEdxKKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uC7SyO3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uC7SyO3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154F5C116D0;
	Sat, 28 Feb 2026 18:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301921;
	bh=0h5BFdsqQpUnGVxiqeAi4PsCQPIVIiY4i+4A280pHVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uC7SyO3OmiW/8jjOOQKNKkWZeAC0tgCPa8K6Lyok5kdjm8TSqUX7EAVLCS6+F2tX4
	 DC68z23pu6Xiyfeq5i8aV1cP5a4yCgnoVYnOXZghjqYNdF+YGaJI0mrU41mTPUztwk
	 xHVdgNjwBI17eXzBEwWPqDVb//BnIOqD3aEAfRZOJWkg0FDAgcDiNtex9qAPKpkKVC
	 JoPvePf+BhF1i+LeDpCWSKS2ZliZqj1HahfTp6Dyi2/skq4tqL+gndiKV9W6IoAcT5
	 05FCKf1VHquhBNysPUoFRteomM2AgugESrXLjOSUFD1t1CW6VpX1QNpSQOqIBMYlK/
	 BZofEzv5gZZDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>,
	syzbot+08d8956768c96a2c52cf@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/385] fs/ntfs3: Initialize new folios before use
Date: Sat, 28 Feb 2026 12:59:37 -0500
Message-ID: <20260228180011.1568201-355-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>

[ Upstream commit f223ebffa185cc8da934333c5a31ff2d4f992dc9 ]

KMSAN reports an uninitialized value in longest_match_std(), invoked
from ntfs_compress_write(). When new folios are allocated without being
marked uptodate and ni_read_frame() is skipped because the caller expects
the frame to be completely overwritten, some reserved folios may remain
only partially filled, leaving the rest memory uninitialized.

Fixes: 584f60ba22f7 ("ntfs3: Convert ntfs_get_frame_pages() to use a folio")
Tested-by: syzbot+08d8956768c96a2c52cf@syzkaller.appspotmail.com
Reported-by: syzbot+08d8956768c96a2c52cf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=08d8956768c96a2c52cf

Signed-off-by: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index f1122ac5be622..23a637cdb0810 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -964,7 +964,7 @@ static int ntfs_get_frame_pages(struct address_space *mapping, pgoff_t index,
 
 		folio = __filemap_get_folio(mapping, index,
 					    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
-					    gfp_mask);
+					    gfp_mask | __GFP_ZERO);
 		if (IS_ERR(folio)) {
 			while (npages--) {
 				folio = page_folio(pages[npages]);
-- 
2.51.0

