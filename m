Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE5623AB86;
	Thu,  3 Jul 2025 15:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554918; cv=none; b=QzCUPqEyZ2n9JDJEZQ4pOeBL93mNdW5OoxFt3sV4K/tWHSSJpiTsaPT0y9Kvqi7imvFxEnqOuuLOQ9uFY/E1vkf0xl999CegfYKfgjBrTH/nEcJ0HfE+xe8h6Jiwh4TxaBFQIQw6b+OAi+WFbMikWpx8ms0rhAJpQpBwRICgZHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554918; c=relaxed/simple;
	bh=QJ3E3kI5D9KvopuaF/OMPhxcMPT/9+qe4CVUsoK45nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ni2J/a25+xbk6K8nq/pXavKLork9ylnsMSsuAPT66Z8EmMNgTlmPe7B1hmg/VM5mTJ/i9fivsZhuZTlGdNNRHoRSfuX8KARLlE4Ozf3a3Uhk6qqqdpWq5wNHJEUuDM2nqC34c9Hr5n1+jO9d0GSXXXxmgcKS1U/sLDAFPhvdg/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWpgxEMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWpgxEMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE537C4CEE3;
	Thu,  3 Jul 2025 15:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554918;
	bh=QJ3E3kI5D9KvopuaF/OMPhxcMPT/9+qe4CVUsoK45nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWpgxEMSNMBMdnOyRGWy0jYdr8/zBs4BImD5Qzm2vLs1kMes498jO44/25oejTTkh
	 ZEC60OLYEbQaXOxlh0VJEVGvD4XqhW1IDWogOtoTHB+SCYayylgIAxMcLLI/qdUisu
	 4FRGeQ0T1cPMQJNi0U+3/JfKLqJO9PgVITPbiTZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 119/263] io_uring: dont assume uaddr alignment in io_vec_fill_bvec
Date: Thu,  3 Jul 2025 16:40:39 +0200
Message-ID: <20250703144009.127486961@linuxfoundation.org>
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

commit e1d7727b73a1f78035316ac35ee184d477059f0b upstream.

There is no guaranteed alignment for user pointers. Don't use mask
trickery and adjust the offset by bv_offset.

Cc: stable@vger.kernel.org
Reported-by: David Hildenbrand <david@redhat.com>
Fixes: 9ef4cbbcb4ac3 ("io_uring: add infra for importing vectored reg buffers")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/io-uring/19530391f5c361a026ac9b401ff8e123bde55d98.1750771718.git.asml.silence@gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index afc67530f912..f2b31fb68992 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1339,7 +1339,6 @@ static int io_vec_fill_bvec(int ddir, struct iov_iter *iter,
 {
 	unsigned long folio_size = 1 << imu->folio_shift;
 	unsigned long folio_mask = folio_size - 1;
-	u64 folio_addr = imu->ubuf & ~folio_mask;
 	struct bio_vec *res_bvec = vec->bvec;
 	size_t total_len = 0;
 	unsigned bvec_idx = 0;
@@ -1361,8 +1360,13 @@ static int io_vec_fill_bvec(int ddir, struct iov_iter *iter,
 		if (unlikely(check_add_overflow(total_len, iov_len, &total_len)))
 			return -EOVERFLOW;
 
-		/* by using folio address it also accounts for bvec offset */
-		offset = buf_addr - folio_addr;
+		offset = buf_addr - imu->ubuf;
+		/*
+		 * Only the first bvec can have non zero bv_offset, account it
+		 * here and work with full folios below.
+		 */
+		offset += imu->bvec[0].bv_offset;
+
 		src_bvec = imu->bvec + (offset >> imu->folio_shift);
 		offset &= folio_mask;
 
-- 
2.50.0



