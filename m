Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA021E0B62;
	Wed,  6 Nov 2024 12:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897209; cv=none; b=TvcI5CcG9Fov24glpBMTqpgUMfLZmJxcy06Yc7VP0ZLTXDRUVDy0x7fzoW0iGJSqIADMPrW1jqRuN3D8PmZvyAo81vBZz65ayeFvLLAwU/r2t+JkmNSM6JcC8sVKs/PKfnBDSYT395oeKgAEPr+jN4DIL93dv7sMLUXzY103WoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897209; c=relaxed/simple;
	bh=qqoTILHFMLtTj69JNfzPH2WDwcFWEs8PzcJpHjzmViE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1DjGHGhLceSgPkSzIG9/ra035knEqhF8jC32E20ke2GjbxPdxa8D/2WslnaFzDGqLGUv0k8Sh8gtJ/sTLdQdXp9ocAhuQO/rBXEi3QsuLMlFcpWp8Wun0i8p/WRCkymkmK/StjknaYLxEojoGN78IuVeAU2WGTp3caTR0tYX2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oiofwf2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oiofwf2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8EFC4CECD;
	Wed,  6 Nov 2024 12:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897209;
	bh=qqoTILHFMLtTj69JNfzPH2WDwcFWEs8PzcJpHjzmViE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oiofwf2YKfD/6sJinPlinoirgsyEMHEd8JpBFW4o1EDkVWI2N3wIDqtLhF7ep/jjb
	 OFwJJZWv6/8YFnUorrSESqtGhoEr530enzbhVluZgdfMp/zRm+65c1SeNqOabyU3bY
	 jfzXa8oGI3gD25/BZrm638TpZeh/eldA+Wj8u25g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/126] fs: create kiocb_{start,end}_write() helpers
Date: Wed,  6 Nov 2024 13:05:03 +0100
Message-ID: <20241106120308.816843697@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit ed0360bbab72b829437b67ebb2f9cfac19f59dfe ]

aio, io_uring, cachefiles and overlayfs, all open code an ugly variant
of file_{start,end}_write() to silence lockdep warnings.

Create helpers for this lockdep dance so we can use the helpers in all
the callers.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Message-Id: <20230817141337.1025891-4-amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 1d60d74e8526 ("io_uring/rw: fix missing NOWAIT check for O_DIRECT start write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fs.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 33c4961309833..0d32634c5cf0d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3029,6 +3029,42 @@ static inline void file_end_write(struct file *file)
 	__sb_end_write(file_inode(file)->i_sb, SB_FREEZE_WRITE);
 }
 
+/**
+ * kiocb_start_write - get write access to a superblock for async file io
+ * @iocb: the io context we want to submit the write with
+ *
+ * This is a variant of sb_start_write() for async io submission.
+ * Should be matched with a call to kiocb_end_write().
+ */
+static inline void kiocb_start_write(struct kiocb *iocb)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	sb_start_write(inode->i_sb);
+	/*
+	 * Fool lockdep by telling it the lock got released so that it
+	 * doesn't complain about the held lock when we return to userspace.
+	 */
+	__sb_writers_release(inode->i_sb, SB_FREEZE_WRITE);
+}
+
+/**
+ * kiocb_end_write - drop write access to a superblock after async file io
+ * @iocb: the io context we sumbitted the write with
+ *
+ * Should be matched with a call to kiocb_start_write().
+ */
+static inline void kiocb_end_write(struct kiocb *iocb)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	/*
+	 * Tell lockdep we inherited freeze protection from submission thread.
+	 */
+	__sb_writers_acquired(inode->i_sb, SB_FREEZE_WRITE);
+	sb_end_write(inode->i_sb);
+}
+
 /*
  * This is used for regular files where some users -- especially the
  * currently executed binary in a process, previously handled via
-- 
2.43.0



