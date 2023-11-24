Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B283418E;
	Fri, 24 Nov 2023 19:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDM3rMUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D17C433C7;
	Fri, 24 Nov 2023 19:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853320;
	bh=PDe5nBe/iyMNVsSzepLQ+zYJg+ACYWExn4L5/u4cncg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDM3rMULr40l2I9jQUUg8soDB9AIU+iyz9lYYhmTSwymc2f5pexdo4NnowoYkgGKQ
	 UPTyjNR1vEBJGAx+MKAt50QquvEeEPfXuk9H8Txj5NLfmLs53d7DdjBCzQJa94Kmw4
	 /+lzyvbkKlkBuCdJRATVehdzdhZ30E0xgwwUieGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixu Xia <kaixuxia@tencent.com>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/297] xfs: use invalidate_lock to check the state of mmap_lock
Date: Fri, 24 Nov 2023 17:53:04 +0000
Message-ID: <20231124172005.242033789@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Kaixu Xia <kaixuxia@tencent.com>

[ Upstream commit 82af88063961da9425924d9aec3fb67a4ebade3e ]

We should use invalidate_lock and XFS_MMAPLOCK_SHARED to check the state
of mmap_lock rw_semaphore in xfs_isilocked(), rather than i_rwsem and
XFS_IOLOCK_SHARED.

Fixes: 2433480a7e1d ("xfs: Convert to use invalidate_lock")
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b2ea853182141..df64b902842dd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -378,8 +378,8 @@ xfs_isilocked(
 	}
 
 	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
-		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
-				(lock_flags & XFS_IOLOCK_SHARED));
+		return __xfs_rwsem_islocked(&VFS_I(ip)->i_mapping->invalidate_lock,
+				(lock_flags & XFS_MMAPLOCK_SHARED));
 	}
 
 	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
-- 
2.42.0



