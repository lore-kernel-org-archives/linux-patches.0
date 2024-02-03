Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D90210A13;
	Sat,  3 Feb 2024 04:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933760; cv=none; b=fDR3RYyOR/FLKJoPBqFz1ZqvTrsaEuOJ+dVmBadjjGo0KTjfcFNh2tHN9HTyuDMt4LzEE/yswq8XQwlpgK8z7wiTKSKs7OjbITm1l0TgQCIYZ7mewRVq555arrNFYLRpkgYIyvNZuR2FMuxCbs0YPFcr+BywUM05xcl0knHhYqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933760; c=relaxed/simple;
	bh=hWdQKtoNUOWOt1Dvf2qUmupzyTueEVqvuzUmh+vCijg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+Kjal7WoJLZrnEe/uKiIcGslWVRSiy57DU1jDQ1Whhj4czE1epM/VbwsbOW+SClK0WvJU+qtTLVeWkdK0MYKHOaZlvPCZ4DlTanaYfnb7E6k/b+fpA+kM8kxfjnrqXCbTgL6LJjR8D7fRWuldzVkVLnaqrctXea1mntfXMdJTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZGyR2sb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZGyR2sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CA7C43390;
	Sat,  3 Feb 2024 04:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933759;
	bh=hWdQKtoNUOWOt1Dvf2qUmupzyTueEVqvuzUmh+vCijg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZGyR2sbsKdiKDl5s9IbIqfDpBLrD95RUd2nVE6hRpnG9d0QIovMvomuldQ5o2jjM
	 8248s6ZQVET6QcqC+Oy6i9Uec5a1BeQcNUVDUD8N7R1NmKCEABWnts60/VX6v0WBi+
	 MglbgxVn1+d3g8WwTWZqzNNfbLeOgaRrqV6/gU6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Manas Ghandat <ghandatmanas@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 032/353] jfs: fix slab-out-of-bounds Read in dtSearch
Date: Fri,  2 Feb 2024 20:02:30 -0800
Message-ID: <20240203035404.808644987@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



