Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620804;
	b=Gd1JVNlzYiSZALzOfw/ojBNJ2vw5MvLgt4fHGAvHLLu+sTQZLS2uXykxTEdM582hN4WH
	 Vr3aAB5FtgdbEGY0czTEZARSnBV+IrbeN8HlxCgiloqmym7fZwq3/L5xfhuAmFNnsMxYa
	 SUVxmAuek3Scfd9FFmscNFln0fLUp74Lb7fsSD24RmsuUxGTopa8cw/3EAtFKlmlnpLAS
	 cx248weHVyVzxtIiV4XhqA0XI/Cp6N4VvvkMhgUSdr1tks+Z1D6R8lAt/pyF8H0MFNTDC
	 daRZc6Vox1erlt4yJjry3CHB5V/Th6tVfhl+kozRzhITTnlHYw1pgs7hX+noNLXjhBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T4EfI8/m4C9NAM8EvIs8mQmpYODE8xUySmtVm8Q1KUI=;
	b=rwqxAkId3MmKhC9xMgdHmcLt3VZj/WA7yizdulLqQf+rTtKzzb00U1IGBqRjWIoRP8bC
	 g27siraYF9/GAbf8uZG3J+pt3IhD6GrMLnxt0XjMIF0zuSFO1FhzNrzRKyl7XF06ESRcp
	 MsIIRk8HrCVIaybFcMyFAoBRpg1fKIc++sD7k5R1o5DAZsWVgJzo8zlOqsFwe9PGoqHRk
	 FRt6Rq5pYQdj/pEVjrL6LV+jP5fy7pM10ZRD44pjsMPUnapokCp00bSekApjclBSMOPg9
	 lytb2i7tVKmXLsd1YFYw8BUy1TCqG5c5GTrr9N7if5cWsv8p83lw04QDzMRLyBtU/qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GNpuip63;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5765606A323;
	Wed, 25 Nov 2026 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GNpuip63
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60DA1F000D1;
	Wed, 25 Nov 2026 15:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620804;
	bh=T4EfI8/m4C9NAM8EvIs8mQmpYODE8xUySmtVm8Q1KUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNpuip63ok22fBVANSjJz/KBo/nuZcW7ztF2zyS9kp75aom30asvPkjjGpMtQWoPH
	 F/2e3tHlE4NC8ZuREMOwyjPrj9iragRox7DZvQfqEZcnqCm/ONPeorolkyb7hcov12
	 isnflxg1hq9dEWtHTjPfAuc2wRoOWWo+Mp6HRj+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Long Li <leo.lilong@huawei.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/990] xfs: only assert new size for datafork during truncate extents
Date: Wed, 25 Nov 2026 15:23:16 +0100
Message-ID: <20261125143822.771065228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit e942498385bf80f4d6d075b47174035545eb6a2e ]

The assertion functions properly because we currently only truncate the
attr to a zero size. Any other new size of the attr is not preempted.
Make this assertion is specific to the datafork, preparing for
subsequent patches to truncate the attribute to a non-zero size.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 36b39539e561a..c5afc8997fb4e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1048,7 +1048,8 @@ xfs_itruncate_extents_flags(
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	if (icount_read(VFS_I(ip)))
 		xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
-	ASSERT(new_size <= XFS_ISIZE(ip));
+	if (whichfork == XFS_DATA_FORK)
+		ASSERT(new_size <= XFS_ISIZE(ip));
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(ip->i_itemp->ili_lock_flags == 0);
-- 
2.53.0



