Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671C13126BF;
	Tue,  2 Sep 2025 13:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820368; cv=none; b=V4pkfGbWIpStdUO0I/NpU0Kx4JSrEj9vek4EydG0QLNdR267xK0kJxEyoIshKwzSF/rsszc0zSNG373u3WTHMrD5BaE6wR/vx/zr+ayIDQafd2tP7KvJmId4l6Z3O9SDDPpVHiB6cGyb68DzZfTDgu0bVMGYgZyG/Q6nmgZ33dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820368; c=relaxed/simple;
	bh=Tt8pZad1giJ88BvOwpdhlfOn/Hjocl84Re0NQXT21Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxMvjsJD3o90iwVHoTz7T6CLusW5m71KMt7aUSb8gw9Zq9GT67DR9gSlP9AgNd41u9NqhtRI4vzpFWoYrJmf7GjTV2XYGXFa/GgUWK/BxES4ccWBzDaoOXsvGfP9jqiDiSea9B+vtKU1FWVCVCKLIX+Ros/xE1oPfv+smWB3Ec8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqYQnJVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqYQnJVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28C5C4CEED;
	Tue,  2 Sep 2025 13:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820368;
	bh=Tt8pZad1giJ88BvOwpdhlfOn/Hjocl84Re0NQXT21Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqYQnJVn4zq3eP2Rf1kOADzqYZHXyw1aT9s3SgyxhRnwRSo0FtmmWjmSnBzssJhHE
	 QJJO3xtFv5QiXzR+B1TniqLcoo1H7MpntlNLq7syPPWEk5LS/al0zbKq6VbmpDX3hN
	 w2j70/8yYXHKs68MFp1YPHCneUCRKvzkwZjPuagE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 75/75] xfs: do not propagate ENODATA disk errors into xattr code
Date: Tue,  2 Sep 2025 15:21:27 +0200
Message-ID: <20250902131938.046550266@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Sandeen <sandeen@redhat.com>

commit ae668cd567a6a7622bc813ee0bb61c42bed61ba7 upstream.

ENODATA (aka ENOATTR) has a very specific meaning in the xfs xattr code;
namely, that the requested attribute name could not be found.

However, a medium error from disk may also return ENODATA. At best,
this medium error may escape to userspace as "attribute not found"
when in fact it's an IO (disk) error.

At worst, we may oops in xfs_attr_leaf_get() when we do:

	error = xfs_attr_leaf_hasname(args, &bp);
	if (error == -ENOATTR)  {
		xfs_trans_brelse(args->trans, bp);
		return error;
	}

because an ENODATA/ENOATTR error from disk leaves us with a null bp,
and the xfs_trans_brelse will then null-deref it.

As discussed on the list, we really need to modify the lower level
IO functions to trap all disk errors and ensure that we don't let
unique errors like this leak up into higher xfs functions - many
like this should be remapped to EIO.

However, this patch directly addresses a reported bug in the xattr
code, and should be safe to backport to stable kernels. A larger-scope
patch to handle more unique errors at lower levels can follow later.

(Note, prior to 07120f1abdff we did not oops, but we did return the
wrong error code to userspace.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Cc: stable@vger.kernel.org # v5.9+
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ Adjust context: removed metadata health tracking calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_remote.c |    7 +++++++
 fs/xfs/libxfs/xfs_da_btree.c    |    6 ++++++
 2 files changed, 13 insertions(+)

--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -418,6 +418,13 @@ xfs_attr_rmtval_get(
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
 					0, &bp, &xfs_attr3_rmt_buf_ops);
+			/*
+			 * ENODATA from disk implies a disk medium failure;
+			 * ENODATA for xattrs means attribute not found, so
+			 * disambiguate that here.
+			 */
+			if (error == -ENODATA)
+				error = -EIO;
 			if (error)
 				return error;
 
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2649,6 +2649,12 @@ xfs_da_read_buf(
 
 	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
 			&bp, ops);
+	/*
+	 * ENODATA from disk implies a disk medium failure; ENODATA for
+	 * xattrs means attribute not found, so disambiguate that here.
+	 */
+	if (error == -ENODATA && whichfork == XFS_ATTR_FORK)
+		error = -EIO;
 	if (error)
 		goto out_free;
 


