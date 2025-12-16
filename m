Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE54350D57;
	Tue, 16 Dec 2025 12:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886461; cv=none; b=iiDUS4KU5jA4pqyX+A1ZKbLoM7JfExaKCxmZZ4j3bxSmDJ9ECwAUfbJIrRQv0QbQfIgKYO9WHIriMnhysrWsuRBnR1HkfyDcSYRvFGcJY0o7y3pPxb6+t9Z5IZ22lEavWP2rYEAwB0i3LmYtlYlcA9tTfWmd/axDsgOOjIRI5II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886461; c=relaxed/simple;
	bh=RBeVvGoavneNbgmv9t5LDDxUJ3UOu3ck6SljcvGYnhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgSjwhKcwHf5xLLfsuFjwVzyleGsFHNlq7AWwkCKdjw2hwjwKGzgnQ+SGh4Gf0NY+yEWlN0ybG7g+Hqby1ZT1+I1GKbi52Re3xKzHL29vxHd6NH1eZcVfrbr8zbijF9Lhzsikqggs6zdaMaHG90iHXOTxX+9F1mMQJug/DOs/o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3Ysw18f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3Ysw18f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C799BC4CEF1;
	Tue, 16 Dec 2025 12:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886461;
	bh=RBeVvGoavneNbgmv9t5LDDxUJ3UOu3ck6SljcvGYnhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3Ysw18f3HSVdzQweLyXr6ivS9zy1F2p3td5Kvj4mDCKVWGH93GEKBsbrSCUVSgZt
	 TS5JdPcuCQPOKwA1DbK4wDHjX8WY8Es5/cUYbXc5sKP4CbmIFFT9ir28Lxo2rW3QS5
	 EEo0XteHXavGzMc35BNOtk3MOk//tPS6rrfd/1qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Stoler <michael.stoler@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 443/507] NFS: Initialise verifiers for visible dentries in nfs_atomic_open()
Date: Tue, 16 Dec 2025 12:14:44 +0100
Message-ID: <20251216111401.505670844@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 518c32a1bc4f8df1a8442ee8cdfea3e2fcff20a0 ]

Ensure that the verifiers are initialised before calling
d_splice_alias() in nfs_atomic_open().

Reported-by: Michael Stoler <michael.stoler@vastdata.com>
Fixes: 809fd143de88 ("NFSv4: Ensure nfs_atomic_open set the dentry verifier on ENOENT")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 4f93c3059c566..c0b4d24e95bd5 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2144,12 +2144,12 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 		d_drop(dentry);
 		switch (err) {
 		case -ENOENT:
-			d_splice_alias(NULL, dentry);
 			if (nfs_server_capable(dir, NFS_CAP_CASE_INSENSITIVE))
 				dir_verifier = inode_peek_iversion_raw(dir);
 			else
 				dir_verifier = nfs_save_change_attribute(dir);
 			nfs_set_verifier(dentry, dir_verifier);
+			d_splice_alias(NULL, dentry);
 			break;
 		case -EISDIR:
 		case -ENOTDIR:
-- 
2.51.0



