Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA53217CA00;
	Tue, 18 Jun 2024 12:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715553; cv=none; b=ODS8raCK/DeoGHothHzhDko2uq7XAoI2qG8JW2pQt6uOLDIxKxgYvrRlsdKPC0f/w5WXy75mhIlWREnCxMpGILm+sMcx/pMfxOMCbEirfsS9OoNrvl10KwVyZ43vpH3FL/fDpP44hmee+SzA6eAJP83sukk/JxK4xr9DWswBMnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715553; c=relaxed/simple;
	bh=zIfMW+Gbh0wwsGmjZrYuxovoloGD5Fykye4bc51PKKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcpSXYndIjgoBP1zhjjansF91Hisdf5nt7SQBRJgiJx+Uo6meAOyP5gBF0y8XC3aRd0HvyQXlanj1fsRcJ/dHYyZJZOV0qXVO+GbMLMLmFrNIc2skGC632ODEe3ok+XDQTU6c6QyDCFlngjhcDIQ69QSDJQt7k27LQqrcl65Bzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJL7BjAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJL7BjAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD37C3277B;
	Tue, 18 Jun 2024 12:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715553;
	bh=zIfMW+Gbh0wwsGmjZrYuxovoloGD5Fykye4bc51PKKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJL7BjADs+fDt8LFkGq0Z4dyV/ogouCTzPq+VfydILv3RgQ8WULAt8WP1AOPCKGdc
	 sC+tVAZmoyi4Uh+GIcD28Lo+eny36zvzEau3BMqKAq1weLZNDjwq41jGyZtVHI5QEl
	 xMpO9z+O0gwYIrwOWRFnwF6kBfHzZ506IfhLsC+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 316/770] lockd: Update the NLMv4 TEST arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:49 +0200
Message-ID: <20240618123419.454609429@linuxfoundation.org>
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

[ Upstream commit 345b4159a075b15dc4ae70f1db90fa8abf85d2e7 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr4.c | 72 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 66 insertions(+), 6 deletions(-)

diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index d0960a8551f8b..cf64794fdc1fa 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -96,6 +96,32 @@ nlm4_decode_fh(__be32 *p, struct nfs_fh *f)
 	return p + XDR_QUADLEN(f->size);
 }
 
+/*
+ * NLM file handles are defined by specification to be a variable-length
+ * XDR opaque no longer than 1024 bytes. However, this implementation
+ * limits their length to the size of an NFSv3 file handle.
+ */
+static bool
+svcxdr_decode_fhandle(struct xdr_stream *xdr, struct nfs_fh *fh)
+{
+	__be32 *p;
+	u32 len;
+
+	if (xdr_stream_decode_u32(xdr, &len) < 0)
+		return false;
+	if (len > NFS_MAXFHSIZE)
+		return false;
+
+	p = xdr_inline_decode(xdr, len);
+	if (!p)
+		return false;
+	fh->size = len;
+	memcpy(fh->data, p, len);
+	memset(fh->data + len, 0, sizeof(fh->data) - len);
+
+	return true;
+}
+
 /*
  * Encode and decode owner handle
  */
@@ -135,6 +161,39 @@ nlm4_decode_lock(__be32 *p, struct nlm_lock *lock)
 	return p;
 }
 
+static bool
+svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
+{
+	struct file_lock *fl = &lock->fl;
+	u64 len, start;
+	s64 end;
+
+	if (!svcxdr_decode_string(xdr, &lock->caller, &lock->len))
+		return false;
+	if (!svcxdr_decode_fhandle(xdr, &lock->fh))
+		return false;
+	if (!svcxdr_decode_owner(xdr, &lock->oh))
+		return false;
+	if (xdr_stream_decode_u32(xdr, &lock->svid) < 0)
+		return false;
+	if (xdr_stream_decode_u64(xdr, &start) < 0)
+		return false;
+	if (xdr_stream_decode_u64(xdr, &len) < 0)
+		return false;
+
+	locks_init_lock(fl);
+	fl->fl_flags = FL_POSIX;
+	fl->fl_type  = F_RDLCK;
+	end = start + len - 1;
+	fl->fl_start = s64_to_loff_t(start);
+	if (len == 0 || end < 0)
+		fl->fl_end = OFFSET_MAX;
+	else
+		fl->fl_end = s64_to_loff_t(end);
+
+	return true;
+}
+
 /*
  * Encode result of a TEST/TEST_MSG call
  */
@@ -189,19 +248,20 @@ nlm4svc_decode_void(struct svc_rqst *rqstp, __be32 *p)
 int
 nlm4svc_decode_testargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nlm_args *argp = rqstp->rq_argp;
-	u32	exclusive;
+	u32 exclusive;
 
-	if (!(p = nlm4_decode_cookie(p, &argp->cookie)))
+	if (!svcxdr_decode_cookie(xdr, &argp->cookie))
 		return 0;
-
-	exclusive = ntohl(*p++);
-	if (!(p = nlm4_decode_lock(p, &argp->lock)))
+	if (xdr_stream_decode_bool(xdr, &exclusive) < 0)
+		return 0;
+	if (!svcxdr_decode_lock(xdr, &argp->lock))
 		return 0;
 	if (exclusive)
 		argp->lock.fl.fl_type = F_WRLCK;
 
-	return xdr_argsize_check(rqstp, p);
+	return 1;
 }
 
 int
-- 
2.43.0



