Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D2A47FAF0;
	Thu, 20 Aug 2026 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247008; cv=none; b=QyfoV+0Nri8ZHgN4bUWN4TvVIei+w+qJSrs3TlYuaSFIIs5hVfbDYLnJCXCRx91sUNcUv8ohtaCnbNTHSm/IQRbH6Zhsc2kupHLDQ9pskaTtxi5FCZbRV8FGzIZrh5Jcz8pfTLJfi+mn5Ji1Jn/oApT0bQ1wHFA6ka+CrdijKmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247008; c=relaxed/simple;
	bh=3pYWYBoY/0mwx1kXw8Cp6ZRFyymyVkafWq59KbiZqBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbvGEMd/TemWmQbyxIc+xeIweJS2BzoFztpVXVT/SO4x3W8ojgG0i/2oMzqdC2vCRuzFZ082LFnRSq3CLf9eaAz60b5HGhIGbEtO245uH362vQZjoINqivXFh0kJ3GRh6AwJm7uK5yfBuvX5XcfPC/SjoqgSmy8CQ0glG9x9VKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNXAPGzY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNXAPGzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7201F000E9;
	Thu, 20 Aug 2026 17:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247007;
	bh=5gN7HEtPv5+XM/iPHwq3yv40PuhwOoeu/NRb4McbCyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNXAPGzYuVwZDA7U1qSXyDI6h+7UY1a8oHLMaaukg7xmT5JraRhFPudN1g1sr/XkQ
	 M+/IO5G+SUb6bZF50m3UCYZLRMdzCZVSG4PDnHwHcwVZ1sdz/G5dvKq0wLnKw0wOfR
	 DdkzaEeVCyNukyKZplVAQklTimA4foLuRWKgapSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 100/220] xfs: fix ilock leak on error in xfs_dq_get_next_id
Date: Thu, 20 Aug 2026 16:54:50 +0200
Message-ID: <20260820145226.486310509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -773,7 +773,7 @@ xfs_dq_get_next_id(
 	lock_flags = xfs_ilock_data_map_shared(quotip);
 	error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
 	if (error)
-		return error;
+		goto out_unlock;
 
 	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &cur, &got)) {
 		/* contiguous chunk, bump startoff for the id calculation */
@@ -784,6 +784,7 @@ xfs_dq_get_next_id(
 		error = -ENOENT;
 	}
 
+out_unlock:
 	xfs_iunlock(quotip, lock_flags);
 
 	return error;


