Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E5D1B3B2E;
	Wed, 20 Nov 2024 13:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107610; cv=none; b=cKbguQ8rprOTnZIeD0ZlBzPi/Q6lvZrgM8kAJWRQbqti2jwsdOYvZUJJR9nsou1PR6BhZgkpDiTiss6zlX7BZXBVbpzs0MRKg88KtYu+Cn346ruWSt3LqbpjLSBQpdBSDQVvmVuATGRwCXwDaQ/5D5jLDbS8Zyy2O5L3rW4iRc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107610; c=relaxed/simple;
	bh=J5MxQuhjcZh6MzZ6KpQgq9TkWiRZg184dNRt1AChD98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ttt0+gEE+bOYCGgS4Mt5WqzfD8NDKlZSqVsUxvH4//1AokyIYtNol726JW8vsynbimQYDlEKFa4nsni/6qKp/WT+hFPgRDwt8KqxOcjtjHyba5PFWhN/jSmq7kDx05LTwObYwenFlMFe0yM1ArrKJbyb2j1XUJSjsIMO41qBXJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAm05oxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAm05oxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D00C4CECD;
	Wed, 20 Nov 2024 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107610;
	bh=J5MxQuhjcZh6MzZ6KpQgq9TkWiRZg184dNRt1AChD98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAm05oxY5W2qiRBFb6r91lqA8DSbO2rcJVRZ4DYv+YpnN3BeBwCzO9OMoP+XO+Dl0
	 ltATNNZo1AoumK60gyx28Vg94oQHKrIsgh50nYNKWUnPHHlRNY1e7a1QaikAdBsn2O
	 X6yM0SMhEktFTZXFA026FZiy3n9+9MmAe9LQMmwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chen Hanxiao <chenhx.fnst@fujitsu.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 61/82] NFSD: initialize copy->cp_clp early in nfsd4_copy for use by trace point
Date: Wed, 20 Nov 2024 13:57:11 +0100
Message-ID: <20241120125630.986427442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 15d1975b7279693d6f09398e0e2e31aca2310275 ]

Prepare for adding server copy trace points.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Tested-by: Chen Hanxiao <chenhx.fnst@fujitsu.com>
Stable-dep-of: 9ed666eba4e0 ("NFSD: Async COPY result needs to return a write verifier")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1798,6 +1798,7 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 	__be32 status;
 	struct nfsd4_copy *async_copy = NULL;
 
+	copy->cp_clp = cstate->clp;
 	if (nfsd4_ssc_is_inter(copy)) {
 		if (!inter_copy_offload_enable || nfsd4_copy_is_sync(copy)) {
 			status = nfserr_notsupp;
@@ -1812,7 +1813,6 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 			return status;
 	}
 
-	copy->cp_clp = cstate->clp;
 	memcpy(&copy->fh, &cstate->current_fh.fh_handle,
 		sizeof(struct knfsd_fh));
 	if (nfsd4_copy_is_async(copy)) {


