Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192F11EE001;
	Tue,  3 Dec 2024 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239171; cv=none; b=bCtiUGhHcqzqalk/muFQ5Iuflh2U//3bgZO5lbQH4FORbEsjeU61eWbVcOngO0NkdGc8blMtM90MjN8HFqItQlG7kvSpWFSwOl6MQQv7vxMtz664ZB9vtZSkrp26W3zxtNJjuOzM5oeFIbgqgJSy2BB/YKkfBVhATKg6J+RRNP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239171; c=relaxed/simple;
	bh=w9ywd52eqrNdNl5OzS9PSgZPeaG3FtwvCVAcEP/Fz24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThTT4dS+bBY5pZo96TTyDFBgrWtEUBUOCnf6njrQ0wagPcwPfynuSIpGATh0KPZ3npLzRwlzOTH3omPj/qCbEx9sAIe4jV4HsXQSw32pGAFMOombNYUBNoPhr2X6BJHPuNBMjCIaChrc+WFL51TGb4Knoex6WP4IpG+m2l1Khks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wg3KknIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wg3KknIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C42C4CECF;
	Tue,  3 Dec 2024 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239171;
	bh=w9ywd52eqrNdNl5OzS9PSgZPeaG3FtwvCVAcEP/Fz24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wg3KknIovVwQcNrbdqx/DmNiENVBzD8CUsqBRy0/mYt/Zru6TYwYVpqEcRVClmTj7
	 kgQ7vldxAiHTr//CTdTVW7ggLBT4gh83bmik7pMBMv4EhwjbuOuBaWaFaqL+cpIF9b
	 2bI8JyqI1+wuLttPXdeQ2GmR87YF1xcL3rzI7mg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinsu Lee <jinsu1.lee@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 524/817] f2fs: fix to avoid forcing direct write to use buffered IO on inline_data inode
Date: Tue,  3 Dec 2024 15:41:36 +0100
Message-ID: <20241203144016.346780117@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 26e6f59d0bbaac76fa3413462d780bd2b5f9f653 ]

Jinsu Lee reported a performance regression issue, after commit
5c8764f8679e ("f2fs: fix to force buffered IO on inline_data
inode"), we forced direct write to use buffered IO on inline_data
inode, it will cause performace regression due to memory copy
and data flush.

It's fine to not force direct write to use buffered IO, as it
can convert inline inode before committing direct write IO.

Fixes: 5c8764f8679e ("f2fs: fix to force buffered IO on inline_data inode")
Reported-by: Jinsu Lee <jinsu1.lee@samsung.com>
Closes: https://lore.kernel.org/linux-f2fs-devel/af03dd2c-e361-4f80-b2fd-39440766cf6e@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 611c0aac721a3..b4047d8092890 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -868,7 +868,11 @@ static bool f2fs_force_buffered_io(struct inode *inode, int rw)
 		return true;
 	if (f2fs_compressed_file(inode))
 		return true;
-	if (f2fs_has_inline_data(inode))
+	/*
+	 * only force direct read to use buffered IO, for direct write,
+	 * it expects inline data conversion before committing IO.
+	 */
+	if (f2fs_has_inline_data(inode) && rw == READ)
 		return true;
 
 	/* disallow direct IO if any of devices has unaligned blksize */
-- 
2.43.0



