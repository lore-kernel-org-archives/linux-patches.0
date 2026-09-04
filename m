Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3746B3E49C0;
	Fri,  4 Sep 2026 06:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502235; cv=none; b=FHMvI20yqfUPT3Xd6T9niUfjGM4e+TxK1VDCKpS/qysmwWMzhgB9k80pYJsCh2zjIK2X43zGJF7VLDht56/1DGPYFsjqw7s4tFpdNfanOpPEBU1F707RA8NitqvBiulVeJCKeTtf5JltDxQryzY4J5WurYL60olA+GTkdQC/zak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502235; c=relaxed/simple;
	bh=eWGQkdONdbK6JihRo1aftuRjkrve+HubOQLqrK498DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kt1WhLpseEPVw0T+U8aRxegrfqjR/TUU9EnTLlqbrrbMGVArTmjUhNLkxOnaGZxR9UAA3qBMU3RwSvciOcyikzKvCb9OHxBPN+UhyV+FShqjYVtf9GSSKipZU15MPwP8AKCm7sfvRzli0+7HQGWxAt/bufE8ezZwMdt796KGcq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmdTfKF9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmdTfKF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2B21F00A3D;
	Fri,  4 Sep 2026 06:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502234;
	bh=XDcCwOYCUqt9ThxlwXkwwb5PERwqAYV+eT2cHI4WDNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qmdTfKF9Al3PjZaZ85vuozBd4nqTnxKAa076NknXY5rM2HkkQjZm23SNQuYtbPsiq
	 obh+41uWhHEQUUdir4Tj/rbz8VkV5VYCKzWkT+E7acs8q7OYaBcY5MRfvSU+iHwNJe
	 io8b+oZ173/I0BdEoSW9nQdcuEjyfXZfU4QJZIck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 093/403] nfsd: fix dentry ref leak on V4ROOT export filehandle lookup
Date: Fri,  4 Sep 2026 06:58:16 +0200
Message-ID: <20260904045736.948754661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -276,15 +276,19 @@ static __be32 nfsd_set_fh_dentry(struct
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


