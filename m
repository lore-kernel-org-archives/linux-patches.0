Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EBE28A408;
	Wed, 23 Apr 2025 15:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420667; cv=none; b=oq3lTPHLfIOqZLO2y4usibZY07JXTWQQ6VAEQ/GmYT+jIhOY6v/HGb1izhSxjohNbeS0y6OIONDhxxrLSTyCCK/kTHQdOsVL8/xKpGAekbKC9bTQ3Sh+ZSKdUiS89wJU++Nhos8UEiDi+HWKjX4sA7BhaQEgofpPt99U4LDJ42M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420667; c=relaxed/simple;
	bh=fPI+XquWNzTsCzEZUGQWYPZy2e8oVJ7mg9mw4Jc62Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FehEEJ/sQVooF6MIyQl5cUC3M8kHlP3yAzxyXt4CXTyzhc2ZTz62CLZB2CICPp0v4CtrJ94kjEX2uTtg1IHKiNnKDVJqWk5Zd+cL2kElOSGIV5GZ99HJaKXzUEzu1t7cxUT2W167KwPAACzg8psCwOJbTJGC3dLTlzSh9yDIYq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEbs5Oug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEbs5Oug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E13C4CEE2;
	Wed, 23 Apr 2025 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420666;
	bh=fPI+XquWNzTsCzEZUGQWYPZy2e8oVJ7mg9mw4Jc62Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEbs5OugRKcZVwp7P7nrCbrfkYZsjlJXrXzkYgZmFxMgEhy1c16xUpl3wOscYrxaa
	 v5hVg2UrCMyUEA3t1p4rYta8IBDx5NCZdfhJ2MBcetQ/4/yfQCIiokxjo0IpgrzVrS
	 xuTck4KZdW3TWwI4MyhpAl1RsCs3+MSX7LO+7WRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 112/241] block: integrity: Do not call set_page_dirty_lock()
Date: Wed, 23 Apr 2025 16:42:56 +0200
Message-ID: <20250423142625.153518371@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin K. Petersen <martin.petersen@oracle.com>

commit 39e160505198ff8c158f11bce2ba19809a756e8b upstream.

Placing multiple protection information buffers inside the same page
can lead to oopses because set_page_dirty_lock() can't be called from
interrupt context.

Since a protection information buffer is not backed by a file there is
no point in setting its page dirty, there is nothing to synchronize.
Drop the call to set_page_dirty_lock() and remove the last argument to
bio_integrity_unpin_bvec().

Cc: stable@vger.kernel.org
Fixes: 492c5d455969 ("block: bio-integrity: directly map user buffers")
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/r/yq1v7r3ev9g.fsf@ca-mkp.ca.oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio-integrity.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -104,16 +104,12 @@ err:
 }
 EXPORT_SYMBOL(bio_integrity_alloc);
 
-static void bio_integrity_unpin_bvec(struct bio_vec *bv, int nr_vecs,
-				     bool dirty)
+static void bio_integrity_unpin_bvec(struct bio_vec *bv, int nr_vecs)
 {
 	int i;
 
-	for (i = 0; i < nr_vecs; i++) {
-		if (dirty && !PageCompound(bv[i].bv_page))
-			set_page_dirty_lock(bv[i].bv_page);
+	for (i = 0; i < nr_vecs; i++)
 		unpin_user_page(bv[i].bv_page);
-	}
 }
 
 static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
@@ -129,7 +125,7 @@ static void bio_integrity_uncopy_user(st
 	ret = copy_to_iter(bvec_virt(bounce_bvec), bytes, &orig_iter);
 	WARN_ON_ONCE(ret != bytes);
 
-	bio_integrity_unpin_bvec(orig_bvecs, orig_nr_vecs, true);
+	bio_integrity_unpin_bvec(orig_bvecs, orig_nr_vecs);
 }
 
 /**
@@ -149,8 +145,7 @@ void bio_integrity_unmap_user(struct bio
 		return;
 	}
 
-	bio_integrity_unpin_bvec(bip->bip_vec, bip->bip_max_vcnt,
-			bio_data_dir(bio) == READ);
+	bio_integrity_unpin_bvec(bip->bip_vec, bip->bip_max_vcnt);
 }
 
 /**
@@ -236,7 +231,7 @@ static int bio_integrity_copy_user(struc
 	}
 
 	if (write)
-		bio_integrity_unpin_bvec(bvec, nr_vecs, false);
+		bio_integrity_unpin_bvec(bvec, nr_vecs);
 	else
 		memcpy(&bip->bip_vec[1], bvec, nr_vecs * sizeof(*bvec));
 
@@ -357,7 +352,7 @@ int bio_integrity_map_user(struct bio *b
 	return 0;
 
 release_pages:
-	bio_integrity_unpin_bvec(bvec, nr_bvecs, false);
+	bio_integrity_unpin_bvec(bvec, nr_bvecs);
 free_bvec:
 	if (bvec != stack_vec)
 		kfree(bvec);


