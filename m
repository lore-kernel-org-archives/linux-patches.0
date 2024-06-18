Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA46514D435;
	Tue, 18 Jun 2024 12:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714952; cv=none; b=Ty0IiiEIV+vUdvGUOWYqOjh65gaTWaLuixkxkAYaqg7/GuKtas2Li33Fi0rodJyxD2tNshAigvtZ8Hg6PHo7dWJ4R8rk04N8A5xmXO60Uy+QqRfm3YR9t6ObuvFnVqDzQo4yrMRK/kmpXsjDla0p6sXsu/Aj8EhqLclL45pDAKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714952; c=relaxed/simple;
	bh=KKVMFeEDyTBoP6JzYjsCJV+EQKGLuz+xU7SFSZwfyH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcZwsOMmywzoYOWPYSaO4Ys3QFjhZT3QcLZuok0J0K56poFCkUoMOnpDpJfsC1lsTw+4rgIZqMJ8enahlf6fTOkk9oRnmjsulYcd4l/6+5MBiRGQOah00iHbfuqUqSqaNbJUGurIVQT04A5y+VKL12SnLDnggrIqGGpHdfv5dEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWbziI9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWbziI9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52351C3277B;
	Tue, 18 Jun 2024 12:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714952;
	bh=KKVMFeEDyTBoP6JzYjsCJV+EQKGLuz+xU7SFSZwfyH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWbziI9Yn88sryqjj3vYVT8aI5uVUxHi1Gfrv26b6y2pOW+HsFx7pRT9kf0WS/IYQ
	 abUngmPUp2C0TmFLZyWSxZm9dxSFkQ3GUQIwR6mC0w7ONxX4dvmcUZ6HKDIPpCdYFW
	 AZjEsej+tSK/d6S7Y6eHc+OxVv9yZmB+04P5X7JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/770] nfsd: Fix up nfsd to ensure that timeout errors dont result in ESTALE
Date: Tue, 18 Jun 2024 14:29:16 +0200
Message-ID: <20240618123411.251029073@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 2e19d10c1438241de32467637a2a411971547991 ]

If the underlying filesystem times out, then we want knfsd to return
NFSERR_JUKEBOX/DELAY rather than NFSERR_STALE.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsfh.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 9c29a523f4848..e80a7525561d0 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -268,12 +268,20 @@ static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp)
 	if (fileid_type == FILEID_ROOT)
 		dentry = dget(exp->ex_path.dentry);
 	else {
-		dentry = exportfs_decode_fh(exp->ex_path.mnt, fid,
-				data_left, fileid_type,
-				nfsd_acceptable, exp);
-		if (IS_ERR_OR_NULL(dentry))
+		dentry = exportfs_decode_fh_raw(exp->ex_path.mnt, fid,
+						data_left, fileid_type,
+						nfsd_acceptable, exp);
+		if (IS_ERR_OR_NULL(dentry)) {
 			trace_nfsd_set_fh_dentry_badhandle(rqstp, fhp,
 					dentry ?  PTR_ERR(dentry) : -ESTALE);
+			switch (PTR_ERR(dentry)) {
+			case -ENOMEM:
+			case -ETIMEDOUT:
+				break;
+			default:
+				dentry = ERR_PTR(-ESTALE);
+			}
+		}
 	}
 	if (dentry == NULL)
 		goto out;
-- 
2.43.0



