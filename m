Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7C43ECBCF;
	Fri,  4 Sep 2026 06:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502421; cv=none; b=M4K3iNNcyOkDkdmXA0//2iSiladF6WhuQBa0Bqt5KGuWJf3aqKPtq/EunHu1nXVPUwnCOIAfPYBO1rUYeadXCbi1z+WgXtfutl8HzDt5yyQyQSeaZCYNjycSlGG+zIc+mm5Hm/1evOByatOtRRXbHlBuRNvqk+hRi5VD4A7VSnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502421; c=relaxed/simple;
	bh=iWzrmmyeDY8ywfxkdknrk7c3u42mF2cP5r2FspCi4yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vhy4NF5HwpyLkVWu66aOdZPa1336cw6BgrHfdLhGL47jAUMAsn29cjuUXHRP+SdiVuBHyiimLmxKHv82ruwwle1une13aWByQq5InWAY4vLoOLx94nxoeje8CKfUdW1gFJNrnfLlYpg73S5r1DchWx06yBx0/70eJOJwtGomnQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOOPIa73; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOOPIa73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED321F00A3D;
	Fri,  4 Sep 2026 06:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502419;
	bh=jxvU7RTiGHWjjUVFCLkK3czAREPNN+uG07RanTQlODM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOOPIa73AfUCGGu5GmPrg5ryYMlDVdojTUL1Fnc362J5VOnPeCj/zYxGuUWgl1BV1
	 GV9m2uF6Y8y/6j67YauL5XiDujr2fX8JBklHWIty9ONTBT+RUlbJBZfKFEUfzPlm0F
	 RUI89IEK9fOvFHBHEtECuW+SXgT1qEyv3or1vDLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 201/403] SUNRPC: xdr_buf_trim: clamp buf->len to avoid underflow
Date: Fri,  4 Sep 2026 07:00:04 +0200
Message-ID: <20260904045739.424715262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit 3f491306dcb673ff5e78e1044ba450c58978774e upstream.

xdr_buf_trim() trims `len` bytes from the tail of an xdr_buf by
walking the tail, pages, and head iovecs.  Each per-section step
uses min_t() so it never removes more bytes than that section
holds, but the final accounting at the fix_len label subtracts the
total bytes actually consumed from buf->len without any clamp:

    fix_len:
            buf->len -= (len - trim);

When the caller has set buf->len to a value smaller than the sum
of the iov_lens, (len - trim) can exceed buf->len and the unsigned
subtraction wraps to near UINT_MAX.  gss_krb5_unwrap_v2() reaches
xdr_buf_trim() in exactly that state:

    buf->head[0].iov_len -= GSS_KRB5_TOK_HDR_LEN + headskip;
    buf->len = len - (GSS_KRB5_TOK_HDR_LEN + headskip);
    xdr_buf_trim(buf, ec + GSS_KRB5_TOK_HDR_LEN + tailskip);

buf->len is a small wire-derived value while the iov_lens are at
page scale, so the per-section loops legitimately consume far more
bytes than buf->len records.  The wrapped buf->len then propagates
as the authoritative stream bound into every downstream XDR
decoder.

Fix by clamping the decrement so buf->len bottoms out at zero:

    buf->len -= min_t(unsigned int, buf->len, len - trim);

On the normal path where the iov_lens sum to buf->len, (len - trim)
is always <= buf->len and the result is identical to before.  No
callers change behavior outside the underflow case.

Fixes: 4c190e2f913f ("sunrpc: trim off trailing checksum before returning decrypted or integrity authenticated buffer")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260524010213.557424-4-cel@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -2073,7 +2073,7 @@ void xdr_buf_trim(struct xdr_buf *buf, u
 		trim -= cur;
 	}
 fix_len:
-	buf->len -= (len - trim);
+	buf->len -= min_t(unsigned int, buf->len, len - trim);
 }
 EXPORT_SYMBOL_GPL(xdr_buf_trim);
 


