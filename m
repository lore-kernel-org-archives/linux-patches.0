Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A1E2222CB;
	Mon, 29 Dec 2025 16:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025390; cv=none; b=pQLW5/JYKm9x8xvlRmv/eVAM75rvGb7y/N3NIrtFlYCmkaB7y6CYjrKzFhgMCZP+OM4605DluOHmwDWujzUG6JBBcKww5KIDnWP8cqnWDRQF+j3gSn7P0j4w8ihXsjW+hZRu/bofHYfddK/u14ioIqZA69BJsb77QsfZfuRTKYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025390; c=relaxed/simple;
	bh=hY0dXYB3DsF+bZGDs9jzT9BTueNbjeBv304omIn6T2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ee4p6Eakg3Jg77VgKZKpASYavkky33kWvdYU/IgFZKCcpJq5i4Tw9Ht4nL0jSDkxcFhAf2ERE2Mr323pS4zgQJTV9HNbPHf3y2ep5Et+Ph+4e3jePPVaevwkM3Bym2XN+IVTdKvyhOp0pE2L8WlWPS3X/AyzU+SwDKtMdL51/Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qU1mjzli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qU1mjzli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F6FC4CEF7;
	Mon, 29 Dec 2025 16:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025389;
	bh=hY0dXYB3DsF+bZGDs9jzT9BTueNbjeBv304omIn6T2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qU1mjzliOxfFQOQ8rpwNMaaqyoMZ8rVGJt1YAemTSEEUFepzy6XcsKzI46ebcfduq
	 4nge6Efl1TWY0Ymi76985BVpGUGA4iCp7bCwGxw33+O8Zs57itHo39tn2/tuoiSyMj
	 Cwe1m4Fhjeew4M29rM1WcGpInOQ2vPujxPq4zlIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 195/430] exfat: zero out post-EOF page cache on file extension
Date: Mon, 29 Dec 2025 17:09:57 +0100
Message-ID: <20251229160731.530428700@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 4e163c39dd4e70fcdce948b8774d96e0482b4a11 ]

xfstests generic/363 was failing due to unzeroed post-EOF page
cache that allowed mmap writes beyond EOF to become visible
after file extension.

For example, in following xfs_io sequence, 0x22 should not be
written to the file but would become visible after the extension:

  xfs_io -f -t -c "pwrite -S 0x11 0 8" \
    -c "mmap 0 4096" \
    -c "mwrite -S 0x22 32 32" \
    -c "munmap" \
    -c "pwrite -S 0x33 512 32" \
    $testfile

This violates the expected behavior where writes beyond EOF via
mmap should not persist after the file is extended. Instead, the
extended region should contain zeros.

Fix this by using truncate_pagecache() to truncate the page cache
after the current EOF when extending the file.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index adc37b4d7fc2..536c8078f0c1 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -25,6 +25,8 @@ static int exfat_cont_expand(struct inode *inode, loff_t size)
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 	struct exfat_chain clu;
 
+	truncate_pagecache(inode, i_size_read(inode));
+
 	ret = inode_newsize_ok(inode, size);
 	if (ret)
 		return ret;
@@ -639,6 +641,9 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 
 	inode_lock(inode);
 
+	if (pos > i_size_read(inode))
+		truncate_pagecache(inode, i_size_read(inode));
+
 	valid_size = ei->valid_size;
 
 	ret = generic_write_checks(iocb, iter);
-- 
2.51.0



