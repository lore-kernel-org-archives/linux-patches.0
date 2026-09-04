Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB4F415B85;
	Fri,  4 Sep 2026 05:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498704; cv=none; b=PaezpkIKBYgyTM/8+a6QYrRUp8s8ugBuYIENBYI8CgcfIapqgyQkAuu9pUksCO3sHu7jU+Qphi82+USlqrfSYGweLhRWKaSNy4iWEm8gunGgEen9L+Rp/gtxhD4cG+lyO2FNaAPaOlzfxl8WkF3h6DGFnrHKuakkT2XJ+5rbnBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498704; c=relaxed/simple;
	bh=qw2JCs2uUHQJ2nkVqrwyDZLQt730CTcqcZk/uEERyWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8Rz/CgXqC31z8jm2e9UDylwQE1Rxc94aNgVTNue3uP2OZk6K7My0+fNZsIe9KRQ+3HIHCwcGoFbIYq8ohs0qOa4FUCNM3CpRPXdr9aNPyjdgXZOhn7MDWWdZw5Re7waSX52IVFeHUa5Hc0lpnJFaEkLFOwzpLCPk3yH1FK/HfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dm4tc2wk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dm4tc2wk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665791F00A3D;
	Fri,  4 Sep 2026 05:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498702;
	bh=KajovhE6EI9Uf2C3MvqXbmqbSBlPS3rmPT3oLCIrR34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dm4tc2wk7kyFqmz3UDoKo7JWG8AuoVtmy88+h26I6Ls2zSEnz4nIKOSUx2oOQlFbH
	 h91mh1x1cs38jSTOAyws+eTDK1e6V5ZvfWTKUi1UEgU77LxDYu7scyEajHaIRFKTPK
	 BewOZbUuhs8FSWT9/HRwYIIF8lH7b7+6uA+nnrVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 156/713] nfsd: validate nseconds in TIME_DELEG decode paths
Date: Fri,  4 Sep 2026 06:52:04 +0200
Message-ID: <20260904045807.323666903@linuxfoundation.org>
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

commit 0f4a767340fad392bd656115b8752005518c9065 upstream.

The xdrgen-based TIME_DELEG_ACCESS and TIME_DELEG_MODIFY decode arms
store a raw uint32_t nseconds directly into tv_nsec without enforcing
nseconds < NSEC_PER_SEC. The legacy nfsd4_decode_nfstime4 has this
check but the TIME_DELEG paths do not. A malformed timespec can
propagate through notify_change() to disk.

Add range checks in both nfs4xdr.c (SETATTR path) and
nfs4callback.c (CB_GETATTR path).

Fixes: 6ae30d6eb26b ("nfsd: add support for delegated timestamps")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-7-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4callback.c |    4 ++++
 fs/nfsd/nfs4xdr.c      |    4 ++++
 2 files changed, 8 insertions(+)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -108,6 +108,8 @@ static int decode_cb_fattr4(struct xdr_s
 
 		if (!xdrgen_decode_fattr4_time_deleg_access(xdr, &access))
 			return -EIO;
+		if (access.nseconds >= NSEC_PER_SEC)
+			return -EIO;
 		fattr->ncf_cb_atime.tv_sec = access.seconds;
 		fattr->ncf_cb_atime.tv_nsec = access.nseconds;
 
@@ -117,6 +119,8 @@ static int decode_cb_fattr4(struct xdr_s
 
 		if (!xdrgen_decode_fattr4_time_deleg_modify(xdr, &modify))
 			return -EIO;
+		if (modify.nseconds >= NSEC_PER_SEC)
+			return -EIO;
 		fattr->ncf_cb_mtime.tv_sec = modify.seconds;
 		fattr->ncf_cb_mtime.tv_nsec = modify.nseconds;
 
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -628,6 +628,8 @@ nfsd4_decode_fattr4(struct nfsd4_compoun
 
 		if (!xdrgen_decode_fattr4_time_deleg_access(argp->xdr, &access))
 			return nfserr_bad_xdr;
+		if (access.nseconds >= NSEC_PER_SEC)
+			return nfserr_inval;
 		iattr->ia_atime.tv_sec = access.seconds;
 		iattr->ia_atime.tv_nsec = access.nseconds;
 		iattr->ia_valid |= ATTR_ATIME | ATTR_ATIME_SET | ATTR_DELEG;
@@ -637,6 +639,8 @@ nfsd4_decode_fattr4(struct nfsd4_compoun
 
 		if (!xdrgen_decode_fattr4_time_deleg_modify(argp->xdr, &modify))
 			return nfserr_bad_xdr;
+		if (modify.nseconds >= NSEC_PER_SEC)
+			return nfserr_inval;
 		iattr->ia_mtime.tv_sec = modify.seconds;
 		iattr->ia_mtime.tv_nsec = modify.nseconds;
 		iattr->ia_ctime.tv_sec = modify.seconds;


