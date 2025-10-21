Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B873F26738B;
	Tue, 21 Oct 2025 19:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076448; cv=none; b=bek/yGucgEpubsOqzULQnqJc70O7aQniAaDS47AD9jvYQ9gt/a+Ok2Llyq7fCl7CtR7clX2l0QDGIYFSbZrXKJXa1j/4BdavPx/Ov2T3hM4h0SWwGjmQc/U+sPLPvbPoq/IClVU21X/oEQz5PgRWcuq4tEO7iPfHT69h+axC59U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076448; c=relaxed/simple;
	bh=0M9W7mZ8lHve0m9YRtioTjORhANvrBNVSJQGkQmfP98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8GjFTOeys26yC1iHL0l9MsQM4IFj+1P4Af7aZTQEKbSsOTcvEhuZf44/V3Xne7QdQC5RslGNxxoLYE59ezxZaZfrnJSYfNWXbZlOo0p1awA5SgwbQiU85Qdo1e5bYiSWMtu7qg596tZpDZqUCkc4yVwRTlLy1pwZa1E9s0frSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfnaJQqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfnaJQqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6528C4CEF5;
	Tue, 21 Oct 2025 19:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076444;
	bh=0M9W7mZ8lHve0m9YRtioTjORhANvrBNVSJQGkQmfP98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfnaJQqHvKa/MlY6UWwJVFVU74v5Nefa2QbWh6nY56522Eti04LRIOWf8FpDRyGgD
	 0PmkAYb53dRjY+I1o2OcCixJU91IdpMP0L5BumH5sXlwBMgld4kWmYAZaRDopQVHNF
	 4j6xxERvHMZlXoDG+kTvIW6dzEIjYGJYHASApnho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Friendy Su <friendy.su@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/105] dax: skip read lock assertion for read-only filesystems
Date: Tue, 21 Oct 2025 21:50:44 +0200
Message-ID: <20251021195022.527432075@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 154d1e7ad9e5ce4b2aaefd3862b3dba545ad978d ]

The commit 168316db3583("dax: assert that i_rwsem is held
exclusive for writes") added lock assertions to ensure proper
locking in DAX operations. However, these assertions trigger
false-positive lockdep warnings since read lock is unnecessary
on read-only filesystems(e.g., erofs).

This patch skips the read lock assertion for read-only filesystems,
eliminating the spurious warnings while maintaining the integrity
checks for writable filesystems.

Fixes: 168316db3583 ("dax: assert that i_rwsem is held exclusive for writes")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Friendy Su <friendy.su@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 8c09578fa0357..e1451efaab140 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1578,7 +1578,7 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_rw(iter) == WRITE) {
 		lockdep_assert_held_write(&iomi.inode->i_rwsem);
 		iomi.flags |= IOMAP_WRITE;
-	} else {
+	} else if (!sb_rdonly(iomi.inode->i_sb)) {
 		lockdep_assert_held(&iomi.inode->i_rwsem);
 	}
 
-- 
2.51.0



