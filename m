Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515B77404E;
	Sat, 17 Oct 2026 16:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254801; cv=none; b=p1Il8BeKXR5V93rGc7grkLOOe3C0OSIGnSGLVgObw0HwM8wAuaYDT6RdBZUO/IzzH+euewOfLgpSw+4QkevDE3lPIFaegOumUUnpU/i84NVL2RSAnRiC8dV7tRX1FsfS54jajjY9Tcm7A+mlaQucyyrxO2R8K2+Ud3zfxwfv0DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254801; c=relaxed/simple;
	bh=JKdnsuVhyn2ckZ5izQZcz7xfY8vRkkP8Q5aN7/EJeyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shsV4Y+hNtx2xf3dpVmu6Yo8mGBhad4ttj5tYFY49wx3+suSP4Mdsu9mW6Ai+qyhUfNxmQHzpA08PyiANYTorECzFQ29/mrLBUSCJUZmfZS8GnHyqbcSPGkcfrowI2W7ix3BufftAdtjDaKzMgjQY2SVWg9o6ip0Gxq8plXymmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltxrxJmv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltxrxJmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF1F1F000C4;
	Sat, 17 Oct 2026 16:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254800;
	bh=tyiLIDoOJwYcWLYEoU7nBTujZpcHY+SnG4tSTH2DW+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltxrxJmvSOKvo2xRBe0u0F45fm0l2CRAL/DzCilCOeW0myhpqYXkRK32YVwEZLDeH
	 6Tw4C9eo3pLAi+CtuiKOdha9NhWg80PJUPxtdf5hAyIfOGlIl/mSgWNCcIoMFtpYSb
	 T9WpZUHwqQ6M6qrh5/hguV4G91qNcmTBCrn/YgUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 567/869] SUNRPC: Reject short RFC 4121 MIC tokens in gss_krb5_verify_mic_v2
Date: Sat, 17 Oct 2026 17:56:48 +0200
Message-ID: <20261017160051.608808504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b94f6719dcd9f7a609bc5f459f85795900e77d25 ]

gss_krb5_verify_mic_v2() reads the token ID at ptr[0..1], the flags
byte at ptr[2], and padding at ptr[3..7], then passes
ptr + GSS_KRB5_TOK_HDR_LEN and cksum_len to gss_krb5_mic_build_sg().
None of these accesses check read_token->len first.

The minimum safe token size is GSS_KRB5_TOK_HDR_LEN (16) plus
ctx->krb5e->cksum_len (12-24, depending on the enctype).  All callers
accept shorter tokens from the wire:

 - gss_unwrap_resp_integ() enforces only an upper bound
   (offset + len <= rcv_buf->len) before allocating
   mic.data = kmalloc(len) and passing it to gss_verify_mic().
   A malicious NFS server can therefore supply a short checksum
   opaque, producing a small slab allocation that the Kerberos MIC
   verifier reads past.

 - gss_validate() enforces only len <= RPC_MAX_AUTH_SIZE (400)
   before passing the wire-supplied length to
   gss_validate_seqno_mic(), which constructs a mic xdr_netobj
   and calls gss_verify_mic().

 - svcauth_gss_verify_header() enforces only
   checksum.len >= XDR_UNIT (4 bytes) before dispatching to
   gss_verify_mic().

 - svcauth_gss_unwrap_integ() checks only that the checksum fits
   in gsd->gsd_scratch.

Add a length guard at the top of gss_krb5_verify_mic_v2(), before any
ptr[] access or scatterlist construction.  Well-formed MIC tokens from
gss_krb5_get_mic_v2() already have exactly GSS_KRB5_TOK_HDR_LEN +
cksum_len bytes, so valid traffic is unaffected.

Reported-by: Chris Mason <clm@meta.com>
Fixes: de9c17eb4a91 ("gss_krb5: add support for new token formats in rfc4121")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260523165237.510204-1-cel@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_unseal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sunrpc/auth_gss/gss_krb5_unseal.c b/net/sunrpc/auth_gss/gss_krb5_unseal.c
index ef0e6af9fc959..711697e43f226 100644
--- a/net/sunrpc/auth_gss/gss_krb5_unseal.c
+++ b/net/sunrpc/auth_gss/gss_krb5_unseal.c
@@ -86,6 +86,9 @@ gss_krb5_verify_mic_v2(struct krb5_ctx *ctx, struct xdr_buf *message_buffer,
 
 	dprintk("RPC:       %s\n", __func__);
 
+	if (read_token->len < GSS_KRB5_TOK_HDR_LEN + ctx->gk5e->cksumlength)
+		return GSS_S_DEFECTIVE_TOKEN;
+
 	memcpy(&be16_ptr, (char *) ptr, 2);
 	if (be16_to_cpu(be16_ptr) != KG2_TOK_MIC)
 		return GSS_S_DEFECTIVE_TOKEN;
-- 
2.53.0



