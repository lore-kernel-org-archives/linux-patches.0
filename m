Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A76E6DCE1;
	Wed,  9 Sep 2026 14:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964741; cv=none; b=MpP/jVSwD5xnNPH8CIHt7K/vST25Rw54FLbqFje6GzLV/DgbaZFLyd3kCCrvZX/YMVrEnq+KQhjeMEbdOsBbSFudMGR3RSBTthHQFkMVE1aLJOAAUA6Jdu1Nn2mRYfe5IuxvIh3cBMIU23lGTSNSrs8haS6UVu+gHRSZsA89LcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964741; c=relaxed/simple;
	bh=ec8VF7sFQrowADGKYNe249uEqEIeznNkIhy7ZocDpbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIEAS/p4vpdF8oDIU/zXpiJOG7QYA+YEdYdx9+xtIsP+bHsKMc9oThBIyDqjir4MuhjYOXf3COyt6Q+lSzsvKx9vwFlQqK9pMEJZWd5AgM0yGRsfAdOOQ/pJN+deUglD2TTeFlrhcD9L8p6IME5dDS1tS7cX894v+sunLRZEHVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Axt7zmdX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Axt7zmdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1B11F00A3A;
	Wed,  9 Sep 2026 14:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964740;
	bh=FLgdp4z9DAtNhkzgkCUG8jSmWd1AEw7PlFOpjZjxMWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Axt7zmdXbfr/FY9no1gcVgSrc8LVT/euxdw7RJiVMgEe8scKr1q1ZVORuvlZwd7mj
	 2YEH6Q7FVbMPQPI5pUJco4Ev/r0lSk2LZ0OmWu44fXheHSbDcRX+FcCmKPx9CVBftl
	 Z9E6bQvAoZsYs8w4r8OvvTwwnP+HbZaxkWbvy34g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 528/583] nfsd: check nfsd4_acl_to_attr() return value in nfsd4_create()
Date: Wed,  9 Sep 2026 15:43:33 +0200
Message-ID: <20260909134256.106676429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ retained unconditional ACL conversion because the older helper already handles null ACLs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -800,7 +800,23 @@ nfsd4_create(struct svc_rqst *rqstp, str
 	if (status)
 		return status;
 
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
 	status = nfsd4_acl_to_attr(create->cr_type, create->cr_acl, &attrs);
+	if (status != nfs_ok)
+		goto out_aftermask;
 	current->fs->umask = create->cr_umask;
 	switch (create->cr_type) {
 	case NF4LNK:
@@ -867,6 +883,7 @@ out:
 	fh_put(&resfh);
 out_umask:
 	current->fs->umask = 0;
+out_aftermask:
 	nfsd_attrs_free(&attrs);
 	return status;
 }


