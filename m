Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011887D085;
	Mon,  8 Apr 2024 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584704; cv=none; b=J7tm+W3XOyE+dfdn0K+m8huiIw52Fy0RVUfJk+8NFBxL14YE12e9Dzr79cPjp1DAxrJWjQn4/YU6PgmeW94pI+Mvju3cnABPQ97/D8dPz3S3KzyC99tCfAOyIoZE1HNLZ63/Rvu71QCmcJxGwgm7UnMDStWjMKXlcdUBWqXmy4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584704; c=relaxed/simple;
	bh=VEOPYr17wUsqOChQ8sITIkHxTYkIPepZESHWdc5QGds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVaaeSdOLowdNFPQcgOECJ7WPB8sr+kYQqGZMeU+AKl8+kthXKQk0mMCP4Vw0oDlnE1ZAEeT9PkWE9WvZiqCwkwyDXflhPuiGQKNm8hJs8YkUvPnKLfDERdPPw+Gcogngk5nsNk9dqe9UR2MKrmlmbw+lhMhMcgIRiYvKNd05Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O39lKH+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O39lKH+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A741C433F1;
	Mon,  8 Apr 2024 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584703;
	bh=VEOPYr17wUsqOChQ8sITIkHxTYkIPepZESHWdc5QGds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O39lKH+OWNtoDWBbu7QocNHK2zQh4WcGdAuFliK/3je9h37GMzQgyxS3Mf+m+vtJf
	 nDSI1+1Fo3S/6H1r1FoAuG0qArQZD/7e0dRbpTas8UtZTV0z3G2LnNmWnRj+Yn51a2
	 m0ztbzdd79pNfRrRHXO1H7IQHzD/zun6ZvpLJ2Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 529/690] nfsd: dont open-code clear_and_wake_up_bit
Date: Mon,  8 Apr 2024 14:56:35 +0200
Message-ID: <20240408125418.813037080@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit b8bea9f6cdd7236c7c2238d022145e9b2f8aac22 ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 4a3796c6bd957..677a8d935ccc2 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1173,9 +1173,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		status = nfserr_jukebox;
 	if (status != nfs_ok)
 		nfsd_file_unhash(nf);
-	clear_bit_unlock(NFSD_FILE_PENDING, &nf->nf_flags);
-	smp_mb__after_atomic();
-	wake_up_bit(&nf->nf_flags, NFSD_FILE_PENDING);
+	clear_and_wake_up_bit(NFSD_FILE_PENDING, &nf->nf_flags);
 	goto out;
 }
 
-- 
2.43.0



