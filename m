Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C1E56E066;
	Wed,  9 Sep 2026 14:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964634; cv=none; b=hHcH764rNKuPGIMyFtkhATEW3N1iRbaQSTm/ZTY28IH/oUpI+/aPXZHvBOgZi0V2uVIXh4OlFbHiifRgi7bEq+riuCuUMot95sWhuLJA/wrUM+aot4eiko3hIKRazhDluuDbkI5qGGZDLI+QZoIcML7xpRynE/rramJc+PFvDog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964634; c=relaxed/simple;
	bh=HWmqasuZBFjr1nq7nqk40znI8/65EcCluNdRNjfUCEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lja4cDixg6HEF0/ONZKmqgvipfx1JNhD8MR4k866W8K3aods+7RRSuaW3hr+shbCqg8LxyCA2bxKnlkgkWa9u4ybn1sAYVpLQQdchin5QMc1J6ZP7Kt4ZnceKNn6nRIYTEdeWLARm0D/ni34V1MNFHeOVvHHLHtqBIGtQP94k0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJuxNnuj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJuxNnuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C7F1F00A3A;
	Wed,  9 Sep 2026 14:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964631;
	bh=zjEv1/U3JsazpSpGzEBLCR+/m/+wamRvdOkPZetCHik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJuxNnujgqI9Df9Hi9DA6T5nGi4IrbuJuoUCMb3zM66J01GtavitYn+29EqCu4YZL
	 97mbZL9qKxxG4MIg0+LiaVeNSWO/pYhTeKTp1udlh7M1OXjfORtx1VKOECvykP69Og
	 cWa5fQZJLot2NYYKGLpN072VU3a+v4YSrxCKAjBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 491/583] SUNRPC: fix gssx_dec_option_array error path bugs
Date: Wed,  9 Sep 2026 15:42:56 +0200
Message-ID: <20260909134254.813859056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

[ Upstream commit 5e9a94539b1ec17a89177d952badfd0d844d694a ]

Four coupled defects in the gssx XDR option-array decoder make the
error paths unsafe: a NULL deref in the caller, a refcount leak on
the decoded group_info, and a latent use-after-free that the leak
fix would otherwise expose.

gssx_dec_option_array() sets oa->count = 1 before allocating
oa->data.  If that allocation fails, -ENOMEM is returned with
oa->count == 1 and oa->data == NULL.  All other error paths jump
to free_oa: which frees oa->data and NULLs it but also leaves
oa->count == 1.  The caller trusts the count:

    gssp_accept_sec_context_upcall()
      gssx_dec_accept_sec_context()
        gssx_dec_option_array()        /* fails, count=1 data=NULL */
      data = res.options.data[0].value /* NULL deref */

Independently, free_creds: releases the partially decoded svc_cred
with a bare kfree(creds).  gssx_dec_linux_creds() installs a
groups_alloc() result into creds->cr_group_info; that object is
kvmalloc-backed and refcounted, and only put_group_info() reaches
kvfree().  A plain kfree(creds) drops the wrapper and leaks the
group_info allocation.

The natural fix for the leak is to call free_svc_cred(creds) before
kfree(creds), but free_svc_cred() invokes put_group_info() on
creds->cr_group_info unconditionally when non-NULL.  The existing
out_free_groups: path in gssx_dec_linux_creds() already called
groups_free() on that pointer without clearing it, so once
free_svc_cred() is wired in, the subsequent put_group_info() would
touch freed memory.

Fix all four together:

  - Move the oa->count = 1 assignment below the oa->data allocation
    so it is never set when oa->data is NULL.
  - Reset oa->count to 0 at free_oa: so count and data stay
    coherent and the caller sees an empty option array.
  - Call free_svc_cred(creds) before kfree(creds) at free_creds:
    so the refcounted cr_group_info is released.  free_svc_cred()
    either NULL-guards each field explicitly (cr_group_info has
    an if() check) or delegates to a helper that is NULL-safe
    itself (kfree for the string fields, gss_mech_put() which
    guards with if(gm) at gss_mech_switch.c:342), so it is safe
    to call on a partially decoded svc_cred where only
    cr_uid/cr_gid/cr_group_info have been written and everything
    else is zero from kzalloc.
  - In gssx_dec_linux_creds()'s out_free_groups: path, release
    cr_group_info with put_group_info() rather than groups_free()
    so the teardown matches free_svc_cred()'s refcount-aware path,
    and clear the pointer so a later free_svc_cred() on the same
    creds does not release it a second time.

Fixes: 3cfcfc102a5e ("SUNRPC: fix some memleaks in gssx_dec_option_array")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260528-tier2-v1-2-d026a1415e0b@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/gss_rpc_xdr.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/sunrpc/auth_gss/gss_rpc_xdr.c
+++ b/net/sunrpc/auth_gss/gss_rpc_xdr.c
@@ -222,7 +222,8 @@ static int gssx_dec_linux_creds(struct x
 
 	return 0;
 out_free_groups:
-	groups_free(creds->cr_group_info);
+	put_group_info(creds->cr_group_info);
+	creds->cr_group_info = NULL;
 	return err;
 }
 
@@ -243,12 +244,12 @@ static int gssx_dec_option_array(struct
 		return 0;
 
 	/* we recognize only 1 currently: CREDS_VALUE */
-	oa->count = 1;
-
 	oa->data = kmalloc(sizeof(struct gssx_option), GFP_KERNEL);
 	if (!oa->data)
 		return -ENOMEM;
 
+	oa->count = 1;
+
 	creds = kzalloc(sizeof(struct svc_cred), GFP_KERNEL);
 	if (!creds) {
 		err = -ENOMEM;
@@ -300,8 +301,10 @@ static int gssx_dec_option_array(struct
 	return 0;
 
 free_creds:
+	free_svc_cred(creds);
 	kfree(creds);
 free_oa:
+	oa->count = 0;
 	kfree(oa->data);
 	oa->data = NULL;
 	return err;


