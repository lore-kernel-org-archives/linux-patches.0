Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FBC61FFE;
	Tue, 12 Aug 2025 18:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023265; cv=none; b=k5VUtEhF7kRqYN0kR+oLdjQ3wY01cj6DJz60n2RU7Brmr0cKK3VbxQsgVkxtWFN4GvPMGeZsCzaooZQfmthkOXdIK65V4UYjSXCOflT58GwxkbyHerMgBnGaHYt4lGdZTlE0AQa1Khny0qAsttNWCG1mCY24xWaIDAgSJ4cLYAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023265; c=relaxed/simple;
	bh=ibODbyfYmAdF3JPPqYsDiTDfGMBhqekmYyXN77ybYVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jD1/0707vQCz4IdaOneQKseZ3VTvTQuLi5ZAXOBtNqo7DoJScFA1LWXGeFeQigzLYY7A7EMU6+np1NEKulNkotPV4FtH57pygHceFR/7q94bAxSAebyhbJLNdGNe1FuRKlhKP9E3WmewQK5Gj40l1IbdvHE3NB37XqaxKJab/u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVkbXIzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVkbXIzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84B3C4CEF1;
	Tue, 12 Aug 2025 18:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023265;
	bh=ibODbyfYmAdF3JPPqYsDiTDfGMBhqekmYyXN77ybYVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVkbXIzuaaFhrDVyBQuueaRDPgvAPDNbq7miI4viJ+4k47/WvXjkXviPsedgq1pWX
	 rnB5bC9cCvut/SN+9yPEIZYtkdArVCJ19DCLTmljEIRHucrjXBXmSA3MMMayVXvEPr
	 gm5zdutfJ6nyU63DwblzfjuMxx4NM70kAA+NsBAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 009/627] hfsplus: make splice write available again
Date: Tue, 12 Aug 2025 19:25:04 +0200
Message-ID: <20250812173419.678497041@linuxfoundation.org>
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

[ Upstream commit 2eafb669da0bf71fac0838bff13594970674e2b4 ]

Since 5.10, splice() or sendfile() return EINVAL. This was
caused by commit 36e2c7421f02 ("fs: don't allow splice read/write
without explicit ops").

This patch initializes the splice_write field in file_operations, like
most file systems do, to restore the functionality.

Fixes: 36e2c7421f02 ("fs: don't allow splice read/write without explicit ops")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250529140033.2296791-1-frank.li@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index f331e9574217..c85b5802ec0f 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -368,6 +368,7 @@ static const struct file_operations hfsplus_file_operations = {
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= filemap_splice_read,
+	.splice_write	= iter_file_splice_write,
 	.fsync		= hfsplus_file_fsync,
 	.open		= hfsplus_file_open,
 	.release	= hfsplus_file_release,
-- 
2.39.5



