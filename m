Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E66E2EBDCC;
	Tue, 17 Jun 2025 15:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174949; cv=none; b=ob+kR6igo5GKqCxecZdwtdxcoXbzmMYK/jtkM/kCtyYHW2Ug8p/R/mJ12Vsiq0yDL+m2TP0sbfmZuOPaJUrH/2eYb0WPssag+R0dyt7Q3PKuu3pVWlr6F3jeA7dMpkKgxnf1VMYq/edtXYjAFDEhVTdSOLE6KveOlyCboOGvd5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174949; c=relaxed/simple;
	bh=sc/jooSsAzRfEwPqtmkWFh2DGpujk+KeX0d3CREoi2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFImU8sTSKoxR595vc+w5s1bIBxWt5HwDc1oV03AykPCqPx4e6++tsH7L0WoXHwcu9E7SKqgSigG9vVGA2HxZu6EZ6TNdv6yHvREG8RK8SvW0hCgXQgCzUTYqGDq31c2w7wH62gWik52gopu+4XdL/ootObqIcGPIQx78OuOFpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IF47YpOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IF47YpOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00462C4CEF0;
	Tue, 17 Jun 2025 15:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174949;
	bh=sc/jooSsAzRfEwPqtmkWFh2DGpujk+KeX0d3CREoi2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IF47YpOIl9rehrkfzM+hqAIFgXia3DCwPbluWZgp4J57t80h7I1gAFz2cS6RsnLCM
	 EJIEPt7iSWyX59Oi1hZF0ufy6AOLzJJIg5Un0bwmtRIZ1qcIbrCS4zIwuSMUyIG17F
	 AKgkx2vzonCzNyrn4seRgLEFh7orJ0sbjwrakfuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e36cc3297bd3afd25e19@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/512] fs/ntfs3: Add missing direct_IO in ntfs_aops_cmpr
Date: Tue, 17 Jun 2025 17:20:45 +0200
Message-ID: <20250617152422.783283484@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 8b26c8c376b29cf29710fbfd093df194cefe26ad ]

The ntfs3 can use the page cache directly, so its address_space_operations
need direct_IO. Exit ntfs_direct_IO() if it is a compressed file.

Fixes: b432163ebd15 ("fs/ntfs3: Update inode->i_mapping->a_ops on compression state")
Reported-by: syzbot+e36cc3297bd3afd25e19@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e36cc3297bd3afd25e19
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index a1e11228dafd0..5c05cccd2d40b 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -805,6 +805,10 @@ static ssize_t ntfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		ret = 0;
 		goto out;
 	}
+	if (is_compressed(ni)) {
+		ret = 0;
+		goto out;
+	}
 
 	ret = blockdev_direct_IO(iocb, inode, iter,
 				 wr ? ntfs_get_block_direct_IO_W :
@@ -2108,5 +2112,6 @@ const struct address_space_operations ntfs_aops_cmpr = {
 	.read_folio	= ntfs_read_folio,
 	.readahead	= ntfs_readahead,
 	.dirty_folio	= block_dirty_folio,
+	.direct_IO	= ntfs_direct_IO,
 };
 // clang-format on
-- 
2.39.5



