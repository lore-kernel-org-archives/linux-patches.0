Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8258415990E;
	Tue, 18 Jun 2024 13:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716649; cv=none; b=UFIy/EcqZT0kBZc1yDHD6oTDDfMwRBU/HvpggAd0Dzx9nv+ynwk3trdtaOqEv8SSMVz4xWhpTW1XjDRx2NmcsaCZmxhveugtR/90N1y4hrOUDvnp/ojfBMIfAdQOHXWYfJEcx5NB6wv8n7TmfeSwtt6LGgHQLmsfPGNt/Zc5sE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716649; c=relaxed/simple;
	bh=L9o1pvUkpD/o4gnGoz8b3aRD8uYYfhRgzbnC9znvY88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6VhURbQhQZ9YDQibVAv7uAAaA99KPuBR8WoHlrjVGIlp2uwmOoo7/cWdMuvmqTwTtR/cuXctvC0mgFOXor9pDME3UmWWWFH+Ph1su/JBo9ReykTBk9YHYzDYBJsRmFxiKAZMQGCEJRgNiwKQljBYE0l4RL6TnR2ovG1B8pY9vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snUnbGsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snUnbGsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B430C3277B;
	Tue, 18 Jun 2024 13:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716649;
	bh=L9o1pvUkpD/o4gnGoz8b3aRD8uYYfhRgzbnC9znvY88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snUnbGsMIWUJp2+PkZPh4s8aiGsBAgpTCIktpeQH/i7zENCu3+ZT/fleQHuqUBael
	 7H0xn2uqou2JwzJl1JjLaRrXqOO3ltlrBJdEWAhVwObfCYIVeNUz7il5/fuVOVjy2x
	 u5l3XQ0/3dfYjlDv7fq0VvERVURWq1m1mYU6OsFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 715/770] NFSD: pass range end to vfs_fsync_range() instead of count
Date: Tue, 18 Jun 2024 14:39:28 +0200
Message-ID: <20240618123434.871323692@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 79a1d88a36f77374c77fd41a4386d8c2736b8704 ]

_nfsd_copy_file_range() calls vfs_fsync_range() with an offset and
count (bytes written), but the former wants the start and end bytes
of the range to sync. Fix it up.

Fixes: eac0b17a77fb ("NFSD add vfs_fsync after async copy is done")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Tested-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 86ab9b8ac2daf..cf558d951ec68 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1632,6 +1632,7 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy,
 	u64 src_pos = copy->cp_src_pos;
 	u64 dst_pos = copy->cp_dst_pos;
 	int status;
+	loff_t end;
 
 	/* See RFC 7862 p.67: */
 	if (bytes_total == 0)
@@ -1651,8 +1652,8 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy,
 	/* for a non-zero asynchronous copy do a commit of data */
 	if (nfsd4_copy_is_async(copy) && copy->cp_res.wr_bytes_written > 0) {
 		since = READ_ONCE(dst->f_wb_err);
-		status = vfs_fsync_range(dst, copy->cp_dst_pos,
-					 copy->cp_res.wr_bytes_written, 0);
+		end = copy->cp_dst_pos + copy->cp_res.wr_bytes_written - 1;
+		status = vfs_fsync_range(dst, copy->cp_dst_pos, end, 0);
 		if (!status)
 			status = filemap_check_wb_err(dst->f_mapping, since);
 		if (!status)
-- 
2.43.0



