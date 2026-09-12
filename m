Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5364E3382CB;
	Sat, 12 Sep 2026 13:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219819; cv=none; b=rA/FU+d6Gv+sm5CBKmlBJL+A7iddNSNrTQvHfpowTBLJOggy8QnHpvsnzM5XjGcouzweB13g2ZE7JKL8ki6l6UV/ITDdmGMt9Gx3TCnEM7/DY4ffNQQvjfjDCdKyWxPEZhEKwpa0g6nK7D3voQ/QkQBiCL6dbZTsrqzszTJizWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219819; c=relaxed/simple;
	bh=A40qLgCzV0vOTaFih1nJMcVV+kVPQYmFoNsZ0yEaInE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wo94oDt/uv+KAF6k9VvSkhmdKIbyg/G72ynVyhPWr+iWqLWyXr+ScwlTJQ3A32NzcuDv3UERvRmTWlRKUvpWf6W6iMF40QWWfd+/j16I8BNr5Bwh+8W4zxYFa/JcPvgsojV68ROyHm7r1JzCxAj4BF/d+CU7Yu6rKL0GnC5CIyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhjA2Ds6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhjA2Ds6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF13C1F000FF;
	Sat, 12 Sep 2026 13:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219817;
	bh=GWtyMg4Ioy0JPH+USx+1GPm0j/A7rtf4ZnZcai7kAJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xhjA2Ds6fyZ9IgZRKtHR1VkQXcgmQ/dvjSBGD8bKZ8MTQQ/uogqT7igtY+jJxV9Hj
	 Vxxd9Lzdgk7n262phTOs9VrcOQJC0NmWsS8N3rrT1hKjTYFe8CGhJ/CJEe3ekeUItU
	 CFXQhriMcgpGJAg+LxoTqQmtoRs3hNQe9bBuEoHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0051/1424] nfsd: release path refs on follow_down() error
Date: Sat, 12 Sep 2026 08:41:23 +0200
Message-ID: <20260912065608.445768683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -134,8 +134,10 @@ nfsd_cross_mnt(struct svc_rqst *rqstp, s
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


