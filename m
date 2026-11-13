Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591534;
	b=XbuOdkM3uC85T7xpc1qogltConfCDUAYKIdH+/hFXsDIUEroviYnUbg/QM2JKFW5EW8+
	 uPDpGLhyFZF4NJqCfSrqWMjbu1Gu0GQJKAiOnvbUXFjLi/nD20bC/3A77B4Cv2qvvRdkG
	 zWziJKJ4O3kv8dBUi/3P/1m25pM2FCJRjvdHX50UhaxPh6rAU8GY4nJqAkep1mnADbLYK
	 hEGVAvAzc+QUHtgzt623iIVFh2pREelB1xaDI4tEGeIy02c762O0rj7DS9foLNKmtkmkN
	 P82YzHFqZV3vagkqaHPk0RtcrSXhgqGVN/HKoP+ZMPSgHphppI4rqOLt9k1PoBqvccg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YSP5B0YIFVO+Yee1HXlfXPrBX1LaioCkVdyjgh9NsE4=;
	b=rX6/EouJddUuZr/Yby3R42KsJqE1gG9ECyRVe9ldlbG8qtKL7ZcdnxF1CMDZVch4HFcy
	 ScNRExuwbRIr6oBXjCicjBcONNIMa+bI1F2yvDXK0j9z7T2SCiQsgrOxBoIDOV511gr7e
	 vty/Gg//L1aldyUbPb6y/kZFTUszEvdrPv708HOX8u0KjXyZh2cJku31V7wdZJRqaaj0B
	 zXMmX+dn7eNqmoD86LuamX7pyQw8kuJ/ZC4cHPY1sRv3JI2N4xAm0KD9QE8sa92uVadCb
	 0TTcMOElJMgV+xrE87hctYdEAldvQy5s3NMuXqCP2/Ba+R+qd0NnJVK7qWNdDcAgh3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i1idE0xI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C05606D4B0;
	Fri, 13 Nov 2026 17:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i1idE0xI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F801F000C5;
	Fri, 13 Nov 2026 17:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591534;
	bh=YSP5B0YIFVO+Yee1HXlfXPrBX1LaioCkVdyjgh9NsE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1idE0xI0UFT+eRkSJLFe6/2Xp3VR/UEQXvYw3vTym+vHja6jIxp9WLDHVxKxlzL5
	 vZ3BmQFGTnvPxE440VPLaLf8YScFOBR1ZmE221YkxvOVZbZMPr48J+eTCmkKqXywyr
	 x13CxA1onchjOPYphRkwW4bxdPyap7/CWQkBzjHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Andrea Parri <parri.andrea@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 563/670] iomap: dont lose a failed direct I/O bios error when zeroing the tail
Date: Fri, 13 Nov 2026 10:52:07 -0500
Message-ID: <20261113153830.959777015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit a9fd24bcbe690ed4a5b8ea6a7516fa297fae9360 ]

iomap_dio_bio_iter() falls through to the sub-block tail zeroing when
the data bio submission fails, so that the rest of the block is still
zeroed and stale data is not exposed.  The zeroing result was assigned
to ret, which overwrote the submission error with the successful
zeroing result (zero) and the failed write was reported as success.

iomap_dio_zero() can only return an error from a can't-happen
WARN_ON_ONCE() (nr_vecs exceeding BIO_MAX_VECS, which the existing
comment there says "shall never be reached" for any in-tree
filesystem), so it isn't a real runtime failure worth reporting to
userspace, let alone one worth losing the actual submission error for.
Make iomap_dio_zero() return void and drop the error handling at both
call sites instead of threading the result through a separate
variable.

Fixes: 10553a91652d ("iomap: fix iomap_dio_zero() for fs bs > system page size")
Cc: stable@vger.kernel.org # v6.12
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/0cbce1012f5333690be36a9adafb3e190fe2ca77.1790342457.git.parri.andrea@gmail.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Adjusted context for the existing 64 KiB zero buffer and length guard instead of the upstream zero folio and vector-count guard. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index c81cfcbb1bb6d..92eb494aa0f0f 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -250,19 +250,19 @@ void iomap_dio_bio_end_io(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(iomap_dio_bio_end_io);
 
-static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
+static void iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 		loff_t pos, unsigned len)
 {
 	struct inode *inode = file_inode(dio->iocb->ki_filp);
 	struct bio *bio;
 
 	if (!len)
-		return 0;
+		return;
 	/*
 	 * Max block size supported is 64k
 	 */
 	if (WARN_ON_ONCE(len > IOMAP_ZERO_PAGE_SIZE))
-		return -EINVAL;
+		return;
 
 	bio = iomap_dio_alloc_bio(iter, dio, 1, REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
 	fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
@@ -273,7 +273,6 @@ static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 
 	__bio_add_page(bio, zero_page, len, 0);
 	iomap_dio_submit_bio(iter, dio, bio, pos);
-	return 0;
 }
 
 /*
@@ -382,10 +381,7 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 	if (need_zeroout) {
 		/* zero out from the start of the block to the write offset */
 		pad = pos & (fs_block_size - 1);
-
-		ret = iomap_dio_zero(iter, dio, pos - pad, pad);
-		if (ret)
-			goto out;
+		iomap_dio_zero(iter, dio, pos - pad, pad);
 	}
 
 	/*
@@ -463,8 +459,7 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 		/* zero out from the end of the write to the end of the block */
 		pad = pos & (fs_block_size - 1);
 		if (pad)
-			ret = iomap_dio_zero(iter, dio, pos,
-					     fs_block_size - pad);
+			iomap_dio_zero(iter, dio, pos, fs_block_size - pad);
 	}
 out:
 	/* Undo iter limitation to current extent */
-- 
2.53.0



