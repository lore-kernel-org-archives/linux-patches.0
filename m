Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB0D3A16AC;
	Fri,  4 Sep 2026 05:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498735; cv=none; b=goSmbSVlLA5jsTcvqCVohdHeiHmrlN0RwSBEtzpcT1ZHevOuL5+ElYYCqHCvZaakL/ay/pTcOK0HWtGceZtejwoslz+17UvVXKXsYWyya2UrdsgltQHIO1EteWQGEJ5grFgU+A3ejJSQNNIxL6fzt3kDDvt5A+rXk2gm1Ca8v0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498735; c=relaxed/simple;
	bh=/gvu/mPsj6mVHTq7EyxNppRFYfonDQfHBfE9Z/k4aIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAjrSffmhzhANCJQ/0rvp9sUPyK1vhuquYO9ny4zi6gHCYbSVYy6KVTvpHuQwYxCBBtCvZi/wajKyD2WjUh5UYcyYQAFoMJB41OYd7SVcQ1uGjrkwpwJp4b4qMeAfNO245Ae2vDtbOfX3bgJHH2Kg/5vDfQJ8nb40iroO9+sb/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWVgfrGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWVgfrGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525681F00A3E;
	Fri,  4 Sep 2026 05:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498733;
	bh=4DjuS1D1A5WeUn2bl87KIWjGS4aLEYmoB1qHSiKQlck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWVgfrGvuQ46TSucwNC4kFz0c/jHPn8rEYfJQenn3trgHxM3JDOyXlyZx+O60m9Uc
	 drmTjfYZJ30XPzHcz2iH+xKak/Yr8A5dFQJf5jW/3lCWsPE8gvBI8CllTMXFnOjJt0
	 PKofJ5eYfZEIB+UgPx9J5MMEeMVJjiZfmz+xHgsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 166/713] nfsd: check nfsd4_acl_to_attr() return value in nfsd4_create()
Date: Fri,  4 Sep 2026 06:52:14 +0200
Message-ID: <20260904045807.543710599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 2c7912732184773dbd371a411da87af1cc080b86 upstream.

nfsd4_create() stores the return value of nfsd4_acl_to_attr() in
status, but the switch(create->cr_type) block unconditionally
overwrites it in every branch. ACL translation errors are silently
discarded, and the CREATE proceeds without the requested ACL.

Add an early exit check after nfsd4_acl_to_attr(), matching the
pattern already used in nfsd4_setattr().

Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
[ cel: prefer NFS4ERR_BADTYPE over NFS4ERR_ATTRNOTSUPP ]
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-5-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -839,6 +839,20 @@ nfsd4_create(struct svc_rqst *rqstp, str
 	if (status)
 		goto out_aftermask;
 
+	/* Sanitize cr_type to avoid returning ATTRNOTSUPP. */
+	switch (create->cr_type) {
+	case NF4LNK:
+	case NF4BLK:
+	case NF4CHR:
+	case NF4SOCK:
+	case NF4FIFO:
+	case NF4DIR:
+		break;
+	default:
+		status = nfserr_badtype;
+		goto out_aftermask;
+	}
+
 	if (create->cr_acl) {
 		if (attrs.na_dpacl || attrs.na_pacl) {
 			status = nfserr_inval;
@@ -846,6 +860,8 @@ nfsd4_create(struct svc_rqst *rqstp, str
 		}
 		status = nfsd4_acl_to_attr(create->cr_type, create->cr_acl,
 								&attrs);
+		if (status != nfs_ok)
+			goto out_aftermask;
 	}
 	current->fs->umask = create->cr_umask;
 	switch (create->cr_type) {


