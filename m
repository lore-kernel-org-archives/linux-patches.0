Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FF530FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67910C433CA;
	Wed, 20 Sep 2023 12:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212632;
	bh=MjCM6iJ7HMzJuuAQU7ZDD8JMtrj6NPzD4sFLsJbzd6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0+/H2ymF0oI167HEXx3a6RmdKgoG2rdDPEyPcfenVKxhUDvOJVlc+jlPQI4u16BN
	 gqY4f5VtlE2YIUVf0YYK26za+xfrL2wqA9URMSvu8aj6b6SR7EGkQ5lCnqMVunp/Yv
	 486Cjw753cc3vMSa7r0tR7LmZm56owsVsOZ73Kbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH 5.10 73/83] mm/filemap: fix infinite loop in generic_file_buffered_read()
Date: Wed, 20 Sep 2023 13:32:03 +0200
Message-ID: <20230920112829.541295877@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112826.634178162@linuxfoundation.org>
References: <20230920112826.634178162@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kent Overstreet <kent.overstreet@gmail.com>

commit 3644e2d2dda78e21edd8f5415b6d7ab03f5f54f3 upstream.

If iter->count is 0 and iocb->ki_pos is page aligned, this causes
nr_pages to be 0.

Then in generic_file_buffered_read_get_pages() find_get_pages_contig()
returns 0 - because we asked for 0 pages, so we call
generic_file_buffered_read_no_cached_page() which attempts to add a page
to the page cache, which fails with -EEXIST, and then we loop. Oops...

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Reported-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2203,6 +2203,9 @@ ssize_t generic_file_buffered_read(struc
 
 	if (unlikely(*ppos >= inode->i_sb->s_maxbytes))
 		return 0;
+	if (unlikely(!iov_iter_count(iter)))
+		return 0;
+
 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes);
 
 	index = *ppos >> PAGE_SHIFT;


