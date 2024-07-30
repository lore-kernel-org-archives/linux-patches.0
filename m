Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E921A76C7;
	Tue, 30 Jul 2024 17:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359220; cv=none; b=C4AMs7gt8PBJ9S0T6cWv+U8Ej34R0UtW9dfTxGAcOpU9i3QIVg1KGRv9EQoBBtivz4oZ2S+Qh0eoo9OkBE3C/sGZqffy35Fh2yaipOgOp56hiwilazdvvVc7SMpMxyP3pe9kaEZcqhdhhgw8jj2jzdBaM0i5zbbd1Z+IsbraN40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359220; c=relaxed/simple;
	bh=3ajHqFFFxtMmsM4hGg628S3GizkV2JrfWlWK0LOjprI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hScvkinS7sriwnee1j/yIpxzmprWCNU8rSi4qzMdPfbZZAhDQ0dpTl82VMUrZAUhzcjbEXnb7Ldg2LE0fJ9DwNDhqWMuR8fp9NOCUQu4ecUS2ssQ0QjVOhiEWa7/eI5Ow1VeHzwitnjs1MNmPzp2miAWNh0EqTO4DhO9t+owWuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAS7W/5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAS7W/5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592EBC4AF0E;
	Tue, 30 Jul 2024 17:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359219;
	bh=3ajHqFFFxtMmsM4hGg628S3GizkV2JrfWlWK0LOjprI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAS7W/5tk7SASfMB70yQHSEf4gee9EZuCVTY5xWjCw1o5HrZTU3iaMAj/PYWi+cWG
	 pDSBtYgCE7U2F0bHQwDBCAKkJK/av21I4uWf+3vZW3jHQYvLjFUYcJ5QWQU1Bv9V30
	 jijdvGv5fx1DiBgtTBbMYJjEFRoQtUiaqNtF6s9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Song <v-songbaohua@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 436/568] f2fs: fix to force buffered IO on inline_data inode
Date: Tue, 30 Jul 2024 17:49:03 +0200
Message-ID: <20240730151656.911013795@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit 5c8764f8679e659c5cb295af7d32279002d13735 upstream.

It will return all zero data when DIO reading from inline_data inode, it
is because f2fs_iomap_begin() assign iomap->type w/ IOMAP_HOLE incorrectly
for this case.

We can let iomap framework handle inline data via assigning iomap->type
and iomap->inline_data correctly, however, it will be a little bit
complicated when handling race case in between direct IO and buffered IO.

So, let's force to use buffered IO to fix this issue.

Cc: stable@vger.kernel.org
Reported-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -803,6 +803,8 @@ static bool f2fs_force_buffered_io(struc
 		return true;
 	if (f2fs_compressed_file(inode))
 		return true;
+	if (f2fs_has_inline_data(inode))
+		return true;
 
 	/* disallow direct IO if any of devices has unaligned blksize */
 	if (f2fs_is_multi_device(sbi) && !sbi->aligned_blksize)


