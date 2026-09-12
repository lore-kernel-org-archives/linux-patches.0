Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573CD2F260C;
	Sat, 12 Sep 2026 19:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241250; cv=none; b=rpJ9Gm1wvKyL6QxUlUcx2itlN+8WD6xrxzgwnQnuobe0VZADeV6xv9/XupS+uI3Eefh/Cm403+x7mPXL1HbyM2g7Bafu82nCHV4bdt7j4wM0yaz9KSdmq6oeISyIZaPO/Gvkik0scp1wMXbpCUJxFi1yIKgXPqBNxUYSGdYaHsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241250; c=relaxed/simple;
	bh=yokclUy2Tk1AJwvdqWQta1Sv7FrBWiT1RSu3LlEWMUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ommXTgOyKvHKEgKg2XciPO2kMhyyDROh8FiP5TNvoU2SXrS/NqbtUWocJGpbubQYFvGjDIJV751rHCD+uzQcBShkh0E2rrDperCca8kv5X7JpKl0ndhlW22qy3utqNfiBWaj4WQwPKOYKxrE0lCc19Cy42A1/ToWJ5LqhaE6uy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b11Q2rll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b11Q2rll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CF31F000FF;
	Sat, 12 Sep 2026 19:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241249;
	bh=F09B8I9iQzdcuMtYtOknix1Sj0dLstDlREW5WQRYk7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b11Q2rllibcwL5u9IaihQVOcRjIFmypwpKY17u6xHK2Mbsfa1j0I6IZxcTGVSasMz
	 TcsncElyBh6MCUgX6bGZyeCw1YyzJmIVQeSl/0gEG8eZ2+MssB0z1GwhHKJvNQiLsp
	 3JHCPvA7vokju+kPEvhGSwYQvmRZOL9wUQEqRfn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 095/798] SUNRPC: xdr_buf_trim: clamp buf->len to avoid underflow
Date: Sat, 12 Sep 2026 08:55:23 +0200
Message-ID: <20260912065519.133981219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1519,7 +1519,7 @@ void xdr_buf_trim(struct xdr_buf *buf, u
 		trim -= cur;
 	}
 fix_len:
-	buf->len -= (len - trim);
+	buf->len -= min_t(unsigned int, buf->len, len - trim);
 }
 EXPORT_SYMBOL_GPL(xdr_buf_trim);
 


