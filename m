Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540212C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3ABC433D2;
	Tue,  7 Feb 2023 13:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775671;
	bh=brEMxwWACbUQlTpj6yKwcFvvQP0T9MnzNwrgwlLn7S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEF4xYVnwF+oTXj5V2o7YBlGYQYxwEI4R3tqIW/zAyOD8M8PltbpGKwHKmC1lD3Wa
	 7/j2f+vBA/ES+hV6wxPkkUsnJ7DK5tTsAa1pBnCqGx2d8B3OeihVtgk/h6tirCMlCs
	 EzWboBySDLjhSZrcDN4kroDf7NiR5GkyNN63NnIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7bb81dfa9cda07d9cd9d@syzkaller.appspotmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.15 119/120] gfs2: Always check inode size of inline inodes
Date: Tue,  7 Feb 2023 13:58:10 +0100
Message-Id: <20230207125623.849835413@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 70376c7ff31221f1d21db5611d8209e677781d3a upstream.

Check if the inode size of stuffed (inline) inodes is within the allowed
range when reading inodes from disk (gfs2_dinode_in()).  This prevents
us from on-disk corruption.

The two checks in stuffed_readpage() and gfs2_unstuffer_page() that just
truncate inline data to the maximum allowed size don't actually make
sense, and they can be removed now as well.

Reported-by: syzbot+7bb81dfa9cda07d9cd9d@syzkaller.appspotmail.com
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/aops.c  |    2 --
 fs/gfs2/bmap.c  |    3 ---
 fs/gfs2/glops.c |    3 +++
 3 files changed, 3 insertions(+), 5 deletions(-)

--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -452,8 +452,6 @@ static int stuffed_readpage(struct gfs2_
 		return error;
 
 	kaddr = kmap_atomic(page);
-	if (dsize > gfs2_max_stuffed_size(ip))
-		dsize = gfs2_max_stuffed_size(ip);
 	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 	memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
 	kunmap_atomic(kaddr);
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -61,9 +61,6 @@ static int gfs2_unstuffer_page(struct gf
 		void *kaddr = kmap(page);
 		u64 dsize = i_size_read(inode);
  
-		if (dsize > gfs2_max_stuffed_size(ip))
-			dsize = gfs2_max_stuffed_size(ip);
-
 		memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 		memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
 		kunmap(page);
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -450,6 +450,9 @@ static int gfs2_dinode_in(struct gfs2_in
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
+	if (gfs2_is_stuffed(ip) && inode->i_size > gfs2_max_stuffed_size(ip))
+		goto corrupt;
+
 	if (S_ISREG(inode->i_mode))
 		gfs2_set_aops(inode);
 


