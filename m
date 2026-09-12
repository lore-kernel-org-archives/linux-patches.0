Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017E134252D;
	Sat, 12 Sep 2026 09:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205886; cv=none; b=E1YSdgf14nhnnuUN3XbsE0173numKzV1jCCLWjYGGiaqelkkmfOvZQYrcIbOZCOa+JrSAPCU+HX6pFfau8NRzTjg+KO3pkcbIsteOhW6ucpJ73VQrkHirfZgl6ypMPOoqMfoe9U56I66IYPqE4aX249lQluNO9d0kPB+2SgFaAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205886; c=relaxed/simple;
	bh=L+9Fy52SrHkEnmgIX7f4NHY6e+MxpnU2pDHZH8uez8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q97l1WUZHhkxhUdFlFkL2x2Tadnpm30Ci7smHx4vq3dTtuFE84++lDCZ1tisR7MtlSm6ybf33VTia094gp+fO5eoz/8J4y386LCVaHrroUt6++HVV5kUBFWijwz9P9zOtlMRxyZb3LZ1vtXYb4J/ul/p3Lk9TGneyQ705g5YaPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDFTmwkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDFTmwkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C944E1F000FF;
	Sat, 12 Sep 2026 09:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205884;
	bh=Ol4TVK7U8mkhUqO1UtfnRcFn1lVQkln7e8RtlpCKFeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDFTmwkH//uIptLQhXbae4cVP3LsyHGLH68HsXAh7hlFwgYfxNMKIeRKIiAbxhIZ0
	 m3soKPCOYpVYNjRVADwUNtznVJe+pbKow5Zx6iKTc1rhuqIcFdP0ZtvqwHVLPtHc9g
	 ZBYdWSdG6EEt7fOrV9+BKZa7lU+fJwdD9doREpzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <me@linux.beauty>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0050/1518] nvdimm: pmem: keep PREFLUSH before data writes
Date: Sat, 12 Sep 2026 08:36:59 +0200
Message-ID: <20260912065624.573667501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Chen <me@linux.beauty>

[ Upstream commit c644a2f8fef5618fcf453c591177700fd07dd024 ]

pmem_submit_bio() records a REQ_PREFLUSH error, but continues to copy the
bio data and can later overwrite the error with a successful REQ_FUA flush.
That lets data writes run after a failed preflush and can complete the bio
successfully despite the failed ordering barrier.

Run the REQ_PREFLUSH flush synchronously before touching the bio data and
complete the bio with the flush error if it fails. Keep asynchronous flush
chaining for REQ_FUA. At that point, data copy has completed and the parent
bio can wait for the chained flush bio.

Signed-off-by: Li Chen <me@linux.beauty>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260630092338.2094628-3-me@linux.beauty>
Stable-dep-of: e57140944b5a ("nvdimm: virtio_pmem: refcount requests for token lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/pmem.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -208,8 +208,14 @@ static void pmem_submit_bio(struct bio *
 	struct pmem_device *pmem = bio->bi_bdev->bd_disk->private_data;
 	struct nd_region *nd_region = to_region(pmem);
 
-	if (bio->bi_opf & REQ_PREFLUSH)
-		ret = nvdimm_flush(nd_region, bio);
+	if (bio->bi_opf & REQ_PREFLUSH) {
+		ret = nvdimm_flush(nd_region, NULL);
+		if (ret) {
+			bio->bi_status = errno_to_blk_status(ret);
+			bio_endio(bio);
+			return;
+		}
+	}
 
 	do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
 	if (do_acct)
@@ -229,7 +235,7 @@ static void pmem_submit_bio(struct bio *
 	if (do_acct)
 		bio_end_io_acct(bio, start);
 
-	if (bio->bi_opf & REQ_FUA)
+	if ((bio->bi_opf & REQ_FUA) && !bio->bi_status)
 		ret = nvdimm_flush(nd_region, bio);
 
 	if (ret)


