Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EAD13BC35;
	Tue, 18 Jun 2024 12:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715559; cv=none; b=hB463/2G95PsX7rGOMqTcJ/i57dS6Zh6vnmU6aNXA32nT0L8jLktG7lBFGaBE7uzjtl7c3+9tqa7SLzEPzE30oBZL/Z5pAo+nWu+rknxoaN4HEVLa5lHnSV6HozmquFCmd3dEqPSUd6dXSpsC3niYDq3EnJlXmXVtXQOaVkXX+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715559; c=relaxed/simple;
	bh=Z9QTNTuueOGEptmVlO1RXbnMhZltpYgowgdHthfZg/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvaKlliKFED3NvhQyhQ5xteHvfkg2acI4BF6RbIrMtpochros6JJnqmFA0kQZrDNYlQrrBE43g7/7pGcDj9+4qcF5PxLO7Q+AxzOPBLz6cps7GkrlynzU8OJ8Pd0xcS83ltPT55fXlKZ8EYFkHeifvZcFXaZTmOReDMgvNWuLU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbWGXmB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbWGXmB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5C7C3277B;
	Tue, 18 Jun 2024 12:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715559;
	bh=Z9QTNTuueOGEptmVlO1RXbnMhZltpYgowgdHthfZg/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbWGXmB8S11KZ/eV+V0IVrt50BaqABenj5ezk02+EmAcbd+p179KKOu0FqM0BusHg
	 vqZwoeAQR1ISKWCrOXelvcpimhoX1Uwb+s+M9btxvL6fvrCKgkLNmUXoTc3rzjxNJa
	 9aPnBaEFX5amsghLI4m/f1lHiY8/6UAYW8j06DpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 308/770] lockd: Update the NLMv1 SM_NOTIFY arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:41 +0200
Message-ID: <20240618123419.149321981@linuxfoundation.org>
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

[ Upstream commit 137e05e2f735f696e117553f7fa5ef8fb09953e1 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index 911b6377a6da4..421613170e5f9 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -313,6 +313,32 @@ nlmsvc_decode_res(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
+int
+nlmsvc_decode_reboot(struct svc_rqst *rqstp, __be32 *p)
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
 nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
@@ -380,19 +406,6 @@ nlmsvc_decode_notify(struct svc_rqst *rqstp, __be32 *p)
 	return xdr_argsize_check(rqstp, p);
 }
 
-int
-nlmsvc_decode_reboot(struct svc_rqst *rqstp, __be32 *p)
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
 nlmsvc_encode_void(struct svc_rqst *rqstp, __be32 *p)
 {
-- 
2.43.0



