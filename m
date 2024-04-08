Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2A96EB72;
	Mon,  8 Apr 2024 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584445; cv=none; b=B7iSh2lc6xKc3iQimWwO4m9yt2fILurr/0RIoHlITs4rN78YfqCW/WfPtn0U99CwTqpdldNijyBLrOosY1j1g01t74GKwB/1DzOLuj666oSvmqr9Gx2pL2JRpFu+WhaxmHcI90JIX6txPNJo7vu+/5tsO+fq4E+PniB8q7vo5vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584445; c=relaxed/simple;
	bh=Wpq55/5/Nos2HA/on0NFf83bmY9DULuotQsKK/pMv8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD3mqFroiBU4SDErSvUSpKfHsj8pQmKrcrxws/SYXoaqNGxP7chILNXRqqyr1SRmu9MrgBJ2Dp6/gp+I06Ko7r2norEBR9/KquPNv7LE5amEWEP0fI6KgQ/IotN2QIabBwxiLrVxiIUGh1YqkGRafFKZfonObh3vu38dduWLnU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxgembB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxgembB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D65C433F1;
	Mon,  8 Apr 2024 13:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584445;
	bh=Wpq55/5/Nos2HA/on0NFf83bmY9DULuotQsKK/pMv8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxgembB3f6uWeJE5S5ArZkaI2ipF357bRnO+eFzfdUZnkPjf1zY9ierCf/AwS5V9X
	 4r1fSa/f97L+ATKUucJlTOlJHHfcO+tvsh2V3lxOxauzt6COqPmLopZf3myJklUdOl
	 epA/fcnOsg0f2tA9yTr5gxBABPMy7Z+A3o8PGh6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 440/690] NFSD: Clean up WRITE arg decoders
Date: Mon,  8 Apr 2024 14:55:06 +0200
Message-ID: <20240408125415.580637379@linuxfoundation.org>
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

[ Upstream commit d4da5baa533215b14625458e645056baf646bb2e ]

xdr_stream_subsegment() already returns a boolean value.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs3xdr.c | 4 +---
 fs/nfsd/nfsxdr.c  | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 71e32cf288854..3308dd671ef0b 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -571,10 +571,8 @@ nfs3svc_decode_writeargs(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 		args->count = max_blocksize;
 		args->len = max_blocksize;
 	}
-	if (!xdr_stream_subsegment(xdr, &args->payload, args->count))
-		return false;
 
-	return true;
+	return xdr_stream_subsegment(xdr, &args->payload, args->count);
 }
 
 bool
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index aba8520b4b8b6..caf6355b18fa9 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -338,10 +338,8 @@ nfssvc_decode_writeargs(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 		return false;
 	if (args->len > NFSSVC_MAXBLKSIZE_V2)
 		return false;
-	if (!xdr_stream_subsegment(xdr, &args->payload, args->len))
-		return false;
 
-	return true;
+	return xdr_stream_subsegment(xdr, &args->payload, args->len);
 }
 
 bool
-- 
2.43.0



