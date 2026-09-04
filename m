Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0292441C2FB;
	Fri,  4 Sep 2026 05:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498763; cv=none; b=Oy0kWnOYnnmTBfZlkh8pQjPPLmDe8Yrczxd0CWX/JlL/DxabI8zomGVFN3ALJCXOFZPSrGF6fVeLblYiwpvkefF/peS6i5OkqvMiPen3NXN1NbB2ssxdip0stf8ioPNJpRbHLoRQKAlf+O/VLKQQ0nnQSx9jw/B4ARrL1/u1HXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498763; c=relaxed/simple;
	bh=Gck2I6H87gupGet+6B3qB6FBri5MOfzARAz75euUSvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDGFx3Q2bwpZd3JwF9ml0b5078Xfnwv/a4M4lncG/Fsq9Cxq6S1Huo/grHO29IAiOAWbN88mpnJ0AagzHp7Sh51IdWLkLR9QDdrxKhk32umbW3E6AKnoAG5CxeHs5i9XXUhHT4+71fSCi7D4JEljP177SROmshm0iRyy0e3pwO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTLaZnhd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTLaZnhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3461F00A3E;
	Fri,  4 Sep 2026 05:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498761;
	bh=me4e6m4DeznJqz0QWKIa9PoDWdjhqySrirHWLd3ItUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTLaZnhdAxBhmyElrzKYSBjZLVhP6qJYIUZ3C+AV+suPsgvpObWSY1s3g3JqLPKuF
	 Lv0qgHQupMQbpGukoBafwcmkCl9oXRSPhMw6Px7ha83b8TPmohDyKGvafzZUZQ9OSY
	 STC+nenrjxUlthDuEnq9/gW8MBGZ3Vsp1L0EMdjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 179/713] nfsd: fix dentry ref leak on V4ROOT export filehandle lookup
Date: Fri,  4 Sep 2026 06:52:27 +0200
Message-ID: <20260904045807.831691337@linuxfoundation.org>
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

commit 6247023fbbec1325029f2d5f2a7cdc0f9f9ea15a upstream.

nfsd_set_fh_dentry() leaks the dentry reference from
exportfs_decode_fh_raw() when the NFS3_FHSIZE or NFS_FHSIZE
switch cases detect NFSEXP_V4ROOT and goto out. The out: label
calls exp_put() but never dput(dentry), and fhp->fh_dentry was
never assigned so fh_put() cannot compensate.

A crafted NFSv3 filehandle targeting a V4ROOT export's fsid
triggers the leak on every request.

Fixes: ef7f6c4904d0 ("nfsd: move V4ROOT version check to nfsd_set_fh_dentry()")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260531-nfsd-testing-v1-4-7bfa481b0540@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsfh.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -342,15 +342,19 @@ static __be32 nfsd_set_fh_dentry(struct
 		if (dentry->d_sb->s_export_op->flags & EXPORT_OP_NOWCC)
 			fhp->fh_no_wcc = true;
 		fhp->fh_64bit_cookies = true;
-		if (exp->ex_flags & NFSEXP_V4ROOT)
+		if (exp->ex_flags & NFSEXP_V4ROOT) {
+			dput(dentry);
 			goto out;
+		}
 		break;
 	case NFS_FHSIZE:
 		fhp->fh_no_wcc = true;
 		if (EX_WGATHER(exp))
 			fhp->fh_use_wgather = true;
-		if (exp->ex_flags & NFSEXP_V4ROOT)
+		if (exp->ex_flags & NFSEXP_V4ROOT) {
+			dput(dentry);
 			goto out;
+		}
 	}
 
 	fhp->fh_dentry = dentry;


