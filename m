Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6FD33D6C1;
	Tue, 16 Dec 2025 11:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883921; cv=none; b=r0E+6cUPURFlqgj66c2R6e9aSSWQrTliaGYr2H2+FjObirAmN5AXW5pKqsKIUDqwwZ4d4lJ4R/qR1vzO4fAS8ESUCwd31pCzDEDh5+PjZum0HEPxUJ0l2w1dUzowYmEVrdeab4Egnb+x1hoPp+D6oa8JlRdYTPwTLMInvFAyUQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883921; c=relaxed/simple;
	bh=rTjK5KNx2UjnKJRqDFdgyqgbEOJtJncr0oZjwPyZgME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YD8d0ZbbRIw/m87R/jq1b0Vp7EXwsKU0VWAzkr6QSZRR/woItE6pKv4C4OQfZ9EeDbQCh3hw0E6zPnN7dyuBzrQsrkca7e2/RidVJiDUAggdov/LUuXOrH1wG5p2hyyQy9c+58AizRylorlLW7CkyfrKdWIM4jEwntMvMdv6M94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OximJOHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OximJOHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C016C4CEF1;
	Tue, 16 Dec 2025 11:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883921;
	bh=rTjK5KNx2UjnKJRqDFdgyqgbEOJtJncr0oZjwPyZgME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OximJOHC8zGZiZJe8D1Obzp5t+VXkZY91faVrK5UBl6poNMlW3QpEBm5IFDUGG5g/
	 E+8eGABryZIeWobKzyknsec1He3bcR+1JR09WhOzhqLRaCA9WwPBArqA/M8FxKi5De
	 jHw/LJvwlcWKNYmGG3Um7IcBrynTg3wHxI1yCugw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com,
	Sidharth Seela <sidharthseela@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/354] ntfs3: Fix uninit buffer allocated by __getname()
Date: Tue, 16 Dec 2025 12:10:06 +0100
Message-ID: <20251216111322.331078240@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Sidharth Seela <sidharthseela@gmail.com>

[ Upstream commit 9948dcb2f7b5a1bf8e8710eafaf6016e00be3ad6 ]

Fix uninit errors caused after buffer allocation given to 'de'; by
initializing the buffer with zeroes. The fix was found by using KMSAN.

Reported-by: syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com
Fixes: 78ab59fee07f2 ("fs/ntfs3: Rework file operations")
Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 4e2629d020b75..44fbd9156a30f 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1736,6 +1736,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 	de = __getname();
 	if (!de)
 		return -ENOMEM;
+	memset(de, 0, PATH_MAX);
 
 	/* Mark rw ntfs as dirty. It will be cleared at umount. */
 	ntfs_set_state(sbi, NTFS_DIRTY_DIRTY);
-- 
2.51.0



