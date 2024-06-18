Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F3415EFCB;
	Tue, 18 Jun 2024 12:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714961; cv=none; b=rafLr1tyhxBwzY+/Pxw3DeYeMCJ6A333zpn+QUrK4kM6GjX/LZnr/4nwDqV1OGKxGI4sIBHUX8z5dzjdmHpifKNaslsqcxxF2hqzhxJczD8kJVZHIQ30lFU1d0N00SpTDRgV+gzDjUS9Z7Ess34qbeQOX4MINW3Qdl8qMNfdFwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714961; c=relaxed/simple;
	bh=dgRBtNSwY3/bHw+JPIvUB9Pa9doOHJkxTiUBVQfObAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QD2xYIDDEc7LY7mSm3fclNlnyiXJCeRbb3L2fE+g/Hmrfx7qHyuWeQCoVsuuWJn1d8Igkwdkt+2EFKOUuXCFOjpK2IpFhNjEFU5hvT7X+6PIo4SeksQVqk/v7E5da47zAuTKjrQeTkv0HUogITxoZDMW9gmje5lRdFqc7TQIq6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccm+UTVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccm+UTVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38660C3277B;
	Tue, 18 Jun 2024 12:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714961;
	bh=dgRBtNSwY3/bHw+JPIvUB9Pa9doOHJkxTiUBVQfObAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccm+UTVxZg8XMnMTyOJPn+5nb9tk83y4vBhgBlXZi+zizWcVcpbMDrlr884MNbizl
	 jKum0maXpbAJ1/vHyGXjE48ZauzmBSv9va7FNoaLOhWuccI2sNEtWs9dCbewpbZb+C
	 NdvxHHDc/OC49MO0WII5mPUN0LmTZlpzrlz9Jkko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/770] NFSD: Update the SETATTR3args decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:01 +0200
Message-ID: <20240618123412.986656540@linuxfoundation.org>
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

[ Upstream commit 9cde9360d18d8b352b737d10f90f2aecccf93dbe ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c         | 138 +++++++++++++++++++++++++++++++++-----
 include/uapi/linux/nfs3.h |   6 ++
 2 files changed, 127 insertions(+), 17 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 9437dda2646f2..6a6bf8e34d82b 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -39,12 +39,18 @@ encode_time3(__be32 *p, struct timespec64 *time)
 	return p;
 }
 
-static __be32 *
-decode_time3(__be32 *p, struct timespec64 *time)
+static bool
+svcxdr_decode_nfstime3(struct xdr_stream *xdr, struct timespec64 *timep)
 {
-	time->tv_sec = ntohl(*p++);
-	time->tv_nsec = ntohl(*p++);
-	return p;
+	__be32 *p;
+
+	p = xdr_inline_decode(xdr, XDR_UNIT * 2);
+	if (!p)
+		return false;
+	timep->tv_sec = be32_to_cpup(p++);
+	timep->tv_nsec = be32_to_cpup(p);
+
+	return true;
 }
 
 static bool
@@ -150,6 +156,112 @@ svcxdr_decode_diropargs3(struct xdr_stream *xdr, struct svc_fh *fhp,
 		svcxdr_decode_filename3(xdr, name, len);
 }
 
+static bool
+svcxdr_decode_sattr3(struct svc_rqst *rqstp, struct xdr_stream *xdr,
+		     struct iattr *iap)
+{
+	u32 set_it;
+
+	iap->ia_valid = 0;
+
+	if (xdr_stream_decode_bool(xdr, &set_it) < 0)
+		return false;
+	if (set_it) {
+		u32 mode;
+
+		if (xdr_stream_decode_u32(xdr, &mode) < 0)
+			return false;
+		iap->ia_valid |= ATTR_MODE;
+		iap->ia_mode = mode;
+	}
+	if (xdr_stream_decode_bool(xdr, &set_it) < 0)
+		return false;
+	if (set_it) {
+		u32 uid;
+
+		if (xdr_stream_decode_u32(xdr, &uid) < 0)
+			return false;
+		iap->ia_uid = make_kuid(nfsd_user_namespace(rqstp), uid);
+		if (uid_valid(iap->ia_uid))
+			iap->ia_valid |= ATTR_UID;
+	}
+	if (xdr_stream_decode_bool(xdr, &set_it) < 0)
+		return false;
+	if (set_it) {
+		u32 gid;
+
+		if (xdr_stream_decode_u32(xdr, &gid) < 0)
+			return false;
+		iap->ia_gid = make_kgid(nfsd_user_namespace(rqstp), gid);
+		if (gid_valid(iap->ia_gid))
+			iap->ia_valid |= ATTR_GID;
+	}
+	if (xdr_stream_decode_bool(xdr, &set_it) < 0)
+		return false;
+	if (set_it) {
+		u64 newsize;
+
+		if (xdr_stream_decode_u64(xdr, &newsize) < 0)
+			return false;
+		iap->ia_valid |= ATTR_SIZE;
+		iap->ia_size = min_t(u64, newsize, NFS_OFFSET_MAX);
+	}
+	if (xdr_stream_decode_u32(xdr, &set_it) < 0)
+		return false;
+	switch (set_it) {
+	case DONT_CHANGE:
+		break;
+	case SET_TO_SERVER_TIME:
+		iap->ia_valid |= ATTR_ATIME;
+		break;
+	case SET_TO_CLIENT_TIME:
+		if (!svcxdr_decode_nfstime3(xdr, &iap->ia_atime))
+			return false;
+		iap->ia_valid |= ATTR_ATIME | ATTR_ATIME_SET;
+		break;
+	default:
+		return false;
+	}
+	if (xdr_stream_decode_u32(xdr, &set_it) < 0)
+		return false;
+	switch (set_it) {
+	case DONT_CHANGE:
+		break;
+	case SET_TO_SERVER_TIME:
+		iap->ia_valid |= ATTR_MTIME;
+		break;
+	case SET_TO_CLIENT_TIME:
+		if (!svcxdr_decode_nfstime3(xdr, &iap->ia_mtime))
+			return false;
+		iap->ia_valid |= ATTR_MTIME | ATTR_MTIME_SET;
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
+static bool
+svcxdr_decode_sattrguard3(struct xdr_stream *xdr, struct nfsd3_sattrargs *args)
+{
+	__be32 *p;
+	u32 check;
+
+	if (xdr_stream_decode_bool(xdr, &check) < 0)
+		return false;
+	if (check) {
+		p = xdr_inline_decode(xdr, XDR_UNIT * 2);
+		if (!p)
+			return false;
+		args->check_guard = 1;
+		args->guardtime = be32_to_cpup(p);
+	} else
+		args->check_guard = 0;
+
+	return true;
+}
+
 static __be32 *
 decode_sattr3(__be32 *p, struct iattr *iap, struct user_namespace *userns)
 {
@@ -377,20 +489,12 @@ nfs3svc_decode_fhandleargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_decode_sattrargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_sattrargs *args = rqstp->rq_argp;
 
-	p = decode_fh(p, &args->fh);
-	if (!p)
-		return 0;
-	p = decode_sattr3(p, &args->attrs, nfsd_user_namespace(rqstp));
-
-	if ((args->check_guard = ntohl(*p++)) != 0) { 
-		struct timespec64 time;
-		p = decode_time3(p, &time);
-		args->guardtime = time.tv_sec;
-	}
-
-	return xdr_argsize_check(rqstp, p);
+	return svcxdr_decode_nfs_fh3(xdr, &args->fh) &&
+		svcxdr_decode_sattr3(rqstp, xdr, &args->attrs) &&
+		svcxdr_decode_sattrguard3(xdr, args);
 }
 
 int
diff --git a/include/uapi/linux/nfs3.h b/include/uapi/linux/nfs3.h
index 37e4b34e6b435..c22ab77713bd0 100644
--- a/include/uapi/linux/nfs3.h
+++ b/include/uapi/linux/nfs3.h
@@ -63,6 +63,12 @@ enum nfs3_ftype {
 	NF3BAD  = 8
 };
 
+enum nfs3_time_how {
+	DONT_CHANGE		= 0,
+	SET_TO_SERVER_TIME	= 1,
+	SET_TO_CLIENT_TIME	= 2,
+};
+
 struct nfs3_fh {
 	unsigned short size;
 	unsigned char  data[NFS3_FHSIZE];
-- 
2.43.0



