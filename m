Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775031;
	b=ynoehkhDYJG+Vbdht6sXx4W/hi4XyRsbn2Q5KwQ2AtwxGD9IBzDRpNzYD0yOe5xX+cj6
	 /M6vis3BQFp8PW492oeGbD7FxjdVo3EdQPXgaP4GUuBQecZeVrsEn4CujEnxC+rvEGQ+F
	 j1GBFHomRBMJc5iqynethakSM2Jvc2J9n1Bm+9ewY8DOGvR5zIi9YWD8l9ZOsqumHJ9rp
	 ABHL1zQQOfGlRvuz1+arOZA1C5tWMKAxOXRoPU093vFUSRASbZou0UMzbaZ8NcdNfubob
	 D/h6ET9b1fbIxvgw0Ak8QDJC66Dy9jp/zlx74dsa2AcWjjZWQC3rEAVr8DqQE7Phftg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5K07YdRI3QxQkuqC4wfMhF7NoJGEmB2AXA2x27GP5ec=;
	b=mnQxycc30MykQo6/7pklPDxOZ/I0m9U54vsu097vQMebkymNYVd2o6588v+bywjd65hq
	 Qyi5WzTViJtOjoBzFm2IIol1b0/qNgL9yjpfGow+2jZosX+LT2fgVp8nwdcX99mDEoJvI
	 fEbC9IykYmPlmVdy4aq5eQaqdrm9w4/M5viMsjOaAjJRsVbsc2C6NuNYL3mqlkIqA4p44
	 3OquU36ANG+SXWYf3JrmJnnB97EB8rsBVVndsZsK31RXY9VwcgdUIOkEl+cdXvAzX5oyk
	 QdT7QTsrPNS8ZI8KSzjsuolZRTjqL+WfKeJIbE3igvjTbkEWLezKEjZnoN7rJTi5+DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MR1Qc6gr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F40D606A31A;
	Fri, 23 Oct 2026 17:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MR1Qc6gr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE44A1F01825;
	Fri, 23 Oct 2026 17:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775031;
	bh=5K07YdRI3QxQkuqC4wfMhF7NoJGEmB2AXA2x27GP5ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MR1Qc6groWgUOR7o7/65MKovpTtP0A75dRuLy4mo4Sh3CclZsI8ALWs70oam7UJ3s
	 6yE7iqeosBBzuLLvbH6XUpkykqsNp9Lid+xCzszU7YgBC0ZQ4UNySurtnJCnRUV6Ka
	 kOz9TeXvFy1g+sdFa6fCNRe1kPmYpP0ASxBwGEd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 238/242] ntfs: take invalidate_lock in ntfs_setattr_size()
Date: Fri, 23 Oct 2026 18:41:20 +0200
Message-ID: <20261023163719.482689622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 9cc5761b8f28f9cef72061094eb5e37e2cd44d97 ]

ntfs_setattr_size() updates i_size and resizes the on-disk attribute
without holding mapping->invalidate_lock.  Page faults take the lock
shared, so a fault racing the resize can resolve a VCN against the
transient runlist state of ntfs_non_resident_attr_expand() and fail
with a spurious SIGBUS, and can interleave with the size-change
epilogue (truncate_pagecache(), i_size_write(),
pagecache_isize_extended()).

Take invalidate_lock exclusively around the whole resize after
inode_dio_wait(), matching the fallocate path and other filesystems
such as xfs, which wraps truncate in its mmaplock (= invalidate_lock).

Fixes: 9c87959601e8 ("ntfs: update file operations")
Cc: stable@vger.kernel.org
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/file.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -269,18 +269,25 @@ static int ntfs_setattr_size(struct inod
 		return err;
 
 	inode_dio_wait(vi);
+
+	/*
+	 * Serialize with page faults and pagecache instantiation so that
+	 * readers cannot observe the size change until the attribute
+	 * updates below have completed.
+	 */
+	filemap_invalidate_lock(vi->i_mapping);
 	if (attr->ia_size > old_size) {
 		truncate_pagecache(vi, old_size);
 		i_size_write(vi, attr->ia_size);
 		pagecache_isize_extended(vi, old_size, attr->ia_size);
-	} else
+	} else {
 		truncate_setsize(vi, attr->ia_size);
+	}
 
 	err = ntfs_truncate_vfs(vi, attr->ia_size, old_size);
-	if (err) {
+	if (err)
 		i_size_write(vi, old_size);
-		return err;
-	}
+	filemap_invalidate_unlock(vi->i_mapping);
 
 	return err;
 }


