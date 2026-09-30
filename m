Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941F552ED21;
	Wed, 30 Sep 2026 17:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789923; cv=none; b=rpViuitiArCC3jmgZgvgJ91P5TceerMxtm/JXyxCnGp5v+t+H4N2k4/+SCaegCspTrXcDhnnMM+VMK17J9wpLnaYnvhp0xz5nrXTgIQYD44jYTlUjsEAuYqeLS9mlA6R/RvQDRE6WHNOSz0tKfi/TrFjabBOaDIUlc4I7qGKMfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789923; c=relaxed/simple;
	bh=KKZF4qMEtjVM5shr6xxEq4ue/JfjPvCkcVZSsCw+L74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyvErHHbaKlNN1yD5Rwtbjn4Q5tNhJQq2rR5J/iWeqY3ayFcA+OVh6xfTq0cjJaXfS6SbSnqI0CuuiBJKB0P5n58N+rehYiqzywzZab9PqX6a9wf+UYxU5nP/fLS8pEhA2rDHgJxibjBFtYu49aZK0/bQPZ3hTJAvGq9wrnM6pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ea4flssV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ea4flssV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B0F1F000FF;
	Wed, 30 Sep 2026 17:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789922;
	bh=JxrjSYy739dsM5EpQcXpJKOzzOSkFjcJ4wnOLmA+O9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ea4flssVr1YiuXFM0ZQHr+arO11S0Rzn1zz/PQhXGAUdXzPfxMkORWU30XrIKFArI
	 kd+opwmQYht/SJtKRPjW1XFty4udSHTWLLoQeodCUMEHARlPL2u6raUgjR7Ql0QmIP
	 vQtkfPmbSRFcHJ4ovzwSEcXNxRA9zIAlHnalKR+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <me@linux.beauty>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 649/877] nvdimm: pmem: keep PREFLUSH before data writes
Date: Wed, 30 Sep 2026 17:26:00 +0200
Message-ID: <20260930152428.664636296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -209,8 +209,14 @@ static void pmem_submit_bio(struct bio *
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
@@ -230,7 +236,7 @@ static void pmem_submit_bio(struct bio *
 	if (do_acct)
 		bio_end_io_acct(bio, start);
 
-	if (bio->bi_opf & REQ_FUA)
+	if ((bio->bi_opf & REQ_FUA) && !bio->bi_status)
 		ret = nvdimm_flush(nd_region, bio);
 
 	if (ret)


