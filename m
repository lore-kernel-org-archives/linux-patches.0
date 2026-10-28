Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211283;
	b=VlEt+E34RGGffyIs9s2taCAViLX5nnc1z792aULAP/KpMJNNaMjIxmf+XXtn+dHdnaAT
	 p3hFAIcfe0oz9JQ1omZ4IUaXJprmJShxqYKKtqtdfV1Vql72dl51Ay+65+VBB3coOeFRd
	 IbR+mRBQ1eTNahvVaLzSa+RQEYtNFPUiR8xxo1Qo6WsAUDfGG501tTZY/rB1ixVFuhjqE
	 US/5kMIeF63UwfgGH+bU6VZ7R5e5y9tPSnTGUtYZGfxZa9Shn0JFljGZJV+Vwwqjx0WDU
	 cS9cxqfkUP3mLmL5EMFagw50tmFsGpBFhBVVqtVVXNufKorfiUpt7M98aGTATikyFNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P+NJaNTUVieKGlh0Zjmr/QGhqszBIHQK9FLgs/jljjo=;
	b=WwSbppt2IBLopnKWy+pZhPM9gXJw6p0lB+Sr2ykgmluhtLx0+lIFYXOeLWRr7tdz9+pQ
	 lfUrC5GE6MTm/kd6NTjc9k74+Y0xp/Dr5yumdXo3n7bmNzn/hYHz+qULS3V0pCpqTU/Cf
	 49e8Hv2HxBW1Q62F680tdHyCIRDELo50uO2yzHSoR6aoLki5nKun4GWLotrhtnLoQbSq7
	 ql6jgTenVJqkJidJNIZ3JimMPSZDsjQMvU18QflxKyeP3Em5081E0QzmUQjzPlEiQ4sw+
	 F3ncJHXFtjMSdYA9QLS3SbyQom4uc19fmT1EvJX6qsnLfU4nSETsJXFSeckHI5qX/7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IXipnn/H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B4160A383B;
	Wed, 28 Oct 2026 18:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IXipnn/H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588851F01828;
	Wed, 28 Oct 2026 18:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211282;
	bh=P+NJaNTUVieKGlh0Zjmr/QGhqszBIHQK9FLgs/jljjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IXipnn/HZKmFdgfLXCa52KVrCyvohDKQzaC7zyPTjalI5A63vA8tQrX37QEjXh5y1
	 O/FMwBTO2HF7gieD6E3x8CyilkcY3Cg/nbOVFeWq7IUlb1KrshfEdJmBs/Efgjeiqt
	 TMFXzRjkZ6N4eGEsQP728Ly+PA89ZciMrtm0xUiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/571] SUNRPC: reject duplicate CREDS_VALUE options
Date: Wed, 28 Oct 2026 17:56:56 +0100
Message-ID: <20261028170014.385904496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ac9ae42a69762..967943ae61c62 100644
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



