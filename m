Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00244303A3D;
	Wed,  3 Dec 2025 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776334; cv=none; b=NSYGCDZNkhgJ0LgJYD2e/RKT1aNXxPR9eYTBEjoHzL7KjGjTNkHAsSLz9OF54LP9EzYraY3k2h8xtqIIWAJnPVJo36/ns+hL1Fazo7iGd6bxxMiTR+iQBGmVvAi8hAkX53YRa6JkkxKjfiZnybhq5V3DFT3E/H9Un7f6LzM/E9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776334; c=relaxed/simple;
	bh=c2XTtx2nV3t2VPiYqo14doyOnus3NFieEJ5Yl7yE4RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lr5GHtlxGWiioLWRmLH9YLjR7lShFdZOMtsaUmQOt8RSN+dCw9KUvwYWLMmJj1PINe9aayGMkBVyduZwO4/UzmIISF90N2iiqXdoA3qegxXo02BxgkrZcekc/I6XhcCh+1ZaKmrXtVlCpadTjwKZB36MTvTbDHZ9TcEOTpkikfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqDogZ20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqDogZ20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312ABC4CEF5;
	Wed,  3 Dec 2025 15:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776333;
	bh=c2XTtx2nV3t2VPiYqo14doyOnus3NFieEJ5Yl7yE4RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqDogZ2003h5WYoEqEzbmwNzabxd7/q6bhNpS8b/fXv9P1zsR/XVWHiaaYzRB/SJG
	 8BizsRm11jpoi398v9BiVIJ6Iz3rDMHKSz+LxRnf/w6QTZidzNs9ZfW5ibrwr1El+O
	 ydxabo0aTlQPN4kif3YrD9quhAshY1F5dKLflaJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/300] NFSv4: handle ERR_GRACE on delegation recalls
Date: Wed,  3 Dec 2025 16:25:38 +0100
Message-ID: <20251203152405.578640657@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit be390f95242785adbf37d7b8a5101dd2f2ba891b ]

RFC7530 states that clients should be prepared for the return of
NFS4ERR_GRACE errors for non-reclaim lock and I/O requests.

Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 87774f3b4c354..c454fb042ab2b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7473,10 +7473,10 @@ int nfs4_lock_delegation_recall(struct file_lock *fl, struct nfs4_state *state,
 		return err;
 	do {
 		err = _nfs4_do_setlk(state, F_SETLK, fl, NFS_LOCK_NEW);
-		if (err != -NFS4ERR_DELAY)
+		if (err != -NFS4ERR_DELAY && err != -NFS4ERR_GRACE)
 			break;
 		ssleep(1);
-	} while (err == -NFS4ERR_DELAY);
+	} while (err == -NFS4ERR_DELAY || err == -NFSERR_GRACE);
 	return nfs4_handle_delegation_recall_error(server, state, stateid, fl, err);
 }
 
-- 
2.51.0



