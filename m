Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589596FB0;
	Tue,  5 Dec 2023 03:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQJnd8d2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBB6C433C9;
	Tue,  5 Dec 2023 03:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746599;
	bh=6qXwnit/X4VIGKxPc+DP8ksO1hqPTulihiUVa2aaHx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQJnd8d276d+mYdaMhsG0khGI/ropGx3OJ7saXXPWNCEvA2KnVEKY4lDso3lDW9IZ
	 G5ga8cUyVtLpAQrbbp4qRe+oYdQ+ngJLANJfI3KgjBbYqKs+w6Ioe6oKHPbHh2hg40
	 l5HpEwOtn3/gLsj4hScGEzw9hF8KINfug7mQrDJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.6 052/134] ext2: Fix ki_pos update for DIO buffered-io fallback case
Date: Tue,  5 Dec 2023 12:15:24 +0900
Message-ID: <20231205031538.878687276@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

commit 8abc712ea4867a81c860853048f24e511bbc20f2 upstream.

Commit "filemap: update ki_pos in generic_perform_write", made updating
of ki_pos into common code in generic_perform_write() function.
This also causes generic/091 to fail.
This happened due to an in-flight collision with:
fb5de4358e1a ("ext2: Move direct-io to use iomap"). I have chosen fixes tag
based on which commit got landed later to upstream kernel.

Fixes: 182c25e9c157 ("filemap: update ki_pos in generic_perform_write")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <d595bee9f2475ed0e8a2e7fb94f7afc2c6ffc36a.1700643443.git.ritesh.list@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext2/file.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 1039e5bf90af..4ddc36f4dbd4 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -258,7 +258,6 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			goto out_unlock;
 		}
 
-		iocb->ki_pos += status;
 		ret += status;
 		endbyte = pos + status - 1;
 		ret2 = filemap_write_and_wait_range(inode->i_mapping, pos,
-- 
2.43.0



