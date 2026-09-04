Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCBB30C366;
	Fri,  4 Sep 2026 06:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502066; cv=none; b=fYQDUlfUjc+wrHtdI69V2j3GE2CTem1KD/yVlDYJ+VES0RSIn7nXN3XU6qBFHhRK+8nfiMYr1yip9RPyTCaEf7lMytdUtu9sg0DolQhsdRAkihPDlPiwE5mr1pTsIEU1xU7FYdwuxxv/no1F3IC2OgUhYov8kuF0EJ9fSOK8A+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502066; c=relaxed/simple;
	bh=MhMrSW7f1Mnu+ZpVXK5lqIDG697VzPnuqJQvrFPcg9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nr+BGImeclnP8V7vET1vMgiRIWrdOkPqAivorHeZtAqkkFUobdDzoD1bIJC+n2xVdXT1NVJoAfVuZCCp2MmIPNZqeh72E+0/u2qoDRy9/UIZeLFXjJHGe2z/p9NSnIMxku/nmBmrR/O/FSLx4mEFV0y/JPOhCeR1+hESBDiZ+Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqnD/lll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqnD/lll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF28D1F00A3D;
	Fri,  4 Sep 2026 06:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502065;
	bh=VxI5LgZZv3MPSEAcDWFAIcdIiz5Gqnu4xFNkHN5NxCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqnD/lll1fKHqVYvpo70tCd3+fCjrXAzY4OpX/jhzk2DxUNvt4p+TBSkR8pGhF+Sj
	 Z4jZE3t25Snma6hSdGWTPrDyjqud/PM8yrLM8FUkveC5lbJG0X8N85EJYR0BqcPIPz
	 1vIyGQTOA4F3z857NyukS+LWgE8vTnflKsZa16Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 076/403] nfsd: release path refs on follow_down() error
Date: Fri,  4 Sep 2026 06:57:59 +0200
Message-ID: <20260904045736.562406809@linuxfoundation.org>
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
@@ -133,8 +133,10 @@ nfsd_cross_mnt(struct svc_rqst *rqstp, s
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


