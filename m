Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AB48F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CABC433C8;
	Sun, 16 Jul 2023 19:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537218;
	bh=K5rHq1LfKc4VZBVAHSnPR42oWNHNTxIJfGEJlkEBi4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlTeRr3nQnyKkp6WCG8HyBdjR4h29WNNlwSta4f1Cv3798vWcznKPgqckh5Oa+VqS
	 HIJi3AgJQpAQk4zah9chWfRQAPPPAZ/0c5Hpwjhf8nZSYOv7k1JbqAfGTM1a4jm5Td
	 MzGmapLYg8XK0CRjzryjo0oIW843j5w9/eMZm7EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Jens Axboe <axboe@kernel.dk>,
	Al Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 018/800] splice: Fix filemap_splice_read() to use the correct inode
Date: Sun, 16 Jul 2023 21:37:51 +0200
Message-ID: <20230716194949.527681049@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit c37222082f23c456664d1c3182a714670ab8f9a4 ]

Fix filemap_splice_read() to use file->f_mapping->host, not file->f_inode,
as the source of the file size because in the case of a block device,
file->f_inode points to the block-special file (which is typically 0
length) and not the backing store.

Fixes: 07073eb01c5f ("splice: Add a func to do a splice from a buffered file without ITER_PIPE")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christian Brauner <brauner@kernel.org>
cc: Steve French <stfrench@microsoft.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: David Hildenbrand <david@redhat.com>
cc: John Hubbard <jhubbard@nvidia.com>
cc: linux-mm@kvack.org
cc: linux-block@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
Link: https://lore.kernel.org/r/20230522135018.2742245-2-dhowells@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/filemap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 83dda76d1fc36..8abce63b259c9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2906,7 +2906,7 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
 	do {
 		cond_resched();
 
-		if (*ppos >= i_size_read(file_inode(in)))
+		if (*ppos >= i_size_read(in->f_mapping->host))
 			break;
 
 		iocb.ki_pos = *ppos;
@@ -2922,7 +2922,7 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
 		 * part of the page is not copied back to userspace (unless
 		 * another truncate extends the file - this is desired though).
 		 */
-		isize = i_size_read(file_inode(in));
+		isize = i_size_read(in->f_mapping->host);
 		if (unlikely(*ppos >= isize))
 			break;
 		end_offset = min_t(loff_t, isize, *ppos + len);
-- 
2.39.2



