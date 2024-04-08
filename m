Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2107CF34;
	Mon,  8 Apr 2024 13:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584007; cv=none; b=meLuPl6bTNqSuKvODbfaeF8yFPMftRqwqyhfoRBpeUYTTbCZtTWn1vH7ml4Xd00qeRj/VmL/9PfArqtfh843bGppapR3PlQPxMpNcAn4C1ITDR6CbMY4qQpP+8aqvX4AmgjhSW1xbruVg8+POF5SL6jjW9N6ZXEV4QB00X7VTYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584007; c=relaxed/simple;
	bh=8J4oDKbySQlTYMS/csrEa0R1frejEQWprLIVLr1CSuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fByoL/aPkyf50CoYTiCRklRrBBIih4ROfBypv7iRBJom0LAs3dFnZBuCpe2D1cpmxgEixdI3PjWti6B5kzUiK4n031Xrx5aQ1qXNnFaTn6bF8ezwr0kd1ycGuWsCCwFtw/1ieBlLCwmJ5Kl8TxjghAwI3LfXnmcYzqyJf6deR58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6+E4vTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6+E4vTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DD0C433F1;
	Mon,  8 Apr 2024 13:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584007;
	bh=8J4oDKbySQlTYMS/csrEa0R1frejEQWprLIVLr1CSuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6+E4vTg8px2FF/on095OX7+MwrQJr3vPD0hfTZN9dPp0DtWCfV1YjqWWJFfPQxr6
	 oJYnhizvtBOA/CNDYnliGUZZqOCo+amjpzOwiejVOoA5ng2ppbyhbKnya1VHlWzPHa
	 CqylFU8ZPozvduJSoj4EsWVsF2gXGE3WfeafTWyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 286/690] nfsd: Fix a write performance regression
Date: Mon,  8 Apr 2024 14:52:32 +0200
Message-ID: <20240408125409.975833879@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/nfsd/filecache.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 94157b82b60e1..6cde6ef68996e 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -229,6 +229,13 @@ nfsd_file_check_write_error(struct nfsd_file *nf)
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
@@ -296,11 +303,14 @@ nfsd_file_put(struct nfsd_file *nf)
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
@@ -321,6 +331,7 @@ nfsd_file_dispose_list(struct list_head *dispose)
 	while(!list_empty(dispose)) {
 		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
 		list_del(&nf->nf_lru);
+		nfsd_file_flush(nf);
 		nfsd_file_put_noref(nf);
 	}
 }
@@ -334,6 +345,7 @@ nfsd_file_dispose_list_sync(struct list_head *dispose)
 	while(!list_empty(dispose)) {
 		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
 		list_del(&nf->nf_lru);
+		nfsd_file_flush(nf);
 		if (!refcount_dec_and_test(&nf->nf_ref))
 			continue;
 		if (nfsd_file_free(nf))
-- 
2.43.0



