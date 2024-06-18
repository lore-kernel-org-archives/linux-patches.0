Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E85713FD8C;
	Tue, 18 Jun 2024 12:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714752; cv=none; b=AE/eIlbXd9Z9GxVeUhidjIwBPFPNB8+paxz5d0fDzoki6xzsDo2emr01OKvLhpIUZArNl8F9HqgIXZkOzlJ3hWjlzOGSh4vaBN6IQaTVgp50cIhdTU430GzwIkITb1r+/raGvhYmyEiH/iiUL1e1cYYhN9dM8ywYD3RxQ83/kK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714752; c=relaxed/simple;
	bh=nmDvIA7Uh/VP5Ib8PwyC5y4TzdyxyQdBnpzh07RDf/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmHKB0D0439rqCzRYm6U5G+s2iljqq8W8j8gQg/J6MQRoGk+y32hL9aFWm/2bhD8+4JRy8HWFuxaRSl9SyY4DSjeH8PmSUgsBK0EEnUVr7Bi0mJImRkuflwT5tpO0dVbS4VUBgNx6iYtR/Pr/VrF0e+CxF1exgkDgeAL1PiuOtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQ3BFG4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQ3BFG4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008F3C3277B;
	Tue, 18 Jun 2024 12:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714752;
	bh=nmDvIA7Uh/VP5Ib8PwyC5y4TzdyxyQdBnpzh07RDf/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQ3BFG4N2uApRsMs3rxYDSEosfb3+hKHZJRYdB+jDYaD0eL7KpyAIxK4zJTuVUsUL
	 6kAHCTJqqgvVHErwfQjhLAtW8nn198ncOJNHf+p03KrdmPkgYWKqp+zSu0sx4d/sG9
	 5C9g9VQdyp7HJriifm99cY+KYzlBiKmBZbMZTGy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/770] NFSD: Replace READ* macros in nfsd4_decode_create_session()
Date: Tue, 18 Jun 2024 14:28:42 +0200
Message-ID: <20240618123409.947380137@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 81243e3fe37ed547fc4ed8aab1cec2865540bb18 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 716a16961ff48..3e2e0de00c3a7 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1650,24 +1650,28 @@ static __be32
 nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 			    struct nfsd4_create_session *sess)
 {
-	DECODE_HEAD;
-
-	READ_BUF(16);
-	COPYMEM(&sess->clientid, 8);
-	sess->seqid = be32_to_cpup(p++);
-	sess->flags = be32_to_cpup(p++);
+	__be32 status;
 
+	status = nfsd4_decode_clientid4(argp, &sess->clientid);
+	if (status)
+		return status;
+	if (xdr_stream_decode_u32(argp->xdr, &sess->seqid) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &sess->flags) < 0)
+		return nfserr_bad_xdr;
 	status = nfsd4_decode_channel_attrs4(argp, &sess->fore_channel);
 	if (status)
 		return status;
 	status = nfsd4_decode_channel_attrs4(argp, &sess->back_channel);
+	if (status)
+		return status;
+	if (xdr_stream_decode_u32(argp->xdr, &sess->callback_prog) < 0)
+		return nfserr_bad_xdr;
+	status = nfsd4_decode_cb_sec(argp, &sess->cb_sec);
 	if (status)
 		return status;
 
-	READ_BUF(4);
-	sess->callback_prog = be32_to_cpup(p++);
-	nfsd4_decode_cb_sec(argp, &sess->cb_sec);
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



