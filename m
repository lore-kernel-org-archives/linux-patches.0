Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEC12AD37;
	Fri,  4 Sep 2026 05:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500587; cv=none; b=OFCZvc05rGLrvZEPin+pK5pe1a9P7IEHfnL4W3aBnNL+4w67oWA57O4YiUpSuB71F8g4DvzSDnlDKC61Qmh6RBfMYWFdEC35p7if/iO1H522ileQy/YWeO+HGQeLKgfYn7+KQrphygOdvoMVs0k9uLSVqYXXZ3juUpKgSekUrqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500587; c=relaxed/simple;
	bh=LTUO48e0jiOlr2xJOqv4Ald838SMaXhX3wy9wuvKwrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMSizfgAPaOK/QILc5H4yh7I9hosUe319kDElYx+zeN9PVXTX8D5Ue5rlZcVICqnAMF3m0tH5mtYsKhJV+o4O7NaaXReda1ccaM7/cW2TjEONRL/+mmOK3Eh0s1RfjGIuhhk5qLjR4qdnP4ZXdoeRMKDBlA5U1CMouDX4k3UVzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NunXM8YY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NunXM8YY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F4B1F00A3D;
	Fri,  4 Sep 2026 05:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500586;
	bh=wf+wyEt7tEC30KGSlOBZo0wcsohm/C74ZltSooHQ1Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NunXM8YYbGuS6oEsPEJCjXNf+1nvZPaOC+1NqATlLaQYw8e1vSbJrrgjoBkeBpQk9
	 G5UwWyx7zKXsG9B9PzdHtjHMFFJ1IqOEM6zbeX8cUjtA5T3WBo9njbGy/Yso7iNFvY
	 5Mwymt3bs/bjhJlsGHjo1ewOMxtiaRu1g6TZIoQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 108/552] nfsd: release path refs on follow_down() error
Date: Fri,  4 Sep 2026 06:54:25 +0200
Message-ID: <20260904045750.356082760@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit 6cba08dc1922140d260cfeb30bbda4ee1bf869d8 upstream.

nfsd_cross_mnt() initializes a local struct path with mntget() and
dget() before calling follow_down(). On a negative return the error
arm jumps to out without releasing those references:

    err = follow_down(&path, follow_flags);
    if (err < 0)
            goto out;

follow_down() never drops the caller's entry-time refs on any error
sub-case; for example a pre-cross d_manage() failure leaves path
untouched, so the mntget()/dget() taken on entry survive the call.

Every other early-exit arm in nfsd_cross_mnt() (other-namespace
return, IS_ERR(exp2), and the success tail after the swap) already
calls path_put(&path); the err < 0 arm is the lone omission. The
leak inflates mnt_count and d_count on each failed cross-mount,
blocking umount and pinning dentries against the shrinker, and is
reachable by any authenticated NFS client through nfsd_lookup_dentry
or the NFSv4 READDIR encode path.

Fix by calling path_put(&path) before the goto out in the err < 0
arm so the entry-time refs are released on all follow_down() error
returns.

Fixes: cc53ce53c869 ("Add a dentry op to allow processes to be held during pathwalk transit")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20260531-nfsd-testing-v1-2-7bfa481b0540@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -136,8 +136,10 @@ nfsd_cross_mnt(struct svc_rqst *rqstp, s
 		follow_flags = LOOKUP_AUTOMOUNT;
 
 	err = follow_down(&path, follow_flags);
-	if (err < 0)
+	if (err < 0) {
+		path_put(&path);
 		goto out;
+	}
 	if (path.mnt == exp->ex_path.mnt && path.dentry == dentry &&
 	    nfsd_mountpoint(dentry, exp) == 2) {
 		/* This is only a mountpoint in some other namespace */


