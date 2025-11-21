Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EF4275B18;
	Fri, 21 Nov 2025 13:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731644; cv=none; b=FUKaO2+/ohUFvaWOpSwI6UawtShMywbb2AFDzTz4aQYoluwbikQM3XBHyagOhk4+OApPyXy/Dn82WCFMt3cKZlmlQUuVyflbR2vMydnfPr9Ifg2l/OG/hEIg3yuMtF16qX8RJqekciCg6oTOUvyTyg/gYB9DxlD3gPHsRDq1JJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731644; c=relaxed/simple;
	bh=8qUL4Mrk7ez7jKywryLyaWAb2xkdufhYfsczvV32wws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEXe1AMkjIhzbjqsQxUAkddRoSzF5Osk8/RMbsABktcdwE4rj9NiwiSWSZjEghKCtPXdPdjfoRGzPQL3HC9U/YDaYJekKsOU0G0Er+3VR0XjI6BWaXVIkU+EHUdLRxtOwnu9OtSSy6Q+RE7ntyorCaI8wjXKU4wVx5Z50wvvJBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeDQpF1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeDQpF1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11529C116C6;
	Fri, 21 Nov 2025 13:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731644;
	bh=8qUL4Mrk7ez7jKywryLyaWAb2xkdufhYfsczvV32wws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeDQpF1YvWfC0BMYd2YKiIDwMAnsmpT4wxBK0tH6eu2BIVPU+c2xC1utj6rOwwb0K
	 MyRb+gLcn/PiB1+Vx9DDiojMoXKvthf0B9tG7JFahSQEUnKo4CdFCHlOrHquPEUlpR
	 8SBEwsShDzyh4399WBXYzLSqkoJPnjWsKEKT+tLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/185] erofs: avoid infinite loop due to incomplete zstd-compressed data
Date: Fri, 21 Nov 2025 14:10:58 +0100
Message-ID: <20251121130144.998155705@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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
index 7e177304967e1..24f4731a7a6d4 100644
--- a/fs/erofs/decompressor_zstd.c
+++ b/fs/erofs/decompressor_zstd.c
@@ -178,7 +178,6 @@ static int z_erofs_zstd_decompress(struct z_erofs_decompress_req *rq,
 	dctx.bounce = strm->bounce;
 
 	do {
-		dctx.avail_out = out_buf.size - out_buf.pos;
 		dctx.inbuf_sz = in_buf.size;
 		dctx.inbuf_pos = in_buf.pos;
 		err = z_erofs_stream_switch_bufs(&dctx, &out_buf.dst,
@@ -194,14 +193,18 @@ static int z_erofs_zstd_decompress(struct z_erofs_decompress_req *rq,
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



