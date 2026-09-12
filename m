Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6528B38F649;
	Sat, 12 Sep 2026 19:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242803; cv=none; b=fK458/VuKE7x11YAfuROyP2Go9GVthPSVzOLafsy5WJp+3zyrBQ9d6KLdKCBNDJG59sKqA9FGj3NNref9O2yuI1z2KwTwJ+P2WzQ/sNDbnJ03OaCUKFdWKv3Y9DVlzcKDfMfIJxvrl3eG21cu3k169x6Zktg9Vsvd8GQ6bIngSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242803; c=relaxed/simple;
	bh=QkBvvgtKsr1A+7mt/PdrhDFWMjPkyOZjOLGa3OP2K+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWfFZD96lHYkMDHaf2/IECUg1RruEgSjHmUbhu60S1683yawUJiJiE0tlkrRspNapumeXIDwHcC/ojeIYP4EWV4noy54WzMXINy92tHN4jtfAZf/iOrNmLiGUhQJs/d5FHgF7wp5tUngItQYxdE7wXsghDV9LunAgNbUv6iRSGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+NskDe2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+NskDe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9F71F000FF;
	Sat, 12 Sep 2026 19:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242802;
	bh=LorNTqJe+zwnihQ3QkkDw0y2rkOQTFvYd7jgF6I2aRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+NskDe27FWKBUION78h8Xv7WTvuZoX4wccPEp0jL6OHqgdBzOQlM3BONyLr90TTw
	 fQA9/XOA4rFq+UlKf8vxVemuwjLtBNjg7cUNnGt0Vv1yRY0SgipgMROzLbNA9r16lB
	 ujZeaS1nRQNi3BvCpKCiF9TqOchynl3iPY5jFnlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 533/798] nilfs2: prevent out-of-bounds read in super root block parsing
Date: Sat, 12 Sep 2026 09:02:41 +0200
Message-ID: <20260912065529.347498501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit 7cb2f76a6a2ba2130b577cb8ac13e1e46c4fc689 ]

super-root inode metadata size is trusted before nilfs_read_inode_common().

Reject super-root inode sizes whose computed on-disk footprint exceeds the
filesystem block size. This prevents malformed filesystem images from
making nilfs_read_inode_common() read past the end of the super-root block.

[ryusuke: clarify the commit title]

Fixes: 8a9d2191e9f4 ("nilfs2: operations for the_nilfs core object")
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/the_nilfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 09ba8bbaf6cad..77bba00eec5d0 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -450,6 +450,12 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 			  nilfs->ns_inode_size);
 		return -EINVAL;
 	}
+	if (NILFS_SR_BYTES(nilfs->ns_inode_size) > nilfs->ns_blocksize) {
+		nilfs_err(nilfs->ns_sb,
+			  "too large inode size for super root: %d bytes",
+			  nilfs->ns_inode_size);
+		return -EINVAL;
+	}
 
 	nilfs->ns_first_ino = le32_to_cpu(sbp->s_first_ino);
 	if (nilfs->ns_first_ino < NILFS_USER_INO) {
-- 
2.53.0



