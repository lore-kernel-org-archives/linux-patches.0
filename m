Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9B1332EA7;
	Mon, 29 Dec 2025 16:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025874; cv=none; b=QP7RN3L7EUmy7g1LzNnoXDBnOJYw1SJCBBG7ksSGjeFSwItXl2gJF3MGYWCl6Y5AhORTCI8+pN8V3+8V1Ugh4L+uYaPOlUeOzVaR7y3j+13Hh4kni21BaJkZ6orxq72k+idkaWxzlGheVL6WqdrSVjcztcH2p5VyrmDqMZW5bNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025874; c=relaxed/simple;
	bh=YHVO2UomZyBPbLzP0JpukHR/5yGlQa3b58v+Iq4zx+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGhdKuSLib4OSmpQDrOEX/gEKWSYlWxaQ8E5kjJFX5QSZxeAVZykMiiB1fS4idqZUrn2S0GKaYtJRRtOCfAWjLbgL1oSuRWrHxb6MB20yZ82NHFzLFcNU2zx2GRG7dqEplqUVMFfwzIlA+qsDpB/wfOLKsVe3dduoc3xgz6nq1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkeCvlQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkeCvlQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915CAC4CEF7;
	Mon, 29 Dec 2025 16:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025873;
	bh=YHVO2UomZyBPbLzP0JpukHR/5yGlQa3b58v+Iq4zx+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkeCvlQCfOMlOsvFhVq8RME5QTaXZtexS2XzH/UsdjZLxI2c/kLlnjpQNfV1lhKFW
	 RrwjnqUb8XC+h3WFjj3uqY0rW5o3QN7sjlbEHXcauFe0d0yfcslWaY0rkhwiZH+LMp
	 PBQ2r5QTgdr5PR3YWt4wYq4P93CE7dTXgnmG7ImM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 367/430] NFSD: Clear SECLABEL in the suppattr_exclcreat bitmap
Date: Mon, 29 Dec 2025 17:12:49 +0100
Message-ID: <20251229160737.831802281@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
@@ -3375,6 +3375,11 @@ static __be32 nfsd4_encode_fattr4_suppat
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


