Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FAF369985;
	Fri, 17 Oct 2025 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713724; cv=none; b=JB64s9IYXKb4OMSvh9EMRa3LAZl5Q/YQ4VQ8/CbjsIdnqxc5O58jgyNolDDlX8mSridxUQXuljnGLh6n0VaOTQkFXoCTbX8f3GrNMietO44E7lESTGD6oYyi02rGU3CmFWF+S+qNoYI01xAYe9IXB3YrroZZfHhWxxOek5IFWtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713724; c=relaxed/simple;
	bh=LWuxLdyMCdsgCgIN32Yv9/0I81MIDjsLi4fFOUyhyk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwN1Ecw/e9gxk3ADdJyKoUCYLdtuZAgnZiFMTzpSkbU58NO6f2dMmuGnldNMwyy3tm14qvAKL1+e5TkseU8DThzlo6z5XKUPXbIebmcDb87FIUPU0k2nQzZKy6SlhoyBbaO7/yVqkFOXK+8ggoUAJAaPHguf37r6U5M3yJA78F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAiAn/Fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAiAn/Fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C73C4CEF9;
	Fri, 17 Oct 2025 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713724;
	bh=LWuxLdyMCdsgCgIN32Yv9/0I81MIDjsLi4fFOUyhyk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAiAn/Fv60fOogo8neKugqmZxv0BJUqKMZqOjhxC2+j13XRp0jgc+A1A6nvtygnyx
	 4qJ11am1I3PE6JUlpEjNqvBEmWVd3ANgVTe3QTLVH+O1yop7Ss9hjJTLvs+YBpWyN+
	 uXoS5WmMMPZ1hymoNdT4pgL6tOHQVO+vQfBKb9a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 080/201] blk-crypto: fix missing blktrace bio split events
Date: Fri, 17 Oct 2025 16:52:21 +0200
Message-ID: <20251017145137.694188183@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 06d712d297649f48ebf1381d19bd24e942813b37 upstream.

trace_block_split() is missing, resulting in blktrace inability to catch
BIO split events and making it harder to analyze the BIO sequence.

Cc: stable@vger.kernel.org
Fixes: 488f6682c832 ("block: blk-crypto-fallback for Inline Encryption")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-crypto-fallback.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
+#include <trace/events/block.h>
 
 #include "blk-cgroup.h"
 #include "blk-crypto-internal.h"
@@ -229,7 +230,9 @@ static bool blk_crypto_fallback_split_bi
 			bio->bi_status = BLK_STS_RESOURCE;
 			return false;
 		}
+
 		bio_chain(split_bio, bio);
+		trace_block_split(split_bio, bio->bi_iter.bi_sector);
 		submit_bio_noacct(bio);
 		*bio_ptr = split_bio;
 	}


