Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B143242D6;
	Wed, 25 Feb 2026 06:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002785; cv=none; b=lPwwog80bmFihSbyMSBew3RbNPn7wFM+dULZpgAbZIAO8kQvIU0WitWKzfGkBRkedO2RNVIM09hS7OVujxAT6WxMOVD2nvlKeZFRPq2/wbB7ArW4jAw/5sWOMxM8WBhBmZ8aJgxktlUKrwzb/HFJQS8Exha55YcnnQexmwwG1G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002785; c=relaxed/simple;
	bh=a/UU3qy7q4jy/YaBc4PtzF+ukV9XEDslfKVi87aGdH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lpin2Vp70zD7DKU7rVE1NSU3/M3Zii7EWEIDZhHn11moT/lscaK3Tc8B3rpTvvlvya8pl4R0NAj2996cEOH5NZe03VifhT85bmmoNnjpi0yuD7i6ri89I8H3sGOXTOVTOLh4mXRJ1A3UDqt9CSArbWWhZCSZgtfUN+5aUk551HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9kj9JyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9kj9JyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E49C116D0;
	Wed, 25 Feb 2026 06:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002785;
	bh=a/UU3qy7q4jy/YaBc4PtzF+ukV9XEDslfKVi87aGdH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9kj9JyKL8Z/1F6G3pI0uxCDIUnb/oF5Q+nJhi441hk2BCVO23XEhnkZZXH+eNWL0
	 U/ptqhb9CmjJ7LZHEal4vEpbfSeR+QKwwIt4RHdnfqvTAxePZyPQJxKoqbEiAcSnms
	 yyEm5Q3Fy8RSPlO6VkRdbVEwmTZ2/TnlXPLE/FPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.18 626/641] SUNRPC: fix gss_auth kref leak in gss_alloc_msg error path
Date: Tue, 24 Feb 2026 17:25:52 -0800
Message-ID: <20260225012403.674148372@linuxfoundation.org>
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

From: Daniel Hodges <git@danielhodges.dev>

commit dd2fdc3504592d85e549c523b054898a036a6afe upstream.

Commit 5940d1cf9f42 ("SUNRPC: Rebalance a kref in auth_gss.c") added
a kref_get(&gss_auth->kref) call to balance the gss_put_auth() done
in gss_release_msg(), but forgot to add a corresponding kref_put()
on the error path when kstrdup_const() fails.

If service_name is non-NULL and kstrdup_const() fails, the function
jumps to err_put_pipe_version which calls put_pipe_version() and
kfree(gss_msg), but never releases the gss_auth reference. This leads
to a kref leak where the gss_auth structure is never freed.

Add a forward declaration for gss_free_callback() and call kref_put()
in the err_put_pipe_version error path to properly release the
reference taken earlier.

Fixes: 5940d1cf9f42 ("SUNRPC: Rebalance a kref in auth_gss.c")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Hodges <git@danielhodges.dev>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/auth_gss.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -39,6 +39,8 @@ static const struct rpc_authops authgss_
 static const struct rpc_credops gss_credops;
 static const struct rpc_credops gss_nullops;
 
+static void gss_free_callback(struct kref *kref);
+
 #define GSS_RETRY_EXPIRED 5
 static unsigned int gss_expired_cred_retry_delay = GSS_RETRY_EXPIRED;
 
@@ -551,6 +553,7 @@ gss_alloc_msg(struct gss_auth *gss_auth,
 	}
 	return gss_msg;
 err_put_pipe_version:
+	kref_put(&gss_auth->kref, gss_free_callback);
 	put_pipe_version(gss_auth->net);
 err_free_msg:
 	kfree(gss_msg);


