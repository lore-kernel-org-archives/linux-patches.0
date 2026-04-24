Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5D43290A5;
	Fri, 24 Apr 2026 13:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038040; cv=none; b=s1xM7H1hIb4KzCGOB7SOwuPi7ji0H6By9mPk0pub1FI6zitlfIABz6WlmYhsYCYbeSZsMkgKYi0ZPrjdBrRHnvlxFe7jTi1n7YEZ3imMHGADhRHte7Ch09ZqaiHMWiqpTpvhA/p83kVKI8iNnzbiuE1opObAPSp0ffJZh+jMJZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038040; c=relaxed/simple;
	bh=YgtnnngoY19LRt/mRAs/q1RLe148VA2VWbMbdjTj2LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h/sWqqtjJOsd5c7EPpOxdR37jqqGowWf1gAjPZ77HNh178687RZHhuTC/5TyD5GU9eneNu1AMSPOnFuA1pbROaE0wefSe9CDodTLvyiR64CRnEfW9XWn+R6Y2bYeP3MhOQMuiYrjEwepXYiv0eu3oDXClxjETmzgiEf4YV+F0Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugSdV8kN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugSdV8kN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7564C19425;
	Fri, 24 Apr 2026 13:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038040;
	bh=YgtnnngoY19LRt/mRAs/q1RLe148VA2VWbMbdjTj2LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugSdV8kNzHZP6ICSuSAV5etwICccUYypOQtsO9hSvpvOOAZ+a2YvoWI5+0i2Ymlg6
	 2VCPtQF/yZAdVdpeK7u1wUFJtjzvoH50ImDtWwStXpRFrZy+BPf/4JrZsjUTfn+mYo
	 Va31y4+qXmqKNFmwKfeDz7csaFaQzNWZhi4UGvxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Saad <geoo115@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 156/166] f2fs: fix use-after-free of sbi in f2fs_compress_write_end_io()
Date: Fri, 24 Apr 2026 15:31:10 +0200
Message-ID: <20260424132605.833794255@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Saad <geoo115@gmail.com>

commit 39d4ee19c1e7d753dd655aebee632271b171f43a upstream.

In f2fs_compress_write_end_io(), dec_page_count(sbi, type) can bring
the F2FS_WB_CP_DATA counter to zero, unblocking
f2fs_wait_on_all_pages() in f2fs_put_super() on a concurrent unmount
CPU. The unmount path then proceeds to call
f2fs_destroy_page_array_cache(sbi), which destroys
sbi->page_array_slab via kmem_cache_destroy(), and eventually
kfree(sbi). Meanwhile, the bio completion callback is still executing:
when it reaches page_array_free(sbi, ...), it dereferences
sbi->page_array_slab — a destroyed slab cache — to call
kmem_cache_free(), causing a use-after-free.

This is the same class of bug as CVE-2026-23234 (which fixed the
equivalent race in f2fs_write_end_io() in data.c), but in the
compressed writeback completion path that was not covered by that fix.

Fix this by moving dec_page_count() to after page_array_free(), so
that all sbi accesses complete before the counter decrement that can
unblock unmount. For non-last folios (where atomic_dec_return on
cic->pending_pages is nonzero), dec_page_count is called immediately
before returning — page_array_free is not reached on this path, so
there is no post-decrement sbi access. For the last folio,
page_array_free runs while the F2FS_WB_CP_DATA counter is still
nonzero (this folio has not yet decremented it), keeping sbi alive,
and dec_page_count runs as the final operation.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Cc: stable@vger.kernel.org
Signed-off-by: George Saad <geoo115@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/compress.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1434,10 +1434,10 @@ void f2fs_compress_write_end_io(struct b
 
 	f2fs_compress_free_page(page);
 
-	dec_page_count(sbi, type);
-
-	if (atomic_dec_return(&cic->pending_pages))
+	if (atomic_dec_return(&cic->pending_pages)) {
+		dec_page_count(sbi, type);
 		return;
+	}
 
 	for (i = 0; i < cic->nr_rpages; i++) {
 		WARN_ON(!cic->rpages[i]);
@@ -1447,6 +1447,14 @@ void f2fs_compress_write_end_io(struct b
 
 	page_array_free(sbi, cic->rpages, cic->nr_rpages);
 	kmem_cache_free(cic_entry_slab, cic);
+
+	/*
+	 * Make sure dec_page_count() is the last access to sbi.
+	 * Once it drops the F2FS_WB_CP_DATA counter to zero, the
+	 * unmount thread can proceed to destroy sbi and
+	 * sbi->page_array_slab.
+	 */
+	dec_page_count(sbi, type);
 }
 
 static int f2fs_write_raw_pages(struct compress_ctx *cc,


