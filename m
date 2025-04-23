Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8789E18DB17;
	Wed, 23 Apr 2025 14:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420047; cv=none; b=hQX3NaMywRsueJOoVAHht9NfusBOwogFlnI6/qOKaMitzCBd0eAFj6T4olIYIveJCKrGw9BqzDOmlE6qtMufImzTxXVdJfH+7qBb2y7AiMilSO/Lfd1V/E/MiMWIMIoscJ0h081qWNh9qtEthg3g4zhcuie4krdL0cuYOvgInv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420047; c=relaxed/simple;
	bh=6FcaOJksybvfKCdmHltqmjceaT/NCRs+twjXBj9ayRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2eDrwu0ER58FgkDSrAmFZ+tu2Sd3iTdiT/0P8Y44Ony8CxNTHepARIDeB8RsGWKOaIZ3ekT2+kDD8klDKJla+hj1PTufwlBvgZ+jkU2xg08hOxjB0DcdlAnwz7N5vKVjx69BHVR4AKbbKKgJKitvy3T+zDcFQKWpuDmnOnJuto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6SrgzOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6SrgzOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1901BC4CEE2;
	Wed, 23 Apr 2025 14:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420047;
	bh=6FcaOJksybvfKCdmHltqmjceaT/NCRs+twjXBj9ayRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6SrgzOzVSt+qzAq2saOeHNcgej3N5wMxb8DwD/kJUVCb5qRmFYfbw8fbBRK3uV2z
	 rGUHkIZ7Z3BOFPQlkZjZRjySa8olMaSLdGqXI8hIO6f1/qty11mqygF8Z12yzwm1hk
	 aWFhobis6VKf0/OfU+Ic8dNzutSRgVf25As1gcQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 095/223] block: integrity: Do not call set_page_dirty_lock()
Date: Wed, 23 Apr 2025 16:42:47 +0200
Message-ID: <20250423142620.988311699@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -362,7 +357,7 @@ int bio_integrity_map_user(struct bio *b
 	return 0;
 
 release_pages:
-	bio_integrity_unpin_bvec(bvec, nr_bvecs, false);
+	bio_integrity_unpin_bvec(bvec, nr_bvecs);
 free_bvec:
 	if (bvec != stack_vec)
 		kfree(bvec);


