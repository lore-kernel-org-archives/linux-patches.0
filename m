Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDC430CD95;
	Tue,  2 Sep 2025 13:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819735; cv=none; b=DhwJKw1gvPD+9N+pAblOTjd7aliBHZPAuoP9IUuACT4TTFYHgidCksEbNLgqDCTnboXzwVWRcu/+Wd6LeprRZe7MWkkEVLsjSknl4YRU3Na+ZrWNq3Vj3ag72D3xeR96jP7LIp4zKYdVUCzqR5q28EQ5XCZ/ZOjs9oggHsvLnMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819735; c=relaxed/simple;
	bh=HlwDrQNsjVvtH/f5yls/qI3crVXvWO+miDLkBEu230Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTdd7AvCcTLh9DZoVmhd7YOtW8ijN8udKKWpM7rNA0KUsVMICwcFZAs+mYmFiIYzRET3CYcgCyFaEjAtnDvQ8nlY013IK9OKG8kwn96wrG0h21kJRL1bDbgBl1zomOlvZcpYBnbKcpV0+njUCRfR23C3+BfZ628DwUgYMeEzDuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGtu/oBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGtu/oBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC41C4CEED;
	Tue,  2 Sep 2025 13:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819735;
	bh=HlwDrQNsjVvtH/f5yls/qI3crVXvWO+miDLkBEu230Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGtu/oBnn9aZtJUvdOBllEtm9xRr0tKFNMMUWMuijAJ2R5zGSrsEhk2LiyfgHjT6y
	 wN858+DJ7vHav2v+R1pApvkRrz8Vo3Ff/He7scZLcgQRaU/V0KEaIhBurF4uT/y/Fs
	 C0G6/PFx+VccOakwJFnE76DAVDt7wF5lEtQqfMM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.16 123/142] xfs: do not propagate ENODATA disk errors into xattr code
Date: Tue,  2 Sep 2025 15:20:25 +0200
Message-ID: <20250902131952.994946746@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_remote.c |    7 +++++++
 fs/xfs/libxfs/xfs_da_btree.c    |    6 ++++++
 2 files changed, 13 insertions(+)

--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -435,6 +435,13 @@ xfs_attr_rmtval_get(
 					0, &bp, &xfs_attr3_rmt_buf_ops);
 			if (xfs_metadata_is_sick(error))
 				xfs_dirattr_mark_sick(args->dp, XFS_ATTR_FORK);
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
@@ -2833,6 +2833,12 @@ xfs_da_read_buf(
 			&bp, ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_dirattr_mark_sick(dp, whichfork);
+	/*
+	 * ENODATA from disk implies a disk medium failure; ENODATA for
+	 * xattrs means attribute not found, so disambiguate that here.
+	 */
+	if (error == -ENODATA && whichfork == XFS_ATTR_FORK)
+		error = -EIO;
 	if (error)
 		goto out_free;
 


