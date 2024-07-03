Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F12316F8FA;
	Wed,  3 Jul 2024 11:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005562; cv=none; b=dUBabLAcxNSfXWLfu25A++GNxWljqsa06BAjM0hPM4FBauLq6lqcwABezHhAbem4akV/u/YV4slgkAKvRtoFarHX01DP7jZPdcFOUJILuUtLWTeucM8c1GCkg7axQMLKSctNTVViAhBxQs7os0fxkLW2D6qGmRnq0qj2e7dCWWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005562; c=relaxed/simple;
	bh=2qDYh6dzES3ChLNX7PY9eZgZ9vtHSNQcK8Wq6WXla0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sa5e5xeO4u6XySVog38Q3yyFO7/Icfg72A9gBOBmJy2k8gZQjy7Dx/cE+2pwoq2LVnZSEYQEioLbyjhuEtlodZovVkLDETRE2pgVqbVXpLNtm1yKrA4Jq2aeb9aSvvrhAiazV+MtKiYgczeLnGDCdIhDalpYNfNMPVL+cgukVPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhpTjjX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhpTjjX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92D1C2BD10;
	Wed,  3 Jul 2024 11:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005562;
	bh=2qDYh6dzES3ChLNX7PY9eZgZ9vtHSNQcK8Wq6WXla0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhpTjjX+L5DPT4Gd+Z3AA/yxVnNNnjj14k8j3Kp0CsLZ1CMeubqyszeFacqU3gewt
	 HrlqMYuFcrt24kvFMEPLLOQtNQQ4klBnpuLp0wp4EK/4XK0brk2X9zvc6fMslfgKBU
	 0Azp3adYS1OVuZflKC2sI7LTkaNgoijRvzgG9XUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 123/356] knfsd: LOOKUP can return an illegal error value
Date: Wed,  3 Jul 2024 12:37:39 +0200
Message-ID: <20240703102917.748432735@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit e221c45da3770962418fb30c27d941bbc70d595a upstream.

The 'NFS error' NFSERR_OPNOTSUPP is not described by any of the official
NFS related RFCs, but appears to have snuck into some older .x files for
NFSv2.
Either way, it is not in RFC1094, RFC1813 or any of the NFSv4 RFCs, so
should not be returned by the knfsd server, and particularly not by the
"LOOKUP" operation.

Instead, let's return NFSERR_STALE, which is more appropriate if the
filesystem encodes the filehandle as FILEID_INVALID.

Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsfh.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -569,7 +569,7 @@ fh_compose(struct svc_fh *fhp, struct sv
 		_fh_update(fhp, exp, dentry);
 	if (fhp->fh_handle.fh_fileid_type == FILEID_INVALID) {
 		fh_put(fhp);
-		return nfserr_opnotsupp;
+		return nfserr_stale;
 	}
 
 	return 0;
@@ -595,7 +595,7 @@ fh_update(struct svc_fh *fhp)
 
 	_fh_update(fhp, fhp->fh_export, dentry);
 	if (fhp->fh_handle.fh_fileid_type == FILEID_INVALID)
-		return nfserr_opnotsupp;
+		return nfserr_stale;
 	return 0;
 out_bad:
 	printk(KERN_ERR "fh_update: fh not verified!\n");


