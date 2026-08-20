Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D625F37E2ED;
	Thu, 20 Aug 2026 15:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238420; cv=none; b=ZObuEdizPpkyd8ao7rLi3yybXNahnDmfyfyE28qNY/seE/h04ikBKVfCYBG8X4znuQVH2u6OSqOFvOyQOccFLSv473fFjQ3Nf+RdQDaF1cgRJRtchviJ65bLE57m+l4fERxGw+pPxcuH5yi9UHbWbm45jZKF/gI6klXIN3NmwGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238420; c=relaxed/simple;
	bh=1H/2s8dnk5DBwd9MO3LN2+cY/ERNdUZ/cXSbnRIepCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ivjqu6qto0b9hKYKbVNvYfSdJvaDHcexKt5mzocWbuQukmM1UskF5SVN6SQag6cLIDnO9KYGk0bO9KMzubslmpHPcztWFcbuyZ7i/Q6qaz/4Pd3iGU9Ey/pspTHjmnYiTMYA8L3TD31XrBaipt0A4oeWfgVm0iyiUyn3K6aEis8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pmj22QO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pmj22QO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE201F000E9;
	Thu, 20 Aug 2026 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238418;
	bh=W9AwW1OAFpl6xa1WrMvGlxhJYJcvpUFFQORLn5XZ1FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pmj22QO50RCuu1H7Qvjqbwk6f6mjMsInbLEbgFhiHXH1BcewvFHJJnLrMY0ciKcHS
	 MK29TzITaxK7Eth8Bb0LmJJFrmcxIanV32Ghc2W12spsFPwDK1/B7Wuvzjr3GUmKYG
	 6DRsxycHIVrfxQ4n7DPMLT70OpfF07EiKn6HbKeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 139/228] xfs: fix ilock leak on error in xfs_dq_get_next_id
Date: Thu, 20 Aug 2026 16:54:41 +0200
Message-ID: <20260820145248.828636174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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
@@ -778,7 +778,7 @@ xfs_dq_get_next_id(
 	lock_flags = xfs_ilock_data_map_shared(quotip);
 	error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
 	if (error)
-		return error;
+		goto out_unlock;
 
 	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &cur, &got)) {
 		/* contiguous chunk, bump startoff for the id calculation */
@@ -789,6 +789,7 @@ xfs_dq_get_next_id(
 		error = -ENOENT;
 	}
 
+out_unlock:
 	xfs_iunlock(quotip, lock_flags);
 
 	return error;


