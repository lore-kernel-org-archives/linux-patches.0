Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C762439343;
	Thu, 30 Jul 2026 14:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422191; cv=none; b=D/teHGLZtArdxm1r70rsUqN9DmzCBlciiZ1dABzxL/afaXaHGoqDdDhWFwbZeXJtGP0n53flo5e5PX/t7+ZcNFGF8TPbectldgESnTrxBJjS90wl0yIYJASZ2o3s8bmWSGiWkOSf6CTG2W1EN8EzyjYN93+T8btw0cmpgaZ+sUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422191; c=relaxed/simple;
	bh=AK1JWb+ar560fwNcuodQZB9OTkP3YTGlMefuFdlZask=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxMtueSnqRWQVRYLgx2a7DlEwfmaZjCT4+amec5H47v0Cl73vSaoGFG/GLJKDO5HHmkASOpvTeiaGgcn896uTQIp1CqXprFQBq6Vfyo1uYWKUDO0jmJy43dFCfUIldUGUKET2IkJ/78ktNcmDUHghbj+EYCdDpVrUmx2oP2uJEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOjDMMb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOjDMMb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AA51F000E9;
	Thu, 30 Jul 2026 14:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422190;
	bh=YVKl7oZlZMt1mlJxauWTGFRatV+xKYGgW36OzCdDhKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GOjDMMb6hCiebNABdY/sJrQY3KByDdxEysAhEqrjCwiMkdR+ZTuUnCFmm2dS3oBB7
	 qHgZ84Xm1c9W/Bh6uHiCFwVQRmd0qjKnOBtOQodZwwaaWORy+NxKVPW60ROjpIt4pN
	 WUhjitYpyOYgfhp/82PxWFtRFf09hCBKVLvo39VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 318/744] iomap: fix incorrect did_zero setting in iomap_zero_iter()
Date: Thu, 30 Jul 2026 16:09:51 +0200
Message-ID: <20260730141451.044039836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 7a6fd6b21d7e1737b40de1a210acf9e6a1e4d59e ]

The did_zero output parameter was unconditionally set after the loop,
which is incorrect. It should only be set when the zeroing operation
actually completes, not when IOMAP_F_STALE is set or when
IOMAP_F_FOLIO_BATCH is set but !folio causes the loop to break early,
or when iomap_iter_advance() returns an error.

This causes did_zero to be incorrectly set when zeroing a clean
unwritten extent because the loop exits early without actually zeroing
any data.

Fix it by using a local variable to track whether any folio was actually
zeroed, and only set did_zero after the loop if zeroing happened.

Fixes: 98eb8d95025b ("iomap: set did_zero to true when zeroing successfully")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260714082325.325163-4-yi.zhang@huaweicloud.com
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 116110628994df..0edb21bdb2f384 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1540,6 +1540,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 		const struct iomap_write_ops *write_ops)
 {
 	u64 bytes = iomap_length(iter);
+	bool zeroed = false;
 	int status;
 
 	do {
@@ -1558,6 +1559,8 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 		/* a NULL folio means we're done with a folio batch */
 		if (!folio) {
 			status = iomap_iter_advance_full(iter);
+			if (status)
+				return status;
 			break;
 		}
 
@@ -1568,6 +1571,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 				bytes);
 
 		folio_zero_range(folio, offset, bytes);
+		zeroed = true;
 		folio_mark_accessed(folio);
 
 		ret = iomap_write_end(iter, bytes, bytes, folio);
@@ -1577,10 +1581,10 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 
 		status = iomap_iter_advance(iter, bytes);
 		if (status)
-			break;
+			return status;
 	} while ((bytes = iomap_length(iter)) > 0);
 
-	if (did_zero)
+	if (did_zero && zeroed)
 		*did_zero = true;
 	return status;
 }
-- 
2.53.0



