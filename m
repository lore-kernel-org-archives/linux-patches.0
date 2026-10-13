Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306604F3916;
	Tue, 13 Oct 2026 12:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893904; cv=none; b=TKbyoMDraz+HnPmmPlTubQTNsenkL/PKi0iBczpkri/AQLloP+tFaHUQMAFoQnAnLteKTqJqZDECVsDkg35LvqA7dPCqOTObSK6RMN1lLVFjBoXx5emM0H79vfzfsqcTn4nV39wRh/ksjr2vruQeIv4VtY3wo4/prB85Bp+LGvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893904; c=relaxed/simple;
	bh=D9pe1sqryBS7Z3Kimfd1O+c0dHXRU099IKv8iHd0ky8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jc/ElR9LkzR2UCQG/ct6euJCsnHtuhmqv6Z/ZEeMI9gcB0voU4Rc8r6XCQx3egmw+ByhIEX5hg2Va/uOGlIuWdd8MhPcbl4HkLtlV/CqgfsEqtDYBKFMNQLDIzuYzSFD2/y/DaqdlJOqdCOiYj6IxAmjaLWjGcwnrhQoDLTXLZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLaP65Du; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLaP65Du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859C51F000FF;
	Tue, 13 Oct 2026 12:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893903;
	bh=y2aChddb5OdVQZZM3NcfNq6o6dl5CH+ZlxtBZrvXhU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tLaP65DutzFXcK/5zuBcUrMNZMhWN2KB31ImJba24WGy72lILq5kPwGE6cXtnAtPO
	 OwkFHls/UjOg4JBcQA368+CZs0h6QmgvmbQlpb80bljenSsFzfdVeLE4ofyI3Ff3qQ
	 EOC5EFvVXlg+AkrDvNYF21H2jR+c7au9Bb/pfoqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 380/621] SUNRPC: Switch MIC token verification to crypto/krb5
Date: Tue, 13 Oct 2026 13:36:15 +0200
Message-ID: <20261013112929.862599289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit d4f6bd01c5bf7afbf4a3d07f2229e06c2236e8ed ]

gss_krb5_verify_mic_v2() currently recomputes a checksum using
gss_krb5_checksum() and then compares it against the received
checksum with memcmp(). Replace this with a call to
crypto_krb5_verify_mic(), which performs the hash, comparison,
and offset/length adjustment in a single operation through the
crypto/krb5 library.

The scatterlist layout required by RFC 4121 Section 4.2.4 is
constructed via gss_krb5_mic_build_sg(), the shared helper
introduced in the preceding commit. The received checksum
occupies the first scatterlist entry, pointing directly into
the token buffer.

The errno result from crypto_krb5_verify_mic() is mapped to a
GSS major status code via gss_krb5_errno_to_status(), which
returns GSS_S_BAD_SIG for -EBADMSG (checksum mismatch).

Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: b94f6719dcd9 ("SUNRPC: Reject short RFC 4121 MIC tokens in gss_krb5_verify_mic_v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_unseal.c | 36 +++++++++++++++++----------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_unseal.c b/net/sunrpc/auth_gss/gss_krb5_unseal.c
index ef0e6af9fc959..b5fb70419faaa 100644
--- a/net/sunrpc/auth_gss/gss_krb5_unseal.c
+++ b/net/sunrpc/auth_gss/gss_krb5_unseal.c
@@ -60,6 +60,8 @@
 #include <linux/types.h>
 #include <linux/jiffies.h>
 #include <linux/sunrpc/gss_krb5.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
 
 #include "gss_krb5_internal.h"
 
@@ -71,18 +73,19 @@ u32
 gss_krb5_verify_mic_v2(struct krb5_ctx *ctx, struct xdr_buf *message_buffer,
 		       struct xdr_netobj *read_token)
 {
-	struct crypto_ahash *tfm = ctx->initiate ?
-				   ctx->acceptor_sign : ctx->initiator_sign;
-	char cksumdata[GSS_KRB5_MAX_CKSUM_LEN];
-	struct xdr_netobj cksumobj = {
-		.len	= ctx->gk5e->cksumlength,
-		.data	= cksumdata,
-	};
+	const struct krb5_enctype *krb5 = ctx->krb5e;
+	struct crypto_shash *shash = ctx->initiate ?
+		ctx->acceptor_sign_shash : ctx->initiator_sign_shash;
+	unsigned int cksum_len = krb5->cksum_len;
+	struct scatterlist sg_head[XDR_BUF_TO_SG_NENTS];
+	struct scatterlist *sg_overflow;
+	size_t mic_offset, mic_len;
 	u8 *ptr = read_token->data;
 	__be16 be16_ptr;
 	time64_t now;
 	u8 flags;
-	int i;
+	int nsg, i;
+	int ret;
 
 	dprintk("RPC:       %s\n", __func__);
 
@@ -104,13 +107,20 @@ gss_krb5_verify_mic_v2(struct krb5_ctx *ctx, struct xdr_buf *message_buffer,
 		if (ptr[i] != 0xff)
 			return GSS_S_DEFECTIVE_TOKEN;
 
-	if (gss_krb5_checksum(tfm, ptr, GSS_KRB5_TOK_HDR_LEN,
-			      message_buffer, 0, &cksumobj))
+	nsg = gss_krb5_mic_build_sg(message_buffer,
+				    ptr + GSS_KRB5_TOK_HDR_LEN,
+				    cksum_len, ptr,
+				    sg_head, &sg_overflow);
+	if (nsg < 0)
 		return GSS_S_FAILURE;
 
-	if (memcmp(cksumobj.data, ptr + GSS_KRB5_TOK_HDR_LEN,
-				ctx->gk5e->cksumlength))
-		return GSS_S_BAD_SIG;
+	mic_offset = 0;
+	mic_len = cksum_len + message_buffer->len + GSS_KRB5_TOK_HDR_LEN;
+	ret = crypto_krb5_verify_mic(krb5, shash, NULL, sg_head, nsg,
+				     &mic_offset, &mic_len);
+	kfree(sg_overflow);
+	if (ret)
+		return gss_krb5_errno_to_status(ret);
 
 	/* it got through unscathed.  Make sure the context is unexpired */
 	now = ktime_get_real_seconds();
-- 
2.53.0



