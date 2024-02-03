Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DC410A1B;
	Sat,  3 Feb 2024 04:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933328; cv=none; b=BcWzgq31CH4NyhsiJBMCr4WaiYCN47i9dmj4PN3Y6etrv4ezDToK+5q+fZrGe1+WmtrImu3yF9UyIDp5s7VnoxVq1B3KnTRS3+6lCgCDAjs5cV2SM0HLAKimt1F74WtWPxQuJ9AiffgOvM+034Npb0rvFbqryN4nemORR1S3dto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933328; c=relaxed/simple;
	bh=nK2wCFNr2sSGQa0HJn2esS5t6mnCf/ekX4Em4TDGQPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrUgMRLQ3bR/FIAgIOQfUUpy1UA3YGph8pqtxt1Ac/G4qbhzEv1zEfndDdE8vYlMfLW/rVzfgh3G/cdVnrViH7pQoa6uOZtSxkkLxUlEuM2wPrwuCCVrCJVT9kvyrj+CDs9hYcElBushQ2B1hK001rGOLtqhjZNMJuq3n6Dr77o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGcFtWtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGcFtWtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB524C43390;
	Sat,  3 Feb 2024 04:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933328;
	bh=nK2wCFNr2sSGQa0HJn2esS5t6mnCf/ekX4Em4TDGQPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGcFtWtYuGAU8VlCHKQn4Jd3XM8nBBDdaHvNWgKKC5dMKnQrpLnxHhHaYFVNaOWeC
	 qbSJHED5K/RigLdJyj+VrMD6MOI28VBSC9HavGTdrGxAgBUadEJHxr2DbxAqjnZ3Br
	 TjxX73IM9cQdrKvL9ncjaQbW/HEtUftOGZZGxz2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Manas Ghandat <ghandatmanas@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/219] jfs: fix slab-out-of-bounds Read in dtSearch
Date: Fri,  2 Feb 2024 20:03:17 -0800
Message-ID: <20240203035319.877997162@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manas Ghandat <ghandatmanas@gmail.com>

[ Upstream commit fa5492ee89463a7590a1449358002ff7ef63529f ]

Currently while searching for current page in the sorted entry table
of the page there is a out of bound access. Added a bound check to fix
the error.

Dave:
Set return code to -EIO

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202310241724.Ed02yUz9-lkp@intel.com/
Signed-off-by: Manas Ghandat <ghandatmanas@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dtree.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index f3d3e8b3f50c..031d8f570f58 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -633,6 +633,11 @@ int dtSearch(struct inode *ip, struct component_name * key, ino_t * data,
 		for (base = 0, lim = p->header.nextindex; lim; lim >>= 1) {
 			index = base + (lim >> 1);
 
+			if (stbl[index] < 0) {
+				rc = -EIO;
+				goto out;
+			}
+
 			if (p->header.flag & BT_LEAF) {
 				/* uppercase leaf name to compare */
 				cmp =
-- 
2.43.0



