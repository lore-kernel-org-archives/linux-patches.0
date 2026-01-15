Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231B02C0F83;
	Thu, 15 Jan 2026 17:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499053; cv=none; b=Jguyvl3cx04n22e4eqc16jN41SbsUUFyxa5z57fiDNq/gwSPLSsZYPBFXHDXCq3dgh02gd3JrY4KAr5OfcCLPQToHQYFYhb911KeRVaPrsrIj+xRKb4arhpUACI7pr5NVkRDbiJNRlhI9ylhD6pyOUPo4C6457ntdv2FqGXPfLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499053; c=relaxed/simple;
	bh=rylK+gMM8MfvR3m1KHlrjltWUINYuP/XimSpREiB/CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjSMxpYb+Uykw9DceIWay9H12EJ74XRzLBFGfMJFlFj17nfgVbaZW4Taw7vGC7g7IGFUw5TVO9JVxkwV8rCif+Sv/lHQ2FYUMyL0DbiWtEtBDgF2YIizLMwjFiCcKVcQudXcp/ZaQDv/VxHER4XiPhu0tXvkVMfZIDlJF91CggY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h74BSpWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h74BSpWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C22AC116D0;
	Thu, 15 Jan 2026 17:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499052;
	bh=rylK+gMM8MfvR3m1KHlrjltWUINYuP/XimSpREiB/CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h74BSpWEoLnrFElmhujTyiBT13JG/TrLmwuWNcEKOJClSvN3/UxrtGGnnAzLcY3Z7
	 Szo7h24E1TelVx/u4tMoZZZ4cNqcD3uJclIjJnm2SwmGsykYYu3Aytw7DhA9aHjlpX
	 /JtV4iZqjyhFGFn1uS0xa8AheEBp6Pkm0/DhcINI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/451] ext4: correct the checking of quota files before moving extents
Date: Thu, 15 Jan 2026 17:44:19 +0100
Message-ID: <20260115164232.996825923@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit a2e5a3cea4b18f6e2575acc444a5e8cce1fc8260 ]

The move extent operation should return -EOPNOTSUPP if any of the inodes
is a quota inode, rather than requiring both to be quota inodes.

Fixes: 02749a4c2082 ("ext4: add ext4_is_quota_file()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251013015128.499308-2-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/move_extent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 4cb1872c9af43..b1ad339165e41 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -473,7 +473,7 @@ mext_check_arguments(struct inode *orig_inode,
 		return -ETXTBSY;
 	}
 
-	if (ext4_is_quota_file(orig_inode) && ext4_is_quota_file(donor_inode)) {
+	if (ext4_is_quota_file(orig_inode) || ext4_is_quota_file(donor_inode)) {
 		ext4_debug("ext4 move extent: The argument files should not be quota files [ino:orig %lu, donor %lu]\n",
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EOPNOTSUPP;
-- 
2.51.0



