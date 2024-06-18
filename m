Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7413D1553AE;
	Tue, 18 Jun 2024 12:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715473; cv=none; b=PYfkK0IaxfcNyEB4jXc+VdlDZadGqs5yF6E+1S1cBvPtX3AYkLoVJ13qzoVkCD52EIT1N6LV8DxVMVxZ/gGB2HoCx43fS9hp8zuTMe8ClusjvQdKkIJb8LDLbNrRo9b1Hcz9s3KWRNtQC8CUFPyU1GZ4xpqEHC5sQdziW+ySA0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715473; c=relaxed/simple;
	bh=KEq5nlsbN3d0T5lLW6v2EUopnf0JHZSNU2bHoQX0fy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nskVyQS1uGO59ZArueJ0jBGDFWuzvio7Hca9g2geNEMZtPbUm7OEXjun9WMrk4GQT+/f2i28KnvTDIVrBkIGh09QMXEZCaM5c0doglrG+7ahcVFbzhwn+N+VOyBJEzsCS4J/gaQcj8jdzHKWyoLjM2gDA00Qahbie/WP25MMRZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZafFSPzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZafFSPzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA4EC3277B;
	Tue, 18 Jun 2024 12:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715473;
	bh=KEq5nlsbN3d0T5lLW6v2EUopnf0JHZSNU2bHoQX0fy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZafFSPzROQVmj/K75Z6kc/k5LnryciApEW2+SC131BQQiO/oFQEYVpXa9D91AfYfu
	 66JupOOnLtE36OgEhUqFJYqAIbwv/+QioXv+FLByZ+tRD3QP6Q0qz1q3YcqC/qfz//
	 gWv+ulOEm4mnXQH7t5BYvP7vb5XrhilKRJ5gOP+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 321/770] lockd: Update the NLMv4 SM_NOTIFY arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:54 +0200
Message-ID: <20240618123419.648665221@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit bc3665fd718b325cfff3abd383b00d1a87e028dc ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr4.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 6bd3bfb69ed7f..2dbf82c2726be 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -309,6 +309,32 @@ nlm4svc_decode_res(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
+int
+nlm4svc_decode_reboot(struct svc_rqst *rqstp, __be32 *p)
+{
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
+	struct nlm_reboot *argp = rqstp->rq_argp;
+	u32 len;
+
+	if (xdr_stream_decode_u32(xdr, &len) < 0)
+		return 0;
+	if (len > SM_MAXSTRLEN)
+		return 0;
+	p = xdr_inline_decode(xdr, len);
+	if (!p)
+		return 0;
+	argp->len = len;
+	argp->mon = (char *)p;
+	if (xdr_stream_decode_u32(xdr, &argp->state) < 0)
+		return 0;
+	p = xdr_inline_decode(xdr, SM_PRIV_SIZE);
+	if (!p)
+		return 0;
+	memcpy(&argp->priv.data, p, sizeof(argp->priv.data));
+
+	return 1;
+}
+
 int
 nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
@@ -376,19 +402,6 @@ nlm4svc_decode_notify(struct svc_rqst *rqstp, __be32 *p)
 	return xdr_argsize_check(rqstp, p);
 }
 
-int
-nlm4svc_decode_reboot(struct svc_rqst *rqstp, __be32 *p)
-{
-	struct nlm_reboot *argp = rqstp->rq_argp;
-
-	if (!(p = xdr_decode_string_inplace(p, &argp->mon, &argp->len, SM_MAXSTRLEN)))
-		return 0;
-	argp->state = ntohl(*p++);
-	memcpy(&argp->priv.data, p, sizeof(argp->priv.data));
-	p += XDR_QUADLEN(SM_PRIV_SIZE);
-	return xdr_argsize_check(rqstp, p);
-}
-
 int
 nlm4svc_encode_void(struct svc_rqst *rqstp, __be32 *p)
 {
-- 
2.43.0



