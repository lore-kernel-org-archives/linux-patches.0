Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C57824A3;
	Mon, 28 Oct 2024 06:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098469; cv=none; b=F0ifjcmSpSTtqDOmuYAhvqXXaWSv903RVELaIKhlGFwnBoQOkrkBGkHrHOGKWlvn5dcV1YfsTltDLaXkbOPFkiHeyVLcq9NXUw4ubf09x6eV9PDjiD0Ao2lADxabfTnpWGKfMmbAOKMS7L6IAm2nsh+DyFpZ2gpOVPn0rUdqAY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098469; c=relaxed/simple;
	bh=N0TEKEpbDJ4QsO0llCz/MOg4wfffMVa4eqhJSmpgq3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UP+ZUV8zkHPbaCOStKBtQSCgSqJhoG+0SJ/EPV6xJtY7psKqm9qdIVGX6HHKDi6YK7sRV1RgEt3BzeqV3RnNeiqerYL855Z5Je1ObHs0GjGW6wqYzwIMD2T8V7ZhPQWqKX4knc3vZPr3lQ5o0uPcSrzzUp3zz8fV5oA08Tk7a9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0avPTYBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0avPTYBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8541EC4CEC7;
	Mon, 28 Oct 2024 06:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098468;
	bh=N0TEKEpbDJ4QsO0llCz/MOg4wfffMVa4eqhJSmpgq3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0avPTYBOiPgClA00FYsVqAo29BbYgOrxojhbKMat4RuigCHy5TH9mLFgERV72i6/N
	 Ej0rL5BOpb2TaAuWxG3JnSuFt03UEFHk4Ec1TAaXW1D5W4RFcxbnceuRPcMn2akGR0
	 2EJfbIeJHrrLBLXLkBNRTyatu0H9LRYTp+AOtxW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Zhang <xizhang@purestorage.com>,
	Uday Shankar <ushankar@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 240/261] block: fix sanity checks in blk_rq_map_user_bvec
Date: Mon, 28 Oct 2024 07:26:22 +0100
Message-ID: <20241028062318.131269016@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xinyu Zhang <xizhang@purestorage.com>

commit 2ff949441802a8d076d9013c7761f63e8ae5a9bd upstream.

blk_rq_map_user_bvec contains a check bytes + bv->bv_len > nr_iter which
causes unnecessary failures in NVMe passthrough I/O, reproducible as
follows:

- register a 2 page, page-aligned buffer against a ring
- use that buffer to do a 1 page io_uring NVMe passthrough read

The second (i = 1) iteration of the loop in blk_rq_map_user_bvec will
then have nr_iter == 1 page, bytes == 1 page, bv->bv_len == 1 page, so
the check bytes + bv->bv_len > nr_iter will succeed, causing the I/O to
fail. This failure is unnecessary, as when the check succeeds, it means
we've checked the entire buffer that will be used by the request - i.e.
blk_rq_map_user_bvec should complete successfully. Therefore, terminate
the loop early and return successfully when the check bytes + bv->bv_len
> nr_iter succeeds.

While we're at it, also remove the check that all segments in the bvec
are single-page. While this seems to be true for all users of the
function, it doesn't appear to be required anywhere downstream.

CC: stable@vger.kernel.org
Signed-off-by: Xinyu Zhang <xizhang@purestorage.com>
Co-developed-by: Uday Shankar <ushankar@purestorage.com>
Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Fixes: 37987547932c ("block: extend functionality to map bvec iterator")
Link: https://lore.kernel.org/r/20241023211519.4177873-1-ushankar@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-map.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -600,9 +600,7 @@ static int blk_rq_map_user_bvec(struct r
 		if (nsegs >= nr_segs || bytes > UINT_MAX - bv->bv_len)
 			goto put_bio;
 		if (bytes + bv->bv_len > nr_iter)
-			goto put_bio;
-		if (bv->bv_offset + bv->bv_len > PAGE_SIZE)
-			goto put_bio;
+			break;
 
 		nsegs++;
 		bytes += bv->bv_len;


