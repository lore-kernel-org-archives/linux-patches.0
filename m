Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB79F2E2F0E;
	Mon,  4 May 2026 14:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903537; cv=none; b=mrtdhWHKvALHSkxr3/xvEx5ZxHbg0/0tmXANaRZqxoRZcn+3bOZsIbltMpG9CIScIGhBlQ03I3iybonC/1p4e8UFr/L4Rox6HIbnnY4LkhIj4mz/1soJ2+r6oK8zntp8u/VqLrgVp2CTFjLTswYH2CTA4wniX3LBD3HlZQjZm8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903537; c=relaxed/simple;
	bh=bWDFVvKZlkb0VqHYI3d3+Yb/iW0fbZJ4xqLEDfYtjpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/gfmyiXeGeV1SBG5FXZa/mvX624ILzgCqiFDBXe5o1kRV4GtLwBklUHms+i8mrwoioVxR7y08R0yr1jvE0QgKgj9P4iXYpTm3kjG/gYmTlRJ90pN3dgSgpMKIX+jqmMVGDpwwRoTQVFuo+YlF3PJkjkP5TT8PPFN5XTSRZkzSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkYcid8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkYcid8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81071C2BCF4;
	Mon,  4 May 2026 14:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903536;
	bh=bWDFVvKZlkb0VqHYI3d3+Yb/iW0fbZJ4xqLEDfYtjpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkYcid8JbwHYQ8Hf1F4oOVgviENmC3druQWj8EwUceXvZ9xEiAF9QsM4E75p3aboX
	 9f4w907pAw1iT5nXRwUqtYZi4regfTSvlIuUHcR+WufhDvo/bX+6QKFNh+0Cd7vMLf
	 F47FBaaT2bbprMl50LVJDdCww6gTW3qIjw8Ucc/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 7.0 271/307] erofs: fix unsigned underflow in z_erofs_lz4_handle_overlap()
Date: Mon,  4 May 2026 15:52:36 +0200
Message-ID: <20260504135153.003977544@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit 21e161de2dc660b1bb70ef5b156ab8e6e1cca3ab upstream.

Some crafted images can have illegal (!partial_decoding &&
m_llen < m_plen) extents, and the LZ4 inplace decompression path
can be wrongly hit, but it cannot handle (outpages < inpages)
properly: "outpages - inpages" wraps to a large value and
the subsequent rq->out[] access reads past the decompressed_pages
array.

However, such crafted cases can correctly result in a corruption
report in the normal LZ4 non-inplace path.

Let's add an additional check to fix this for backporting.

Reproducible image (base64-encoded gzipped blob):

H4sIAJGR12kCA+3SPUoDQRgG4MkmkkZk8QRbRFIIi9hbpEjrHQI5ghfwCN5BLCzTGtLbBI+g
dilSJo1CnIm7GEXFxhT6PDDwfrs73/ywIQD/1ePD4r7Ou6ETsrq4mu7XcWfj++Pb58nJU/9i
PNtbjhan04/9GtX4qVYc814WDqt6FaX5s+ZwXXeq52lndT6IuVvlblytLMvh4Gzwaf90nsvz
2DF/21+20T/ldgp5s1jXRaN4t/8izsy/OUB6e/Qa79r+JwAAAAAAAL52vQVuGQAAAP6+my1w
ywAAAAAAAADwu14ATsEYtgBQAAA=

$ mount -t erofs -o cache_strategy=disabled foo.erofs /mnt
$ dd if=/mnt/data of=/dev/null bs=4096 count=1

Fixes: 598162d05080 ("erofs: support decompress big pcluster for lz4 backend")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/decompressor.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -145,6 +145,7 @@ static void *z_erofs_lz4_handle_overlap(
 	oend = rq->pageofs_out + rq->outputsize;
 	omargin = PAGE_ALIGN(oend) - oend;
 	if (!rq->partial_decoding && may_inplace &&
+	    rq->outpages >= rq->inpages &&
 	    omargin >= LZ4_DECOMPRESS_INPLACE_MARGIN(rq->inputsize)) {
 		for (i = 0; i < rq->inpages; ++i)
 			if (rq->out[rq->outpages - rq->inpages + i] !=


