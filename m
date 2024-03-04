Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E2C1EB5A;
	Mon,  4 Mar 2024 21:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589098; cv=none; b=F8WbHAAzwJafY81dt2ST/Xc6mnvmKkkjPGBy3ArAv6eohntHVB/2GTQGbKMeINIL/AJXBH1xfypvwP7gKYjWz1fsR+arxm2I07QKA6h3ciMtDHilEdOvo8bFw43Nax1mVOFDwBM1BlA6L8bLXhTiBL00Rutu1g683mKs87szefU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589098; c=relaxed/simple;
	bh=vSQQKgBM812u/tWTP6FUXHtFBrb6CBIWD2gHr7vlf8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lg2hXcxs9fq8/xi52AN2hEjpIQYGNAwvqAemW9w7r7D+hUIC7s/gRu9qyoN6mfnVDUhr7eohvuY5JX/+n4vRgGm399rDEzqQP8hERyrB30rBv7QaI2BpxfCM3ldzKLRzXO4B468BdZjTzxJAMjTaEykpRX/ZOnR8x7QUJQr9zWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWyxRuOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWyxRuOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB7FC433F1;
	Mon,  4 Mar 2024 21:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589098;
	bh=vSQQKgBM812u/tWTP6FUXHtFBrb6CBIWD2gHr7vlf8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWyxRuOYU+IsFSLzOnWaNH++UUklsO3+7PToi3zID2vbYXAWeWyScW63cx9+BWAgM
	 HXyfP/LmBbtUnN1kaYaiftvLKbnb/c8P1pcxy9KCS8B7wjF7NJauvDCpD+Att5J4b6
	 qtrNMArc2FIrmywi/Ht7vYzlBUZk3LATfcJM6k08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 176/215] NFSD: Use set_bit(RQ_DROPME)
Date: Mon,  4 Mar 2024 21:23:59 +0000
Message-ID: <20240304211602.524335165@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5304930dbae82d259bcf7e5611db7c81e7a42eff ]

The premise that "Once an svc thread is scheduled and executing an
RPC, no other processes will touch svc_rqst::rq_flags" is false.
svc_xprt_enqueue() examines the RQ_BUSY flag in scheduled nfsd
threads when determining which thread to wake up next.

Fixes: 9315564747cb ("NFSD: Use only RQ_DROPME to signal the need to drop a reply")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsproc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -211,7 +211,7 @@ nfsd_proc_read(struct svc_rqst *rqstp)
 	if (resp->status == nfs_ok)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
-		__set_bit(RQ_DROPME, &rqstp->rq_flags);
+		set_bit(RQ_DROPME, &rqstp->rq_flags);
 	return rpc_success;
 }
 
@@ -246,7 +246,7 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 	if (resp->status == nfs_ok)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
-		__set_bit(RQ_DROPME, &rqstp->rq_flags);
+		set_bit(RQ_DROPME, &rqstp->rq_flags);
 	return rpc_success;
 }
 


