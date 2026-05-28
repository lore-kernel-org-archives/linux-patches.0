Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085E232ABC0;
	Thu, 28 May 2026 20:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999100; cv=none; b=YLFlRDZprBdslTOxztKlrah6X7ar9VvBAwhoAtCYCFYnl7EQhMmcaeKLdlgZTZzZaRgRy9fiiwWmZAlEfV7ACVoVIYS34oCJCzz1cki58kqsXlzEsZXfTz7TW7TlOe2fw873bhHl0fGC4y+hZBlNgP1hYHioeLMcCUEEZihJSz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999100; c=relaxed/simple;
	bh=nhdItg5uEHHj84//Ot4jGDLHeOe7Tp/DKFYC2/qjaoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iN3OEgH6fiCxfegpzaUzFTz1+G+ZEeaI1A4I1Sy/6Q3YpKtgKycFbBaWwxwlzuyPtBAJcyZ0Chz53qY3WodbcyrHv2229AKX+ZTpUM0wYpU9jRwMrlwE45CipmQHcJmpEDNKWwVyq3JDQA0J6zq6XPU8HwruiUVsgC3i5VH/yKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWyxYvfB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWyxYvfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6702F1F000E9;
	Thu, 28 May 2026 20:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999098;
	bh=8SHVmjlda9JpSZAytGm3ATR/brqp3GosRJEUACpzjso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWyxYvfB2d55Q6rAdBmc1E+W58PSUUfr0a/PB1hTG9O39zFqKdNMAlBjNur8b1n90
	 QEeyML8yS1cflfgAOCkImjynJoPnpyi57gQkfb3TFBeyv/RbKj3duepTk+WwYvXi/e
	 O012mMi5jX26z89k4TYOM1isqdIpptDUdvgp8Pqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 409/461] erofs: fix managed cache race for unaligned extents
Date: Thu, 28 May 2026 21:48:58 +0200
Message-ID: <20260528194659.323876947@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index fe8121df9ef2f..d7445e98312d8 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1511,8 +1511,15 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
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
@@ -1548,14 +1555,8 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
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



