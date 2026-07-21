Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2D73770B;
	Tue, 21 Jul 2026 15:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649069; cv=none; b=ehX7AYnPpK8Gz88NvINo5F1VBv/7C6PzolhNZzcUCDO4s5P4Xgp3a7LNa2J1egl1DQEbDSvBLTM5rFZSmGvLlhiOC5cSHzPEIZr+kBmzKahJ1WbqomfcoU25LeKpXyFvgr4kb1CnqIGxuz56mDa0Nu8WIBQB74P6XXcKTT01HaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649069; c=relaxed/simple;
	bh=NaKEGN+iGkWYuOr9rYEAfd+y3C8wsxJlfJHqct7B+vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USMESZQMRhakqeiA1+pArML776jRNJ+RFcHSDZpCjVqxX53p0HjMO+YHti+o/HfEJY/ihzvh4Aiam6AlC3nYY6uUMJu/uf3BO98fjGXDoVmbcAOwfJ11P7+jxkXNG0O6tA6Kx8gVE0qdqbrhAFvrLZ4b/Ei4AuocYdIUD2pKVzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vb47gylB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vb47gylB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18701F00A3A;
	Tue, 21 Jul 2026 15:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649068;
	bh=vI50fKsU+t1ZXTIY/iOInVmgBmLdRFtyhKLubss7Pjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vb47gylB2krgaZU4i8aTXCODCSy119TL+2GKNelIMtYBOdEdrRMOR5nIk+ywu0G3v
	 IadhE1m1s0ecp4ySEu4ICwWzYXnx7IpwPllCXE69IKeWhgp5jqFqsQB2W9F22IkOMq
	 +onJZ1iLQPXWUPBAayra9XlgPijGe0Nr+8lH8Gww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0437/2077] ext2: fix ignored return value of generic_write_sync()
Date: Tue, 21 Jul 2026 17:01:50 +0200
Message-ID: <20260721152603.064359329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit a4659be0bc7cb1856ffb15b67f903229ae8891ec ]

Fix ext2_dio_write_iter() to propagate the error returned by
generic_write_sync() instead of silently discarding it, which could
cause write(2) to return success to userspace on O_SYNC/O_DSYNC files
even when the sync failed.

The correct pattern, already used in ext2_dax_write_iter() in the same
file and in ext4, xfs, f2fs among others, is:
    if (ret > 0)
        ret = generic_write_sync(iocb, ret);

Found by Linux Verification Center (linuxtesting.org) with SVACE.

[JK: Reflect also filemap_write_and_wait() return value]

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Link: https://patch.msgid.link/20260530122311.136803-1-listdansp@mail.ru
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index d9b1eb34694a04..781d227aff1556 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -267,12 +267,15 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		endbyte = pos + status - 1;
 		ret2 = filemap_write_and_wait_range(inode->i_mapping, pos,
 						    endbyte);
-		if (!ret2)
+		if (!ret2) {
 			invalidate_mapping_pages(inode->i_mapping,
 						 pos >> PAGE_SHIFT,
 						 endbyte >> PAGE_SHIFT);
-		if (ret > 0)
-			generic_write_sync(iocb, ret);
+			if (ret > 0)
+				ret = generic_write_sync(iocb, ret);
+		} else {
+			ret = ret2;
+		}
 	}
 
 out_unlock:
-- 
2.53.0



