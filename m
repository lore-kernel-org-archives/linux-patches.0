Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AE13A48E4;
	Sat, 17 Oct 2026 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259659; cv=none; b=DYgugvREPOeGMaHStDZQhkl4Vk9Ol4vfnO+A00md8g9KpeVpR8KTlovOlgpsVvBv3OSzgMJUuk4V37Jcs70ZJEDh8qc3trM1o0cwm+K8rSaV2XdREQv8TOzfbMtnd9HZDpJvbwp/ZT0d8o1F2WGQW3s0KBzCzANwsHCqdMs/x/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259659; c=relaxed/simple;
	bh=hgIPOzKPEPvZ/KhfIjSG1/5ijkEkLULlJDcrDAl3X98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlOPYC/TW+uwnyCKylgHKLGrCH+AmXWptARWFmSCrnrQca7JBicXyCIDDEK0uWADQ05rQoy7L68rI1j0kIehudvATpe5OA/BOOZPl2Ccbb67TQdwggecDBcbQLGNgifiVVYzMGUsqOaRdP8UHfXwEb0h2GsH7EjdigOguWcAxSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uufj6dfi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uufj6dfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18BB1F000C4;
	Sat, 17 Oct 2026 17:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259658;
	bh=g4NXe2ZiPeRfWNWy3pgg5akjz1NO9G2JngjjSgyyPxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uufj6dfiAKGRyRWRmSJa07LqoeHvR2SSTQz7S2O8NzxtR3lXfDVLN9fY4q5CMsK1R
	 uCBW6gdfOnk7pihZI17XIg8TsQUII1a1s6roVT5yHFmLQ9LZcTmW6zdwO0nVqt23/d
	 QVHhihi4TGJVHc3zjXvvMfUkwrIR/VuDz+Ni3yGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1288/1674] SUNRPC: Reject short RFC 4121 MIC tokens in gss_krb5_verify_mic_v2
Date: Sat, 17 Oct 2026 17:59:20 +0200
Message-ID: <20261017160504.201089014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4fbc50a0a2c4b..1a98060dae2c9 100644
--- a/net/sunrpc/auth_gss/gss_krb5_unseal.c
+++ b/net/sunrpc/auth_gss/gss_krb5_unseal.c
@@ -88,6 +88,9 @@ gss_krb5_verify_mic_v2(struct krb5_ctx *ctx, struct xdr_buf *message_buffer,
 
 	dprintk("RPC:       %s\n", __func__);
 
+	if (read_token->len < GSS_KRB5_TOK_HDR_LEN + ctx->gk5e->cksumlength)
+		return GSS_S_DEFECTIVE_TOKEN;
+
 	memcpy(&be16_ptr, (char *) ptr, 2);
 	if (be16_to_cpu(be16_ptr) != KG2_TOK_MIC)
 		return GSS_S_DEFECTIVE_TOKEN;
-- 
2.53.0



