Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B981F2264A3;
	Fri,  4 Sep 2026 05:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500607; cv=none; b=Iil0Em9UwwIBahOO8ab1yctoNmNecZC4togwzRvI9/AkXK5S4n0QjCD7h36CZMYZtr1yeZEwlnv1OvF/iiv3ZbNpnNc+DEvGBcpTfRFB4J19UAY/0FLduoQt4tltvup7r+qemf4+NNcXwCJmwsCRyyf+68agRgiyNnHDcvGUcAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500607; c=relaxed/simple;
	bh=pafMPib9VZwfuWLGNsZVYzkJNaO7LcjVbppkmYsDdMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJOAoE2T/nj/duRy6q+pqkgLHH4C56pqlV/MfXmpcJIbxUoMH8/5lAegJ9wdbH76RPMCUgg4jeMl4E19MyVwADEW9csWejq6N2CLl9eSA+wEPKtzpZ99KmcK153292r3N9WjI5r2LWtmBYfGR2U4Uyp0lli5ZRZjSzfKsXxVEoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mC90jqPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mC90jqPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BCD1F00A3D;
	Fri,  4 Sep 2026 05:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500606;
	bh=PEqSFhK1nHgfMBa4rgvNAVRPbjhDF22SwAmqgE0NYpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mC90jqPsgSu+LWLaMXTnlZ2kSKusGUqhmB4tB+YxJgrKgD24iXIoWE/gZPYgmlwuq
	 a4h0oM5hKhmAPbgjmA43BOez4Hf/dbRujGZsLLcCrFpCtfHYkWH10gpol9jLiNI89f
	 xselxuCdv2h/LNovd6cT3r9WiRtkNZCPo3Nu4ZTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 114/552] nfsd: validate nseconds in TIME_DELEG decode paths
Date: Fri,  4 Sep 2026 06:54:31 +0200
Message-ID: <20260904045750.501771893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -526,6 +526,8 @@ nfsd4_decode_fattr4(struct nfsd4_compoun
 
 		if (!xdrgen_decode_fattr4_time_deleg_access(argp->xdr, &access))
 			return nfserr_bad_xdr;
+		if (access.nseconds >= NSEC_PER_SEC)
+			return nfserr_inval;
 		iattr->ia_atime.tv_sec = access.seconds;
 		iattr->ia_atime.tv_nsec = access.nseconds;
 		iattr->ia_valid |= ATTR_ATIME | ATTR_ATIME_SET | ATTR_DELEG;
@@ -535,6 +537,8 @@ nfsd4_decode_fattr4(struct nfsd4_compoun
 
 		if (!xdrgen_decode_fattr4_time_deleg_modify(argp->xdr, &modify))
 			return nfserr_bad_xdr;
+		if (modify.nseconds >= NSEC_PER_SEC)
+			return nfserr_inval;
 		iattr->ia_mtime.tv_sec = modify.seconds;
 		iattr->ia_mtime.tv_nsec = modify.nseconds;
 		iattr->ia_ctime.tv_sec = modify.seconds;


