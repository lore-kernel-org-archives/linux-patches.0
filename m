Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1570433372A;
	Tue, 13 Oct 2026 12:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893892; cv=none; b=lXrvO84eHly37kx0YLV+HEoFtUCTlsbKrrlB31xgsztI3ghMgm/UDe07awuEz6ys8/Avz4wCA7S+TO8Iorto+Ub80Ns7Dh1z0N88HbAabHH2KciIPBIr4zOf5g8L5epEYiVGS4Qvl+cf80OkRFik2F29lTkQZkTiWjVNH2dNxUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893892; c=relaxed/simple;
	bh=iHOx1776SE9uCjL4gHZRe6VhvMI1wx7xuPGPAkcqiE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhJcIJPHF+ETzFyEWSfIPz1zQSaRTE955Z9e/p1/V2MZ+CXWSDptGOq3yod4noPTVYotSEfBbEdl8zgYiPTd57mm55NHjtrDDhDo7qswzkwzDDsvU/jpmmre3jJMTVWOMaL58r5pXTDtjmAYSjC7Ua5K2bQWU54oizzLP2GlTfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNpdYp0Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNpdYp0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C741F000FF;
	Tue, 13 Oct 2026 12:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893891;
	bh=dYb/qWaRgb6jIv4iBFWhvpJqzuZcYI6MhgZU9ipSgCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PNpdYp0YdWJIqt18OEzrnVLxXKsfKUhCvljgbhNKsfD/ogaucl5uIFSbnl/EZskAD
	 S65yG6Dv6RA8KG128ID3EyPF1L4B2rFHvuaA7hMIwxNFpFiF2hK2iaO8MIBzF7jQpD
	 laTmV0ZyIj0qZ0D8YrKI7h+nCYbduXJgbVZvskks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 376/621] SUNRPC: Prepare crypto/krb5 encryption and checksum handles
Date: Tue, 13 Oct 2026 13:36:11 +0200
Message-ID: <20261013112929.769937534@linuxfoundation.org>
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

[ Upstream commit 25ccbefc9fd6f62acbf2f3d8eb9e2b3950e5fe28 ]

Allocate crypto_aead handles for encryption (one per direction)
and crypto_shash handles for checksumming (one per direction)
using the crypto/krb5 library's key preparation functions.

These four handles derive their subkeys from the session key
and the RFC 4121 usage numbers and are ready for use in
encrypt, decrypt, get_mic, and verify_mic operations.

The existing crypto_sync_skcipher and crypto_ahash handles
remain in place for now; subsequent patches switch the
per-message operations to the new handles and then remove
the old ones.

Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: b94f6719dcd9 ("SUNRPC: Reject short RFC 4121 MIC tokens in gss_krb5_verify_mic_v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_internal.h |  4 +++
 net/sunrpc/auth_gss/gss_krb5_mech.c     | 45 +++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/net/sunrpc/auth_gss/gss_krb5_internal.h b/net/sunrpc/auth_gss/gss_krb5_internal.h
index a3fe4be3b9ae2..33d41d972bd18 100644
--- a/net/sunrpc/auth_gss/gss_krb5_internal.h
+++ b/net/sunrpc/auth_gss/gss_krb5_internal.h
@@ -65,6 +65,10 @@ struct krb5_ctx {
 	u32			flags;
 	const struct gss_krb5_enctype *gk5e; /* enctype-specific info */
 	const struct krb5_enctype *krb5e; /* crypto/krb5 enctype */
+	struct crypto_aead	*initiator_enc_aead;
+	struct crypto_aead	*acceptor_enc_aead;
+	struct crypto_shash	*initiator_sign_shash;
+	struct crypto_shash	*acceptor_sign_shash;
 	struct crypto_sync_skcipher *enc;
 	struct crypto_sync_skcipher *seq;
 	struct crypto_sync_skcipher *acceptor_enc;
diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index fd6c9f2f4b7a7..cc75f7b193428 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -300,6 +300,10 @@ gss_krb5_import_ctx_v2(struct krb5_ctx *ctx, gfp_t gfp_mask)
 		.len	= ctx->gk5e->keylength,
 		.data	= ctx->Ksess,
 	};
+	struct krb5_buffer TK = {
+		.len	= ctx->gk5e->keylength,
+		.data	= ctx->Ksess,
+	};
 	struct xdr_netobj keyout;
 	int ret = -EINVAL;
 
@@ -374,12 +378,49 @@ gss_krb5_import_ctx_v2(struct krb5_ctx *ctx, gfp_t gfp_mask)
 	if (ctx->acceptor_integ == NULL)
 		goto out_free;
 
+	ctx->initiator_enc_aead =
+		crypto_krb5_prepare_encryption(ctx->krb5e, &TK,
+					       KG_USAGE_INITIATOR_SEAL,
+					       gfp_mask);
+	if (IS_ERR(ctx->initiator_enc_aead)) {
+		ret = PTR_ERR(ctx->initiator_enc_aead);
+		goto out_free;
+	}
+	ctx->acceptor_enc_aead =
+		crypto_krb5_prepare_encryption(ctx->krb5e, &TK,
+					       KG_USAGE_ACCEPTOR_SEAL,
+					       gfp_mask);
+	if (IS_ERR(ctx->acceptor_enc_aead)) {
+		ret = PTR_ERR(ctx->acceptor_enc_aead);
+		goto out_free;
+	}
+	ctx->initiator_sign_shash =
+		crypto_krb5_prepare_checksum(ctx->krb5e, &TK,
+					     KG_USAGE_INITIATOR_SIGN,
+					     gfp_mask);
+	if (IS_ERR(ctx->initiator_sign_shash)) {
+		ret = PTR_ERR(ctx->initiator_sign_shash);
+		goto out_free;
+	}
+	ctx->acceptor_sign_shash =
+		crypto_krb5_prepare_checksum(ctx->krb5e, &TK,
+					     KG_USAGE_ACCEPTOR_SIGN,
+					     gfp_mask);
+	if (IS_ERR(ctx->acceptor_sign_shash)) {
+		ret = PTR_ERR(ctx->acceptor_sign_shash);
+		goto out_free;
+	}
+
 	ret = 0;
 out:
 	kfree_sensitive(keyout.data);
 	return ret;
 
 out_free:
+	crypto_free_shash(ctx->acceptor_sign_shash);
+	crypto_free_shash(ctx->initiator_sign_shash);
+	crypto_free_aead(ctx->acceptor_enc_aead);
+	crypto_free_aead(ctx->initiator_enc_aead);
 	crypto_free_ahash(ctx->acceptor_integ);
 	crypto_free_ahash(ctx->initiator_integ);
 	crypto_free_ahash(ctx->acceptor_sign);
@@ -502,6 +543,10 @@ gss_krb5_delete_sec_context(void *internal_ctx)
 {
 	struct krb5_ctx *kctx = internal_ctx;
 
+	crypto_free_shash(kctx->acceptor_sign_shash);
+	crypto_free_shash(kctx->initiator_sign_shash);
+	crypto_free_aead(kctx->acceptor_enc_aead);
+	crypto_free_aead(kctx->initiator_enc_aead);
 	crypto_free_sync_skcipher(kctx->seq);
 	crypto_free_sync_skcipher(kctx->enc);
 	crypto_free_sync_skcipher(kctx->acceptor_enc);
-- 
2.53.0



