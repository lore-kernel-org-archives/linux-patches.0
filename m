Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8A9369D71;
	Thu, 17 Sep 2026 15:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660634; cv=none; b=j7xFLuC4RfUrvKNBxpdREAUtpGXSDLKUQx5m0DH0CxU9Efk39i0fgOjraP2msaPxNCAwg8gE9aKo1eBHG5GjSIgx0u0d87Ap8Yld8QVGBBds44UK+v7GCyWEYVMVcSEVAriUX4ZGWlXEUJSB1rbG23R/vf/UpXb3NotVB7yjlYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660634; c=relaxed/simple;
	bh=M2BlFSxmmEQ7Ozw+8RJx/x+PSPhBedPhWO+qcIIFk/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZowpP/E+LOZxPKAYyXt58cktn/csBctycrRSysWA8NUyVAT8MJOHbpg0/DMIsF8ssau83N5O1gbagiuRIxSpZWwLJ16OgPh/KXU0AQXXnY+utZ91Hv4rwDLjpfqdZHY1bNiOGlP7CRLq30Qd+guspAq/3olmIHKBHdaneGGk4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LerHTDSi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LerHTDSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325D91F000FF;
	Thu, 17 Sep 2026 15:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660632;
	bh=CLi6cemvN1gtaBhwue0WLs1nAXE2HyKQPsk/6joy2c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LerHTDSiHbsKugBCZcNHFIGIY30N28IIr7BGtK0ii+stEjwoaHo87xRpJCEaxs3+t
	 rwVKfTZ9eqJ8Fjl8NIWNE7l2aiRqwE0pRmcltqrmvgeJQ1cWAkFHBAZg352Yna1SDi
	 QSYYz+Tl3p2ulINy1uApkBj81C53mBciIUtePHXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Tia <floss@jetm.me>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 656/733] xfs: initialise args->total for parent pointer updates
Date: Thu, 17 Sep 2026 16:16:04 +0100
Message-ID: <20260917151408.999313678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Tia <javier@peridio.com>

commit 8e4ebb6afaa34bd2e8ce52da231003d24111c2d6 upstream.

xfs_parent_da_args_init() builds an xfs_da_args from a zeroed
xfs_parent_args (kmem_cache_zalloc), leaving args->total == 0.
xfs_da_grow_inode_int() treats that field as a running block reservation
and subtracts from it; because it is an xfs_extlen_t (uint32_t), the
first attr-fork growth wraps it to ~0U.  That defeats the free-space
check in xfs_alloc_space_available(), and when it coincides with an AG
that has exactly zero available blocks the allocation is clamped to
maxlen 0 and returns -ENOSPC, which xfs_defer_finish_noroll() escalates
to a filesystem shutdown.

Set args->total the way the log recovery path does
(xfs_attri_recover_work(), xfs_attr_item.c:706), in the add and replace
paths that can grow the fork.  Removals and lookups never grow it, so
they leave the field alone, matching that switch.

Fixes: b7c62d90c12c ("xfs: parent pointer attribute creation")
Cc: stable@vger.kernel.org # v6.10
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_parent.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -193,7 +193,7 @@ xfs_parent_addname(
 	const struct xfs_name	*parent_name,
 	struct xfs_inode	*child)
 {
-	int			error;
+	int			error, local;
 
 	error = xfs_parent_iread_extents(tp, child);
 	if (error)
@@ -203,6 +203,10 @@ xfs_parent_addname(
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			I_INO(child), parent_name);
 
+	/* Growing the attr fork needs a real reservation in args->total. */
+	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
+	ASSERT(local);
+
 	return xfs_attr_setname(&ppargs->args, 0);
 }
 
@@ -239,7 +243,7 @@ xfs_parent_replacename(
 	const struct xfs_name	*new_name,
 	struct xfs_inode	*child)
 {
-	int			error;
+	int			error, local;
 
 	error = xfs_parent_iread_extents(tp, child);
 	if (error)
@@ -249,6 +253,10 @@ xfs_parent_replacename(
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			I_INO(child), old_name);
 
+	/* Growing the attr fork needs a real reservation in args->total. */
+	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
+	ASSERT(local);
+
 	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
 
 	ppargs->args.new_name = new_name->name;


