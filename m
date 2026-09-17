Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0804F93B2;
	Thu, 17 Sep 2026 17:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667900; cv=none; b=sHkCRhVTDLLLuTIZqeKOqRbIuDyHXm8lM5xlo/akhD/dxqH3cHjy1qEsz0RHcjdI34tedF4Z8Wv1g+mgqof0C8WHKrHNAc1c0dxySxLUiL2E/qaXbB5ODsqaOi+l0nyJNGKRPodYQ86HBoNOEsTycu2Rj0elYXrvgB4mfaaZfKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667900; c=relaxed/simple;
	bh=bVaqrTfiSP7oH1xF/57R0hI+Z+ZY75ULgPDFg4GZUac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKBoSOQy7eHnXybiXElzNeWBw0nCR1cbM0myrcLkMQk8PHS/kH4De8XrCdf/u6IJpc8k9DUiYZM0vKXd7ttqLaivdloCj5FntokNvPevKKmFpJGdDbgaI/gIQ2ZouAu7RZms1n/HROPEFRJSW/MkrI3erQ6cKJ5FjY+4AhU+oTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LcmATB2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LcmATB2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8357A1F000FF;
	Thu, 17 Sep 2026 17:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667899;
	bh=sBXPy3ut25cKO+XcQt9tzRgn87TDvjqz1l+sSbQvVk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcmATB2Rw6DLBJ+X55HcR6iJ3IRi3pAs2Zrt72W4IHKX/OWQ7X2c2RADUl1TAlqh1
	 AWyQvLQpL0XvIgpbBR/Y1Dyv6xtGbR2pKuqIS7nDsoNtbP5wWNei721xmmkMN0gIx2
	 kPGshntBiS+jJvOsYbByIwPewdKK0T71wWMxpJLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0245/1102] NFS: fix eof updates after NFSv4.2 fallocate/zero-range
Date: Thu, 17 Sep 2026 16:03:08 +0100
Message-ID: <20260917151545.745054852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



