Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBDB45518E;
	Thu, 20 Aug 2026 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247497; cv=none; b=qD19HdvtRFwKPuxumci5umF6DIGKV9kFy21QHyJccsCzP1fTGfOs8QN2SSLWr5hC4in4D3doZKXrEPuqyITeA6MLgBK5inQ5FbeTE9oyKN+oJLu+tsFv2y1gCO21x8tp/gj3aHBtH+huICTva6hbZUeCvsZRbImEqooQMeMTKY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247497; c=relaxed/simple;
	bh=YOiBaCqdVieWg+7fQOYXavAdDFhhaB7e/30RfYCtz4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlDOBBtlgoPa/9fYuabtiqH6wGTgnFuTD+H9vMWhluXUV7aPyAjCgHSg4w6sDwADyZurtrOow5T7wJ5GGKtYkkn4c0dtjGuvHJt17XsrfS8ud2TYv8Xr/0x9kn3HeIOE9Tbr58QIxumLAlakMHJWB4OdHKBfva9xbx3uj93tPbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7+ZwtL2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7+ZwtL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25301F00A3A;
	Thu, 20 Aug 2026 17:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247496;
	bh=EbaEerV/kGx59kBXIuWY081cELMEzSU6L46F79VIeA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r7+ZwtL2jQAuHl22w+U7P5biWR1Kvu4GINdINpa0q2cVNZptzB0fH2X3gy7oqJXbm
	 qoBNqwNEPT69oVF+JmLEHRojwvW9/E4mond963TBYDMV2xoJIDjbfXd3CU4hzKF/F7
	 GhVkOs4wYYu7NZ/HkTj0JSxtEJ1epqO24bO6ZD04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 065/166] xfs: fix ilock leak on error in xfs_dq_get_next_id
Date: Thu, 20 Aug 2026 16:55:24 +0200
Message-ID: <20260820145213.101200895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


