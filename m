Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0063B42C0;
	Wed, 30 Sep 2026 18:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794383; cv=none; b=K39mlqG+wu40mYZMPneoke/I+OS4fwEKnsQ9ZwGx4IFglz54B+UT73U+ehzHNHhWbJy0frL5/4XzdWXTo+UUl12hjBiJ8BNzWb+nwtAWCSUB+gtmIaHaY5nhi4hrEeMCfoHhEo87Fy48N4DQnhsNjxcJkOmz7vSV1G5tVDZn5lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794383; c=relaxed/simple;
	bh=OKYMVUnmsh3JJNQUvw3ATQ2bWE+eyJtPHCST0+td9+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hW15sDmTYPluthYVQMwFyNz3+6Yw8jyNPo0yJkRqP3kyz8Bd9Pke2ZHy+0JWqx6uxJgSh7FcQeC5oQp1BxlKMKYUB+nZlb5/htYSsBnfxRdaX1rBiQL0j6h+MWO9jZNba9QOGRR1Ic6YvJSp44phVs03+IB40v4+IhBYDc0FOqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgk/lj+l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgk/lj+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542E91F000FF;
	Wed, 30 Sep 2026 18:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794381;
	bh=6SQ+OFjbLcS2N9Kbewvq4zP3IGu6rbZzkMwqgNVVI8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vgk/lj+lFYZJwpiSH7fs63g55IVctjgvddIpLNG0VRBOIuC0uL503gjm0NloQJgO0
	 HreXfWzMVlM+L6LAme7RoD2as6yCzOMeGONSx9NIm/b0P7PashI48JPtBuEggJxZhJ
	 HQsTK1nWGtrIrzvyA36FxxHAK1sKa1yN3Z9gqB3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0189/1193] NFS: fix eof updates after NFSv4.2 fallocate/zero-range
Date: Wed, 30 Sep 2026 17:14:33 +0200
Message-ID: <20260930152438.395695457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 582cf8a469560..fa68c85e6160c 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -79,12 +79,17 @@ static int _nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
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



