Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A508801;
	Tue, 30 Apr 2024 11:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476209; cv=none; b=Bcm9QWyCpNjKf5Tw6BNeVGARE4nz5WwbUdKvxMyBuXPLY3ljeE1F0ZP3Yx4C/MExkR0lOdFxwBF1TwVhkU/nBcXWGG3qiKY6eREpkhhVKJ4Y27mVZMtMajlw1OxAo67KpMLBa4w4bktb+8WapsL+abD+do6k37XEXBYXmwhKn1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476209; c=relaxed/simple;
	bh=rnVyA1JHtvCuj2gqzSYeH24QC0EyaTPnsuStrN8qROE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlsWrGgOryV8j3n38231uaIEYTWcb5SygcBX/1PEPx3NR9YusS07ZVcogFqu0bq4dfR4tw7VATGn837ogCUam8OiNojIQAkMYFcBzqVbuIYHbA+bskTXmCp9lU3RMMyjoflba09GUbsW7+YJsxgfUC39mTRZOMvY/9rgM5sp4vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tj+acnw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tj+acnw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E60C2BBFC;
	Tue, 30 Apr 2024 11:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476209;
	bh=rnVyA1JHtvCuj2gqzSYeH24QC0EyaTPnsuStrN8qROE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tj+acnw1J9gFCUA6YATF0PU5PFtThB+cAN/npOnMKwZn9UYajv5SUyppL07ODLZAy
	 ODn+gjW6WKO86HAK5lnBdNkL/qL28WA2NWwFtdyXMxm9nuiYcnDA3+A0ZfxuMeLrr2
	 D6GGzY9Z6P3ut4N/UJuqvob5f7qeDJsj692Lt/PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Alexander Zubkov <green@qrator.net>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/107] mlxsw: spectrum_acl_tcam: Fix race during rehash delayed work
Date: Tue, 30 Apr 2024 12:40:28 +0200
Message-ID: <20240430103046.663369862@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit d90cfe20562407d9f080d24123078d666d730707 ]

The purpose of the rehash delayed work is to reduce the number of masks
(eRPs) used by an ACL region as the eRP bank is a global and limited
resource.

This is done in three steps:

1. Creating a new set of masks and a new ACL region which will use the
   new masks and to which the existing filters will be migrated to. The
   new region is assigned to 'vregion->region' and the region from which
   the filters are migrated from is assigned to 'vregion->region2'.

2. Migrating all the filters from the old region to the new region.

3. Destroying the old region and setting 'vregion->region2' to NULL.

Only the second steps is performed under the 'vregion->lock' mutex
although its comments says that among other things it "Protects
consistency of region, region2 pointers".

This is problematic as the first step can race with filter insertion
from user space that uses 'vregion->region', but under the mutex.

Fix by holding the mutex across the entirety of the delayed work and not
only during the second step.

Fixes: 2bffc5322fd8 ("mlxsw: spectrum_acl: Don't take mutex in mlxsw_sp_acl_tcam_vregion_rehash_work()")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Alexander Zubkov <green@qrator.net>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/1ec1d54edf2bad0a369e6b4fa030aba64e1f124b.1713797103.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index ec0d5a4a60a98..5c0ff3d612e3c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -756,7 +756,9 @@ static void mlxsw_sp_acl_tcam_vregion_rehash_work(struct work_struct *work)
 			     rehash.dw.work);
 	int credits = MLXSW_SP_ACL_TCAM_VREGION_REHASH_CREDITS;
 
+	mutex_lock(&vregion->lock);
 	mlxsw_sp_acl_tcam_vregion_rehash(vregion->mlxsw_sp, vregion, &credits);
+	mutex_unlock(&vregion->lock);
 	if (credits < 0)
 		/* Rehash gone out of credits so it was interrupted.
 		 * Schedule the work as soon as possible to continue.
@@ -1394,7 +1396,6 @@ mlxsw_sp_acl_tcam_vregion_migrate(struct mlxsw_sp *mlxsw_sp,
 	int err, err2;
 
 	trace_mlxsw_sp_acl_tcam_vregion_migrate(mlxsw_sp, vregion);
-	mutex_lock(&vregion->lock);
 	err = mlxsw_sp_acl_tcam_vchunk_migrate_all(mlxsw_sp, vregion,
 						   ctx, credits);
 	if (err) {
@@ -1414,7 +1415,6 @@ mlxsw_sp_acl_tcam_vregion_migrate(struct mlxsw_sp *mlxsw_sp,
 			/* Let the rollback to be continued later on. */
 		}
 	}
-	mutex_unlock(&vregion->lock);
 	trace_mlxsw_sp_acl_tcam_vregion_migrate_end(mlxsw_sp, vregion);
 	return err;
 }
-- 
2.43.0



