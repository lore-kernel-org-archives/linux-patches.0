Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51EB53A7;
	Fri,  6 Dec 2024 15:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497704; cv=none; b=mGXtjhO69mRv927Y2p70IHNyMecDkijF2gLbor0Yfp3ykCdalrnP6cPUIISqfAx/NbFNs4X5pJOo3M0rFnAEzuOMAWsHAR0ghXzNOOLYbR6od/J2hZKLvh/qnqs1Eg/IBcGjK0cJHKLRaI+nyNf9WcfKtB6ZwuiPO3NtILJQ5xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497704; c=relaxed/simple;
	bh=H+7B2OMYYSuqmFyVbNcQvhtDQYH0j9yW56YUyKChz5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPCM8o3fNe2BeSdMsLWtIgpZwodKe7UbxCUo4htr6OFOWAHOVX4JnbDS3hGsbsAEHdAB7JpukXlRmkJHjuhDkD1HlMK9jKwk7iOIudrqyXgmeQ/CxNEatU68tx38pbu3/DNidKAfk5hN5SLCBU30orNoctPzckQLM/ZS0aPGjwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2i/b2/X+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2i/b2/X+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5023C4CED1;
	Fri,  6 Dec 2024 15:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497704;
	bh=H+7B2OMYYSuqmFyVbNcQvhtDQYH0j9yW56YUyKChz5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2i/b2/X+/iBJVTz/LmZsWPK+yvubbYNcomoYmRyrCmz0kNGpN/9n6weeLHTr/YVBX
	 Wdl6tFsZ/dRAnP8JbCDF3zEBTYy21ENakapVd+0h02WGJSzFDBaEq3CEk7WF7665Pt
	 U+XPcoPX2NmgaLa9ZDvkeLZHoNXHyZhuApczT9Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinsu Lee <jinsu1.lee@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 368/676] f2fs: fix to avoid forcing direct write to use buffered IO on inline_data inode
Date: Fri,  6 Dec 2024 15:33:07 +0100
Message-ID: <20241206143707.721046403@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 26e6f59d0bbaac76fa3413462d780bd2b5f9f653 ]

Jinsu Lee reported a performance regression issue, after commit
5c8764f8679e ("f2fs: fix to force buffered IO on inline_data
inode"), we forced direct write to use buffered IO on inline_data
inode, it will cause performace regression due to memory copy
and data flush.

It's fine to not force direct write to use buffered IO, as it
can convert inline inode before committing direct write IO.

Fixes: 5c8764f8679e ("f2fs: fix to force buffered IO on inline_data inode")
Reported-by: Jinsu Lee <jinsu1.lee@samsung.com>
Closes: https://lore.kernel.org/linux-f2fs-devel/af03dd2c-e361-4f80-b2fd-39440766cf6e@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c6bc4cbd72b9d..196755a34833d 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -846,7 +846,11 @@ static bool f2fs_force_buffered_io(struct inode *inode, int rw)
 		return true;
 	if (f2fs_compressed_file(inode))
 		return true;
-	if (f2fs_has_inline_data(inode))
+	/*
+	 * only force direct read to use buffered IO, for direct write,
+	 * it expects inline data conversion before committing IO.
+	 */
+	if (f2fs_has_inline_data(inode) && rw == READ)
 		return true;
 
 	/* disallow direct IO if any of devices has unaligned blksize */
-- 
2.43.0



