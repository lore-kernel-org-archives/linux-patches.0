Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D342EF9B0;
	Thu,  3 Jul 2025 15:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555412; cv=none; b=E8GhPZ8GDAQXPRIhTxq5bBJXM7NZOv+xD6WUe+YzUgc6W0phXal4beVD0EdbRgQ0zf+2x6/XDHL9JEf29fwQt+AMHYB6pT3FnLWyF2PtG3GSGm/AvcDB/1nhQzxS210phz0ROY5VzkMWxItVNxrkmqauToc/+8QmY0JyLw1Lpic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555412; c=relaxed/simple;
	bh=2+7W0VY0eFLCdWYePtk+NLlQat+z6ZZIeTE1JhNO+V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OArdJ1HweB7eoZC2pXF4epNSqre3HZzuXEHZrN7fkR5g6HW0AH8VYbpYka6EDuI99Y2dVBPabYDsZ6v1+2y5iPGRXzp+45YamwUtli7qXkdrNVuMiOnBdcFv1sTscUA3I7re+oeSzJhHdsUBC1TzFsWxitNCtVQvbImDgJOpziE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YumWkAzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YumWkAzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA76DC4CEE3;
	Thu,  3 Jul 2025 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555412;
	bh=2+7W0VY0eFLCdWYePtk+NLlQat+z6ZZIeTE1JhNO+V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YumWkAzQtz2NvrUTx3bLl2g+awfd1C96aKxv1eCjvjt2rWbLw1QsswFTJtxykW0to
	 kjvKYbZaGurA7YUU2l6Ldw46X+613J5/VVB2wJzqxmLOtbGdz7LmHyDar7M7EEiePh
	 0VcKKUy+5z258GTPjg4gXc3gcUwGEHyVDMPEAu/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 262/263] io_uring: gate REQ_F_ISREG on !S_ANON_INODE as well
Date: Thu,  3 Jul 2025 16:43:02 +0200
Message-ID: <20250703144014.917642322@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 6f11adcc6f36ffd8f33dbdf5f5ce073368975bc3 upstream.

io_uring marks a request as dealing with a regular file on S_ISREG. This
drives things like retries on short reads or writes, which is generally
not expected on a regular file (or bdev). Applications tend to not
expect that, so io_uring tries hard to ensure it doesn't deliver short
IO on regular files.

However, a recent commit added S_IFREG to anonymous inodes. When
io_uring is used to read from various things that are backed by anon
inodes, like eventfd, timerfd, etc, then it'll now all of a sudden wait
for more data when rather than deliver what was read or written in a
single operation. This breaks applications that issue reads on anon
inodes, if they ask for more data than a single read delivers.

Add a check for !S_ANON_INODE as well before setting REQ_F_ISREG to
prevent that.

Cc: Christian Brauner <brauner@kernel.org>
Cc: stable@vger.kernel.org
Link: https://github.com/ghostty-org/ghostty/discussions/7720
Fixes: cfd86ef7e8e7 ("anon_inode: use a proper mode internally")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1647,11 +1647,12 @@ static void io_iopoll_req_issued(struct
 
 io_req_flags_t io_file_get_flags(struct file *file)
 {
+	struct inode *inode = file_inode(file);
 	io_req_flags_t res = 0;
 
 	BUILD_BUG_ON(REQ_F_ISREG_BIT != REQ_F_SUPPORT_NOWAIT_BIT + 1);
 
-	if (S_ISREG(file_inode(file)->i_mode))
+	if (S_ISREG(inode->i_mode) && !(inode->i_flags & S_ANON_INODE))
 		res |= REQ_F_ISREG;
 	if ((file->f_flags & O_NONBLOCK) || (file->f_mode & FMODE_NOWAIT))
 		res |= REQ_F_SUPPORT_NOWAIT;


