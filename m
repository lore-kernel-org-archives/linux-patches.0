Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838E72264A3;
	Fri,  4 Sep 2026 05:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500647; cv=none; b=et4RgCnSU8OffJ2HxfdtKS77FI7Ip+TE95DsHMfurpmDkmRc3BgQPIWpuD+Q+6D5htjqNgpcrmHXhl7ZtS5GyU2mvB1wv8TXcHOAWLJIFpDDP+a9gdzh4BKSv+X8wVZKsuFCpQ8xV/yNHAphoSuzAcqhCbrD1RtU4xbs86gi/Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500647; c=relaxed/simple;
	bh=LhLEW3Q4nn5YEbIOuR/B7y8CoQ/6ByvpNXRitQ9muho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WchsC5Ol7qpeqeh1KcTjPrm3eG2Vq7/5izWaDk1coyovBSD8hP8q8BJi57hEYaNQpBkgXx01hNFKtPugC0l6p8rg3aA6hoFSd1fMIs2T5lzCSCWL77KO7Jge1uks9zV1cgn+6Ze7H+MJV4gxWWE9AFLmDqJNHdqj/BvA0jZ0Ny8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fC1CQOnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fC1CQOnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6159E1F00A3D;
	Fri,  4 Sep 2026 05:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500645;
	bh=PpvFRo7mG94vyWz7pDXdCsPEQq59j/lWU9FYR7rjbqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fC1CQOnPjHKq+tSAXgkdJyjXjXAdQ6o251SyGlu1R5r6k04kshZwUtC2vPoshmFcn
	 cehafZkU0GuTRA5pj3p8oSr4FxjJ0zFHcJ+LyQTdfBMOyzzHpoDJDRxnS0/qqlOQ4+
	 fh2rj+5G4tbJXskdZRmVy3gnZNpIhpKOEZiuxrmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 131/552] nfsd: fix FL_SLEEP being set unconditionally for all LOCK types
Date: Fri,  4 Sep 2026 06:54:48 +0200
Message-ID: <20260904045751.299153961@linuxfoundation.org>
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

commit 246a90a5109bb2857db41f491277882ee2743b26 upstream.

The FL_SLEEP guard uses lk_type & (NFS4_READW_LT | NFS4_WRITEW_LT) which
computes lk_type & 7, non-zero for all valid lock types including
non-blocking ones. This was introduced by commit 7e64c5bc497c
("NLM/NFSD: Fix lock notifications for async-capable filesystems") when
refactoring from per-case switch arms.

Replace the bitmask test with explicit equality checks.

Fixes: 7e64c5bc497c ("NLM/NFSD: Fix lock notifications for async-capable filesystems")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-10-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8470,10 +8470,11 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 		goto out;
 	}
 
-	if (lock->lk_type & (NFS4_READW_LT | NFS4_WRITEW_LT) &&
-		nfsd4_has_session(cstate) &&
-		locks_can_async_lock(nf->nf_file->f_op))
-			flags |= FL_SLEEP;
+	if ((lock->lk_type == NFS4_READW_LT ||
+	     lock->lk_type == NFS4_WRITEW_LT) &&
+	    nfsd4_has_session(cstate) &&
+	    locks_can_async_lock(nf->nf_file->f_op))
+		flags |= FL_SLEEP;
 
 	nbl = find_or_allocate_block(lock_sop, &fp->fi_fhandle, nn);
 	if (!nbl) {


