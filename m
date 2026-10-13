Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4DA4F55C2;
	Tue, 13 Oct 2026 12:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893889; cv=none; b=J3PkdZOUw4SU13cYH7meInX2n0i/S49UJeeJ5Z0fiCLTf9lzlTdWLTvSXVSysVD5DnjLa8yYGadTQvlfxkd+Xm7qWJ/A2Y8VAQBosB7A9XcujTbsq4DHwaeYtyGghis8kPkUKW3P18gwIWJXaLEgnELKoM7pEIvJb1gv1RVOUfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893889; c=relaxed/simple;
	bh=rZ+CMvGkLwO1MCE0RB2pvR6u9kWlV9PpSR7zl7Zi+fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8gEB/7257B6LY3g4DDi4PViXiULKJHxj4z0B69Y0/0Y/z1b/9wHFmz4QV8RnRDzDCq2n/IREnJRMwubLavB7fzeLclbALjeWb/ffNlxXMOsnjhlwFUM39yk1Bq4m2ynCo60K4Hk0/AeMZ9JxBuWvrT/RukEbG1WVfabcAd5eBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsQi3EmZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsQi3EmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4E61F000FF;
	Tue, 13 Oct 2026 12:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893887;
	bh=qb+l6Fv9A3Ukhrc15vYmlFPeIuHoaEkTZtMVVlR1LgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HsQi3EmZsoge0qbT0I70kU6mLXWA8wvZEt5y3wtHLfAiBQpf3fA+GAxK87r8d3m2v
	 t2K8jgVXniaNssplM1/fh/1TmZbDOJV8oeA2iNJZoZuJv1jtzum2tsbne6GITWduKp
	 ihXWWMp/e5uHQ9dg8ywxz6DsQ95c1sbJBN45hnHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 375/621] SUNRPC: Add errno-to-GSS status conversion helper
Date: Tue, 13 Oct 2026 13:36:10 +0200
Message-ID: <20261013112929.746719957@linuxfoundation.org>
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

[ Upstream commit 6e5e0c58dbd059eef27f01805c032b8fa3cd5eb1 ]

The crypto/krb5 library returns standard negative errno values,
but the GSS mechanism layer reports results as GSS_S_* major
status codes. A translation is needed at each call site that
will be switched to the new library.

Rather than open-coding the mapping in every wrapper, provide a
single helper function.

Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: b94f6719dcd9 ("SUNRPC: Reject short RFC 4121 MIC tokens in gss_krb5_verify_mic_v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_internal.h |  2 ++
 net/sunrpc/auth_gss/gss_krb5_mech.c     | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/net/sunrpc/auth_gss/gss_krb5_internal.h b/net/sunrpc/auth_gss/gss_krb5_internal.h
index 11402c3b4972d..a3fe4be3b9ae2 100644
--- a/net/sunrpc/auth_gss/gss_krb5_internal.h
+++ b/net/sunrpc/auth_gss/gss_krb5_internal.h
@@ -180,6 +180,8 @@ u32 krb5_etm_encrypt(struct krb5_ctx *kctx, u32 offset, struct xdr_buf *buf,
 u32 krb5_etm_decrypt(struct krb5_ctx *kctx, u32 offset, u32 len,
 		     struct xdr_buf *buf, u32 *headskip, u32 *tailskip);
 
+u32 gss_krb5_errno_to_status(int err);
+
 #if IS_ENABLED(CONFIG_KUNIT)
 void krb5_nfold(u32 inbits, const u8 *in, u32 outbits, u8 *out);
 const struct gss_krb5_enctype *gss_krb5_lookup_enctype(u32 etype);
diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index 0879438cd7b66..fd6c9f2f4b7a7 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -516,6 +516,30 @@ gss_krb5_delete_sec_context(void *internal_ctx)
 	kfree(kctx);
 }
 
+/**
+ * gss_krb5_errno_to_status - Map a negative errno to a GSS major status
+ * @err: negative errno value, or zero
+ *
+ * Returns:
+ *   %GSS_S_COMPLETE if @err is zero
+ *   %GSS_S_BAD_SIG if @err is -EBADMSG (integrity check failure)
+ *   %GSS_S_DEFECTIVE_TOKEN if @err is -EPROTO (malformed token)
+ *   %GSS_S_FAILURE for all other negative values
+ */
+u32 gss_krb5_errno_to_status(int err)
+{
+	switch (err) {
+	case 0:
+		return GSS_S_COMPLETE;
+	case -EBADMSG:
+		return GSS_S_BAD_SIG;
+	case -EPROTO:
+		return GSS_S_DEFECTIVE_TOKEN;
+	default:
+		return GSS_S_FAILURE;
+	}
+}
+
 /**
  * gss_krb5_get_mic - get_mic for the Kerberos GSS mechanism
  * @gctx: GSS context
-- 
2.53.0



