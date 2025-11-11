Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391B82AE8D;
	Tue, 11 Nov 2025 00:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822148; cv=none; b=HxnSQduIwnhTLE01F177PZoHMWMxVnnl9rtiHLpmAqVvP0z4AyIvf+WCWNnSeh09R8mVstipgNWX1gq8+tbXn3FlWuerwYeceVZJDl8V/j8yR+IelPOs+sPqbh4y8J9bvQFygrMPAL2vE+oDip/M4SO3SEFw4v2Kg+nnsDtbOWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822148; c=relaxed/simple;
	bh=gupxntolVK0kgJwU7VOyDEzUpoIYhY06reuvsCzUI+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bf3KGpQQ0yP45KYprKxEOR94wAdT+zZOt6VTjT9PSatipjLU7lJ9ch7SxNR7+aASr3z6mN1ppvLdXlhON6ihF7euSkvQ4wgeAQySZiKQG3q2YMwilZxk2M8yP2SfqzW+QAli78pGimKzcxfjKjFSDfHl8s+ifT1A5v/9KyKh+ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKC5uvQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKC5uvQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89A9C4CEFB;
	Tue, 11 Nov 2025 00:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822148;
	bh=gupxntolVK0kgJwU7VOyDEzUpoIYhY06reuvsCzUI+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKC5uvQmFEft7KkFSGxtkyq5zFJ+FbeWCo7afNdCmwWE9rkaiweBBucwPHTN7/MA9
	 LQvcwBqBiQSbljsvaM6EqYPH72SciZFksv0WCB7yneeMLs2XnEtpXzSjw6KUAvcB4N
	 x3YQ6WwQj1Hpkf8ulk/jhnOWEkZMNXOzPGoZLg9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.17 003/849] NFSD: Define actions for the new time_deleg FATTR4 attributes
Date: Tue, 11 Nov 2025 09:32:53 +0900
Message-ID: <20251111004536.547674614@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 4f76435fd517981f01608678c06ad9718a86ee98 upstream.

NFSv4 clients won't send legitimate GETATTR requests for these new
attributes because they are intended to be used only with CB_GETATTR
and SETATTR. But NFSD has to do something besides crashing if it
ever sees a GETATTR request that queries these attributes.

RFC 8881 Section 18.7.3 states:

> The server MUST return a value for each attribute that the client
> requests if the attribute is supported by the server for the
> target file system. If the server does not support a particular
> attribute on the target file system, then it MUST NOT return the
> attribute value and MUST NOT set the attribute bit in the result
> bitmap. The server MUST return an error if it supports an
> attribute on the target but cannot obtain its value. In that case,
> no attribute values will be returned.

Further, RFC 9754 Section 5 states:

> These new attributes are invalid to be used with GETATTR, VERIFY,
> and NVERIFY, and they can only be used with CB_GETATTR and SETATTR
> by a client holding an appropriate delegation.

Thus there does not appear to be a specific server response mandated
by specification. Taking the guidance that querying these attributes
via GETATTR is "invalid", NFSD will return nfserr_inval, failing the
request entirely.

Reported-by: Robert Morris <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/linux-nfs/7819419cf0cb50d8130dc6b747765d2b8febc88a.camel@kernel.org/T/#t
Fixes: 51c0d4f7e317 ("nfsd: add support for FATTR4_OPEN_ARGUMENTS")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2939,6 +2939,12 @@ struct nfsd4_fattr_args {
 typedef __be32(*nfsd4_enc_attr)(struct xdr_stream *xdr,
 				const struct nfsd4_fattr_args *args);
 
+static __be32 nfsd4_encode_fattr4__inval(struct xdr_stream *xdr,
+					 const struct nfsd4_fattr_args *args)
+{
+	return nfserr_inval;
+}
+
 static __be32 nfsd4_encode_fattr4__noop(struct xdr_stream *xdr,
 					const struct nfsd4_fattr_args *args)
 {
@@ -3560,6 +3566,8 @@ static const nfsd4_enc_attr nfsd4_enc_fa
 
 	[FATTR4_MODE_UMASK]		= nfsd4_encode_fattr4__noop,
 	[FATTR4_XATTR_SUPPORT]		= nfsd4_encode_fattr4_xattr_support,
+	[FATTR4_TIME_DELEG_ACCESS]	= nfsd4_encode_fattr4__inval,
+	[FATTR4_TIME_DELEG_MODIFY]	= nfsd4_encode_fattr4__inval,
 	[FATTR4_OPEN_ARGUMENTS]		= nfsd4_encode_fattr4_open_arguments,
 };
 


