Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C36B1E50A;
	Tue, 30 Apr 2024 11:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475401; cv=none; b=eQejL0AiCLBRB/9j5S1r5sHRRbtXvjeE0I2yq6QkocXRq/rRtIGVW4u2WAFZTxzTMeu6CfNWmHSakVhASjbxFEr2c2+C/FlN2qG70FIU2M+cPC6cFBxOUt/FYCOGWTh/D4m2riRq9XzThfUTCB6+lHAcfpj4j7l9pT1XI5vYYQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475401; c=relaxed/simple;
	bh=Xp5fUGKytgrTTMae2mzti197VHuc+RvHgMOCOCXAbyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8nY0GUkdHetHvehWhn8e0iU3fqnrJ+BLskP3EdwkJYswEEFTpMTsC0viWD+Y2+1sC3oSArvskp/s3IPZXY+LMKiPA6hGPqtBLWYR/cXVu5AZ/zi1zGIREizPWx5yOq7yZ8I6a+VdszFt8nMwgBKWQJuirY9YtzAmwO4SSFycuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRFrLsbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRFrLsbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D585CC2BBFC;
	Tue, 30 Apr 2024 11:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475401;
	bh=Xp5fUGKytgrTTMae2mzti197VHuc+RvHgMOCOCXAbyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRFrLsbOel8jBN7N6ZltWuvYIvYvoKH9HS9pb9CwDQl+8ni2t7ANtWwNIu2QCzD3N
	 M5BolbGSxNP0QcJukD2SI5QY7EvvY1UGRhV4MoFrAP5vqL9Ih/CncP2xMDtestcC+h
	 sJYFacPP4D9TV87s/Mypxo6gYaO4pZ4MtevOahO4=
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
Subject: [PATCH 6.6 076/186] mlxsw: spectrum_acl_tcam: Fix race during rehash delayed work
Date: Tue, 30 Apr 2024 12:38:48 +0200
Message-ID: <20240430103100.244539624@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b6a4652a6475a..9c0c728bb42dc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -718,7 +718,9 @@ static void mlxsw_sp_acl_tcam_vregion_rehash_work(struct work_struct *work)
 			     rehash.dw.work);
 	int credits = MLXSW_SP_ACL_TCAM_VREGION_REHASH_CREDITS;
 
+	mutex_lock(&vregion->lock);
 	mlxsw_sp_acl_tcam_vregion_rehash(vregion->mlxsw_sp, vregion, &credits);
+	mutex_unlock(&vregion->lock);
 	if (credits < 0)
 		/* Rehash gone out of credits so it was interrupted.
 		 * Schedule the work as soon as possible to continue.
@@ -1323,7 +1325,6 @@ mlxsw_sp_acl_tcam_vregion_migrate(struct mlxsw_sp *mlxsw_sp,
 	int err, err2;
 
 	trace_mlxsw_sp_acl_tcam_vregion_migrate(mlxsw_sp, vregion);
-	mutex_lock(&vregion->lock);
 	err = mlxsw_sp_acl_tcam_vchunk_migrate_all(mlxsw_sp, vregion,
 						   ctx, credits);
 	if (err) {
@@ -1343,7 +1344,6 @@ mlxsw_sp_acl_tcam_vregion_migrate(struct mlxsw_sp *mlxsw_sp,
 			/* Let the rollback to be continued later on. */
 		}
 	}
-	mutex_unlock(&vregion->lock);
 	trace_mlxsw_sp_acl_tcam_vregion_migrate_end(mlxsw_sp, vregion);
 	return err;
 }
-- 
2.43.0



