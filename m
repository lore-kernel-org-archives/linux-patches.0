Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4C334DCEA;
	Tue,  6 Jan 2026 17:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720450; cv=none; b=kzo8rUnWRrnhuSbs5SwiiLOlREqP48EdyQnJPnR3z6+1hk+DfPbLyDOnhp50spocw+cg1OFMoV/Avif+LuGxDN5NSH5zPq9TWhGtvQmLe38QIHLJzzbn0DPVc8sY4bJwXg2qCileCS3eiG1Ew8BC+el9PuCUn2FTTwJpfKS1QcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720450; c=relaxed/simple;
	bh=qiQ2BPk6bhb56R92Zn6iFgd0d/EdKGb/cZAyDisR+PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXAI2g1Z1yNOgIiN5ieXkDb2tIFQXnuLNKvMjtHCn6LOiA9oEqnFb5i1Uo6l/AawBUGFeKwcIboVnGkRAaLUZJhGV25rO1efmwtebheZhFGZsExNmBNo1wsCUkBrGIBLFtYN4R1jcB1NDEZ2RcWplqhUOUL+lcWEXpKSVapY0Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oz04rCJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oz04rCJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA1EC16AAE;
	Tue,  6 Jan 2026 17:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720450;
	bh=qiQ2BPk6bhb56R92Zn6iFgd0d/EdKGb/cZAyDisR+PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oz04rCJaUx+Cad/fikKUia6X/2LYjO+0HWYymQ7fa0Nic0K5h4I5yRADOBN59Wb+c
	 AvH0PjXvqMBWBv6s9pFGYKiYbmbx/MpY2l/48QSoRhJEA8iSZezUWVX3z0w9wRBK19
	 3Sd+QsLbSUdmCP7YCRV3Gwyjzq8KZudsvPLXC260=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 239/567] NFSD: Clear SECLABEL in the suppattr_exclcreat bitmap
Date: Tue,  6 Jan 2026 18:00:21 +0100
Message-ID: <20260106170500.158723560@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 27d17641cacfedd816789b75d342430f6b912bd2 upstream.

>From RFC 8881:

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3362,6 +3362,11 @@ static __be32 nfsd4_encode_fattr4_suppat
 	u32 supp[3];
 
 	memcpy(supp, nfsd_suppattrs[resp->cstate.minorversion], sizeof(supp));
+	if (!IS_POSIXACL(d_inode(args->dentry)))
+		supp[0] &= ~FATTR4_WORD0_ACL;
+	if (!args->contextsupport)
+		supp[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
+
 	supp[0] &= NFSD_SUPPATTR_EXCLCREAT_WORD0;
 	supp[1] &= NFSD_SUPPATTR_EXCLCREAT_WORD1;
 	supp[2] &= NFSD_SUPPATTR_EXCLCREAT_WORD2;


