Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F3017DFFD;
	Fri, 15 Nov 2024 06:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653806; cv=none; b=Cmtqa3S3fYT+y4IQ/WTNsJmzWnqN0BnSEhtuYshKNcSZ74TppE2Oq/A5f/uX2a5FHXAeZg5ZlKZfyV+1gx6YStC1Hnfm1IkqjnfnAqAnnEQljDQ4hL7jyfFbmZN9izpmdoAvvbQIKvnUpzAY5g6qQ2txm1qjlCKNC3qJ9eS2P6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653806; c=relaxed/simple;
	bh=7qtLGnPaMS/oucIfoeB8PxE9UTSDOCjrLhrHZZq4HyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LewWqmzVkxd/OuUEqxoEv+yZpsaL03G1/ZHFhfgTD0YRde2T7VMOvaSNJOnOvaZO3Z1P1BRyDeK0ePOPjxxKOoaFHZlpaHa01rD4EW9jYU940ojAoD98/nW69OidpdjVhVCv0KlvqtNISv2H2+up6gyVu2EjwXeTyETEKGpjuP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjeVevep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjeVevep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E79C4CECF;
	Fri, 15 Nov 2024 06:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653805;
	bh=7qtLGnPaMS/oucIfoeB8PxE9UTSDOCjrLhrHZZq4HyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjeVevepotEYaMhvD1Y2JWzdve/vyI7p11zwPWJ1JsAd/eLNOff2xOFj+H7uDLLJr
	 NhzSxIRAFT1a24CZ/XQrMrRlKPV6FpNPqRna9xk7M0l+OX1S/UXXbKa+ujmbb1mplQ
	 Cq2UFqbBFzmZwkVLnSAovN8hlys+U76ijBMbZFDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/82] fs: create kiocb_{start,end}_write() helpers
Date: Fri, 15 Nov 2024 07:38:19 +0100
Message-ID: <20241115063727.075441626@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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
 include/linux/fs.h | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index a7d839b196069..4e475ded5cf58 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1797,6 +1797,41 @@ static inline bool sb_start_intwrite_trylock(struct super_block *sb)
 	return __sb_start_write_trylock(sb, SB_FREEZE_FS);
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
 
 extern bool inode_owner_or_capable(const struct inode *inode);
 
-- 
2.43.0



