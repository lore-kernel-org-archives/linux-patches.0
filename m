Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0F14F5DE6;
	Thu, 17 Sep 2026 16:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664373; cv=none; b=ssVX2VSKecZJpsBbCY9uZqTptW7Lig2VzZTSZdvcHbQ61+mJG5DxKJAb5+Lrwqum0wyLEa/GvSLDFqq2jzJz8nit33+GY6F2mMxLdH0UL7NWRQDTT5SZusSI1Nc+3ZtbK12WScR96kTCajp3z+3O/JAdJ5gs0LxCDxL0J1fR0sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664373; c=relaxed/simple;
	bh=pudlI3Wki2ivRZeHiwFh2Im+Y+6H5rdAC/df5QuaZGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pt9lVi4We8CP5P9fKTOcEtrabsblZqe9Oxk93U8px7dcSqSiZP99Kx/2KccLF1tvu16SNEukInc7sSNUDOixHyPP1GP505ABnkdr1ND/2o84g5WLmrVV3BFGwK2Med8XFEi+JcfR1FkSw39X4n/s/2l27nuRp/7Bx6+1l3ErtUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUZq4iB9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUZq4iB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF461F000FF;
	Thu, 17 Sep 2026 16:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664371;
	bh=R51E9/kXEPbITsNFUKbgsnIeYokrstXUSrsc80xzFt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eUZq4iB9wWILYbPJy14ByswG/MXnP9xW5glEng5zpHpwx5V40W9c4Y62i+qchKiv0
	 r/KRCyEHo6T7WgcsGPHiS/sHsXQn7UoE8EARCxp9uByLwFsboTJgRurYZTx2YoHLrt
	 TuyNd4l1R31IvchiQhvb2ea39+6yC0oYj7XSMJnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0351/1250] NFS: fix eof updates after NFSv4.2 fallocate/zero-range
Date: Thu, 17 Sep 2026 16:02:26 +0100
Message-ID: <20260917151601.582831696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 35168eb947f230aaa35fd8416a30563ef89f5421 ]

Generic/075 reliably exposes a regression when the client holds an
NFSv4 write delegation: ZERO_RANGE/ALLOCATE extends the file on the
server, but the local inode keeps the old i_size. The test then fails
with 'Size error' because the post-op attribute refresh refuses to
touch i_size while a delegation is outstanding, and the cached EOF
was never marked stale.

Update _nfs42_proc_fallocate() so that on success it:

- bumps i_size when the operation extends the file, and
- marks NFS_INO_INVALID_BLOCKS since the block count can also change

Tested with xfstests generic/075 over NFSv4.2.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index c08520828708b..1c66e1bb19652 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -81,12 +81,17 @@ static int _nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 	status = nfs4_call_sync(server->client, server, msg,
 				&args.seq_args, &res.seq_res, 0);
 	if (status == 0) {
-		if (nfs_should_remove_suid(inode)) {
-			spin_lock(&inode->i_lock);
+		loff_t newsize = offset + len;
+
+		spin_lock(&inode->i_lock);
+		if (newsize > i_size_read(inode))
+			i_size_write(inode, newsize);
+		nfs_set_cache_invalid(inode, NFS_INO_INVALID_BLOCKS);
+		if (nfs_should_remove_suid(inode))
 			nfs_set_cache_invalid(inode,
-				NFS_INO_REVAL_FORCED | NFS_INO_INVALID_MODE);
-			spin_unlock(&inode->i_lock);
-		}
+					      NFS_INO_REVAL_FORCED |
+					      NFS_INO_INVALID_MODE);
+		spin_unlock(&inode->i_lock);
 		status = nfs_post_op_update_inode_force_wcc(inode,
 							    res.falloc_fattr);
 	}
-- 
2.53.0



