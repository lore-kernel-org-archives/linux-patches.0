Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163A915E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0k6rj9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B676C433C8;
	Mon, 23 Oct 2023 11:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060397;
	bh=SV6BtxR0oVGgdR2P71txoRQvZJO3vGRjQ4IRH1Oruxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0k6rj9+IS5V/f75mVZW9eEJAZNxPFpJfiKqZEE0ZNt0LF/ljKzgutK9O90IRhZJx
	 NoixMPlUHhG0dWMu7GV12sIaz0mm295ZbXYyxFEV/dvYK2PPrh/2Z/ERUTZ5LrOinl
	 0ohnla7K47PsSy3Ox6gys/pZZB/A+W+Gqqkg3Kc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@hammerspace.com>,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 6.1 158/196] nfs42: client needs to strip file modes suid/sgid bit after ALLOCATE op
Date: Mon, 23 Oct 2023 12:57:03 +0200
Message-ID: <20231023104832.922771366@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

commit f588d72bd95f748849685412b1f0c7959ca228cf upstream.

The Linux NFS server strips the SUID and SGID from the file mode
on ALLOCATE op.

Modify _nfs42_proc_fallocate to add NFS_INO_REVAL_FORCED to
nfs_set_cache_invalid's argument to force update of the file
mode suid/sgid bit.

Suggested-by: Trond Myklebust <trondmy@hammerspace.com>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs42proc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -81,7 +81,8 @@ static int _nfs42_proc_fallocate(struct
 	if (status == 0) {
 		if (nfs_should_remove_suid(inode)) {
 			spin_lock(&inode->i_lock);
-			nfs_set_cache_invalid(inode, NFS_INO_INVALID_MODE);
+			nfs_set_cache_invalid(inode,
+				NFS_INO_REVAL_FORCED | NFS_INO_INVALID_MODE);
 			spin_unlock(&inode->i_lock);
 		}
 		status = nfs_post_op_update_inode_force_wcc(inode,


