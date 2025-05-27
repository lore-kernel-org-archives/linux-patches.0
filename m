Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97527194A67;
	Tue, 27 May 2025 16:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364366; cv=none; b=fc7nA/mLR9iYA1/QQnti0fyyNRE4aNM2sKIjlb20q9HBf+zBRRO+ePBsWBfMJHjayh/24FUx1Q8EM2vcP7zI09asYPOCLgSRvtSS4AULYS3wk05LePrJsNvBB8YNkjB2Nyi9EAUxZWRAnWT8e8HahI4agyiIJTmEIHkqsyxezn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364366; c=relaxed/simple;
	bh=oyFtLuaVKvsJFxssws/Q3a2ZUNcsvlN2PqpbSj3fg/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdoB8vbVUshIKVE6S4Q0X8ajOA2c++mJiOio1GMLXdt6bmpymkhlOqnBYt52Hkco7Z4SBVkCeQfUwig53xXLUgFfGeD5h/apOp5sTHswLQAPwM4vy2wAtdjyya3peT200ixhhd11A5cUcdXZOjuFN5Kn1PJabOm36aMv9ea/dwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqTGIYl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqTGIYl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AAAC4CEE9;
	Tue, 27 May 2025 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364366;
	bh=oyFtLuaVKvsJFxssws/Q3a2ZUNcsvlN2PqpbSj3fg/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqTGIYl3gfI9vHRTaR4c+pvaKnFINus8e/hHMpmTAZyV/RWirSZVburxHjI4//0FV
	 Erfa4BFwpoFi/AjXrJYIqkbKz+YrP14jWyewUQhv1VqTWi3NCl07Fi4hho52Uj6JrD
	 NNvbHNyqA+blblbK4/dkLIAzCUgV+fEsK/SedrMo=
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
Subject: [PATCH 6.12 033/626] fs/buffer: use sleeping version of __find_get_block()
Date: Tue, 27 May 2025 18:18:46 +0200
Message-ID: <20250527162446.413427997@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b04705eb6cc57..e9e84512a027a 100644
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
@@ -1446,7 +1448,12 @@ EXPORT_SYMBOL(__find_get_block_nonatomic);
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



