Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0222141D5;
	Tue, 12 Nov 2024 10:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407105; cv=none; b=g0zCwraA1faMqu1Wt01F0Ujolj2U6cvslAgsBEROSt6V4JyYpnq9qOYzXcbzOZMHGvC2N3U5BnBtky6AhiJValNViHQUXvZFQ8NvQVcGYK0AI29cDB5aB1+4BiyJYkqLSolRgYQhTyCcz7zTN+aJMeOSNrCM6Woro2zsBS0A3p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407105; c=relaxed/simple;
	bh=ddnrFRYvSTCj0rDNI/UVIHjpkWuGhmDnRP9avmC6+Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvYqTDDVdgTTryc1r4n6JKAvBYC4Coq+RjbHvZzLGig2A7K8MdKnwQfSubbwo4FgQrwGpa7ipdjP3TsozbNv6QLxxfCxTBXgnxfkzOoRUtZvUoc16CT/adptZrS4+ymExnexZCsizjE9reZOvrcA/u0MKSMwGTPW5pFNvUQlbig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNuMfifu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNuMfifu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6301C4CECD;
	Tue, 12 Nov 2024 10:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407105;
	bh=ddnrFRYvSTCj0rDNI/UVIHjpkWuGhmDnRP9avmC6+Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNuMfifuuMoIYtms7JN666ddKq9t0T6rRFb1lEAUB6UU5+Gmm0U1dQtT8nNbXXjoJ
	 UEyxJkHSeRj5kEL2h0e0rZ8dApLh8zI/iTIFVx6iVPQAecBoFDRqFdMXdlYcywZMpA
	 Sv0EYYncZ5f0Y95OHZEm5DFHY5uWYGFmKIw376Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 51/76] fs: create kiocb_{start,end}_write() helpers
Date: Tue, 12 Nov 2024 11:21:16 +0100
Message-ID: <20241112101841.726033077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

Commit ed0360bbab72b829437b67ebb2f9cfac19f59dfe upstream.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fs.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6ff6ade229a07..2ef0e48c89ec4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3058,6 +3058,42 @@ static inline void file_end_write(struct file *file)
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



