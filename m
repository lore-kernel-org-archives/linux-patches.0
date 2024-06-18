Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B1415A860;
	Tue, 18 Jun 2024 13:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716765; cv=none; b=p6knc+iewHjYbM0unGShDfGVy1HfPxRTDbV5JUkAbJfm6CcZtGZUgMVfN+27MAiuZShCtI1/WA1MWnq1xwyvSfgEKqOewAOHe9fe3F9kETzo5sqJKL36J/x6OIfJb+ztiKjEUC0x1pw2trGpelEkibHbO4bN/59/MliJtZ3zavQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716765; c=relaxed/simple;
	bh=xls96WPoj4Mqz1rzUrvM2Q5ZPZmmc+8k57Zz6HfoX9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkjKNJ2EDBKL0qqT1q0a+6clLj9lUK0gyo2nXLt8+lgDHYybxl3vdYEN2zwWlHk+CMqjZ9DzqMS/cXnp11E6BKTeU1Ut7hPP4fm5q3dNDY8u2GiCWTYiNiXm0ArnbEuOxzgma3kw/IXfgiE1fmzz1zu2OXIEo2JX+iIpGs4rP08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLsf17HH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLsf17HH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F83BC3277B;
	Tue, 18 Jun 2024 13:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716765;
	bh=xls96WPoj4Mqz1rzUrvM2Q5ZPZmmc+8k57Zz6HfoX9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLsf17HHH3ujzyhaLMYa41Pv4OYZOKCb/fxZdIvdUP/UuGl3Q81VY853X6iw//gv4
	 e2xTihGfNC2KxXTwTX9ewwmtrRhGaPL7m7TvLaA2dCcWlAx4ZsVTTl+wHCKypqB/XY
	 3BxaFNwUQEi+spBHJdiNPWihcQfXDXEhx9tIn6sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 724/770] NFSD: Use set_bit(RQ_DROPME)
Date: Tue, 18 Jun 2024 14:39:37 +0200
Message-ID: <20240618123435.217106571@linuxfoundation.org>
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

[ Upstream commit 5304930dbae82d259bcf7e5611db7c81e7a42eff ]

The premise that "Once an svc thread is scheduled and executing an
RPC, no other processes will touch svc_rqst::rq_flags" is false.
svc_xprt_enqueue() examines the RQ_BUSY flag in scheduled nfsd
threads when determining which thread to wake up next.

Fixes: 9315564747cb ("NFSD: Use only RQ_DROPME to signal the need to drop a reply")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index c32a871f0e275..96426dea7d412 100644
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



