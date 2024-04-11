Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E44013E897;
	Thu, 11 Apr 2024 10:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830659; cv=none; b=Kcuxn2zFp8ez7a38Si6LCVRIF6K0JYKI+1u+O4QUNqG5X6AN30eFA8uAfWtBfgK9wT+MvkyzzAZraKwCKgs5bvNyHXYLyBREGCqNvEu7siPNjc6afZdZke7OPe0QiCLnl2zSn/kvvy34z26gVXFo8b6N82QvsWIte4iMyK3rC7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830659; c=relaxed/simple;
	bh=l7LJ5wLfIwnVglHB7XLDM5wUQ7zOiJvXmy+N9Z0DOtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERN3EwGTPUYSIb1okYtHFhZrGK/fLl42fVIPwjfixP2FwqkeX68RZWcrK2FwAmUMc3OGt7e0VMJQ9owRbD/4mJABuJ3SQooPi+uAwY1xyRVfg9cce3P62w8z/rymp6lriDQFXkQETepAXMyx9mXUaP/xL+HSojla3LstTFCkzeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5GJHW0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5GJHW0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACADC433C7;
	Thu, 11 Apr 2024 10:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830659;
	bh=l7LJ5wLfIwnVglHB7XLDM5wUQ7zOiJvXmy+N9Z0DOtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5GJHW0Qpp5RoEZvyAudQ7Jn5OibIYASG0ESgN/rZmAod1/tKB/JBlkVNaQ+QyOj4
	 GW7pTEK5lT7+W9DnmF4tNGsOIQYjQM0my8QJfJrNyg3QZIwRf6QpyiK3jmdL2Dm8fS
	 fyCWwX0izWPDTjvvkz1Bb+9eeNiTtbDhICDYKfzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/215] nilfs2: prevent kernel bug at submit_bh_wbc()
Date: Thu, 11 Apr 2024 11:54:44 +0200
Message-ID: <20240411095427.164761866@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 269cdf353b5bdd15f1a079671b0f889113865f20 ]

Fix a bug where nilfs_get_block() returns a successful status when
searching and inserting the specified block both fail inconsistently.  If
this inconsistent behavior is not due to a previously fixed bug, then an
unexpected race is occurring, so return a temporary error -EAGAIN instead.

This prevents callers such as __block_write_begin_int() from requesting a
read into a buffer that is not mapped, which would cause the BUG_ON check
for the BH_Mapped flag in submit_bh_wbc() to fail.

Link: https://lkml.kernel.org/r/20240313105827.5296-3-konishi.ryusuke@gmail.com
Fixes: 1f5abe7e7dbc ("nilfs2: replace BUG_ON and BUG calls triggerable from ioctl")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 83dbfd9d25323..530edb813add8 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -111,7 +111,7 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 					   "%s (ino=%lu): a race condition while inserting a data block at offset=%llu",
 					   __func__, inode->i_ino,
 					   (unsigned long long)blkoff);
-				err = 0;
+				err = -EAGAIN;
 			}
 			nilfs_transaction_abort(inode->i_sb);
 			goto out;
-- 
2.43.0



