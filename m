Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918B813FEC
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7GBFZb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09260C433C9;
	Mon, 23 Oct 2023 11:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059283;
	bh=ChRsNnw4nRmKiC+OQTgmj+QOshAn0xWy1ma8RLloWhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7GBFZb0Hv+D9xB1sWYSyu0p8eOZMmOwWQI7pfl/THw7CfAR67Zel+9TuIp8zASWl
	 V7K2f+9//9eyniQaKJJu3IScPwQ+vHPEO6M0z4HpTQRpmBepk5cXPF79rvX9MRAjkO
	 ryeFwwo9/W24M4iOns0Au0yxOrAzdcmHcahk+YQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 126/241] SUNRPC: Fail quickly when server does not recognize TLS
Date: Mon, 23 Oct 2023 12:55:12 +0200
Message-ID: <20231023104836.943506045@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5623ecfcbec165f040a23248d39680f0cc5c0854 ]

rpcauth_checkverf() should return a distinct error code when a
server recognizes the AUTH_TLS probe but does not support TLS so
that the client's header decoder can respond appropriately and
quickly. No retries are necessary is in this case, since the server
has already affirmatively answered "TLS is unsupported".

Suggested-by: Trond Myklebust <trondmy@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth.c     | 11 ++++++++---
 net/sunrpc/auth_tls.c |  4 ++--
 net/sunrpc/clnt.c     | 10 +++++++++-
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 2f16f9d179662..814b0169f9723 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -769,9 +769,14 @@ int rpcauth_wrap_req(struct rpc_task *task, struct xdr_stream *xdr)
  * @task: controlling RPC task
  * @xdr: xdr_stream containing RPC Reply header
  *
- * On success, @xdr is updated to point past the verifier and
- * zero is returned. Otherwise, @xdr is in an undefined state
- * and a negative errno is returned.
+ * Return values:
+ *   %0: Verifier is valid. @xdr now points past the verifier.
+ *   %-EIO: Verifier is corrupted or message ended early.
+ *   %-EACCES: Verifier is intact but not valid.
+ *   %-EPROTONOSUPPORT: Server does not support the requested auth type.
+ *
+ * When a negative errno is returned, @xdr is left in an undefined
+ * state.
  */
 int
 rpcauth_checkverf(struct rpc_task *task, struct xdr_stream *xdr)
diff --git a/net/sunrpc/auth_tls.c b/net/sunrpc/auth_tls.c
index de7678f8a23d2..87f570fd3b00e 100644
--- a/net/sunrpc/auth_tls.c
+++ b/net/sunrpc/auth_tls.c
@@ -129,9 +129,9 @@ static int tls_validate(struct rpc_task *task, struct xdr_stream *xdr)
 	if (*p != rpc_auth_null)
 		return -EIO;
 	if (xdr_stream_decode_opaque_inline(xdr, &str, starttls_len) != starttls_len)
-		return -EIO;
+		return -EPROTONOSUPPORT;
 	if (memcmp(str, starttls_token, starttls_len))
-		return -EIO;
+		return -EPROTONOSUPPORT;
 	return 0;
 }
 
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index be6be7d785315..9fb0ccabc1a26 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2721,7 +2721,15 @@ rpc_decode_header(struct rpc_task *task, struct xdr_stream *xdr)
 
 out_verifier:
 	trace_rpc_bad_verifier(task);
-	goto out_garbage;
+	switch (error) {
+	case -EPROTONOSUPPORT:
+		goto out_err;
+	case -EACCES:
+		/* Re-encode with a fresh cred */
+		fallthrough;
+	default:
+		goto out_garbage;
+	}
 
 out_msg_denied:
 	error = -EACCES;
-- 
2.40.1



