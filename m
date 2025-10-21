Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF3F1A3029;
	Tue, 21 Oct 2025 20:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076983; cv=none; b=sPsfsxaX1+++imYEceszuEYP7K5GgtrK1PLWgg9MQNz6bhk6tsvTFf+BL+jFIebbg/TnurtvS6dwmxtZRoSSWzTChvHzJHcdpx1jqr3o4/KHlSPDxgeVIxPCTjuYZXytWMMskNw5iyiYl9VJhUKT9e4yLaLwipU4YDhKLX1kukc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076983; c=relaxed/simple;
	bh=ylodqQu/0PJa/Av9gulXNAou/2AvlqGrkaqsSRqQ0eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8bZMwgl7BNiOOilrZ/3K8EQY2U5gblxzaTUQZ4MWi4i+W9YJZcypko4maDDcmMYuqvdl751wwJVY2XqYSOQMA/JTh4/fbLtQoCLkCxEFGPnH4IkpRJSw2iVJv6iVrrsbMFZWfOWxtZFKhsaKpiR8/O+jfH2+TesfM0IQEsMI70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMWLMcC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMWLMcC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC62C4CEF1;
	Tue, 21 Oct 2025 20:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076983;
	bh=ylodqQu/0PJa/Av9gulXNAou/2AvlqGrkaqsSRqQ0eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMWLMcC8G9BO5qOzY0RbnoObIES7rFkdQU5KybQQHsz/HR3JhExkOebG6mrcG6D+F
	 tsrPgsaKehZyd0PohdLsHtLcwV9HfEsT6xGh0K3jFeUB3tVhawRpGramHfJ3hAI2KN
	 oVtPStNLn+fC57jw4Pm4H5XCbAq4RBGwt9vv+dwE=
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
Subject: [PATCH 6.12 044/136] dax: skip read lock assertion for read-only filesystems
Date: Tue, 21 Oct 2025 21:50:32 +0200
Message-ID: <20251021195037.045423864@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 21b47402b3dca..756400f2a6257 100644
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



