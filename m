Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58556FE35;
	Mon,  8 Apr 2024 13:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584513; cv=none; b=pnxvgQ5cwwXSkYLXyI9VmbJSijND0CS3bzzMNuXSmyVlaK3SyI0VD9lKPiiIaAfo9LFKT216SVNYTiWfanvtqqErPr6G3SnoVYt+Vp/JoZ53qkgdc6/Je7D8PUTGnYvOHoJ1tl/a3h4PWnFFJwFmuocr/UkJK2hDxqvJZpaPFzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584513; c=relaxed/simple;
	bh=HmVPZfkY/3kM4R2RT+Y3rdrVCSfEprf25gymq/eYvts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQY+QIuiUHn8I0MoDkmjBYQMpuKuvut+e67sby8R9ZaoGt8j1TjAEyJb/HhYMW62j/hMxKguebYfBdBFc/scEO6N7mpKGGBltvgTRJwKludK06EhdAFXDjQhph5FHBGvps3CUmo40b6XigpOpVqEE8ROO1S/hArRsFsbBTutmEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxk0Yfj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxk0Yfj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFDAC433C7;
	Mon,  8 Apr 2024 13:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584512;
	bh=HmVPZfkY/3kM4R2RT+Y3rdrVCSfEprf25gymq/eYvts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxk0Yfj8Cxu2g+HyvUPDNWFleXEYzQ0odDKMZs5RF/XPqN5O1Dd1uDC0vO68VUKVj
	 lDLr5D09TgMGq0caFx/t5gJggmG5uOULH6a0OxLt2DGhiwNlb3nxj9dM/8juR8YY2W
	 YqlxsxP6VxvnKI0GgWYg6LB7eOMwZhsBomsZuWpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 464/690] nfsd: fix use-after-free in nfsd_file_do_acquire tracepoint
Date: Mon,  8 Apr 2024 14:55:30 +0200
Message-ID: <20240408125416.435778525@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit bdd6b5624c62d0acd350d07564f1c82fe649235f ]

When we fail to insert into the hashtable with a non-retryable error,
we'll free the object and then goto out_status. If the tracepoint is
enabled, it'll end up accessing the freed object when it tries to
grab the fields out of it.

Set nf to NULL after freeing it to avoid the issue.

Fixes: 243a5263014a ("nfsd: rework hashtable handling in nfsd_do_file_acquire")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 024adcbe67e95..dceb522f5cee9 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1075,6 +1075,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		goto open_file;
 
 	nfsd_file_slab_free(&nf->nf_rcu);
+	nf = NULL;
 	if (ret == -EEXIST)
 		goto retry;
 	trace_nfsd_file_insert_err(rqstp, key.inode, may_flags, ret);
-- 
2.43.0



