Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D17C17B41A;
	Tue, 18 Jun 2024 12:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715541; cv=none; b=kr8WA9qv83M0K88IqEwoL4UEEE7ElEa47DKtEefnJH+pT1AW0RNAJPeaMuRzpjTTOd0KyI5uefo38rLOHta3GVnoopVAZBBZeiSMOiqlPgnF6Gm9DZd3LUufC1ViimA806+NOtrIbyGNQSz3lQ2peKFlE+N7wDVh+CXWVG0wsPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715541; c=relaxed/simple;
	bh=06ZwBOxHjdi8VP+6JHswstpFHuLMXTg3OrhOHINMJ8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pD0k/vLCf5kk3tAKiKljDVGMG3zpHVjHdf0ZBVeCKFZNQ/P9VChAYZpwFZGIlK9PBI5GBN2GTL3nupmEqd7H9Ru31t2NNkKih9XxtQJ2XWHUuX2XDSiVENIf/3tYSK/muzJqEvHCqBdB8HSvEuEswwQeq7ArY3AMgvEyVg2mhzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFacrARS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFacrARS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1358EC3277B;
	Tue, 18 Jun 2024 12:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715541;
	bh=06ZwBOxHjdi8VP+6JHswstpFHuLMXTg3OrhOHINMJ8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFacrARSRhWOKeyOCebBKVgQTaQYoAsMc8YpJ0efJGwJ9G00xAjs0/vmT7ksyRtgh
	 dsaoA9rTh61e54LJgorpla2AAJN+MEHrGsHRRs//A31RF9HZPI4tsXEuCeTVYY4oYF
	 CwyeGOA/qUodY0S5uDcKgaAs06dDCR3ks7BWf+Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 312/770] lockd: Update the NLMv1 TEST results encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:45 +0200
Message-ID: <20240618123419.302543147@linuxfoundation.org>
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

[ Upstream commit adf98a4850b9ede9fc174c78a885845fb08499a5 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr.c | 74 ++++++++++++++++++++++++--------------------------
 1 file changed, 35 insertions(+), 39 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index 840fa8ff84269..daf3524040d66 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -80,15 +80,6 @@ svcxdr_decode_fhandle(struct xdr_stream *xdr, struct nfs_fh *fh)
 	return true;
 }
 
-/*
- * Encode and decode owner handle
- */
-static inline __be32 *
-nlm_encode_oh(__be32 *p, struct xdr_netobj *oh)
-{
-	return xdr_encode_netobj(p, oh);
-}
-
 static bool
 svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
 {
@@ -121,39 +112,44 @@ svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
 	return true;
 }
 
-/*
- * Encode result of a TEST/TEST_MSG call
- */
-static __be32 *
-nlm_encode_testres(__be32 *p, struct nlm_res *resp)
+static bool
+svcxdr_encode_holder(struct xdr_stream *xdr, const struct nlm_lock *lock)
 {
-	s32		start, len;
-
-	if (!(p = nlm_encode_cookie(p, &resp->cookie)))
-		return NULL;
-	*p++ = resp->status;
+	const struct file_lock *fl = &lock->fl;
+	s32 start, len;
 
-	if (resp->status == nlm_lck_denied) {
-		struct file_lock	*fl = &resp->lock.fl;
-
-		*p++ = (fl->fl_type == F_RDLCK)? xdr_zero : xdr_one;
-		*p++ = htonl(resp->lock.svid);
-
-		/* Encode owner handle. */
-		if (!(p = xdr_encode_netobj(p, &resp->lock.oh)))
-			return NULL;
+	/* exclusive */
+	if (xdr_stream_encode_bool(xdr, fl->fl_type != F_RDLCK) < 0)
+		return false;
+	if (xdr_stream_encode_u32(xdr, lock->svid) < 0)
+		return false;
+	if (!svcxdr_encode_owner(xdr, &lock->oh))
+		return false;
+	start = loff_t_to_s32(fl->fl_start);
+	if (fl->fl_end == OFFSET_MAX)
+		len = 0;
+	else
+		len = loff_t_to_s32(fl->fl_end - fl->fl_start + 1);
+	if (xdr_stream_encode_u32(xdr, start) < 0)
+		return false;
+	if (xdr_stream_encode_u32(xdr, len) < 0)
+		return false;
 
-		start = loff_t_to_s32(fl->fl_start);
-		if (fl->fl_end == OFFSET_MAX)
-			len = 0;
-		else
-			len = loff_t_to_s32(fl->fl_end - fl->fl_start + 1);
+	return true;
+}
 
-		*p++ = htonl(start);
-		*p++ = htonl(len);
+static bool
+svcxdr_encode_testrply(struct xdr_stream *xdr, const struct nlm_res *resp)
+{
+	if (!svcxdr_encode_stats(xdr, resp->status))
+		return false;
+	switch (resp->status) {
+	case nlm_lck_denied:
+		if (!svcxdr_encode_holder(xdr, &resp->lock))
+			return false;
 	}
 
-	return p;
+	return true;
 }
 
 
@@ -345,11 +341,11 @@ nlmsvc_encode_void(struct svc_rqst *rqstp, __be32 *p)
 int
 nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nlm_res *resp = rqstp->rq_resp;
 
-	if (!(p = nlm_encode_testres(p, resp)))
-		return 0;
-	return xdr_ressize_check(rqstp, p);
+	return svcxdr_encode_cookie(xdr, &resp->cookie) &&
+		svcxdr_encode_testrply(xdr, resp);
 }
 
 int
-- 
2.43.0



