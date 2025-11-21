Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F16346E46;
	Fri, 21 Nov 2025 13:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731055; cv=none; b=Q7gJh5mm79Aem2EiNvjFVx0V1m0LNlfl2D56bVeCLxLxD5oF9UR0ud4prhgOjnuk5ttM5q81pMptZdaScJbb+OJl/iCByzGOZe1/cFtVX7kaakLzUei0Hd0uJae3dC10uIBZO4yzv1bKaxaHYC5gPR24c/qypn3qDBTEtB9b2/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731055; c=relaxed/simple;
	bh=Oeit348/hU5826Xe4ST+vB+1fNIPlLXkGgA8UiaJsIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkemZK06iH8KUhtmB+0KVRa1kDSWsvkCH9PyF17/qWjP3A3X5+RDIBmnHZPReNz/dbIDych0qrWdmdZnWmGmsIpeRDKSgb5wc8qTgKwHm4cRN+I20JiGnPLA1rCjvaDDi8pe66lJre5GsprGv0gHHnBkiLXBmawMS6cH9NsrJPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZXlJJn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZXlJJn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74998C4CEFB;
	Fri, 21 Nov 2025 13:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731054;
	bh=Oeit348/hU5826Xe4ST+vB+1fNIPlLXkGgA8UiaJsIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZXlJJn/DOqrDJ+b3pM2iEr7/2OMluZyj99+Cefrft+8qZ3/v+K20Z8izModpRSEo
	 9Qd3yTLpjLZKEMu20Tjt5I0FmlYqoqNAQLHtGa51ivqo8rJY8oBb1wbAPQXy1trFtP
	 DvpQJUqOkkUjza54zajgkDXLzAtBM/b0PHs60tR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 047/247] erofs: avoid infinite loop due to incomplete zstd-compressed data
Date: Fri, 21 Nov 2025 14:09:54 +0100
Message-ID: <20251121130156.290880520@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit f2a12cc3b97f062186568a7b94ddb7aa2ef68140 ]

Currently, the decompression logic incorrectly spins if compressed
data is truncated in crafted (deliberately corrupted) images.

Fixes: 7c35de4df105 ("erofs: Zstandard compression support")
Reported-by: Robert Morris <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/r/50958.1761605413@localhost
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chunhai Guo <guochunhai@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor_zstd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/decompressor_zstd.c b/fs/erofs/decompressor_zstd.c
index b4bfe14229f9f..e38d93bb21048 100644
--- a/fs/erofs/decompressor_zstd.c
+++ b/fs/erofs/decompressor_zstd.c
@@ -172,7 +172,6 @@ static int z_erofs_zstd_decompress(struct z_erofs_decompress_req *rq,
 	dctx.bounce = strm->bounce;
 
 	do {
-		dctx.avail_out = out_buf.size - out_buf.pos;
 		dctx.inbuf_sz = in_buf.size;
 		dctx.inbuf_pos = in_buf.pos;
 		err = z_erofs_stream_switch_bufs(&dctx, &out_buf.dst,
@@ -188,14 +187,18 @@ static int z_erofs_zstd_decompress(struct z_erofs_decompress_req *rq,
 		in_buf.pos = dctx.inbuf_pos;
 
 		zerr = zstd_decompress_stream(stream, &out_buf, &in_buf);
-		if (zstd_is_error(zerr) || (!zerr && rq->outputsize)) {
+		dctx.avail_out = out_buf.size - out_buf.pos;
+		if (zstd_is_error(zerr) ||
+		    ((rq->outputsize + dctx.avail_out) && (!zerr || (zerr > 0 &&
+				!(rq->inputsize + in_buf.size - in_buf.pos))))) {
 			erofs_err(sb, "failed to decompress in[%u] out[%u]: %s",
 				  rq->inputsize, rq->outputsize,
-				  zerr ? zstd_get_error_name(zerr) : "unexpected end of stream");
+				  zstd_is_error(zerr) ? zstd_get_error_name(zerr) :
+					"unexpected end of stream");
 			err = -EFSCORRUPTED;
 			break;
 		}
-	} while (rq->outputsize || out_buf.pos < out_buf.size);
+	} while (rq->outputsize + dctx.avail_out);
 
 	if (dctx.kout)
 		kunmap_local(dctx.kout);
-- 
2.51.0



