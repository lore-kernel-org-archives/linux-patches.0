Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080E51581EF;
	Tue, 18 Jun 2024 13:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715971; cv=none; b=QSXZFqOpgjkSQB3AIzD/JXTwqwMPaNOgOYhjTU69yyILvLOExF0gFpRHLuqDYVKV3+o5T5hY5DunGaaglQecRET/LsnvuW0bo80K2aUC6n6FdGlm6TcmBhiBMokscGE14hUSp7tcgCNtjgcOaYFMzE0oh2NML5zs6c0Iw2jsFt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715971; c=relaxed/simple;
	bh=VGmQLwjOf6rzLQfYoNE1X9ozPkd3xl/s52MzvneK20E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJg+H1GdyG545lRnEqwmlEneCubtqyqLIljr15cUX1yPEfmiEKx/ebp1WwEUZLNiZlV5bUrKzaLlvpCp1MVhIFAgYnWGbZX35gvz0rNrlHYp4K987eq6MGcvsGANvPR+yeR3L8giJsLBHtNyx56oNf9kl4Lth3iJ4vRuxT4p/wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrlOSI9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrlOSI9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8035FC32786;
	Tue, 18 Jun 2024 13:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715970;
	bh=VGmQLwjOf6rzLQfYoNE1X9ozPkd3xl/s52MzvneK20E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrlOSI9QiNlSRfQ6SDtiTNIdS8wnWPe8I7XUzCs6dHj/tp0qIAC+SHMthqJ1lsCtp
	 t+lZ1YE8igdZC9MD5Jib0jBlZ4Wn4Jqx1jkEhkOti08xLAo0cr406ZRWW4WAOM6KUw
	 aQoNkgnjkFTOU9cP+TeFirdv2zbdJSMpQa6Jew/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 489/770] nfsd: Fix a write performance regression
Date: Tue, 18 Jun 2024 14:35:42 +0200
Message-ID: <20240618123426.191370250@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 6b8a94332ee4f7d9a8ae0cbac7609f79c212f06c ]

The call to filemap_flush() in nfsd_file_put() is there to ensure that
we clear out any writes belonging to a NFSv3 client relatively quickly
and avoid situations where the file can't be evicted by the garbage
collector. It also ensures that we detect write errors quickly.

The problem is this causes a regression in performance for some
workloads.

So try to improve matters by deferring writeback until we're ready to
close the file, and need to detect errors so that we can force the
client to resend.

Tested-by: Jan Kara <jack@suse.cz>
Fixes: b6669305d35a ("nfsd: Reduce the number of calls to nfsd_file_gc()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Link: https://lore.kernel.org/all/20220330103457.r4xrhy2d6nhtouzk@quack3.lan
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index cc2831cec6695..496f7b3f75237 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -235,6 +235,13 @@ nfsd_file_check_write_error(struct nfsd_file *nf)
 	return filemap_check_wb_err(file->f_mapping, READ_ONCE(file->f_wb_err));
 }
 
+static void
+nfsd_file_flush(struct nfsd_file *nf)
+{
+	if (nf->nf_file && vfs_fsync(nf->nf_file, 1) != 0)
+		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
+}
+
 static void
 nfsd_file_do_unhash(struct nfsd_file *nf)
 {
@@ -302,11 +309,14 @@ nfsd_file_put(struct nfsd_file *nf)
 		return;
 	}
 
-	filemap_flush(nf->nf_file->f_mapping);
 	is_hashed = test_bit(NFSD_FILE_HASHED, &nf->nf_flags) != 0;
-	nfsd_file_put_noref(nf);
-	if (is_hashed)
+	if (!is_hashed) {
+		nfsd_file_flush(nf);
+		nfsd_file_put_noref(nf);
+	} else {
+		nfsd_file_put_noref(nf);
 		nfsd_file_schedule_laundrette();
+	}
 	if (atomic_long_read(&nfsd_filecache_count) >= NFSD_FILE_LRU_LIMIT)
 		nfsd_file_gc();
 }
@@ -327,6 +337,7 @@ nfsd_file_dispose_list(struct list_head *dispose)
 	while(!list_empty(dispose)) {
 		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
 		list_del(&nf->nf_lru);
+		nfsd_file_flush(nf);
 		nfsd_file_put_noref(nf);
 	}
 }
@@ -340,6 +351,7 @@ nfsd_file_dispose_list_sync(struct list_head *dispose)
 	while(!list_empty(dispose)) {
 		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
 		list_del(&nf->nf_lru);
+		nfsd_file_flush(nf);
 		if (!refcount_dec_and_test(&nf->nf_ref))
 			continue;
 		if (nfsd_file_free(nf))
-- 
2.43.0



