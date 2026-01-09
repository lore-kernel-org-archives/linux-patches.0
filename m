Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B789C224D6;
	Fri,  9 Jan 2026 12:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961133; cv=none; b=g0VZm/t70AJoIueUL6Fl5mPQ3mdOSfCg4E+RAb/AE4MAu7Y6lO+QTnEcm7RyhCgK3EqgALugWQRpSrof46wVpJ+bnvaVEf6oB5adeBWQvJPqhuRE/PiA/MkECqDGQLKFu8EP4fIif+0AImV4QLkniIIq5w3ET6Smz2ItzIjF+qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961133; c=relaxed/simple;
	bh=fgWJBF3jvwE/1WOnRv5F8ed0iSaN7EDD/qNm6gf6K0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuCBqq/pbkAf/V0psU6U4aXSExYA/bsq1nZjjtAKbOr8etr6NuLtSO6zFUvPgdqcTnbHRMRWj4kxit2QMeSplU2DD37moMM03t1+kpiVXxUDlU4uABYUJmTEb3AY2spwD+iqII5Gw+8QJdM/311IxdkPH+MkV8MvJU39tygAOqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpUybN7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpUybN7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435B7C16AAE;
	Fri,  9 Jan 2026 12:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961133;
	bh=fgWJBF3jvwE/1WOnRv5F8ed0iSaN7EDD/qNm6gf6K0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpUybN7kx1f+IdYcsF9Gg2aD5Az9FRpEa2Auj3FB+e8hxD3dD7rK767eakxKPog3g
	 XHLUZ72BU5Aaj+Bli59kuLjvLvGxzuTn9IT10GF9PD5t0/Vw3jWUL8aA/dWNNjriQS
	 nfdwGxuvZPqnXCzaXo37DOZNg0jkGMTaoBZ9nmJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 647/737] NFSD: Clear SECLABEL in the suppattr_exclcreat bitmap
Date: Fri,  9 Jan 2026 12:43:06 +0100
Message-ID: <20260109112158.355440662@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 27d17641cacfedd816789b75d342430f6b912bd2 ]

>>From RFC 8881:

5.8.1.14. Attribute 75: suppattr_exclcreat

> The bit vector that would set all REQUIRED and RECOMMENDED
> attributes that are supported by the EXCLUSIVE4_1 method of file
> creation via the OPEN operation. The scope of this attribute
> applies to all objects with a matching fsid.

There's nothing in RFC 8881 that states that suppattr_exclcreat is
or is not allowed to contain bits for attributes that are clear in
the reported supported_attrs bitmask. But it doesn't make sense for
an NFS server to indicate that it /doesn't/ implement an attribute,
but then also indicate that clients /are/ allowed to set that
attribute using OPEN(create) with EXCLUSIVE4_1.

Ensure that the SECURITY_LABEL and ACL bits are not set in the
suppattr_exclcreat bitmask when they are also not set in the
supported_attrs bitmask.

Fixes: 8c18f2052e75 ("nfsd41: SUPPATTR_EXCLCREAT attribute")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3419,6 +3419,11 @@ out_acl:
 		u32 supp[3];
 
 		memcpy(supp, nfsd_suppattrs[minorversion], sizeof(supp));
+		if (!IS_POSIXACL(d_inode(dentry)))
+			supp[0] &= ~FATTR4_WORD0_ACL;
+		if (!contextsupport)
+			supp[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
+
 		supp[0] &= NFSD_SUPPATTR_EXCLCREAT_WORD0;
 		supp[1] &= NFSD_SUPPATTR_EXCLCREAT_WORD1;
 		supp[2] &= NFSD_SUPPATTR_EXCLCREAT_WORD2;


