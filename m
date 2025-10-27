Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A540A3074AC;
	Mon, 27 Oct 2025 19:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592213; cv=none; b=eHGt5TK3BmW7j3Vpaxxkj/j+seVizsrgGxmZXD9JnuV6Ear10DyEm+uh+l2oLcCLU4YVlejmIgJvXQaERAKi1sen3NhEBgZPbsA+os/yTiwa8fyv/dImtYzRbDQLyMxUv1+DvgcwNi7s67HdieSqYSJz45MPOTPb508EeGgG4o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592213; c=relaxed/simple;
	bh=lbN9aL8gxaY29vKNWffiKcUs2i2ReRdJHztsW71LZ48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRYLuZbeFRBdtCvSBCokfI9yb7QeOuKUQXe+eY+/ZTF0DjDM8WIC1R0DzHS16xu5G0Qw6jVWqA4sQEgpnnYmOpuPgQRn9/syN2N2gnh4jyrS/VEARmKWzNosE5dy2pU9kKRhvePWkBGHT8RuK7yapIQ3rp8m8Wko5XKciVzwpWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZXmUx+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZXmUx+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372DFC4CEF1;
	Mon, 27 Oct 2025 19:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592213;
	bh=lbN9aL8gxaY29vKNWffiKcUs2i2ReRdJHztsW71LZ48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZXmUx+H8tN1O6GcwgTdj04WJ7Guu4nLc4YYTcA9zdCG+BEvi5SpHo3zNG+VSOd69
	 nL357B6kIk/IgrYVSJPJiladpqDy5Xn3quXDgEVVcBEmcmSBm59WLPxNDFmO7KvI/X
	 zVAI9BmUe3Ghk6yChMK9IGK0Zza1hn0yD5MePfWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Friendy Su <friendy.su@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/157] dax: skip read lock assertion for read-only filesystems
Date: Mon, 27 Oct 2025 19:34:57 +0100
Message-ID: <20251027183502.265632642@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 154d1e7ad9e5ce4b2aaefd3862b3dba545ad978d ]

The commit 168316db3583("dax: assert that i_rwsem is held
exclusive for writes") added lock assertions to ensure proper
locking in DAX operations. However, these assertions trigger
false-positive lockdep warnings since read lock is unnecessary
on read-only filesystems(e.g., erofs).

This patch skips the read lock assertion for read-only filesystems,
eliminating the spurious warnings while maintaining the integrity
checks for writable filesystems.

Fixes: 168316db3583 ("dax: assert that i_rwsem is held exclusive for writes")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Friendy Su <friendy.su@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index ca7138bb1d545..2ebe70de35ec3 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1524,7 +1524,7 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_rw(iter) == WRITE) {
 		lockdep_assert_held_write(&iomi.inode->i_rwsem);
 		iomi.flags |= IOMAP_WRITE;
-	} else {
+	} else if (!sb_rdonly(iomi.inode->i_sb)) {
 		lockdep_assert_held(&iomi.inode->i_rwsem);
 	}
 
-- 
2.51.0



