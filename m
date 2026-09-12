Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BA747DFB9;
	Sat, 12 Sep 2026 13:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219464; cv=none; b=os7FNGI92e+aUw9CnUCMFREFvXNpLEUsDF0/KTclqQ+XjecaysEpeV6TGXD/wC3V/mD3rtyYO1cDdWQiKN/ZRfM+iVzIUuOFMrB510jGe9AgNJz/kdKT+X5FYrX1MatXGRHuH4ZvimKm5ze/T2VkJqCx/gGWSSqOB1Pik8+AP6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219464; c=relaxed/simple;
	bh=H/vQG8Vt9YGh3SiDmdwL29cUjS8ptUMyWIHD69kw8SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5p+LT7SLjXdxtltoPverZG7gSLluOs7C5fApXQdDGVy97LnslMi2bZ+RIX1XnY1uDMXCoMhFtoRFRgFKtfi/JNzgRJpD0vJJYG2SOZTaEvicSh8Eq4LlS9xgdStxPnkgC1qR+BapBNjlotFRv63wGbGq1UtavVpreI5IkbuI7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SA2jZ3RR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SA2jZ3RR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E02D1F000FF;
	Sat, 12 Sep 2026 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219463;
	bh=/DsR6LDHeeN8oWvFvt5Dk9YSg+Xsnh+e1xhSqu08nA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SA2jZ3RRiWlVEvfm0B4y7t3SKsu4YzCzLEPKFSYeDJ3Ez2ACXHMuxR9JOF+GWMu/m
	 PHZ9QI9L0ErPWLZt6NAVfY+wX8dQeQguOfrxuxQPRhODEuoG9s5EbMSJWwyqVw5O4L
	 S4tjYy/tR6x4a3th2tMT5lPSRQlQ1qSj3SqmOZX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1357/1376] erofs: fix managed cache race for unaligned extents
Date: Sat, 12 Sep 2026 09:03:03 +0200
Message-ID: <20260912065637.777469069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 649932fc3815eda2f24eb4de4b3a5e94886ee0b9 ]

After unaligned compressed extents were introduced, the following race
could occur:

[Thread 1]                                   [Thread 2]
(z_erofs_fill_bio_vec)
<handle a Z_EROFS_PREALLOCATED_FOLIO folio>
...
filemap_add_folio (1)
                                             (z_erofs_bind_cache)
                                             <the same folio is found..>
                                             ..
                                             ..
folio_attach_private (2)
                                             filemap_add_folio (3) again

Since (1) is executed but (2) hasn't been executed yet, it's possible
that another thread finds the same managed folio in z_erofs_bind_cache()
for a different pcluster and calls filemap_add_folio() again since
folio->private is still Z_EROFS_PREALLOCATED_FOLIO.

Fix this by explicitly clearing folio->private before making the folio
visible in the managed cache so that another pcluster can simply wait
on the locked managed folio as what we did for other shared cases [1].

This only impacts unaligned data compression (`-E48bit` with zstd,
for example).

[1] Commit 9e2f9d34dd12 ("erofs: handle overlapped pclusters out of
 crafted images properly") was originally introduced to handle crafted
 overlapped extents, but it addresses unaligned extents as well.

Fixes: 7361d1e3763b ("erofs: support unaligned encoded data")
Reported-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Closes: https://lore.kernel.org/r/4a2f3801-fac1-42fe-ae75-da315822e088@salutedevices.com
Tested-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index eab5a8eed8486..d36562c4afff7 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1478,8 +1478,15 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
 	DBG_BUGON(z_erofs_is_shortlived_page(bvec->bv_page));
 
 	folio = page_folio(zbv.page);
-	/* For preallocated managed folios, add them to page cache here */
+	/*
+	 * Preallocated folios are added to the managed cache here rather than
+	 * in z_erofs_bind_cache() in order to keep these folios locked in
+	 * increasing (physical) address order.
+	 * Clear folio->private before these folios become visible to others in
+	 * the managed cache to avoid duplicate additions for unaligned extents.
+	 */
 	if (folio->private == Z_EROFS_PREALLOCATED_FOLIO) {
+		folio->private = NULL;
 		tocache = true;
 		goto out_tocache;
 	}
@@ -1515,14 +1522,8 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
 			}
 			return;
 		}
-		/*
-		 * Already linked with another pcluster, which only appears in
-		 * crafted images by fuzzers for now.  But handle this anyway.
-		 */
-		tocache = false;	/* use temporary short-lived pages */
 	} else {
 		DBG_BUGON(1); /* referenced managed folios can't be truncated */
-		tocache = true;
 	}
 	folio_unlock(folio);
 	folio_put(folio);
-- 
2.53.0



