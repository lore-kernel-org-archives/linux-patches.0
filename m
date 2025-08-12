Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A852F7461;
	Tue, 12 Aug 2025 17:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020414; cv=none; b=C3de64BF4brhaFvuBkZpvYJ2Tk/687oojMrIwwuhnnjBUfIloG68BLTHhsLle/rL/VGwUACxyUCj0/eA2j/1C6m5Kzqha5HjHf6rQ6PhpqoOT80MtUsHDw3yeIJDBUr812rdJCHfLPgvXFDAFkpYEHibuTN0nWggfcBgD1UYPYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020414; c=relaxed/simple;
	bh=M1T97OfnY9A3WTYbVoMPo3ToPIXtDZQuxa1/HimVc2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pf9P1UX9lMro/uVxMDhRj5ETz8Q26DBsN5vuXebbD4xphAngd+BZwzua3CM72VzRDV2KQe0rfnGJrG1T7C4N+suhmm1Adku0OBwEAqeL3xMDXjPFy5bmc2EeedCaCChgUJli1+FQR6QU8xA5KTzqlT029JSGLsOfUNDleDucaR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROFh8Vsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROFh8Vsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B5DC4CEF0;
	Tue, 12 Aug 2025 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020414;
	bh=M1T97OfnY9A3WTYbVoMPo3ToPIXtDZQuxa1/HimVc2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROFh8VsuWbekUpmInbvqWeZPy5/gZ2weuTTFfmddOGUz0SQUjP5jaTwCv6aYv+lmn
	 NmSvnpDHmoTPO+1Ftg/6hPTuOwbYrrTFpwAtxg2NZpxXVZcTVHheNs3NgOEP+g3n+u
	 3byZjgo+0giXqZFupWDc1Y0b1Q5qWHxVp+KeXsIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Yue Hu <huyue2@coolpad.com>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 6.1 057/253] erofs: simplify z_erofs_transform_plain()
Date: Tue, 12 Aug 2025 19:27:25 +0200
Message-ID: <20250812172951.153267528@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit c5539762f32e97c5e16215fa1336e32095b8b0fd upstream.

Use memcpy_to_page() instead of open-coding them.

In addition, add a missing flush_dcache_page() even though almost all
modern architectures clear `PG_dcache_clean` flag for new file cache
pages so that it doesn't change anything in practice.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20230627161240.331-2-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/decompressor.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -323,7 +323,7 @@ static int z_erofs_transform_plain(struc
 	const unsigned int lefthalf = rq->outputsize - righthalf;
 	const unsigned int interlaced_offset =
 		rq->alg == Z_EROFS_COMPRESSION_SHIFTED ? 0 : rq->pageofs_out;
-	unsigned char *src, *dst;
+	u8 *src;
 
 	if (outpages > 2 && rq->alg == Z_EROFS_COMPRESSION_SHIFTED) {
 		DBG_BUGON(1);
@@ -336,22 +336,19 @@ static int z_erofs_transform_plain(struc
 	}
 
 	src = kmap_local_page(rq->in[inpages - 1]) + rq->pageofs_in;
-	if (rq->out[0]) {
-		dst = kmap_local_page(rq->out[0]);
-		memcpy(dst + rq->pageofs_out, src + interlaced_offset,
-		       righthalf);
-		kunmap_local(dst);
-	}
+	if (rq->out[0])
+		memcpy_to_page(rq->out[0], rq->pageofs_out,
+			       src + interlaced_offset, righthalf);
 
 	if (outpages > inpages) {
 		DBG_BUGON(!rq->out[outpages - 1]);
 		if (rq->out[outpages - 1] != rq->in[inpages - 1]) {
-			dst = kmap_local_page(rq->out[outpages - 1]);
-			memcpy(dst, interlaced_offset ? src :
-					(src + righthalf), lefthalf);
-			kunmap_local(dst);
+			memcpy_to_page(rq->out[outpages - 1], 0, src +
+					(interlaced_offset ? 0 : righthalf),
+				       lefthalf);
 		} else if (!interlaced_offset) {
 			memmove(src, src + righthalf, lefthalf);
+			flush_dcache_page(rq->in[inpages - 1]);
 		}
 	}
 	kunmap_local(src);


