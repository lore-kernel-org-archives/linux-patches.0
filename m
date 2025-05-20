Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E6324EA9D;
	Tue, 20 May 2025 14:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750485; cv=none; b=u5XviP3NRSPSRmkLDejtiq8vD67A6up2HilREMKWwhB9saqjMrIPUg8rlZiq5sBQXSUj1QpYEtNAV1S05ayvvLbkaE27I7F8+kUrz6O8g4WVFBrBnm6CaQtvsksCM9alapSw7kkJv7GUjq0MNebIKVaWnFzenOa1xHuYutojo+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750485; c=relaxed/simple;
	bh=eXf+sByy78FwWdzf4NDqqmYzJpc2KEs5sCqEsM6X9xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+ZCzV85Ot+oEojQ/DKpta991WznJPElG6vtKYhi5UhT4rMBixtcBb+9ZI1UwzjHTZz0MFdaG3z+S9SXFmX1a9sEeeqA/2KenSbFGZPmqybCG+II3vmb1aPovzbVTdYrlCyiyouBK6sEkal4KWjBIAp4hIkXemHBHSBLY6yHMdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Fv6t/cP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Fv6t/cP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3319C4CEE9;
	Tue, 20 May 2025 14:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750485;
	bh=eXf+sByy78FwWdzf4NDqqmYzJpc2KEs5sCqEsM6X9xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Fv6t/cP0gRD5r9ipvrZRtbG8gRMV7QvXXNdEP1PC/jQUp7K3W/kLcd/PmIoAM0zJ
	 OAeFE/6CExYWtccKYHhv9DZkYLx9qeF88ZfriKeygBDTaNwFjavpcEStkWggnlf+gh
	 5N/z4ZRHBKMb2wpjC5iyFMFiqpxm7bufsV/Wirqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 024/145] NFS/localio: Fix a race in nfs_local_open_fh()
Date: Tue, 20 May 2025 15:49:54 +0200
Message-ID: <20250520125811.504795628@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit fa7ab64f1e2fdc8f2603aab8e0dd20de89cb10d9 ]

Once the clp->cl_uuid.lock has been dropped, another CPU could come in
and free the struct nfsd_file that was just added. To prevent that from
happening, take the RCU read lock before dropping the spin lock.

Fixes: 86e00412254a ("nfs: cache all open LOCALIO nfsd_file(s) in client")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 5c21caeae075c..4ec952f9f47dd 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -278,6 +278,7 @@ nfs_local_open_fh(struct nfs_client *clp, const struct cred *cred,
 		new = __nfs_local_open_fh(clp, cred, fh, nfl, mode);
 		if (IS_ERR(new))
 			return NULL;
+		rcu_read_lock();
 		/* try to swap in the pointer */
 		spin_lock(&clp->cl_uuid.lock);
 		nf = rcu_dereference_protected(*pnf, 1);
@@ -287,7 +288,6 @@ nfs_local_open_fh(struct nfs_client *clp, const struct cred *cred,
 			rcu_assign_pointer(*pnf, nf);
 		}
 		spin_unlock(&clp->cl_uuid.lock);
-		rcu_read_lock();
 	}
 	nf = nfs_local_file_get(nf);
 	rcu_read_unlock();
-- 
2.39.5



