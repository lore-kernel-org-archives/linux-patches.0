Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C27815A853;
	Tue, 18 Jun 2024 13:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716736; cv=none; b=fmxEM35TFlKAmOhakOjKaSUKkzS7X58eSOIcJsgXf9x4qnXvN6Y1R0pDZLuygO3XCipaa484oDW9iZxVozcu33LzpBcctTOYqy6uJpAz9rTwC2ixr34tT+CBdY8SGBvCGjmjvzrIW1c5wrKatK1ArZD9NyhsUxcHk+KX2RvM9Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716736; c=relaxed/simple;
	bh=osE4KKMJHO0AVvdeBqDecK0Bh9mnTajtFtf4O6+2m/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dv2XcjqUz8yRh6kssqFs049eyYDXSnLMGp4dAYMC+jE6VpNEjHsMaIiK7wIbxZce8IyNRNzNOMfI3SZHpEi/X453dN1SSLeojBD0FCG4dv9iDTpjEM01kGVfyP+teQ5ckrG1YWDpUKL/87gdhwhInRpOFCCrA1204VYLle8XiJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0/oZ0Nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0/oZ0Nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81418C3277B;
	Tue, 18 Jun 2024 13:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716735;
	bh=osE4KKMJHO0AVvdeBqDecK0Bh9mnTajtFtf4O6+2m/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0/oZ0NwZzwbejZPhqP7lfW9wPfakoIfeQTn+dxqdPxBsX4JqmviQ10Yk3kLowphz
	 Y5uuTWeFoJsWKBBSQY9Xt0ZFV1dTL2ZETX8gT5JkQcPgLcgj7ZyLSuUujgbnTpQ7oF
	 DmE+Y8+TNqxurMmW/0IHjYuq7XcmuS1YD2pdeKv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 745/770] nfsd: NFSD_FILE_KEY_INODE only needs to find GCed entries
Date: Tue, 18 Jun 2024 14:39:58 +0200
Message-ID: <20240618123436.025541996@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 6c31e4c98853a4ba47355ea151b36a77c42b7734 ]

Since v4 files are expected to be long-lived, there's little value in
closing them out of the cache when there is conflicting access.

Change the comparator to also match the gc value in the key. Change both
of the current users of that key to set the gc value in the key to
"true".

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 677a8d935ccc2..4ddc82b84f7c4 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -174,6 +174,8 @@ static int nfsd_file_obj_cmpfn(struct rhashtable_compare_arg *arg,
 
 	switch (key->type) {
 	case NFSD_FILE_KEY_INODE:
+		if (test_bit(NFSD_FILE_GC, &nf->nf_flags) != key->gc)
+			return 1;
 		if (nf->nf_inode != key->inode)
 			return 1;
 		break;
@@ -694,6 +696,7 @@ nfsd_file_queue_for_close(struct inode *inode, struct list_head *dispose)
 	struct nfsd_file_lookup_key key = {
 		.type	= NFSD_FILE_KEY_INODE,
 		.inode	= inode,
+		.gc	= true,
 	};
 	struct nfsd_file *nf;
 
@@ -1048,6 +1051,7 @@ nfsd_file_is_cached(struct inode *inode)
 	struct nfsd_file_lookup_key key = {
 		.type	= NFSD_FILE_KEY_INODE,
 		.inode	= inode,
+		.gc	= true,
 	};
 	bool ret = false;
 
-- 
2.43.0



