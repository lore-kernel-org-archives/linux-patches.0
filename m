Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B57D3054E4;
	Sat, 12 Sep 2026 07:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196715; cv=none; b=aGLHiHCpmrY50skti/da8474vrTpkE7ppggBGECQoJYOCZeqbnGGRftgCWYMZXo5YoxwWT9/b/vtxgw9jzkc+sga+WYu05opuFVuOaTTOEKlsu2uC5UwI1I9xKzK6KQM6hCZhgzQ4fGsQBo2aecEngfvvpouhchutcYHgu+RQyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196715; c=relaxed/simple;
	bh=WMmTS5lfS2kn0RT2ebGX/Osh+6xgu1wU/sQY0s20IiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+Af+oPmRd6nZknFJCR46+BM1TOzAQWISFw+xvCrvJRXLoXkBOVYl/2nmn7RFrNAQCnRx8Cwu4FiqdSflEZ14UCYIAYwTo0HP22RckHrhdhTnuDZnD1ZtA834pttct8CbwNAHRkzBu/rZMNXhHwtlHIRJUW6wM2X6xzzFu9Ziu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjUwKBD+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjUwKBD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E701F000FF;
	Sat, 12 Sep 2026 07:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196713;
	bh=bE3dn8mb/Gfn4PFqbDSwL1AA2Vat+qYXTqFG7dyv0fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjUwKBD+IUA/JAtLHFbO7RieYnibDzwtav+eqX4i7py1fKWNVVy3G8eG8p2C1ntUC
	 /Wh/tmbT72KEIrbakTzGpkex0BpLBR1ysNKHH+QQ3/9zyNQflVcxHplN9dC0KGCJ7+
	 FlBndTV2/FfDnUysomVNqhUvFpqITWM9Dq+F/9lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <me@linux.beauty>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0022/1815] nvdimm: pmem: keep PREFLUSH before data writes
Date: Sat, 12 Sep 2026 08:29:32 +0200
Message-ID: <20260912065649.528482263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


