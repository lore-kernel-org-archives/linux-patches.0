Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90CC143880;
	Tue, 10 Sep 2024 10:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963521; cv=none; b=LOzr3tpjSI33Mgi5YLcVT0rDmdNaiR+j4UKl31/a5JUhq3UEz9Q/K2KJ8xsL7lnmhGXwdGpYqxju9tTKrqwYPO+lG7qKwpJCKgdhrfVXsgf1UE3U8NTAeGzaXlaaQZXhFGcOEyrDEgrOmebLihHwf5jTRLXpyl+ST1892dipqHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963521; c=relaxed/simple;
	bh=CGiLpLcjT9rO+n4IacF8u5iNQkCnEMKzgEDIBBx2D+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsYGTHOKs6Gp4DsiBZDTvl5pWzkTh6NaaX+Y0ZrTAxKpUFu3DRpr8jCnp2IJ5cbc3OfNA8oOAEUsuaFskLgGYWHcXNNs+IEZyacn0VKjwE/SGHK/RxuhHSDy/gvcSHGM7C4dBPhTBJk1fR34Pjh+arYshSFz58r5rYJ062l6bwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSpKSyYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSpKSyYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B764C4CEC6;
	Tue, 10 Sep 2024 10:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963520;
	bh=CGiLpLcjT9rO+n4IacF8u5iNQkCnEMKzgEDIBBx2D+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSpKSyYuAtge+0ffzMDO3W3//NNVncryj+ZWY/sWt2O/RwMFilSyTWCqYtROSK0Gh
	 P9hR58cByuHTPrmAAkyEZWkqK+GvQjk1DDuO1fvWlrOCXgaXUCOHrV+NVa9AXhbgOZ
	 RUKhCuuhqzeoPM1Vn8jt+Bo1ezby5QaAWZ2I1rCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 058/214] ext4: reject casefold inode flag without casefold feature
Date: Tue, 10 Sep 2024 11:31:20 +0200
Message-ID: <20240910092601.132881367@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Biggers <ebiggers@google.com>

commit 8216776ccff6fcd40e3fdaa109aa4150ebe760b3 upstream.

It is invalid for the casefold inode flag to be set without the casefold
superblock feature flag also being set.  e2fsck already considers this
case to be invalid and handles it by offering to clear the casefold flag
on the inode.  __ext4_iget() also already considered this to be invalid,
sort of, but it only got so far as logging an error message; it didn't
actually reject the inode.  Make it reject the inode so that other code
doesn't have to handle this case.  This matches what f2fs does.

Note: we could check 's_encoding != NULL' instead of
ext4_has_feature_casefold().  This would make the check robust against
the casefold feature being enabled by userspace writing to the page
cache of the mounted block device.  However, it's unsolvable in general
for filesystems to be robust against concurrent writes to the page cache
of the mounted block device.  Though this very particular scenario
involving the casefold feature is solvable, we should not pretend that
we can support this model, so let's just check the casefold feature.
tune2fs already forbids enabling casefold on a mounted filesystem.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20230814182903.37267-2-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4921,9 +4921,12 @@ struct inode *__ext4_iget(struct super_b
 				 "iget: bogus i_mode (%o)", inode->i_mode);
 		goto bad_inode;
 	}
-	if (IS_CASEFOLDED(inode) && !ext4_has_feature_casefold(inode->i_sb))
+	if (IS_CASEFOLDED(inode) && !ext4_has_feature_casefold(inode->i_sb)) {
 		ext4_error_inode(inode, function, line, 0,
 				 "casefold flag without casefold feature");
+		ret = -EFSCORRUPTED;
+		goto bad_inode;
+	}
 	if ((err_str = check_igot_inode(inode, flags)) != NULL) {
 		ext4_error_inode(inode, function, line, 0, err_str);
 		ret = -EFSCORRUPTED;


