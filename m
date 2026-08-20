Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56EA2931C0;
	Thu, 20 Aug 2026 17:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247933; cv=none; b=QqHgpEeW+7MbccTL2zbXWt+y6n4ysSt2OJfpCERqPCHKp6r6keq7RCUirlcy5CvCSjQoG7d65tSgc+8b4452EYNQTR+QGvkfDmcHsc2dYneGNoY5Nuc/MS/dJz7ZsmuTZFGeu89DOST7/B6K3JS3ooHaz6ZlCzMC4fk1UuGQ9Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247933; c=relaxed/simple;
	bh=2aYWmn9dSZ2mITFb9pJSwCCCJ4tlVvEeG0sBdI3BJ68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJaRFDVJhkNPYwxWSyDaADFz3+b5hrgRDgtaya89QdsDQRKXoc2N944dM77864EwjNmf9t7HgeiDs87Kfmz0nJCmYMgyXc3y8rAay7AVY6AtaRQeCjHgAs7RiQ5eYDBFddzkUkSFElIpzRI/f12vBs5YzBozYuPcGxcaUxyZCm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwKGgaZG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwKGgaZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C66B1F00A3A;
	Thu, 20 Aug 2026 17:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247931;
	bh=mZJpzONznPGwp/ONYrFNWMIJAAWtHWQ0oDSoCWOVeUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fwKGgaZGhUyFpC5QqnTPOj1S3SGv4dio2W4m09qltesweGqjnTl67YjZo8GQPq0a+
	 ZbS6OwKVZxGPXjsItX++TAsiqF6EnjoDWZzdbiievZ6O+I+QZnRVmrEO3l1FwMg8Ey
	 ZQV8iWrrhL0lAtLLu7FrgHePaWhOku42Gedf4Q9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 051/303] xfs: fix ilock leak on error in xfs_dq_get_next_id
Date: Thu, 20 Aug 2026 16:53:07 +0200
Message-ID: <20260820145254.707409103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

commit 63320a0f70f66f311f4bccff3af0719c2119f46c upstream.

xfs_dq_get_next_id() takes the quota inode ILOCK before calling
xfs_iread_extents().  If xfs_iread_extents() fails, the function returns
immediately without releasing the lock, leaking the quota inode ILOCK.
This can leave the quota inode locked and cause subsequent quota
operations to hang.

Fix this by jumping to a common unlock path on error instead of returning
directly.

Fixes: bda250dbaf39f ("xfs: rewrite xfs_dq_get_next_id using xfs_iext_lookup_extent")
Cc: stable@vger.kernel.org # v4.12
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -723,7 +723,7 @@ xfs_dq_get_next_id(
 	lock_flags = xfs_ilock_data_map_shared(quotip);
 	error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
 	if (error)
-		return error;
+		goto out_unlock;
 
 	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &cur, &got)) {
 		/* contiguous chunk, bump startoff for the id calculation */
@@ -734,6 +734,7 @@ xfs_dq_get_next_id(
 		error = -ENOENT;
 	}
 
+out_unlock:
 	xfs_iunlock(quotip, lock_flags);
 
 	return error;


