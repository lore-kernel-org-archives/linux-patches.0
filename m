Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2799238A70B;
	Thu, 20 Aug 2026 16:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243290; cv=none; b=e7xTK8DcDohapSHKVNMkG+K0gCJtbfJwrbDYMrs2EACPyUQSGUSR8TrDBsX3HIeQZd+izeWuxFB1to3FzLSdmVBY3FZ/XsPmVIGQ9QXafC5HPAtsG3imMSgqXFd4+m1p228xSk0D78COuZX17EbnBBqrrwkVUinNJfljXZdEcI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243290; c=relaxed/simple;
	bh=V4r9NNTFhue1aegvfB7hk0riwHDylsEF7d2dyvoCDX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nw04zm02S68Q+V2wsYfxv1lR71tL99ajUjfjxP1N6J+iusRs+8QMPj6zFR8nuROyVV0zakNuAomiuwZAbf51IXUENApEw4XOpFmA0Gs3q/HNuJaN1aQCx5JtErVdLQMF8X4eti3rENOAcBlYy0jqbzWwMq+0bdJRBK1gKFv79II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S38SB7ul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S38SB7ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9BD1F000E9;
	Thu, 20 Aug 2026 16:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243289;
	bh=BYzQqidbVAgu54J/+tkc3sLLvyKdRmW3qfvIJ/i+GFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S38SB7ulGNQ4hnFd/dxP7mSOilfDWLGeJQKfjh2ZmDewqSQ1vZyYzyeh7ild7NDSa
	 z9YEM5pNAuac3U0B6Kt0POu9SEqFbDNJVbsuemAtPWpk1DQijR+y9FhvzCG73e5Lid
	 nmWSziMO2SkCXGrpMTCpSe74v0crF1ce9M3XgRfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 044/272] xfs: fix ilock leak on error in xfs_dq_get_next_id
Date: Thu, 20 Aug 2026 16:53:48 +0200
Message-ID: <20260820145232.545222218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -750,7 +750,7 @@ xfs_dq_get_next_id(
 	lock_flags = xfs_ilock_data_map_shared(quotip);
 	error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
 	if (error)
-		return error;
+		goto out_unlock;
 
 	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &cur, &got)) {
 		/* contiguous chunk, bump startoff for the id calculation */
@@ -761,6 +761,7 @@ xfs_dq_get_next_id(
 		error = -ENOENT;
 	}
 
+out_unlock:
 	xfs_iunlock(quotip, lock_flags);
 
 	return error;


