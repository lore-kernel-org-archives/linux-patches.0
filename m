Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF8827E7C6;
	Tue, 27 May 2025 17:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366325; cv=none; b=dU0AeimwKd0uGQsKg2Jh69OgoiRd8Lr0GAePPe6zEIbGttMYbo2jVb/qVF98168nbI1addnirSQPVsdE2o++V55YCKp8ynaij/UfTumd2nMbJAIla7jz2MPhpwuW4zn/D3M8UNDgImCfIb7NmnPiiQw3HcLQUgTlQqE+JRLl9Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366325; c=relaxed/simple;
	bh=uPeACFw+owjPuCIm7bqBK4O7FQC1LuPz8BimVz3snls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9gYGYzZ1hnjwFmdYmTd0OLAuXXpFx9O0jvHRfOOeekWRw41xR6anxogtK5UDu1GBKere+zea4QqA1Ew6CG4ncYgwXQRvFrA/JUBXeuJdI6InVvX1mD5FC7SJMWGo59XsmxyEbTLFPjuD+Tm0N1u0RZHPIpcYlxRwmhQLF764MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcJ74S3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcJ74S3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68017C4CEEB;
	Tue, 27 May 2025 17:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366324;
	bh=uPeACFw+owjPuCIm7bqBK4O7FQC1LuPz8BimVz3snls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcJ74S3o3391GlMJQvHGfySp1iE8ez039nLECNBu7DMeW9BGixIS0udcDkbb+dZDB
	 qQmqfxWAyobo/9bd86b+J15DCTXjAWzT/CyNp7yILo0mGpyqSLwMalVxem9nKTTtKF
	 WkRTAYgd8u47ydoPmzO49ah0kktgpbKZ3ytxIXDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kdevops@lists.linux.dev
Subject: [PATCH 6.14 032/783] fs/buffer: use sleeping version of __find_get_block()
Date: Tue, 27 May 2025 18:17:09 +0200
Message-ID: <20250527162514.430777792@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 5b67d43976828dea2394eae2556b369bb7a61f64 ]

Convert to the new nonatomic flavor to benefit from potential performance
benefits and adapt in the future vs migration such that semantics
are kept.

Convert write_boundary_block() which already takes the buffer
lock as well as bdev_getblk() depending on the respective gpf flags.
There are no changes in semantics.

Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://kdevops.org/ext4/v6.15-rc2.html # [0]
Link: https://lore.kernel.org/all/aAAEvcrmREWa1SKF@bombadil.infradead.org/ # [1]
Link: https://lore.kernel.org/20250418015921.132400-4-dave@stgolabs.net
Tested-by: kdevops@lists.linux.dev # [0] [1]
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/buffer.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 7981097c846d4..2494fe3a5e69e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -658,7 +658,9 @@ EXPORT_SYMBOL(generic_buffers_fsync);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize)
 {
-	struct buffer_head *bh = __find_get_block(bdev, bblock + 1, blocksize);
+	struct buffer_head *bh;
+
+	bh = __find_get_block_nonatomic(bdev, bblock + 1, blocksize);
 	if (bh) {
 		if (buffer_dirty(bh))
 			write_dirty_buffer(bh, 0);
@@ -1440,7 +1442,12 @@ EXPORT_SYMBOL(__find_get_block_nonatomic);
 struct buffer_head *bdev_getblk(struct block_device *bdev, sector_t block,
 		unsigned size, gfp_t gfp)
 {
-	struct buffer_head *bh = __find_get_block(bdev, block, size);
+	struct buffer_head *bh;
+
+	if (gfpflags_allow_blocking(gfp))
+		bh = __find_get_block_nonatomic(bdev, block, size);
+	else
+		bh = __find_get_block(bdev, block, size);
 
 	might_alloc(gfp);
 	if (bh)
-- 
2.39.5



