Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80821422D9;
	Wed, 19 Jun 2024 13:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804006; cv=none; b=tTwzauoGlN/ve4YdYUwUsMsK+Z0iRoYiJKZBpT8UcYDdCe2VN+Fn3Vu2lC5PCGQ2/yvoj9M/ovzMbgnZBGTQmr5Cly6SiuP+Luul5oBzcuzXFYN0kv3RqNi6nH2Sz5v8jTpK8BAjSTPIVscHBw5K++sgbWgA5y0wiZS9l/9rtTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804006; c=relaxed/simple;
	bh=fiNppnqoqZcIHfs4bMCzXz4N5z+jANb1P7Aq3zZGGbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2cq731BMjMRy8C67VCw3e6WGONKqUtOzuG+IsIEY06+xSjQ4fEnnA196Un5RDTSjFuWAqohmOKrSWavkksROv7hSdZGPznr7RvPqv/r5Mbx2nAn+8dp1c+vq1cAwoe1uFwu0rr1pGb4EmHTgU4gatv6ZIxjNmWiVApBKTWt7GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=no/h7V2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="no/h7V2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8CFC2BBFC;
	Wed, 19 Jun 2024 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804006;
	bh=fiNppnqoqZcIHfs4bMCzXz4N5z+jANb1P7Aq3zZGGbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=no/h7V2GTpkhg/wBzUIDM98sR4ox+P/oqNfQWL9+TDNH9n2IEmQO0lsgVU7Y1/7Eq
	 vp8a8F+n76UyML4BswZCeQcFmzhihT2IVIJo4aibw9SY+vGuNZURVm5LgVHytjQ2iv
	 bpMCCUTNxWqPRM8QLHcg9qTvIvLNC5xwgQ2+CGks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 178/217] knfsd: LOOKUP can return an illegal error value
Date: Wed, 19 Jun 2024 14:57:01 +0200
Message-ID: <20240619125603.555130713@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


