Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F130A4F4D0A;
	Tue, 13 Oct 2026 12:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893886; cv=none; b=H+X/w53cZ6LUSoJOBamrcsdYo2r6t2yEJPX9B5K87B2WcZTkS9ngnlvTMfX+jizl0F69ekaeImljFEhKjyJJafDljd8uo1VIeIxbGGznYXTpT7RHbWnjTBONSNEwJmQY6mS+0bXpuJRC1Pg/zT/xkNPUYcll8AC3DL2IfrALNdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893886; c=relaxed/simple;
	bh=+did1WpTeBco7cgXDSr+dOL5OKEtoSavBBwIDZm0ptY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnVyuMNE7Rf23ShBkkc29bLjZ5NP+eZ17Rqw3xluXNWrGB1UMv1tffvM/ZMdC3fvVAUW+j+uYdrUVCynn9MRItEH42bK2xcMA6PihjZ3+wX19sk4Rtxmqi+0NauXQQ2f5uPaGomM8D3OYzXZWTV2oB07IAaJIn8W2F94SPM+DOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2fhGDnC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2fhGDnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4517A1F000FF;
	Tue, 13 Oct 2026 12:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893884;
	bh=WMiAiyTH+oQs9+KcVtlOgBGbDPPlRbH5XLWzPlBIbf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2fhGDnC3Ix16xG9t3gLkKdx+x2EPCwJdqXnGlwVfa4LzHCpYjE/CdZhN1QSJ/byU
	 Q27Eeu5NlhQ+Ipqkx8OZBDJmkyHWsX3mu7z9oUnhohUcBogx/t20LKs/OANVt0exjJ
	 zBRiHLhYvHIcizwjFq6RN/N4dpiCSrJGb2iawSY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 374/621] SUNRPC: Add crypto/krb5 enctype lookup to krb5_ctx
Date: Tue, 13 Oct 2026 13:36:09 +0200
Message-ID: <20261013112929.723549701@linuxfoundation.org>
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

[ Upstream commit f8b942fc380c3b38b8a0e2d97f020b162fa3f3ae ]

Each krb5_ctx currently points to a gss_krb5_enctype, the
rpcsec_gss_krb5 module's own enctype descriptor. To begin
using the common crypto/krb5 library, store a pointer to the
corresponding struct krb5_enctype (from <crypto/krb5.h>) as
well.

The lookup is performed in gss_import_v2_context() immediately
after the existing gss_krb5_lookup_enctype() call. If
crypto_krb5_find_enctype() cannot find a matching enctype the
context import fails, ensuring the module never operates with
a partially-initialized krb5_ctx.

Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: b94f6719dcd9 ("SUNRPC: Reject short RFC 4121 MIC tokens in gss_krb5_verify_mic_v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_internal.h | 3 +++
 net/sunrpc/auth_gss/gss_krb5_mech.c     | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/net/sunrpc/auth_gss/gss_krb5_internal.h b/net/sunrpc/auth_gss/gss_krb5_internal.h
index 8769e9e705bfa..11402c3b4972d 100644
--- a/net/sunrpc/auth_gss/gss_krb5_internal.h
+++ b/net/sunrpc/auth_gss/gss_krb5_internal.h
@@ -8,6 +8,8 @@
 #ifndef _NET_SUNRPC_AUTH_GSS_KRB5_INTERNAL_H
 #define _NET_SUNRPC_AUTH_GSS_KRB5_INTERNAL_H
 
+#include <crypto/krb5.h>
+
 /*
  * The RFCs often specify payload lengths in bits. This helper
  * converts a specified bit-length to the number of octets/bytes.
@@ -62,6 +64,7 @@ struct krb5_ctx {
 	u32			enctype;
 	u32			flags;
 	const struct gss_krb5_enctype *gk5e; /* enctype-specific info */
+	const struct krb5_enctype *krb5e; /* crypto/krb5 enctype */
 	struct crypto_sync_skcipher *enc;
 	struct crypto_sync_skcipher *seq;
 	struct crypto_sync_skcipher *acceptor_enc;
diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index 3366505bc669a..0879438cd7b66 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -432,6 +432,13 @@ gss_import_v2_context(const void *p, const void *end, struct krb5_ctx *ctx,
 		p = ERR_PTR(-EINVAL);
 		goto out_err;
 	}
+	ctx->krb5e = crypto_krb5_find_enctype(ctx->enctype);
+	if (!ctx->krb5e) {
+		dprintk("gss_kerberos_mech: crypto/krb5 missing enctype %u\n",
+			ctx->enctype);
+		p = ERR_PTR(-EINVAL);
+		goto out_err;
+	}
 	keylen = ctx->gk5e->keylength;
 
 	p = simple_get_bytes(p, end, ctx->Ksess, keylen);
-- 
2.53.0



