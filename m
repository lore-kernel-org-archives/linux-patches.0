Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5752C2F2344;
	Thu,  3 Jul 2025 15:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555504; cv=none; b=LSIqF3WUIwIYFI6ePsdqQFrSwRaDMnixksbgKuAkkuNhMRGp3/6m21JkbTlEklKUtUFWUlKeqz8Jnu6HLGsuZW2YzPDYrpRHgOcNRfgFJ1G0e8Ocf4Oo+8HMhVWGlk/Rz8TJA+YO7BXg4NZNU/txXFIBXbdWJzNSaBVhcOgxnEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555504; c=relaxed/simple;
	bh=Gydh9MnC4vVloj0x3gQhwO+F5LfrlI2k38YE1ypjnfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ox0M5WDS8dscuhKfVkMZzaU3EnweSToig5JeXs8+zDyoT1gah/P53oy1BU6xaFljW58t2L5DedkO5s5Ee+zaSkEYdtb16bIbGlEeMptgCHzOpfXeStDOLDL8oPzJkQU+ajqvQwS9IRPJ0dOof7KF7ExOlfE5CZW5yhJJiAdNMqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znKtSJce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znKtSJce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305A3C4CEEE;
	Thu,  3 Jul 2025 15:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555502;
	bh=Gydh9MnC4vVloj0x3gQhwO+F5LfrlI2k38YE1ypjnfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znKtSJce80Jn/dz+RFkyWmKBR5OK1ojVWRAxAIDQdKRgF939p7lmiLmg4cvAQZU2P
	 B2VTBV/+GFvRsr06M3mEc7tVgZLZ+gb/aMfR4P4AoVbetaKRJnnXSeHBBFKuOvSFI0
	 1vMMEBY2SUkdrb4ANNBsDxgxb9AHSnVqD7qSgHiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Young <hanyang.tony@bytedance.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/139] NFSv4: Always set NLINK even if the server doesnt support it
Date: Thu,  3 Jul 2025 16:41:07 +0200
Message-ID: <20250703143941.355047467@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Young <hanyang.tony@bytedance.com>

[ Upstream commit 3a3065352f73381d3a1aa0ccab44aec3a5a9b365 ]

fattr4_numlinks is a recommended attribute, so the client should emulate
it even if the server doesn't support it. In decode_attr_nlink function
in nfs4xdr.c, nlink is initialized to 1. However, this default value
isn't set to the inode due to the check in nfs_fhget.

So if the server doesn't support numlinks, inode's nlink will be zero,
the mount will fail with error "Stale file handle". Set the nlink to 1
if the server doesn't support it.

Signed-off-by: Han Young <hanyang.tony@bytedance.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 06230baaa554e..419d98cf9e29f 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -555,6 +555,8 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 			set_nlink(inode, fattr->nlink);
 		else if (fattr_supported & NFS_ATTR_FATTR_NLINK)
 			nfs_set_cache_invalid(inode, NFS_INO_INVALID_NLINK);
+		else
+			set_nlink(inode, 1);
 		if (fattr->valid & NFS_ATTR_FATTR_OWNER)
 			inode->i_uid = fattr->uid;
 		else if (fattr_supported & NFS_ATTR_FATTR_OWNER)
-- 
2.39.5



