Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B0313DDD2;
	Tue, 18 Jun 2024 12:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714651; cv=none; b=rNPV3fpjfzE9l1h+fpUcUSKguqqRHQ0b2VgBZ0l5qLHUNbIjjRYzLQpAZ6d0QoD41c3W9rpLJ41/uSyOombarZAOFU4ecdrdzelspsNDVC/dvImSmo5GloIW+CGeBi/C7J7TwPcbX4G3ftwnyDpKzeS6SYzky8BCJmKHMW9ya5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714651; c=relaxed/simple;
	bh=6XB4tmUFmwFhMK/TipGsWszWZcEwWWXewM05QAC/Fgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMPw20CQb68ylBMPtRP22PtVq4PDPXpM66R9GXNHi1LgvKun/YyQUV3atjcAixC6wVOOF6z3m1X90uKOD5mrqX7W9nSovcspFRchJJ7G94UsvvM7mtCfcbfbCaU3OS7Hjm0fA9i58gCf+iiyjHCuvW18/fpHKqWEeRNMbCzc+eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a11JiD9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a11JiD9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7B1C3277B;
	Tue, 18 Jun 2024 12:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714651;
	bh=6XB4tmUFmwFhMK/TipGsWszWZcEwWWXewM05QAC/Fgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a11JiD9bbGWbwUiqlJBzkCpX9FUL7cqjFf6FmjaYG3oLRORp5Hyei9gPczAVpL6h6
	 Y6MccEc3EokGJpIS3nOo9Qn1U+O9PWaOnFqPfL4U8HsIUuDlzS7nsZF0bNRrFf50RF
	 UPuPJ0pVNVAAookC0xvnYJHVJLJQgcy65HLZd+/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/770] NFSD: Replace READ* macros in nfsd4_decode_lock()
Date: Tue, 18 Jun 2024 14:28:08 +0200
Message-ID: <20240618123408.649486303@linuxfoundation.org>
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

[ Upstream commit 7c59deed5cd2e1cfc6cbecf06f4584ac53755f53 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 15ed5249e2c74..b50d2987bb6e8 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -878,21 +878,17 @@ nfsd4_decode_locker4(struct nfsd4_compoundargs *argp, struct nfsd4_lock *lock)
 static __be32
 nfsd4_decode_lock(struct nfsd4_compoundargs *argp, struct nfsd4_lock *lock)
 {
-	DECODE_HEAD;
-
-	/*
-	* type, reclaim(boolean), offset, length, new_lock_owner(boolean)
-	*/
-	READ_BUF(28);
-	lock->lk_type = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &lock->lk_type) < 0)
+		return nfserr_bad_xdr;
 	if ((lock->lk_type < NFS4_READ_LT) || (lock->lk_type > NFS4_WRITEW_LT))
-		goto xdr_error;
-	lock->lk_reclaim = be32_to_cpup(p++);
-	p = xdr_decode_hyper(p, &lock->lk_offset);
-	p = xdr_decode_hyper(p, &lock->lk_length);
-	status = nfsd4_decode_locker4(argp, lock);
-
-	DECODE_TAIL;
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_bool(argp->xdr, &lock->lk_reclaim) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &lock->lk_offset) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &lock->lk_length) < 0)
+		return nfserr_bad_xdr;
+	return nfsd4_decode_locker4(argp, lock);
 }
 
 static __be32
-- 
2.43.0



