Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E792FD1AD;
	Tue, 12 Aug 2025 18:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023199; cv=none; b=rqMZ5A59CNEZ6JfpsoRkgsViXxEIfv4hVaed6794pjO/btJFutJI/cJHvyDEARGbbfxAcMlsgPBq4nzP27w21d6l5hbcFHHQ37+6Sfs9csEjWm0bYd+z9bjlQ0AvgKbOToVqpSiE8kf0WUa6ap9Men0geSYRW+E2w57swzxUyOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023199; c=relaxed/simple;
	bh=HsrS4tEl73UPdDBqpsmDALOsB0Vbuf7PHPQ+yldGcYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CD33/tziyAAGqIuS0p78X+iKpulwsT5mLNc+9aXsTWcdYG9RJkxH44dXHOYn58nbgcuox289RE8mLs1TOaSIBiVUj7GWFuniTwf5aM+wuFNYBDQce95G5yafn1+k0Bipld3Q4gYvy/HRsKY0ZBTBoaDCVEdc4HgwFcdE+I+x2Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U71YFZ3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U71YFZ3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27DEC4CEF0;
	Tue, 12 Aug 2025 18:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023199;
	bh=HsrS4tEl73UPdDBqpsmDALOsB0Vbuf7PHPQ+yldGcYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U71YFZ3hsNpg/Pj5PNfrT3cUHaNpjDIXcw4STyyZuXd6ju6/BxSZuYy+7jsm43dZJ
	 Cqs+X5dByiYoEqKpYAJlsnDhETr8yjqQMZrNgWrY/+PZ41RLl0d2iXuTaKShetX4cK
	 kkaAROwAyoRF1PoEfORTLPlVi8gLdzsWPXTD34IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 010/627] hfs: make splice write available again
Date: Tue, 12 Aug 2025 19:25:05 +0200
Message-ID: <20250812173419.716664121@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 4c831f30475a222046ded25560c3810117a6cff6 ]

Since 5.10, splice() or sendfile() return EINVAL. This was
caused by commit 36e2c7421f02 ("fs: don't allow splice read/write
without explicit ops").

This patch initializes the splice_write field in file_operations, like
most file systems do, to restore the functionality.

Fixes: 36e2c7421f02 ("fs: don't allow splice read/write without explicit ops")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250529140033.2296791-2-frank.li@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index a81ce7a740b9..451115360f73 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -692,6 +692,7 @@ static const struct file_operations hfs_file_operations = {
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= filemap_splice_read,
+	.splice_write	= iter_file_splice_write,
 	.fsync		= hfs_file_fsync,
 	.open		= hfs_file_open,
 	.release	= hfs_file_release,
-- 
2.39.5



