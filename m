Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC557EEF0;
	Mon,  8 Apr 2024 13:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584659; cv=none; b=QlGkXmDSpdXMcv7dOZNUgEG5Hd1l6riH9HMFMbcnbu/+2yipFcdGuKLNt+B8NAaikAc1C89R28xknQGvXOnRpJGOJNWoqw8YuH1q4bNkm/zYSThxVlVVOA64Ev3ReVDy8g7QUz1QjDVO0aCDn2kf4ysNSWGj7MdRuABATeeTBBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584659; c=relaxed/simple;
	bh=3rnQ5ceuHJJ7+9m8G9wvXRPAXCTFDEXP5r4bSTGb1JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiMVJAHq9RDC68R2UzBbSDUpY4zI3yQU1rjLx+cUcBWoyg2+HPtIXMTB+PBeKuKyKFX6OTAa8Y78ZUApFWB1NDkigwskDVY2Q6U3ZtjdoqVF7qcK6kbhpI6zeG9PHtjkwaweASAfVoYmiBki1yNy09OENe+AQdLLUmQZV+dJ1ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2jywPQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2jywPQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6D8C433F1;
	Mon,  8 Apr 2024 13:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584659;
	bh=3rnQ5ceuHJJ7+9m8G9wvXRPAXCTFDEXP5r4bSTGb1JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2jywPQUgxozYutbfM5oyjmIgu2FVrEzTHc2MrmgBj7fPLwYVf5ANuIP9zZdVTbDk
	 EYQaC7KEkieEPOgBV9jSrqUilJ7kpgvsiwza7owcnvOW2gBVmlWAcXbZAq66ZNJiSM
	 ktM/kX25D0GmUOXM+MhN4jdr4Hv6IObA+LQW+9sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 512/690] NFSD: Use set_bit(RQ_DROPME)
Date: Mon,  8 Apr 2024 14:56:18 +0200
Message-ID: <20240408125418.195156108@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5304930dbae82d259bcf7e5611db7c81e7a42eff ]

The premise that "Once an svc thread is scheduled and executing an
RPC, no other processes will touch svc_rqst::rq_flags" is false.
svc_xprt_enqueue() examines the RQ_BUSY flag in scheduled nfsd
threads when determining which thread to wake up next.

Fixes: 9315564747cb ("NFSD: Use only RQ_DROPME to signal the need to drop a reply")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsproc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index a5570cf75f3fd..9744443c39652 100644
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
 
-- 
2.43.0



