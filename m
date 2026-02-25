Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F603242D6;
	Wed, 25 Feb 2026 06:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002785; cv=none; b=Ahymj6gDYNG3HEbCtuIS3eZIoxoKVZzuhs1S72yaA0DyBIu5RvHWZyM7A74Ike33K4r3a0S8O2C5WVc7OQMcsHgMjMNO0VC86kLU4IghiuvcnMaHViQ5toyTZ7Ak+V89M9ZW9HU+5OeJZ6S9sBBf5z6m54rzJwohdgx+NfF+oPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002785; c=relaxed/simple;
	bh=aO5EqwgfHtA9VYy8rTNySHyAG8JsB4Q86P9fq6v0/sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3xAtjmwEFMyiispm2AED5fZfpRI4Q9Dg1Sxj8MEupmeYaJkytzyp5u+sA/jN62LHuOzNS1DsrWg/kHisxUBPDglbb9Hi0siIaE/+T+7Tz2+1stQpMHqq0yT0+8Azfh/mmohRmpOff3unjBcxu3E5YVnrmig+XbQW9wrfyT1zMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Stbo8QUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Stbo8QUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD59C116D0;
	Wed, 25 Feb 2026 06:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002784;
	bh=aO5EqwgfHtA9VYy8rTNySHyAG8JsB4Q86P9fq6v0/sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Stbo8QUYaInqiuUayDIltizU3TCTGc1VGhCcS9BpneF3Fj7NjQeQQQofy0AMWrGH7
	 zbZqPPnRn4ArX49oe0zOUN4H5MDYPvGSSITtBm07K7Wmen4OvQJNC6hVAOZNgeKnIR
	 NYScCRcBWPpbBJ+9ebibdYaytddwa/qcZw10diKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingjing Deng <micro6947@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 625/641] SUNRPC: auth_gss: fix memory leaks in XDR decoding error paths
Date: Tue, 24 Feb 2026 17:25:51 -0800
Message-ID: <20260225012403.650081747@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

commit 3e6397b056335cc56ef0e9da36c95946a19f5118 upstream.

The gssx_dec_ctx(), gssx_dec_status(), and gssx_dec_name()
functions allocate memory via gssx_dec_buffer(), which calls
kmemdup(). When a subsequent decode operation fails, these
functions return immediately without freeing previously
allocated buffers, causing memory leaks.

The leak in gssx_dec_ctx() is particularly relevant because
the caller (gssp_accept_sec_context_upcall) initializes several
buffer length fields to non-zero values, resulting in memory
allocation:

    struct gssx_ctx rctxh = {
        .exported_context_token.len = GSSX_max_output_handle_sz,
        .mech.len = GSS_OID_MAX_LEN,
        .src_name.display_name.len = GSSX_max_princ_sz,
        .targ_name.display_name.len = GSSX_max_princ_sz
    };

If, for example, gssx_dec_name() succeeds for src_name but
fails for targ_name, the memory allocated for
exported_context_token, mech, and src_name.display_name
remains unreferenced and cannot be reclaimed.

Add error handling with goto-based cleanup to free any
previously allocated buffers before returning an error.

Reported-by: Xingjing Deng <micro6947@gmail.com>
Closes: https://lore.kernel.org/linux-nfs/CAK+ZN9qttsFDu6h1FoqGadXjMx1QXqPMoYQ=6O9RY4SxVTvKng@mail.gmail.com/
Fixes: 1d658336b05f ("SUNRPC: Add RPC based upcall mechanism for RPCGSS auth")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/gss_rpc_xdr.c |   82 +++++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 18 deletions(-)

--- a/net/sunrpc/auth_gss/gss_rpc_xdr.c
+++ b/net/sunrpc/auth_gss/gss_rpc_xdr.c
@@ -320,29 +320,47 @@ static int gssx_dec_status(struct xdr_st
 
 	/* status->minor_status */
 	p = xdr_inline_decode(xdr, 8);
-	if (unlikely(p == NULL))
-		return -ENOSPC;
+	if (unlikely(p == NULL)) {
+		err = -ENOSPC;
+		goto out_free_mech;
+	}
 	p = xdr_decode_hyper(p, &status->minor_status);
 
 	/* status->major_status_string */
 	err = gssx_dec_buffer(xdr, &status->major_status_string);
 	if (err)
-		return err;
+		goto out_free_mech;
 
 	/* status->minor_status_string */
 	err = gssx_dec_buffer(xdr, &status->minor_status_string);
 	if (err)
-		return err;
+		goto out_free_major_status_string;
 
 	/* status->server_ctx */
 	err = gssx_dec_buffer(xdr, &status->server_ctx);
 	if (err)
-		return err;
+		goto out_free_minor_status_string;
 
 	/* we assume we have no options for now, so simply consume them */
 	/* status->options */
 	err = dummy_dec_opt_array(xdr, &status->options);
+	if (err)
+		goto out_free_server_ctx;
 
+	return 0;
+
+out_free_server_ctx:
+	kfree(status->server_ctx.data);
+	status->server_ctx.data = NULL;
+out_free_minor_status_string:
+	kfree(status->minor_status_string.data);
+	status->minor_status_string.data = NULL;
+out_free_major_status_string:
+	kfree(status->major_status_string.data);
+	status->major_status_string.data = NULL;
+out_free_mech:
+	kfree(status->mech.data);
+	status->mech.data = NULL;
 	return err;
 }
 
@@ -505,28 +523,35 @@ static int gssx_dec_name(struct xdr_stre
 	/* name->name_type */
 	err = gssx_dec_buffer(xdr, &dummy_netobj);
 	if (err)
-		return err;
+		goto out_free_display_name;
 
 	/* name->exported_name */
 	err = gssx_dec_buffer(xdr, &dummy_netobj);
 	if (err)
-		return err;
+		goto out_free_display_name;
 
 	/* name->exported_composite_name */
 	err = gssx_dec_buffer(xdr, &dummy_netobj);
 	if (err)
-		return err;
+		goto out_free_display_name;
 
 	/* we assume we have no attributes for now, so simply consume them */
 	/* name->name_attributes */
 	err = dummy_dec_nameattr_array(xdr, &dummy_name_attr_array);
 	if (err)
-		return err;
+		goto out_free_display_name;
 
 	/* we assume we have no options for now, so simply consume them */
 	/* name->extensions */
 	err = dummy_dec_opt_array(xdr, &dummy_option_array);
+	if (err)
+		goto out_free_display_name;
 
+	return 0;
+
+out_free_display_name:
+	kfree(name->display_name.data);
+	name->display_name.data = NULL;
 	return err;
 }
 
@@ -649,32 +674,34 @@ static int gssx_dec_ctx(struct xdr_strea
 	/* ctx->state */
 	err = gssx_dec_buffer(xdr, &ctx->state);
 	if (err)
-		return err;
+		goto out_free_exported_context_token;
 
 	/* ctx->need_release */
 	err = gssx_dec_bool(xdr, &ctx->need_release);
 	if (err)
-		return err;
+		goto out_free_state;
 
 	/* ctx->mech */
 	err = gssx_dec_buffer(xdr, &ctx->mech);
 	if (err)
-		return err;
+		goto out_free_state;
 
 	/* ctx->src_name */
 	err = gssx_dec_name(xdr, &ctx->src_name);
 	if (err)
-		return err;
+		goto out_free_mech;
 
 	/* ctx->targ_name */
 	err = gssx_dec_name(xdr, &ctx->targ_name);
 	if (err)
-		return err;
+		goto out_free_src_name;
 
 	/* ctx->lifetime */
 	p = xdr_inline_decode(xdr, 8+8);
-	if (unlikely(p == NULL))
-		return -ENOSPC;
+	if (unlikely(p == NULL)) {
+		err = -ENOSPC;
+		goto out_free_targ_name;
+	}
 	p = xdr_decode_hyper(p, &ctx->lifetime);
 
 	/* ctx->ctx_flags */
@@ -683,17 +710,36 @@ static int gssx_dec_ctx(struct xdr_strea
 	/* ctx->locally_initiated */
 	err = gssx_dec_bool(xdr, &ctx->locally_initiated);
 	if (err)
-		return err;
+		goto out_free_targ_name;
 
 	/* ctx->open */
 	err = gssx_dec_bool(xdr, &ctx->open);
 	if (err)
-		return err;
+		goto out_free_targ_name;
 
 	/* we assume we have no options for now, so simply consume them */
 	/* ctx->options */
 	err = dummy_dec_opt_array(xdr, &ctx->options);
+	if (err)
+		goto out_free_targ_name;
+
+	return 0;
 
+out_free_targ_name:
+	kfree(ctx->targ_name.display_name.data);
+	ctx->targ_name.display_name.data = NULL;
+out_free_src_name:
+	kfree(ctx->src_name.display_name.data);
+	ctx->src_name.display_name.data = NULL;
+out_free_mech:
+	kfree(ctx->mech.data);
+	ctx->mech.data = NULL;
+out_free_state:
+	kfree(ctx->state.data);
+	ctx->state.data = NULL;
+out_free_exported_context_token:
+	kfree(ctx->exported_context_token.data);
+	ctx->exported_context_token.data = NULL;
 	return err;
 }
 


