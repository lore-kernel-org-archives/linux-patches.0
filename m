Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6C937E2F3;
	Sat, 12 Sep 2026 19:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241270; cv=none; b=SX4Brs45/zNqK1TaholD3EB90qLERt9TBTFgh2BCLr6RW4OkMgwHquFqxAdl2ZdgF2JutmhEbheJ0Bvd6CKFo6xEiQ+Kaw0qlpRxSqS75NBI7Ph9PFSyKGji19nT+IIl410gdAlKMo5a20OPoaLJqD1iepyquf6BVTDoGvPJW9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241270; c=relaxed/simple;
	bh=tRySD5iGVPw7gXyFcBqHoxrcHttHm9EgIxpqA4lM418=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQjGzMqA+jBgnvYez4LiuTojApZRM0klXyLSed3CXf+jCkrrt94J9/KvhqDi8XeqqB0i5BOaGECjjQBQDHxkCD8HtrgXfeQFwQPshuFkfhbkCnh0RuZwFV5QZxLSDIM4vesJN5dQ74z7osQw0+Ke+PeuFTGR9tMit08RPv3v8oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxg5jaJ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxg5jaJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174711F000FF;
	Sat, 12 Sep 2026 19:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241269;
	bh=xiGo16+/lv4mn85cCp8MOb+JYEAmOMz12dLQZb2KuM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxg5jaJ4R6aIZ3WiExQPC0IbXe81P0rxCd2YHgl5jhB8PXabCwdt5Fp8FQ2V10BTj
	 NDcfJVNh6jS2BymBS86HRyNGQ4/Z21JJoE3POvQ1YKc5fpx6wVlIaKJIYZqWf7206z
	 Hw2DSsqO+0J9m76N1jzl4abWTCKO18o2pzn6nW1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 099/798] SUNRPC: harden gss_krb5_unwrap_v2 against short tokens
Date: Sat, 12 Sep 2026 08:55:27 +0200
Message-ID: <20260912065519.225240658@linuxfoundation.org>
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

commit 6959297aaa9572783d620a226d73c3fb94494888 upstream.

gss_krb5_unwrap_v2() reads the EC and RRC header fields at ptr+4 and
ptr+6 before validating that the token is at least GSS_KRB5_TOK_HDR_LEN
(16) bytes long, and its rotate_left() helper passes buf->len - base
to xdr_buf_subsegment() without verifying that base <= buf->len. When
a caller hands in a sub-16-byte token, or a token whose declared len
leaves base past the end of the buffer, three distinct failures follow:

    gss_krb5_unwrap_v2(offset, len, buf)
      ptr = buf->head[0].iov_base + offset
      ec  = *(ptr + 4)              /* OOB read on short head */
      rrc = *(ptr + 6)              /* OOB read on short head */
      rotate_left(offset + 16, buf, rrc)
        xdr_buf_subsegment(buf, &subbuf,
                           base, buf->len - base)   /* u32 wrap when base > len */
        _rotate_left(&subbuf, shift)
          shift %= buf->len         /* divide-by-zero when base == len */

After decryption, the cleanup arithmetic has the same shape:

    movelen = min_t(unsigned int, buf->head[0].iov_len, len);
    movelen -= offset + GSS_KRB5_TOK_HDR_LEN + headskip;
    BUG_ON(offset + GSS_KRB5_TOK_HDR_LEN + headskip + movelen >
                                            buf->head[0].iov_len);

The BUG_ON re-adds the value just subtracted, so it reduces to
min(A, B) > A and is permanently false; it cannot catch the unsigned
underflow of movelen, which then drives a ~UINT_MAX-byte memmove().

Add four defense-in-depth guards inside the unwrap core so it is safe
regardless of what its callers validate:

  - reject tokens with len - offset < GSS_KRB5_TOK_HDR_LEN before
    touching ptr+4/ptr+6;
  - bail from rotate_left() when buf->len <= base, covering both the
    underflow and zero-length cases;
  - return early from _rotate_left() when buf->len is zero, so the
    shift %= buf->len modulo cannot fault;
  - replace the dead BUG_ON with a live check that returns
    GSS_S_DEFECTIVE_TOKEN before the movelen subtraction.

Fixes: de9c17eb4a91 ("gss_krb5: add support for new token formats in rfc4121")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260524010213.557424-5-cel@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/gss_krb5_wrap.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -389,6 +389,8 @@ static void _rotate_left(struct xdr_buf
 	int shifted = 0;
 	int this_shift;
 
+	if (!buf->len)
+		return;
 	shift %= buf->len;
 	while (shifted < shift) {
 		this_shift = min(shift - shifted, LOCAL_BUF_LEN);
@@ -401,6 +403,8 @@ static void rotate_left(u32 base, struct
 {
 	struct xdr_buf subbuf;
 
+	if (buf->len <= base)
+		return;
 	xdr_buf_subsegment(buf, &subbuf, base, buf->len - base);
 	_rotate_left(&subbuf, shift);
 }
@@ -476,6 +480,9 @@ gss_unwrap_kerberos_v2(struct krb5_ctx *
 	if (kctx->gk5e->decrypt_v2 == NULL)
 		return GSS_S_FAILURE;
 
+	if (len - offset <= GSS_KRB5_TOK_HDR_LEN)
+		return GSS_S_DEFECTIVE_TOKEN;
+
 	ptr = buf->head[0].iov_base + offset;
 
 	if (be16_to_cpu(*((__be16 *)ptr)) != KG2_TOK_WRAP)
@@ -542,9 +549,9 @@ gss_unwrap_kerberos_v2(struct krb5_ctx *
 	 * head buffer space rather than that actually occupied.
 	 */
 	movelen = min_t(unsigned int, buf->head[0].iov_len, len);
+	if (movelen < offset + GSS_KRB5_TOK_HDR_LEN + headskip)
+		return GSS_S_DEFECTIVE_TOKEN;
 	movelen -= offset + GSS_KRB5_TOK_HDR_LEN + headskip;
-	BUG_ON(offset + GSS_KRB5_TOK_HDR_LEN + headskip + movelen >
-							buf->head[0].iov_len);
 	memmove(ptr, ptr + GSS_KRB5_TOK_HDR_LEN + headskip, movelen);
 	buf->head[0].iov_len -= GSS_KRB5_TOK_HDR_LEN + headskip;
 	buf->len = len - (GSS_KRB5_TOK_HDR_LEN + headskip);


