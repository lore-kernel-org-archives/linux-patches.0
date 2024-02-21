Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7472169D21;
	Wed, 21 Feb 2024 13:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522421; cv=none; b=f6asXjJLvqHRcSAQWNj7lzoxM+edqhe6Az69CVnDzuzZSQa5aN+sFzvJiNw+rElnW23VLUythzhk8CIHcVZ0ilEiUJittODNkgQP4y9kmFe5iqfXxn7QtvAb1v2fQXVlH2TnzPGR9vhkri4VgL5IvPCUIOTqMqBMCRS1/pPT7as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522421; c=relaxed/simple;
	bh=nQ5wuBZocZxytnQh++YdjBifz0ucFIE7Ha9PmtDXfCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+/j8TmgMm2Yw/3yu5cbBQm4It7WIfyPyKcMdoj9cwiMJc9007mu9GgZXvtcT/po4YbOkD1atB7zb6AV7SxKIHt9JLq2b50WkSdCLTtJjc5sFZelPiUB/iaz4MBHqq+fMvcB4ztjFj37R5JR11+2KzHUQoMdhUuybkrAOY9QtFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZ97iLFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZ97iLFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86066C433F1;
	Wed, 21 Feb 2024 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522421;
	bh=nQ5wuBZocZxytnQh++YdjBifz0ucFIE7Ha9PmtDXfCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZ97iLFmE+oC3QZp3/DSYGmNBAlMVFH7r/ALeHWwW7GkmkemBKKY8vYk2VLj5gkXO
	 0BaeG/pFLneUwcqRWo2SHVDM4xD/b07FsZbgHyUtLWwOMyNcALSmbtoLiwvy4NmsgP
	 ZIgQqkbT+ck5jiGlpoNdFLSs46A7UHgxyuItl4kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/476] ecryptfs: Reject casefold directory inodes
Date: Wed, 21 Feb 2024 14:03:31 +0100
Message-ID: <20240221130013.851006472@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit cd72c7ef5fed44272272a105b1da22810c91be69 ]

Even though it seems to be able to resolve some names of
case-insensitive directories, the lack of d_hash and d_compare means we
end up with a broken state in the d_cache.  Considering it was never a
goal to support these two together, and we are preparing to use
d_revalidate in case-insensitive filesystems, which would make the
combination even more broken, reject any attempt to get a casefolded
inode from ecryptfs.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ecryptfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 16d50dface59..bea4c2b0cd6b 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -76,6 +76,14 @@ static struct inode *__ecryptfs_get_inode(struct inode *lower_inode,
 
 	if (lower_inode->i_sb != ecryptfs_superblock_to_lower(sb))
 		return ERR_PTR(-EXDEV);
+
+	/* Reject dealing with casefold directories. */
+	if (IS_CASEFOLDED(lower_inode)) {
+		pr_err_ratelimited("%s: Can't handle casefolded directory.\n",
+				   __func__);
+		return ERR_PTR(-EREMOTE);
+	}
+
 	if (!igrab(lower_inode))
 		return ERR_PTR(-ESTALE);
 	inode = iget5_locked(sb, (unsigned long)lower_inode,
-- 
2.43.0



