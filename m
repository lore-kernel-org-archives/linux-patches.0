Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3851EF0AE;
	Tue,  3 Dec 2024 15:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239228; cv=none; b=VqnK7XfJCzZAwI4oDXq7b9UUJcLsYtI9Z+gxE8aRKAKxSWlF6AkG7BmQ1HZLPE2pJP5cvMLdK8W1xO1eXpBY9pH6KMA4hcotKCzQSyHzma3pTh6W277ZU2OZtij2gjgS0HTREIrriOAa8Osn1qcSx9vmj/y/bzOp2bS6hokXk/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239228; c=relaxed/simple;
	bh=UXgjru7CPt9c8NYYmHcKd0y/k0hAFrYc+H5AE1J4h9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZDZzw5XsTgdV/H5xbiowTh4P1ka/5MKyPyE1fIHAlEeN6NdbK5fq2Uy6ve2E2hZ8TjTeG9rItcCKfV/Tx432J7NrENgpjhNLnped6o26gdIdjwd3Vv6bLnsbJnZIKZ2zxtXvCli5+K/F5fpWru9Sg1haQA1q15ouby1ooFPfa0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvCUF1Uj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvCUF1Uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8E4C4CECF;
	Tue,  3 Dec 2024 15:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239228;
	bh=UXgjru7CPt9c8NYYmHcKd0y/k0hAFrYc+H5AE1J4h9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvCUF1UjviPe+BTRuxXy5TFrw+eyqdAxMlIg1YExa08D5i9QF/ujSm1ur+xtSVbmi
	 DlkSddVM0cA5UDhqkZNEAlO6cTtaynkVJ5INu/Z1dDYsmP3Wey0JwM+bb+mv0tJAMY
	 Vwht9Z/DAptrTQOiCbvmoWLiPCj5jG9SaMMLTB1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 510/817] f2fs: Fix not used variable index
Date: Tue,  3 Dec 2024 15:41:22 +0100
Message-ID: <20241203144015.780930860@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit 0c3a38a4b442893f8baca72e44a2a27d52d6cc75 ]

Fix the following compilation warning:
fs/f2fs/data.c:2391:10: warning: variable ‘index’ set but not used
[-Wunused-but-set-variable]
 2391 |  pgoff_t index;

Only define and set the variable index when the CONFIG_F2FS_FS_COMPRESSION
is enabled.

Fixes: db92e6c729d8 ("f2fs: convert f2fs_mpage_readpages() to use folio")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2354,10 +2354,10 @@ static int f2fs_mpage_readpages(struct i
 		.nr_cpages = 0,
 	};
 	pgoff_t nc_cluster_idx = NULL_CLUSTER;
+	pgoff_t index;
 #endif
 	unsigned nr_pages = rac ? readahead_count(rac) : 1;
 	unsigned max_nr_pages = nr_pages;
-	pgoff_t index;
 	int ret = 0;
 
 	map.m_pblk = 0;
@@ -2375,9 +2375,9 @@ static int f2fs_mpage_readpages(struct i
 			prefetchw(&folio->flags);
 		}
 
+#ifdef CONFIG_F2FS_FS_COMPRESSION
 		index = folio_index(folio);
 
-#ifdef CONFIG_F2FS_FS_COMPRESSION
 		if (!f2fs_compressed_file(inode))
 			goto read_single_page;
 


