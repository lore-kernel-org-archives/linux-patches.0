Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473F638F91;
	Thu,  3 Jul 2025 15:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554915; cv=none; b=TfWAz2AmDdXb6ddBvXIj5vCuqffBrTckscMY/Mfl2eIjUO60qwodzz0o3KLXpRc2qNxwnsPX4VUUDoxs8Dv7K03KWhZpioMEK5VAYonFVRTJHeCBdRS0/Rb+7vpie9jD0xEQo1mI4bW11aGM8eq1NUJRdPd7SwzvUk0epU9iWc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554915; c=relaxed/simple;
	bh=98v3aOt1yABcPc/Miy/zNvx6el3GTa6CbIi2Z1srxT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYxG8lzLHUKOFcvkLYEV359IQyUItFQ848WL67PHNHGBq516yfs0xbwuvouEc4YpmdQ6wvkAQiAu36cz5auLP/baYJRHLWZGrJsaljDschYdXa4eI4dAkg8zJm5ziNLRhZ2E6lNu4xwE93p+Omz1pA696GlsLDu8OuVIspNkTdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHgNHrNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHgNHrNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEBCC4CEE3;
	Thu,  3 Jul 2025 15:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554915;
	bh=98v3aOt1yABcPc/Miy/zNvx6el3GTa6CbIi2Z1srxT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHgNHrNgB/Oct/YE3K7O2usZu0Qj0dBBRF1iw359i8irWz2ryJlBCzi9VG7juNsZi
	 qD5SXspVbmqiR3pALfJDRXtctAmHKRkD43CgrvUgUUjjpD884p/YxFpFAmKOOsHZ3H
	 kRMK9o2elw1Ax/BpK+G57CszNuhBw9s2LYc21wg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 118/263] io_uring/rsrc: dont rely on user vaddr alignment
Date: Thu,  3 Jul 2025 16:40:38 +0200
Message-ID: <20250703144009.088988253@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 3a3c6d61577dbb23c09df3e21f6f9eda1ecd634b upstream.

There is no guaranteed alignment for user pointers, however the
calculation of an offset of the first page into a folio after coalescing
uses some weird bit mask logic, get rid of it.

Cc: stable@vger.kernel.org
Reported-by: David Hildenbrand <david@redhat.com>
Fixes: a8edbb424b139 ("io_uring/rsrc: enable multi-hugepage buffer coalescing")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/io-uring/e387b4c78b33f231105a601d84eefd8301f57954.1750771718.git.asml.silence@gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    7 ++++++-
 io_uring/rsrc.h |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -738,6 +738,7 @@ bool io_check_coalesce_buffer(struct pag
 
 	data->nr_pages_mid = folio_nr_pages(folio);
 	data->folio_shift = folio_shift(folio);
+	data->first_folio_page_idx = folio_page_idx(folio, page_array[0]);
 
 	/*
 	 * Check if pages are contiguous inside a folio, and all folios have
@@ -831,7 +832,11 @@ static struct io_rsrc_node *io_sqe_buffe
 	if (coalesced)
 		imu->folio_shift = data.folio_shift;
 	refcount_set(&imu->refs, 1);
-	off = (unsigned long) iov->iov_base & ((1UL << imu->folio_shift) - 1);
+
+	off = (unsigned long)iov->iov_base & ~PAGE_MASK;
+	if (coalesced)
+		off += data.first_folio_page_idx << PAGE_SHIFT;
+
 	node->buf = imu;
 	ret = 0;
 
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -49,6 +49,7 @@ struct io_imu_folio_data {
 	unsigned int	nr_pages_mid;
 	unsigned int	folio_shift;
 	unsigned int	nr_folios;
+	unsigned long	first_folio_page_idx;
 };
 
 bool io_rsrc_cache_init(struct io_ring_ctx *ctx);


