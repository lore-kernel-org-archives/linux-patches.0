Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30C615532E;
	Tue, 18 Jun 2024 12:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715423; cv=none; b=Z++/3rZYEEQi/QXavKOKtOx0EerFJ7Al/BocG2aObo/IWB4KDQ9DHxEg3kcx4fVFhn1qaOut4HWejy8gsMmb1M2UDgD+Q3kVz9K6d494z2VYfG8iRrVEzTCywRA3J7Eu8Wb15zuHoykt103YOoT6FF8YIZFfcBp/euefRLvaX9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715423; c=relaxed/simple;
	bh=Qiv1+vD0rgRDzWRDZkKjEbQc4Y5K13H/ljQfsgbIohw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFky1/UUf9izEE6r7ohoevfHQzaOvpixXl95u49Wn0UvtERzAkKuyytPDLqYjJmC/QqLL1zHMb99of8paFdU5Nb03XBe36mNV7S5/tDlQUeCEjqMp4RyxLDHImz4LMVD5XnQU6igWC9ktsS/0MOsLBMpiYJUGsAZr30GgJ3KAQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gf9BCsZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gf9BCsZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EC6C3277B;
	Tue, 18 Jun 2024 12:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715422;
	bh=Qiv1+vD0rgRDzWRDZkKjEbQc4Y5K13H/ljQfsgbIohw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gf9BCsZY5/mn7r5tiey505XxnOjOb0Hl2o/YL2NS/JCy0l1acTB5/rkS7kMj9rcl2
	 s6dMdDJDc7uV1dKjlziQJE/Yr/WcQTHgJNCX/HX14rziKlHSpFIukFBCmvAQIjkRD3
	 G46oe5dL4PRgkoBBFCNaq9Jgz2UZ3n6tnGMoMqoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 303/770] lockd: Update the NLMv1 TEST arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:36 +0200
Message-ID: <20240618123418.959190773@linuxfoundation.org>
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

[ Upstream commit 2fd0c67aabcf0f8821450b00ee511faa0b7761bf ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr.c | 72 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 66 insertions(+), 6 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index 8be42a23679e9..56982edd47667 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -98,6 +98,33 @@ nlm_decode_fh(__be32 *p, struct nfs_fh *f)
 	return p + XDR_QUADLEN(NFS2_FHSIZE);
 }
 
+/*
+ * NLM file handles are defined by specification to be a variable-length
+ * XDR opaque no longer than 1024 bytes. However, this implementation
+ * constrains their length to exactly the length of an NFSv2 file
+ * handle.
+ */
+static bool
+svcxdr_decode_fhandle(struct xdr_stream *xdr, struct nfs_fh *fh)
+{
+	__be32 *p;
+	u32 len;
+
+	if (xdr_stream_decode_u32(xdr, &len) < 0)
+		return false;
+	if (len != NFS2_FHSIZE)
+		return false;
+
+	p = xdr_inline_decode(xdr, len);
+	if (!p)
+		return false;
+	fh->size = NFS2_FHSIZE;
+	memcpy(fh->data, p, len);
+	memset(fh->data + NFS2_FHSIZE, 0, sizeof(fh->data) - NFS2_FHSIZE);
+
+	return true;
+}
+
 /*
  * Encode and decode owner handle
  */
@@ -143,6 +170,38 @@ nlm_decode_lock(__be32 *p, struct nlm_lock *lock)
 	return p;
 }
 
+static bool
+svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
+{
+	struct file_lock *fl = &lock->fl;
+	s32 start, len, end;
+
+	if (!svcxdr_decode_string(xdr, &lock->caller, &lock->len))
+		return false;
+	if (!svcxdr_decode_fhandle(xdr, &lock->fh))
+		return false;
+	if (!svcxdr_decode_owner(xdr, &lock->oh))
+		return false;
+	if (xdr_stream_decode_u32(xdr, &lock->svid) < 0)
+		return false;
+	if (xdr_stream_decode_u32(xdr, &start) < 0)
+		return false;
+	if (xdr_stream_decode_u32(xdr, &len) < 0)
+		return false;
+
+	locks_init_lock(fl);
+	fl->fl_flags = FL_POSIX;
+	fl->fl_type  = F_RDLCK;
+	end = start + len - 1;
+	fl->fl_start = s32_to_loff_t(start);
+	if (len == 0 || end < 0)
+		fl->fl_end = OFFSET_MAX;
+	else
+		fl->fl_end = s32_to_loff_t(end);
+
+	return true;
+}
+
 /*
  * Encode result of a TEST/TEST_MSG call
  */
@@ -192,19 +251,20 @@ nlmsvc_decode_void(struct svc_rqst *rqstp, __be32 *p)
 int
 nlmsvc_decode_testargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nlm_args *argp = rqstp->rq_argp;
-	u32	exclusive;
+	u32 exclusive;
 
-	if (!(p = nlm_decode_cookie(p, &argp->cookie)))
+	if (!svcxdr_decode_cookie(xdr, &argp->cookie))
 		return 0;
-
-	exclusive = ntohl(*p++);
-	if (!(p = nlm_decode_lock(p, &argp->lock)))
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



