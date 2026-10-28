Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208804;
	b=wVfosQEJrszdy3evzn9DCkU/FCDUks8Gtva9fEqkkXbSzvHd+g8cAxZ7O50f3HGK/BKM
	 vZ4p3mgwvYeyAx3OuGLkfQD5M4/s9rt/hqrX2Dlb51DQDRy5EqWbMG9C4racePtDzTugj
	 mX9Lya534KQAE3+QIeGBXJwQPXJWe5kZUATfjHMBRUNmuzXwF4surIWlKnLwYKg7HGb0g
	 n6FYea+l77usaEP1MD6Ob4kBd8kTBO9GKpFYLILiiaEJ/6D4e5uxx41IjRS7Rjw4vT7TJ
	 HsTsQ8tw1Q9EH7vfNIbnTtB3ORaO13jWIfujZyIpodqOZsD1GkBGJCwdqYfdBDhswdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V6GIJ7N2GLb/CW/1Zs7SaUmHzo3ZIWsjXy7NTDR0NpY=;
	b=uvgSXilR/ODRtgPv0BlA2QsQsBWTLbiHyTIDP1GZE/cQ4h0T7fmDRuy7Qfhoxvp0JRSw
	 Zg4WwOtscnlzT81zYRzJLSQC9IsP0V2b/YqVQ/JbixeNS1/N3wPpUgEj5AZGzbvS6QLmQ
	 0Nb2JBOEM76KUOEBNlMIBJ43qMX0v2WEUUBfbOHjdYHUPNIyHZxijoDxdEmcuu39UYfbl
	 xizD1fYGRwRRoxQSdVnysCm3GkcP/6p/jYtyERnfccxAbLbY3fFMJecoZ1f1fbmNH8ejC
	 q010G8xzfxYghIxgeAbdEiKav7167Iz9QYL3Jubhwa2P2UH76p6jGepXpHHyyjWfeyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=loxEN1U0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69730606A31A;
	Wed, 28 Oct 2026 17:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=loxEN1U0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87601F01825;
	Wed, 28 Oct 2026 17:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208804;
	bh=V6GIJ7N2GLb/CW/1Zs7SaUmHzo3ZIWsjXy7NTDR0NpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=loxEN1U0XXLgII4GDCyMn9TW0Jz6We7UXkemML7ShZDxJFMjzh8LDrx6Ln6DFy+LS
	 N3ETDE2IuoGO7uv5eS9oF/kzqBISuv2JI7Aeat5x8IQ0fGKgnerVDk3qtv+e/vSAYb
	 6dEXDJypbQUiZs83b8hkaUUR4BP5ieLiZPMOpgpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/516] SUNRPC: reject duplicate CREDS_VALUE options
Date: Wed, 28 Oct 2026 17:56:41 +0100
Message-ID: <20261028170009.395356880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

[ Upstream commit 2e4ce62385c1b8a887c5370af058ac7b52a8eaf9 ]

gssx_dec_option_array() walks the wire-supplied option array and, for
every entry whose name matches CREDS_VALUE, calls
gssx_dec_linux_creds() on the same struct svc_cred. That helper
unconditionally installs a fresh groups_alloc() result into
creds->cr_group_info without releasing whatever pointer was already
there:

    for (i = 0; i < count; i++) {
        ... decode name ...
        if (length == sizeof(CREDS_VALUE) &&
            memcmp(p, CREDS_VALUE, sizeof(CREDS_VALUE)) == 0) {
            err = gssx_dec_linux_creds(xdr, creds);
            ...
        }
    }

A reply that carries two CREDS_VALUE entries therefore overwrites
cr_group_info on the second iteration and orphans the group_info
allocated by the first call. The earlier free_creds path only
releases the last cr_group_info via free_svc_cred(), so the first
allocation's refcount stays at one and its kvmalloc-backed storage
is leaked. No in-tree caller of gssp_accept_sec_context_upcall()
expects more than one CREDS_VALUE per reply.

Fix by tracking whether a CREDS_VALUE option has already been
decoded and returning -EINVAL on any subsequent match, so the
free_creds path releases the single group_info that was installed.

Fixes: 1d658336b05f ("SUNRPC: Add RPC based upcall mechanism for RPCGSS auth")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260528-tier2-v1-3-d026a1415e0b@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_rpc_xdr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sunrpc/auth_gss/gss_rpc_xdr.c b/net/sunrpc/auth_gss/gss_rpc_xdr.c
index 1f0bbc3a21c09..cd9b8d6d7c24d 100644
--- a/net/sunrpc/auth_gss/gss_rpc_xdr.c
+++ b/net/sunrpc/auth_gss/gss_rpc_xdr.c
@@ -231,6 +231,7 @@ static int gssx_dec_option_array(struct xdr_stream *xdr,
 				 struct gssx_option_array *oa)
 {
 	struct svc_cred *creds;
+	bool creds_decoded = false;
 	u32 count, i;
 	__be32 *p;
 	int err;
@@ -281,9 +282,14 @@ static int gssx_dec_option_array(struct xdr_stream *xdr,
 		if (length == sizeof(CREDS_VALUE) &&
 		    memcmp(p, CREDS_VALUE, sizeof(CREDS_VALUE)) == 0) {
 			/* We have creds here. parse them */
+			if (creds_decoded) {
+				err = -EINVAL;
+				goto free_creds;
+			}
 			err = gssx_dec_linux_creds(xdr, creds);
 			if (err)
 				goto free_creds;
+			creds_decoded = true;
 			oa->data[0].value.len = 1; /* presence */
 		} else {
 			/* consume uninteresting buffer */
-- 
2.53.0



