Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C206248F57;
	Tue, 21 Jul 2026 15:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649227; cv=none; b=VDov3SCAaJ0CM/PyRY9v/V6ZPWHNSrs7dmTdAJi6yZ75TTp2igSCKuuLzir7r+4RNUm9mSBT9tlBrDRj0NU7ACj9a4Vqmtly7huHFndyytPYwa1PL+fJzoB6yDrL+7BF9fNQawAzsLfkc2shPmcttfknoBxM05NHC2JvppjdiaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649227; c=relaxed/simple;
	bh=RvKmDY6LMD631tT3wnPUleVJbe6Yhx0xkglyK6l7IHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsqTxsnfa5zPqVWH8LS7vMv6kgBC18gsRBNLBCo3K/E5uPgXbW6lancP2tD1vIo/CjMrcL53TdlzJ4Mk5aWDrotFDrdC1WTdtPcoshfZAJRgHAp7K03sRI2VAUQwTODOuXxWqfydo5H9M4iv2I5nLZR1t+365Sgll2VVd8HO0zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGECd54j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGECd54j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C061F000E9;
	Tue, 21 Jul 2026 15:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649226;
	bh=+rX8yd+3raOxC8QorQPKEo6cI7sS/PFLBg/mpgnzJ9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OGECd54jtariPxRPfBISwFZ2b/UQhsdWyeTxBahCtk08T+DnOjJzWVKlSBBSgrlZd
	 BT0WHGdgCiPCQRx2c6ku+c6sz9L6CyNKt38YHK3kmOeqpY2Oto7ocKs7qqyC9oklcA
	 CGElzQrwAD7yqIYYeRjZw5fdkAaCQ6dQ6gbipSXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0496/2077] ntfs: free link name from ntfs_name_cache
Date: Tue, 21 Jul 2026 17:02:49 +0200
Message-ID: <20260721152604.512374345@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit 8488c4d066e6a52937fa5d82ab131c7554ddc9d8 ]

ntfs_link() converts the new link name with ntfs_nlstoucs() using
NTFS_MAX_NAME_LEN. In this case ntfs_nlstoucs() allocates the result
from ntfs_name_cache, and its contract requires callers to release the
buffer with kmem_cache_free(ntfs_name_cache, ...).

All other ntfs_nlstoucs() callers in namei.c do that, but ntfs_link()
uses kfree(), which mismatches the allocator for successfully converted
names.

The conversion failure path reaches the common out label with uname ==
NULL. That was harmless for kfree(), but kmem_cache_free() does not
provide the same NULL contract. Return directly on conversion failure
and free successful conversions with ntfs_name_cache.

Fixes: af0db57d4293 ("ntfs: update inode operations")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/namei.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index c4f82846c58c30..9c1c36acfad24e 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -1532,8 +1532,7 @@ static int ntfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (uname_len < 0) {
 		if (uname_len != -ENAMETOOLONG)
 			ntfs_error(sb, "Failed to convert name to unicode.");
-		err = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	if (!(vol->vol_flags & VOLUME_IS_DIRTY))
@@ -1563,7 +1562,7 @@ static int ntfs_link(struct dentry *old_dentry, struct inode *dir,
 	mutex_unlock(&ni->mrec_lock);
 
 out:
-	kfree(uname);
+	kmem_cache_free(ntfs_name_cache, uname);
 	return err;
 }
 
-- 
2.53.0



