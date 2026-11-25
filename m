Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618300;
	b=213Brgi7lKR3cbL21xF2FuBQeBrOXRQIBsgyskszXwMuOH1cPYXHI8hDst7nln9EaQA7
	 Zxj5nhN9RHdozUJw5mmUPdXIFgWMTz/UQdMmUuaprkaaZO3QHH/QOQtd9y1G0WtWsWhcD
	 0sQS49efFTt9AviTENU851HKnCIFHyDw4tA60a+MTZr2HJsLq+8nNxE94/vZZczTyanbi
	 svY7YvprMLKDbossVUjb4wzq6Eo5BQZPA1WVTXLue6WCA+X0pimvp/WlxJguPM9aEtt3O
	 mkHpbowFwek7qNPagYRabEzVS5FOeMCRAEahqisL3MjjYD9M3voARILVE/hkxPBi7TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p+npFRR6nvPMK1L0om/eDCX8/DAHQ6mZ2GTxev/Dc80=;
	b=WzUmjo6AZXdIeFYYijipFJnxhEU5z3QSqRqmlQukwxGlrfn0cMvoKgqy3zHF5lEj0HvT
	 UuXxieot5oPNWSgtAZ0c3mMBHbvb+Rz0vDTXD/CS/l2bDDeEN2YZRMLz+4SAbISmNIwoX
	 YMdey1v8BZ/nvAWLrtfBNse9FTa1kDVmwrg8m21cqM071DML5Ec7hpZQhi0djDTNZ6mJn
	 mOtlen+sByVHHZ+jcMb+7LZg2NR9hFwiaA+dEZUxhVATUmxFi6DT9eo9X3Gao5f2rqZpc
	 vwDGcG2Ah4mJy5zXudE648d8QtsR107sji/z73MObtN/Xr0Fg/mlQNLeW/Ark98vdiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XdDhfy+C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EAE606A323;
	Wed, 25 Nov 2026 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XdDhfy+C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4E51F000C4;
	Wed, 25 Nov 2026 14:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618299;
	bh=p+npFRR6nvPMK1L0om/eDCX8/DAHQ6mZ2GTxev/Dc80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XdDhfy+Cnku8WjArC+tjntz4+XS+A4SZJ9yqnGU7NqNuqmeWwbsDxNqbWzuqLVjLJ
	 94tWtb+0219ieXWvIMIkJyTPyY/zHEhGvGaasjjvba9X55Tgwqs1Vvm9Q3tMJMMw36
	 fS7s3747XP+HjQHdKp+rbzsL6xRlLbK996Xgs4RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0236/1005] ext2: only flush DIRSYNC directories on every change
Date: Wed, 25 Nov 2026 15:26:14 +0100
Message-ID: <20261125143827.268029019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 3f57fc2c49ed05ccfc56e4dc9eda41be95925bbd ]

Every change of an ext2 directory is written to disk before the system call
returns, whether the directory is DIRSYNC or not: its pages with
filemap_write_and_wait() and its inode with sync_inode_metadata().

Writes which reach the device for 2000 files, and 200 directories, in a
directory without DIRSYNC, with the flusher turned off:

            create   rename   unlink   mkdir
    before    4000     8000     4000     800
    after        0        0        0       0

In a directory with chattr +D the numbers are those of "before", before and
after.

commit bc943f4872a7 ("ext2: Don't flush page immediately for DIRSYNC
directories") moved the flush from ext2_commit_chunk() to the new
ext2_handle_dirsync().  The IS_DIRSYNC() check which was around it didn't
move along.

Fix by putting the check into ext2_handle_dirsync().

Fixes: bc943f4872a7 ("ext2: Don't flush page immediately for DIRSYNC directories")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261027-b4-ext2-dirsync-v1-1-3dcd012d518d@toxicpanda.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index e17bbc7598c14..5de32c221a83b 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -442,6 +442,9 @@ static int ext2_handle_dirsync(struct inode *dir)
 {
 	int err;
 
+	if (!IS_DIRSYNC(dir))
+		return 0;
+
 	err = filemap_write_and_wait(dir->i_mapping);
 	if (!err)
 		err = sync_inode_metadata(dir, 1);
-- 
2.53.0



