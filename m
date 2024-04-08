Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF12D6FE35;
	Mon,  8 Apr 2024 13:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584518; cv=none; b=NIl6zypotRGPPpqdJkHpaeTIkViXEcg+grH9MaFujMQQqeWRdkLcZ/zuOKPVBKdQP3E1bDPyspw4ALqFH2Y2FoMnh7esHO/flpZh2gF0+7DbXGu7QzXXfpxVdroEA/LMjmyQK62gutfWt1vTMRsKp9MgPH9n07P0X1iCQgxsyU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584518; c=relaxed/simple;
	bh=AWGW4Nnb+mswLHNJV2uRrZJMDWkafBCkKvUal+6XKvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGiejSvwYl6+GA14LSukLZ28xBI7WUykJF+kEwqgXLJ68HaJPuiA/i/pwvSYm2B54rLnOTNwkUJSCtIp+BVs5wHIusUovnIswuolhKLtc7D8E0yYJ4clsFc6S/gotXY/7ylw5Bmf6Yt8fa4F1psfqPQ9O6Diiw/IR+oCtPmW5dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTkCrV0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTkCrV0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B655C433C7;
	Mon,  8 Apr 2024 13:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584518;
	bh=AWGW4Nnb+mswLHNJV2uRrZJMDWkafBCkKvUal+6XKvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTkCrV0pabkzYxJP7JNfVuyAdQRqoU41Oy1vyh5rF3TNX+xGH2NCyhFG/qfhtoARM
	 UTOvBm6HZKfETxJR6BUFypq9/aoVw4PyFka5YgH2dfgO0gfcmabchzHhtcEhZ9yjc8
	 u+7kiv+WEjTtjPOg4Ve+caakwtyc0PTAszRdZfho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 466/690] NFSD: Fix trace_nfsd_fh_verify_err() crasher
Date: Mon,  8 Apr 2024 14:55:32 +0200
Message-ID: <20240408125416.504988384@linuxfoundation.org>
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

[ Upstream commit 5a01c805441bdc86e7af206d8a03735cc9394ffb ]

Now that the nfsd_fh_verify_err() tracepoint is always called on
error, it needs to handle cases where the filehandle is not yet
fully formed.

Fixes: 93c128e709ae ("nfsd: ensure we always call fh_verify_error tracepoint")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/trace.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 1229502b6e9e0..72aa7435d55bd 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -254,7 +254,10 @@ TRACE_EVENT_CONDITION(nfsd_fh_verify_err,
 				  rqstp->rq_xprt->xpt_remotelen);
 		__entry->xid = be32_to_cpu(rqstp->rq_xid);
 		__entry->fh_hash = knfsd_fh_hash(&fhp->fh_handle);
-		__entry->inode = d_inode(fhp->fh_dentry);
+		if (fhp->fh_dentry)
+			__entry->inode = d_inode(fhp->fh_dentry);
+		else
+			__entry->inode = NULL;
 		__entry->type = type;
 		__entry->access = access;
 		__entry->error = be32_to_cpu(error);
-- 
2.43.0



