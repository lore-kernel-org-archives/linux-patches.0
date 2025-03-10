Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CACF22B5AD;
	Mon, 10 Mar 2025 18:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630560; cv=none; b=oyigAgDVwrsCiRNVN9KKQC7ZRFlcX9waI7gQI5tU8G1+2YzzQSDoDL21AiCYYHaVp0a4Ya3kQT/QePy1TgEKlz135abv5qQaz6UHmhjv0L4KFGuBZbUTxUq98JLZ+FpUI7lSLZ6qfUq1+p4Lrn+FSgEpZ0+2FrLYqGDYeB5t0W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630560; c=relaxed/simple;
	bh=HHGN4r/eol9u//ZIzWljRXNV/amVZLbPy+qQ7l0oANs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+cEOGv0lzXDASPwngAxS9XsUc16Oc1OUArr/lmv1IOV4KZ0fm5gtrYtLAI0ew9e4AbqIqL9JPwVenMb/L4XOybIPScziigg6TltPyolrqf1Zq5lm9Ms20qkeq8qAoXfuVN9Ph8TnB2VBuZtrz+d2+jxhHNpNeIAxcpp2fvhWx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnI1XamB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnI1XamB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F3AC4CEE5;
	Mon, 10 Mar 2025 18:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630559;
	bh=HHGN4r/eol9u//ZIzWljRXNV/amVZLbPy+qQ7l0oANs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnI1XamB6GU7nUijMNcDAZ1RUSmtJjoidifBTph8VKhP5QtPK5BwQ2OlIIGmT0geF
	 4NMymn3IfDWEuFZfGwgq06aKlRB1zUbKn+LhHHVw0hHuquQ6Ocp2ppjKdCvyqipiTJ
	 GP44qkGzclVIXHN5RRISxWktP11Tku5O7EracRvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 5.15 425/620] f2fs: fix to wait dio completion
Date: Mon, 10 Mar 2025 18:04:31 +0100
Message-ID: <20250310170602.367948239@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 96cfeb0389530ae32ade8a48ae3ae1ac3b6c009d upstream.

It should wait all existing dio write IOs before block removal,
otherwise, previous direct write IO may overwrite data in the
block which may be reused by other inode.

Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -965,6 +965,13 @@ int f2fs_setattr(struct user_namespace *
 				return err;
 		}
 
+		/*
+		 * wait for inflight dio, blocks should be removed after
+		 * IO completion.
+		 */
+		if (attr->ia_size < old_size)
+			inode_dio_wait(inode);
+
 		down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 		filemap_invalidate_lock(inode->i_mapping);
 
@@ -1790,6 +1797,12 @@ static long f2fs_fallocate(struct file *
 	if (ret)
 		goto out;
 
+	/*
+	 * wait for inflight dio, blocks should be removed after IO
+	 * completion.
+	 */
+	inode_dio_wait(inode);
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		if (offset >= inode->i_size)
 			goto out;


