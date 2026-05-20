Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E44363C6F;
	Wed, 20 May 2026 17:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298773; cv=none; b=E7NZrA9lfUI+Mdhvb0rV/qch3SZwpOBkh7qJuXbE1TiCsWUXey/Wo1OixBlHRdMHeVkTc150t3yf5zcsWwspEWocilRDLEPrHiwpR9kxrP317QYJtCYBLKRwPQrntJTY7LmxiTBqFXDZY2y+hYmIO4mgzKJTmBlEekyyo//lDU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298773; c=relaxed/simple;
	bh=7/EU3byhlzldlWv/O5/XNIYKWYwkYDFk8YHPAAQ/PDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8qY0NOAQOqqV/XRT8RSbwUEmkV0A13HHKTr0v7aQxN/qwzkWDlr9zFx81fl5DH/PmVB4p1lJ9T2v7oAszas4vZlnCsnMoRvddRGIggeCnagSeljEBVyUShDk6sV5xERqFKSJjO1PJP0PvfHESr727w52T1RDf/iQM+aT4BSgvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqlPgA74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqlPgA74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AC41F000E9;
	Wed, 20 May 2026 17:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298772;
	bh=7nrsZrWkin5ZNt1mcExS5k9qS/9Dn4i8hOz/2XFvAkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zqlPgA74WvLat+t5QfiPnbCoO3hrbOc0kBrSGZMyTVBO94szsKZGN4HeI2C8pulzp
	 Q9lZAaw4rKGzQI9bvxmOu9Ze6Mx+27HYEa54awK/bG4DYMv3BfeJutBsWexQGYVJs+
	 8DhzPXbZQRsUbEKXx8i7L7Cy1PHMmcm5eSpct/bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 539/957] NFSD: fix nfs4_file access extra count in nfsd4_add_rdaccess_to_wrdeleg
Date: Wed, 20 May 2026 18:17:02 +0200
Message-ID: <20260520162146.223438999@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit b48f44f36e6607b2f818560f19deb86b4a9c717b ]

In nfsd4_add_rdaccess_to_wrdeleg, if fp->fi_fds[O_RDONLY] is already
set by another thread, __nfs4_file_get_access should not be called
to increment the nfs4_file access count since that was already done
by the thread that added READ access to the file. The extra fi_access
count in nfs4_file can prevent the corresponding nfsd_file from being
freed.

When stopping nfs-server service, these extra access counts trigger a
BUG in kmem_cache_destroy() that shows nfsd_file object remaining on
__kmem_cache_shutdown.

This problem can be reproduced by running the Git project's test
suite over NFS.

Fixes: 8072e34e1387 ("nfsd: fix nfsd_file reference leak in nfsd4_add_rdaccess_to_wrdeleg()")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index c5dba49c90356..adc33830438bb 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6255,12 +6255,12 @@ nfsd4_add_rdaccess_to_wrdeleg(struct svc_rqst *rqstp, struct nfsd4_open *open,
 			return (false);
 		fp = stp->st_stid.sc_file;
 		spin_lock(&fp->fi_lock);
-		__nfs4_file_get_access(fp, NFS4_SHARE_ACCESS_READ);
 		if (!fp->fi_fds[O_RDONLY]) {
+			__nfs4_file_get_access(fp, NFS4_SHARE_ACCESS_READ);
 			fp->fi_fds[O_RDONLY] = nf;
+			fp->fi_rdeleg_file = nfsd_file_get(fp->fi_fds[O_RDONLY]);
 			nf = NULL;
 		}
-		fp->fi_rdeleg_file = nfsd_file_get(fp->fi_fds[O_RDONLY]);
 		spin_unlock(&fp->fi_lock);
 		if (nf)
 			nfsd_file_put(nf);
-- 
2.53.0



