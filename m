Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E332A408031;
	Tue, 25 Aug 2026 13:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664583; cv=none; b=rUr3+9BTODwik0cDZgsoY0YjRjUi+VX5jV4IgOx5Tbdy0uyiqsHF3zflJZF11k0b5pOJYIur1Zry8cxY6OW/SO4GuzqGU8KdtKXvn/zxy11Bq0BSjZS1X1qVxGYE+7pFNbeULR53tNfT/kW996cTI7a9M0fb1OIsGLmvLug9Kd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664583; c=relaxed/simple;
	bh=E33wT3EczOxSZBfscClqqSYhdyNnMmC4hsK4+t8EycE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUfiUalxx6L5sMZVl7YLslmgV0thyWUvw+Qulipse+NzH2hz/+OJV93ahU0eHo7TkM+FHvgWQR7DgJb3ijZE+cY63QNGmsms0oVWU8OtIu7mtqzhgB1fSml7S5pczxIFcZmDJaBjBJLG/KcCAsvZS9vbHmuifvVwJ6OjJ8/u6yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/Rexgg6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/Rexgg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F9D1F000E9;
	Tue, 25 Aug 2026 13:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664581;
	bh=CfNDtrbTLOr3i7grQEQ+0nRYGaguw8/DPFohrGi+kuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/Rexgg6adQbzQsq0lXWKEXGV2ideNUcuhDAQnMKMaWwz4Ie7z1yK8WJGhjcsxJAe
	 uQZcsGoqnPxXZGed3hzl7jGvIjpxWt15kqJ74dNxD42AZVEGjk5JAKDu3y7jzUaBEW
	 VIa+wilbuTYfx4M5/URB1i9CvxB7Be+Tk+psJ9ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 19/82] io_uring/rsrc: fix folio size overflow in io_vec_fill_bvec()
Date: Tue, 25 Aug 2026 15:25:06 +0200
Message-ID: <20260825132542.278828241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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
@@ -1477,7 +1477,7 @@ static int io_vec_fill_bvec(int ddir, st
 				struct iovec *iovec, unsigned nr_iovs,
 				struct iou_vec *vec)
 {
-	unsigned long folio_size = 1 << imu->folio_shift;
+	unsigned long folio_size = 1UL << imu->folio_shift;
 	unsigned long folio_mask = folio_size - 1;
 	struct bio_vec *res_bvec = vec->bvec;
 	size_t total_len = 0;


