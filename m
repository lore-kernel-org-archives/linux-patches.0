Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5745256C84;
	Wed, 25 Feb 2026 01:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983685; cv=none; b=REeGnEiEyC/eakqf//XbvMLz+4thxxzdIb9msjKL+gsI8h4dudg6LEJ2lkwmPEeSU2mbaSkOjmyHuYnVtvU0Ds05kIbJxET1hZCm6Xa0oPLyf5/WIMtGc2w7N/dURqDVosy1rjjQ8jJ87maLWaWPNbzLuCgR2i/A2hb4DsD9a4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983685; c=relaxed/simple;
	bh=1uxREbklg5i0iVHPxFottOFQIiigj3O6d0pO52pdFQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQutQPNJNt0mgH55slbsgsukRJC/qPxd+LUaidoYa3O6ZhNNMatebjI/rm9H0O/qCh21lE5f24Bw1JPojAWsI0eeJ1wCgWFpz5AAIXv8SCJuPOwL1t+3f10v019rfKNmFG8wa98QcEC4LZzbm7xYSLRLtaJhLXvqaEVnBW26AIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMLJwQ4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMLJwQ4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976BAC19423;
	Wed, 25 Feb 2026 01:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983685;
	bh=1uxREbklg5i0iVHPxFottOFQIiigj3O6d0pO52pdFQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMLJwQ4KdfiQlU3aCteoA79gPDI7ft+DH2/RLBZnHCn46IQVwjE5/ZBlY++ecwErD
	 /q1mpiGN2AgVYO1CGegnLAvmWHE9iP//d0C4ATvc+lXOqEFz998U6F3qdYR8xOFp8V
	 9rFcpALDiXquLLfZz3FRsNVZ+Ua4xjq1I2ArRu/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.19 769/781] SUNRPC: fix gss_auth kref leak in gss_alloc_msg error path
Date: Tue, 24 Feb 2026 17:24:38 -0800
Message-ID: <20260225012418.577751454@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


