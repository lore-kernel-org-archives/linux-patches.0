Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AB23B7B7B;
	Fri,  4 Sep 2026 05:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499350; cv=none; b=IponoqW0GbvVwopGCcR7EQNhAKx/w1tHEYrSSFQsFc2RtZcRqA0m3PL8Lw3fnFwJYclo8RGCg+Oj9iFF6L4aDnDs4ashVbrDsmXwP0Aq7K70wB1aZVzX8lNlHFHRfAHpNOu1XsEeAfjVdXVSwLY1KmThcT2wEE42F5CaQ/76TMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499350; c=relaxed/simple;
	bh=K3RM1XMQROYCn+31rZN9wuzfHi2WnHCYKLjTw8Pp7gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLMlowW2OVldjA8qXz/N88MScDkEN9eRnLC+KuEw9ouWryy9k47wF1HWM8FE6sZlclwoX/9GkJ7WkC+Fl6YSmso756Zpt8MrDkQD72kl/+GhTYtqkbCWY/Vu1Z5NKyZUWqi7jFUD0ltTxPb4LHdHYl0p19uDCWUBjlLhLWtWZfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mz27EZmk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mz27EZmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1EC1F00A3D;
	Fri,  4 Sep 2026 05:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499349;
	bh=QbeHR6JymiDZeGySTW6W7H97DDZjUtwscQsLFzkWntY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mz27EZmkHlV+qI5j9PIsWU0EMdzureHrCzTN/cGD99ZxWIVlVxEtbifXsDGYlD3dk
	 EDfsYYMN+S0cqsnLanaxGkyZFR56UGAxSsgeFWzhTDSkAxtZZLP+hk5951WDsFYgQA
	 Yqrf/18dbTtmNHLDJH4PYlOpRfbPoBf4vgGvlbq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 385/713] SUNRPC: reject duplicate CREDS_VALUE options
Date: Fri,  4 Sep 2026 06:55:53 +0200
Message-ID: <20260904045812.454669343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

commit 2e4ce62385c1b8a887c5370af058ac7b52a8eaf9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/gss_rpc_xdr.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/sunrpc/auth_gss/gss_rpc_xdr.c
+++ b/net/sunrpc/auth_gss/gss_rpc_xdr.c
@@ -231,6 +231,7 @@ static int gssx_dec_option_array(struct
 				 struct gssx_option_array *oa)
 {
 	struct svc_cred *creds;
+	bool creds_decoded = false;
 	u32 count, i;
 	__be32 *p;
 	int err;
@@ -281,9 +282,14 @@ static int gssx_dec_option_array(struct
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


