Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41F125743D;
	Tue, 25 Mar 2025 12:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905653; cv=none; b=FW/WzgY+uHOM3/lABNZPNzUUtWM1cG6SHxeijwnx7bG9q9Yf5ditritKUgnTvsbxzPNKFePGZLyyTkROEobo5+w4KgKPURsGexLdqEE0JkgtbgFLRNv7cvrgH5LRdagM9RgHq18oKrNR2yCatnFg8U4FdU7MZCk92rdg0rWY6/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905653; c=relaxed/simple;
	bh=QeNFMx18qo/seDWqDVDQtLg5MlevDPyk9gHkjK3ZyJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHKJeWF/n5sLFQ3ouAXqWgIgbu57ufmjgVtwNhBQzDnWQNwsyUAwrax/9gxnjtzXB0UjYnvQyOcR2StnJAC9xJLT+eCel9ccyQ1/Bki8elG1xLqk+ZngGuijv1rVrI2W4Ghe3YqhwqlY7uioyrrTmb2gDLNooK11Tv7VCQDLMjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ozTYWg+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ozTYWg+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DD4C4CEED;
	Tue, 25 Mar 2025 12:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905652;
	bh=QeNFMx18qo/seDWqDVDQtLg5MlevDPyk9gHkjK3ZyJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozTYWg+Nu1KlplYaw1JmRyXIawCcLACVWTQeM+9JmW5TTdkCfj1WR/3uKcFjRDVMB
	 ycEOlA493B1+787RSYfSvCpKnyGaFULYvBdIXjbNi9UuoPI6MmYmdlBJH54/amFW7U
	 rhvoyQCFd34GB1HV/LaADcmrOCl5uJOhuoq6RgIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 090/198] xfs: dont leak recovered attri intent items
Date: Tue, 25 Mar 2025 08:20:52 -0400
Message-ID: <20250325122159.006839872@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 07bcbdf020c9fd3c14bec51c50225a2a02707b94 ]

If recovery finds an xattr log intent item calling for the removal of an
attribute and the file doesn't even have an attr fork, we know that the
removal is trivially complete.  However, we can't just exit the recovery
function without doing something about the recovered log intent item --
it's still on the AIL, and not logging an attrd item means it stays
there forever.

This has likely not been seen in practice because few people use LARP
and the runtime code won't log the attri for a no-attrfork removexattr
operation.  But let's fix this anyway.

Also we shouldn't really be testing the attr fork presence until we've
taken the ILOCK, though this doesn't matter much in recovery, which is
single threaded.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_attr_item.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -329,6 +329,13 @@ xfs_xattri_finish_update(
 		goto out;
 	}
 
+	/* If an attr removal is trivially complete, we're done. */
+	if (attr->xattri_op_flags == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    !xfs_inode_hasattr(args->dp)) {
+		error = 0;
+		goto out;
+	}
+
 	error = xfs_attr_set_iter(attr);
 	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
 		error = -EAGAIN;
@@ -608,8 +615,6 @@ xfs_attri_item_recover(
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
-		if (!xfs_inode_hasattr(args->dp))
-			goto out;
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
 	default:


