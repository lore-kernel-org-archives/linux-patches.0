Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABD3A93C;
	Tue, 13 Feb 2024 17:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846037; cv=none; b=lkD4xOwA+bd8pfO7lB6Vqvf50KQlRbwkcLZ1hG/yPALatyBCfCHB61lGIGQneAda9TLQYtkktEqnwVyqmlO61AAJr8FhGMb7sDImSWTAKlihTMvjESfSnUcdZdePSfIOADnr/YHRFZH++BLWs5meJGcV48u6z+BlI2ljd+esLVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846037; c=relaxed/simple;
	bh=9wbDvHbYt1fM8IPNgoGj20V6y5WyxuWMF7y1RJgDAcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2p5Hf7NcSAHb4HYhO2PNPxKeDer3g6m7TutCBAO6DScHklIpIDgPV7Z4CgA/XyWyHQ9pmS6X74B1kzZ1iiP9GJl633TmrKEu7bqtWCHz9qu7VGC0a4dCUH3lngiw7UbrHjL5bfLqZaBKJWTFH6tTa6PwHHWKpCrSvkp6RiG9EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pZupU28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pZupU28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6539AC433C7;
	Tue, 13 Feb 2024 17:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707846036;
	bh=9wbDvHbYt1fM8IPNgoGj20V6y5WyxuWMF7y1RJgDAcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pZupU28P8Gfsdzy/Z3i7+Yratf3fOX/7a5FvZ9kb7N0SEE18U10thEKE5pGTcF61
	 RATla0G9vvEbQ3mRdo+C2GrzhL+gqpOCv+Nq+KRu0abpANolbjHdyDIZ9dZMbKtrLj
	 Dcu5nEx4zCnsXTBeMtYj5yea9UF9rgD2nmU08pSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.7 118/124] bcachefs: fix incorrect usage of REQ_OP_FLUSH
Date: Tue, 13 Feb 2024 18:22:20 +0100
Message-ID: <20240213171857.176391369@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 3e44f325f6f75078cdcd44cd337f517ba3650d05 upstream.

REQ_OP_FLUSH is only for internal use in the blk-mq and request based
drivers. File systems and other block layer consumers must use
REQ_OP_WRITE | REQ_PREFLUSH as documented in
Documentation/block/writeback_cache_control.rst.

While REQ_OP_FLUSH appears to work for blk-mq drivers it does not
get the proper flush state machine handling, and completely fails
for any bio based drivers, including all the stacking drivers.  The
block layer will also get a check in 6.8 to reject this use case
entirely.

[Note: completely untested, but as this never got fixed since the
original bug report in November:

   https://bugzilla.kernel.org/show_bug.cgi?id=218184

and the the discussion in December:

    https://lore.kernel.org/all/20231221053016.72cqcfg46vxwohcj@moria.home.lan/T/

this seems to be best way to force it]

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/fs-io.c      |    2 +-
 fs/bcachefs/journal_io.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -79,7 +79,7 @@ void bch2_inode_flush_nocow_writes_async
 			continue;
 
 		bio = container_of(bio_alloc_bioset(ca->disk_sb.bdev, 0,
-						    REQ_OP_FLUSH,
+						    REQ_OP_WRITE|REQ_PREFLUSH,
 						    GFP_KERNEL,
 						    &c->nocow_flush_bioset),
 				   struct nocow_flush, bio);
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1948,7 +1948,8 @@ CLOSURE_CALLBACK(bch2_journal_write)
 			percpu_ref_get(&ca->io_ref);
 
 			bio = ca->journal.bio;
-			bio_reset(bio, ca->disk_sb.bdev, REQ_OP_FLUSH);
+			bio_reset(bio, ca->disk_sb.bdev,
+				  REQ_OP_WRITE|REQ_PREFLUSH);
 			bio->bi_end_io		= journal_write_endio;
 			bio->bi_private		= ca;
 			closure_bio_submit(bio, cl);


