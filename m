Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1206223C6F;
	Thu, 12 Dec 2024 17:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023710; cv=none; b=FjFlssR3IpCVGOqNtQPqvXEubx4Lzv6gz7jJzOXMopcQFbf+iDNvGhtrZ2oSVVpYFy4XQPQCqdqVPeG2Vmjnf9Odvsqh7NHRTuVkfaX5kkwG2LoEE/O4uCrQvbNJh+AqLsfma1Zp+JewFRu+LmU39M23mET7BZo88k9udkYy8bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023710; c=relaxed/simple;
	bh=Me74DVWjEYSVQkOwhkHUiP522ISzPKscviNcg22QZhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoxXs8j3Es14ytbZm6LQUAbqDmgCODte414wBRObZ5MztZX7mE0TboMmsW0EHlI9IqxyvVkWAhJsaDjJUB6JPl5vE7eJz0kfn62x4HnUAe2QnAv+z3V8TiT/97DihMms+tVLWPebQoNCn+EGn04IwqQ17FK/PtVP/1IqWODtmFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwmTm9Hx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwmTm9Hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EE1C4CECE;
	Thu, 12 Dec 2024 17:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023710;
	bh=Me74DVWjEYSVQkOwhkHUiP522ISzPKscviNcg22QZhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwmTm9HxrY31YN29eFfQslW6ygVboGgl+iTqGKfzUYR7HIBALkcqreJy+CgaX0k51
	 E1n7xMvdPSx0ea/Eh7Y3zJJOVbjFMKa6OTeYl0xctYNWP5RaChPqfGb9nAMil2uV0Q
	 jC+EFaYPFmbX7jq1E95RTLm4qHTPbUpM8mq1QcaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chen Hanxiao <chenhx.fnst@fujitsu.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 026/459] NFSD: initialize copy->cp_clp early in nfsd4_copy for use by trace point
Date: Thu, 12 Dec 2024 15:56:04 +0100
Message-ID: <20241212144254.555900030@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1769,6 +1769,7 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 	__be32 status;
 	struct nfsd4_copy *async_copy = NULL;
 
+	copy->cp_clp = cstate->clp;
 	if (nfsd4_ssc_is_inter(copy)) {
 		if (!inter_copy_offload_enable || nfsd4_copy_is_sync(copy)) {
 			status = nfserr_notsupp;
@@ -1783,7 +1784,6 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 			return status;
 	}
 
-	copy->cp_clp = cstate->clp;
 	memcpy(&copy->fh, &cstate->current_fh.fh_handle,
 		sizeof(struct knfsd_fh));
 	if (nfsd4_copy_is_async(copy)) {


