Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B94718455B;
	Tue, 30 Jul 2024 16:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358214; cv=none; b=pp84Q77CClIDvfAX8j3eMlC1dSvSya5LpOIK1U6/3ikTbF7G9d6FCsfmaLCqQMsMfGnLtdnSDHPJF2+cXRIyT2TAobBRNJpozH1rNY/MbEP/n1Pb+IP4ylmXZdkN7jPvOzo9VzNlpXrBlxsOpqq+uet87l3scb7r2RZNZ24jVok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358214; c=relaxed/simple;
	bh=Tm/jEqf71nQbmXHS3W/qm9luuOvkTMZ0sOG1w/vh/3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsrn+ZfZ7Zi8PZG31LEnnd4/j3paPUcYi7HzCJPHqQJNaq5jFUx9zhbz9zCT7oOilJLCW/M60GUuHkM0n0XLAi8csQqZFnh+cPas/7as82WrtR4pEDv+tnQ7Go6w/Rv3excMZ5L0Gw4jyryUfOqy7fDK0YiMoSY2+8FHBmhETJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2kapwKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2kapwKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF59C32782;
	Tue, 30 Jul 2024 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358213;
	bh=Tm/jEqf71nQbmXHS3W/qm9luuOvkTMZ0sOG1w/vh/3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2kapwKihDbSra4IhNYNyP6t5xFUa9GtacMNNFRstJ2B/XebuFv8Uy8TSv9tG0HiO
	 zZVSXioFWbfKPLSfWfXQa2EnSkDw+Ps3HiIydsf1jgMEimUH4SYTEkPw9FhsJ0wx2b
	 EQ0ZYLbi0mfDYge9VxcVxxwMPb2hph+0R/wuD+io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 331/568] fs/ntfs3: Replace inode_trylock with inode_lock
Date: Tue, 30 Jul 2024 17:47:18 +0200
Message-ID: <20240730151652.809308003@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 69505fe98f198ee813898cbcaf6770949636430b ]

The issue was detected due to xfstest 465 failing.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index dfd5402a42e44..cd69cbd0aaae7 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -299,10 +299,7 @@ static int ntfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 		}
 
 		if (ni->i_valid < to) {
-			if (!inode_trylock(inode)) {
-				err = -EAGAIN;
-				goto out;
-			}
+			inode_lock(inode);
 			err = ntfs_extend_initialized_size(file, ni,
 							   ni->i_valid, to);
 			inode_unlock(inode);
-- 
2.43.0



