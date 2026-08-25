Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E2A3FF8BA;
	Tue, 25 Aug 2026 13:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664826; cv=none; b=scQTo8GnINateS3zeT37n3eykTKfuqJmflot3DgZMW7bjgwWEkbTiuXEk9K13qX8vBIbIeeX4SNcomsPZL51ZM8OiVM1MYmXcdjRoekSqsN70m0vdVd0no+8aTLOgLupYwEr984CxCEVkH7QbyfIXMBdFp5mwCn4NaizKQA8zmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664826; c=relaxed/simple;
	bh=iPHaSiBVgi6u/U5d1arU+2G8u+ltZ+NO+sLkDO3z7/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+mRTvFsI+IFELOCTkXtywHbqfePYskCWF6UQPQRPmEoCXrGRwpGWBdo2ceeyWoxYFFxV8vMYuVXetIGAlkG5VFCBGvyLoLh8+GH0KRzTSGs4nBrWxSQgrD3NhDYjsNbgmlqTH9mWIxlJyOMDzkxU9KV8hrLGyD2plThB41Scyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1DxFOnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1DxFOnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0021F00A3A;
	Tue, 25 Aug 2026 13:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664825;
	bh=T7WsqBso9/kwssmknBH2WvSY5iPfzARPH9sTMzXiY2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1DxFOnje73pBWsaXPPZUwlLYZ1IXcOfO+8b4SGiROSufHRGrSeoxDvXJjIMBI5Vl
	 wIwyeai69Hpjv9o28eYmdVrweWoUpQ9pCe6rxGoVcrEye3NB65wjEIpOtVtJKk+Ewb
	 9msw4C8iltXCHXO7F78gVTrdeDCKx6TeqA8UlrLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 018/101] io_uring/rsrc: fix folio size overflow in io_vec_fill_bvec()
Date: Tue, 25 Aug 2026 15:24:56 +0200
Message-ID: <20260825132542.715821277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

commit 3f3a6a16bbe8bde76532d9415438f8cdef439e5d upstream.

io_vec_fill_bvec() computes the folio size with a plain int 1:

	unsigned long folio_size = 1 << imu->folio_shift;

imu->folio_shift is unsigned int and comes from folio_shift() of the
folio backing the registered buffer, so it can be 32 or more on a 64 bit
kernel. Shifting int 1 that far is undefined, and on x86 and arm64 the
count is taken modulo 32, so a shift of 34 yields 4 rather than 16G.
Every other folio_shift shift in this file already uses 1UL.

The result is that the segment estimate and the fill loop disagree.
io_estimate_bvec_size() sizes the bvec array with the real shift:

	max_segs += (iov[i].iov_len >> shift) + 2;

so a 1M iovec on a 16G folio is charged 2 segments, while
io_vec_fill_bvec() then walks the same iovec in folio_size chunks of 4
bytes and writes res_bvec[bvec_idx] a quarter of a million times, past
the end of the array it was given. src_bvec is advanced once per
iteration as well, so imu->bvec is read past its end at the same time.
validate_fixed_range() only checks that the range is inside the
registered buffer and does not bound the segment count.

Reaching it needs a folio with a shift of at least 32, which means a
gigantic hugetlb page: 16G on arm64 with 64K pages, where
CONT_PMD_SHIFT is 34 and hugetlb_add_hstate(CONT_PMD_SHIFT - PAGE_SHIFT)
registers that size, and likewise on powerpc. x86_64 tops out at 1G, so
a shift of 30, which still fits in int and is unaffected.

Use 1UL, as the rest of the file does.

Fixes: 9ef4cbbcb4ac ("io_uring: add infra for importing vectored reg buffers")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Link: https://patch.msgid.link/20260802163030.51005-1-ali@iusegentoo.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1332,7 +1332,7 @@ static int io_vec_fill_bvec(int ddir, st
 				struct iovec *iovec, unsigned nr_iovs,
 				struct iou_vec *vec)
 {
-	unsigned long folio_size = 1 << imu->folio_shift;
+	unsigned long folio_size = 1UL << imu->folio_shift;
 	unsigned long folio_mask = folio_size - 1;
 	struct bio_vec *res_bvec = vec->bvec;
 	size_t total_len = 0;


