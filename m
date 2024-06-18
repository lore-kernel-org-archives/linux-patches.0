Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8B515F408;
	Tue, 18 Jun 2024 12:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715006; cv=none; b=EVS0zm3H68HZgPz7jN74Ccc3RtGOpBjShaljOJpYynD6L6KkOOLqJS54ryeKXg2E++HwtEPLQw8egEsuWe49p9mea/bp+2+/MTvdi1N4JZ7sC73VG3D0p8inagDOzsHrMzrtT4a5ZQjGbcqLrvncRhHMPkHdSMy8LukBxbLksXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715006; c=relaxed/simple;
	bh=L/qgyFg/X5mf7Pv2NTPlbnWANHNcnY8uLN4sBuDlyCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzgLaoHRZ7HILK+2cNwnWumroOP+TvUKndV6mFKq4pkETziaZajFS75ig6yuhhUrsADgg9JFmibSmQswyYEOClc3m4qN1PtuhBaBpLbxYnRuW3Lol+7KvyPtqzXDEPDGrFSDqrdljjhGx6tr8tbIP9GnVrZnoZFPu+tbl3rZTJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRZ0zkFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRZ0zkFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D75C4AF48;
	Tue, 18 Jun 2024 12:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715005;
	bh=L/qgyFg/X5mf7Pv2NTPlbnWANHNcnY8uLN4sBuDlyCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRZ0zkFiPidtIsANJftmMlpj7AQJa1diNRZz3jpkbTAypILKh7S4wLfs0PRJK60zE
	 /LgPiLRzEuCW3q0oPYql+KiWhkvihufsn7Y/eQsfd39ZV1lIcKB/DnhUKcfoQZXPPo
	 8ZoR7ZDOnE0ILl/QCBlEot6t0FaPZXWByfQH5TXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 162/770] NFSD: Update the NFSv2 SETATTR argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:15 +0200
Message-ID: <20240618123413.527717520@linuxfoundation.org>
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

[ Upstream commit 2fdd6bd293b9e7dda61220538b2759fbf06f5af0 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsxdr.c | 82 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 76 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 3d0fe03a3fb94..6c87ea8f38769 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -173,6 +173,79 @@ decode_sattr(__be32 *p, struct iattr *iap, struct user_namespace *userns)
 	return p;
 }
 
+static bool
+svcxdr_decode_sattr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
+		    struct iattr *iap)
+{
+	u32 tmp1, tmp2;
+	__be32 *p;
+
+	p = xdr_inline_decode(xdr, XDR_UNIT * 8);
+	if (!p)
+		return false;
+
+	iap->ia_valid = 0;
+
+	/*
+	 * Some Sun clients put 0xffff in the mode field when they
+	 * mean 0xffffffff.
+	 */
+	tmp1 = be32_to_cpup(p++);
+	if (tmp1 != (u32)-1 && tmp1 != 0xffff) {
+		iap->ia_valid |= ATTR_MODE;
+		iap->ia_mode = tmp1;
+	}
+
+	tmp1 = be32_to_cpup(p++);
+	if (tmp1 != (u32)-1) {
+		iap->ia_uid = make_kuid(nfsd_user_namespace(rqstp), tmp1);
+		if (uid_valid(iap->ia_uid))
+			iap->ia_valid |= ATTR_UID;
+	}
+
+	tmp1 = be32_to_cpup(p++);
+	if (tmp1 != (u32)-1) {
+		iap->ia_gid = make_kgid(nfsd_user_namespace(rqstp), tmp1);
+		if (gid_valid(iap->ia_gid))
+			iap->ia_valid |= ATTR_GID;
+	}
+
+	tmp1 = be32_to_cpup(p++);
+	if (tmp1 != (u32)-1) {
+		iap->ia_valid |= ATTR_SIZE;
+		iap->ia_size = tmp1;
+	}
+
+	tmp1 = be32_to_cpup(p++);
+	tmp2 = be32_to_cpup(p++);
+	if (tmp1 != (u32)-1 && tmp2 != (u32)-1) {
+		iap->ia_valid |= ATTR_ATIME | ATTR_ATIME_SET;
+		iap->ia_atime.tv_sec = tmp1;
+		iap->ia_atime.tv_nsec = tmp2 * NSEC_PER_USEC;
+	}
+
+	tmp1 = be32_to_cpup(p++);
+	tmp2 = be32_to_cpup(p++);
+	if (tmp1 != (u32)-1 && tmp2 != (u32)-1) {
+		iap->ia_valid |= ATTR_MTIME | ATTR_MTIME_SET;
+		iap->ia_mtime.tv_sec = tmp1;
+		iap->ia_mtime.tv_nsec = tmp2 * NSEC_PER_USEC;
+		/*
+		 * Passing the invalid value useconds=1000000 for mtime
+		 * is a Sun convention for "set both mtime and atime to
+		 * current server time".  It's needed to make permissions
+		 * checks for the "touch" program across v2 mounts to
+		 * Solaris and Irix boxes work correctly. See description of
+		 * sattr in section 6.1 of "NFS Illustrated" by
+		 * Brent Callaghan, Addison-Wesley, ISBN 0-201-32750-5
+		 */
+		if (tmp2 == 1000000)
+			iap->ia_valid &= ~(ATTR_ATIME_SET|ATTR_MTIME_SET);
+	}
+
+	return true;
+}
+
 static __be32 *
 encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
 	     struct kstat *stat)
@@ -253,14 +326,11 @@ nfssvc_decode_fhandleargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfssvc_decode_sattrargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd_sattrargs *args = rqstp->rq_argp;
 
-	p = decode_fh(p, &args->fh);
-	if (!p)
-		return 0;
-	p = decode_sattr(p, &args->attrs, nfsd_user_namespace(rqstp));
-
-	return xdr_argsize_check(rqstp, p);
+	return svcxdr_decode_fhandle(xdr, &args->fh) &&
+		svcxdr_decode_sattr(rqstp, xdr, &args->attrs);
 }
 
 int
-- 
2.43.0



