Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E46524B34;
	Tue, 25 Jun 2024 09:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309180; cv=none; b=jiRWnEkCXs0RRSrkr8m3dIcOMY+e0bJeMDuNQRC80cox/M2Hvz6lI7Y/z5/mD0Q8X44hgFOhNR8bt6tOo0APhSrKbeFI8qrIDGb01eMG9LyrJXkiQilvkl+SbaYp8AbUAcz3GNGEo2uLB4IX9qnbIytED9BokQZ0Gqzu6G2NW9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309180; c=relaxed/simple;
	bh=rBZFI3wVLLx7OFldr/rq9EsCnEMo9yTlPemXgUtq974=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDoyq2lbDwdAYW9UYL1pZ2fTMYAdouE5OHpvMWbOju/gpmlFCE4AVc76GN/f5Mv4KC+KikJb5WiD0HO8twdbGURBC8Es7nbY4JdbkgbKCRY3WV1dXOtExY1VDjxE6UUosRy/OrKOXpf3/+Fsqps+U4JJviUgDPYa5tHzozyNjPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIkzpyXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIkzpyXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045F8C32781;
	Tue, 25 Jun 2024 09:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309180;
	bh=rBZFI3wVLLx7OFldr/rq9EsCnEMo9yTlPemXgUtq974=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIkzpyXh0l9LzKSbsdXnDQGxWlJoPaXTOEBmXUADjYT4ti6c3d2OtVKUz+OdcFIsa
	 pGvjG/S9kh5XnXZzcLAp4Rcz+2NrDgOJHBM1Ac49fKWW5KdE95F1/QlO0LwvHmzGlB
	 C+uHpv/iFgdoSBbk2rMCBLPEXfjIGT8tr6lgFd+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenliang Li <cliang01.li@samsung.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/192] io_uring/rsrc: fix incorrect assignment of iter->nr_segs in io_import_fixed
Date: Tue, 25 Jun 2024 11:33:15 +0200
Message-ID: <20240625085541.889829809@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenliang Li <cliang01.li@samsung.com>

[ Upstream commit a23800f08a60787dfbf2b87b2e6ed411cb629859 ]

In io_import_fixed when advancing the iter within the first bvec, the
iter->nr_segs is set to bvec->bv_len. nr_segs should be the number of
bvecs, plus we don't need to adjust it here, so just remove it.

Fixes: b000ae0ec2d7 ("io_uring/rsrc: optimise single entry advance")
Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/20240619063819.2445-1-cliang01.li@samsung.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 2e88b6658e4e0..0f9dcde72ebff 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1108,7 +1108,6 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 			 * branch doesn't expect non PAGE_SIZE'd chunks.
 			 */
 			iter->bvec = bvec;
-			iter->nr_segs = bvec->bv_len;
 			iter->count -= offset;
 			iter->iov_offset = offset;
 		} else {
-- 
2.43.0



