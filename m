Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D5A31D72B;
	Mon, 27 Oct 2025 19:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591831; cv=none; b=OYlBIIxGMsQ9x3aI6lRcMWds7+cbZipAWjkRR8N1zsrfTizAZAGZt4naOUvOgv0TlwnL+iQn5LbOnO8xB+t0Pq09UnHVGTeAO1N/CBegozQM3wm0fjL4bBjMLOiQD5KsAPouvZLEcYGbAssKr42GlepGyy/wyammBOeuNlYQMyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591831; c=relaxed/simple;
	bh=1K86Bmu4wQb4e3dgD4R1L5m/aWuIgAetwyIEHB7OToA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5vyn69qeI5Xjd96t3Hj+AZrPtFqz7bq9HCnwXyM1KbF+PgnvDPR6sTjxgbSu4k0bpWh7WHElZBLPcHFuQHFSGOnhzv/xQTEuifcL8ZhN3yxN/sW9Yaj8zcr+WslWoTpAlY/ZH8lVUu/FdBZbDcYI5iJs4VWlWrWn97lr8ETMoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjLMKbD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjLMKbD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B589C4CEF1;
	Mon, 27 Oct 2025 19:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591831;
	bh=1K86Bmu4wQb4e3dgD4R1L5m/aWuIgAetwyIEHB7OToA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjLMKbD1l8/nhUP1WtTfybw3/FYPIYbJey4OPYL6ELICpkRZBt5/74WH54L6V9zMS
	 g+QyfzFbcr1vQLSrvJYQlFPZdHfp1PPf2+6esMKDKcdNIBzJnVmJL1cquEB6vEvzMc
	 qGM447wfKZdVyjLhYDuBxaYRxyiGOpW1idaoKHqY=
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
Subject: [PATCH 5.15 015/123] dax: skip read lock assertion for read-only filesystems
Date: Mon, 27 Oct 2025 19:34:55 +0100
Message-ID: <20251027183446.808113412@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4ab1c493c73f1..504114394995c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1285,7 +1285,7 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_rw(iter) == WRITE) {
 		lockdep_assert_held_write(&iomi.inode->i_rwsem);
 		iomi.flags |= IOMAP_WRITE;
-	} else {
+	} else if (!sb_rdonly(iomi.inode->i_sb)) {
 		lockdep_assert_held(&iomi.inode->i_rwsem);
 	}
 
-- 
2.51.0



