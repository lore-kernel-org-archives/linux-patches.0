Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B3F22DF91;
	Tue, 29 Apr 2025 17:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948312; cv=none; b=NbXYB8UV6BzHbcyjigz3ivJKkj1IGRdgHa74vJ2hlspyZR8MayoYriSBlE92sCgGddHrrYJ+TKdRANpsG2UBxU5z1gvuBYdZA1VuvOKcJrE5927XUA/jb7ThujmbYnVjP9NVXKmkHiVcvqbwTqZkYPI+oRsCsZeKdIomx4Md8d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948312; c=relaxed/simple;
	bh=UNaP5eGLDVgsvjeGxXWkFJDUeGdWv+JuhjX1YnTdFtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGjCbtbBW+vvMM4nqtwoTcgPlepnLv921BKH+pXLiCxg20rRJI2+edfzvuDYQxr6wcEvVzA6lCX8BsV8FGpUp2XDdyAN4lFNKSZNONwAdM15JgTNg9yBm544d2LnmGE/XDcZdgivrWJQt9vvHKhENbXE158P6or2SaBECwE3AbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JApEm6oA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JApEm6oA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7CFC4CEE9;
	Tue, 29 Apr 2025 17:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948312;
	bh=UNaP5eGLDVgsvjeGxXWkFJDUeGdWv+JuhjX1YnTdFtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JApEm6oAcvfTN+MUjGrcH8EG7XvWdh8fc+M2+2Ahoq2/Qe4N1mHZNy4NPllDnwWun
	 MGe4o5OHPvUCscJ52XUXcbhTQiUROtfS4a8jL3NxB+YV36cyqv69y2/qW1KJ9UYUT4
	 qQMtWGmNLNiSRSRQLoUOWLVBExzFTD08KlaBBH3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Herbolt <lukas@herbolt.com>,
	Dave Chinner <dchinner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 251/280] xfs: do not check NEEDSREPAIR if ro,norecovery mount.
Date: Tue, 29 Apr 2025 18:43:12 +0200
Message-ID: <20250429161125.393003601@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Herbolt <lukas@herbolt.com>

Commit 9e00163c31676c6b43d2334fdf5b406232f42dee upstream

If there is corrutpion on the filesystem andxfs_repair
fails to repair it. The last resort of getting the data
is to use norecovery,ro mount. But if the NEEDSREPAIR is
set the filesystem cannot be mounted. The flag must be
cleared out manually using xfs_db, to get access to what
left over of the corrupted fs.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1619,8 +1619,12 @@ xfs_fs_fill_super(
 #endif
 	}
 
-	/* Filesystem claims it needs repair, so refuse the mount. */
-	if (xfs_has_needsrepair(mp)) {
+	/*
+	 * Filesystem claims it needs repair, so refuse the mount unless
+	 * norecovery is also specified, in which case the filesystem can
+	 * be mounted with no risk of further damage.
+	 */
+	if (xfs_has_needsrepair(mp) && !xfs_has_norecovery(mp)) {
 		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
 		error = -EFSCORRUPTED;
 		goto out_free_sb;


