Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5CF1DDC3A;
	Mon,  6 Jan 2025 15:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177283; cv=none; b=tUdvAMJjA70pdj33dkwkkLAZMCwe3jdf6jYVmlH3dB08sVdofbWBbePZm6o6JmHL+/ApjnIyX+AxiMzCe9u/HRoQxl7aQo1O0Oj1ucHFrbzkfPyA0jBwUjP69AL5ygFlJG6DhWhZzb5Yyuf1pyUOzcr6ccG0gn3a+DdO1VZkJXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177283; c=relaxed/simple;
	bh=pzZ4fW/sWFLMHjGJemz4kyXf20n0jHUjg04/Ane9CWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivZQczFWpdYzSan2+EVKR13gdf8px+o9+me2I/uGcwAAOjbrrYo/cmJ2x8t44rp208VkvIUV7DEEZbkSOOQfijIV8WgNpSlROM0ccsLvk/a/EczSuQtwz0sggRoYZ83d3ZyWPfbvRQR6S9cwunulSWA40J27QJZq9FmwATe/RGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwYJLjQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwYJLjQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7780EC4CEE3;
	Mon,  6 Jan 2025 15:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177282;
	bh=pzZ4fW/sWFLMHjGJemz4kyXf20n0jHUjg04/Ane9CWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwYJLjQL+GTImKm1brW34YB5DcLsTyRsX4Wyl2BJjmcJURfkuDNOU2Sp4irDSB9qb
	 7vq9iSqL964pAPyUf0TxZw3ko9aTq4oGWte2KGuVSMBYdcPOqhZhWkuHSq57uBxPYT
	 jD6EilNpOWQLqFTlAci6yollIuG6G8Kgi7C//VcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.6 112/222] f2fs: fix to wait dio completion
Date: Mon,  6 Jan 2025 16:15:16 +0100
Message-ID: <20250106151154.835164614@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 96cfeb0389530ae32ade8a48ae3ae1ac3b6c009d upstream.

It should wait all existing dio write IOs before block removal,
otherwise, previous direct write IO may overwrite data in the
block which may be reused by other inode.

Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Resolve line conflicts to make it work on 6.6.y ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1037,6 +1037,13 @@ int f2fs_setattr(struct mnt_idmap *idmap
 				return err;
 		}
 
+		/*
+		 * wait for inflight dio, blocks should be removed after
+		 * IO completion.
+		 */
+		if (attr->ia_size < old_size)
+			inode_dio_wait(inode);
+
 		f2fs_down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 		filemap_invalidate_lock(inode->i_mapping);
 
@@ -1873,6 +1880,12 @@ static long f2fs_fallocate(struct file *
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


