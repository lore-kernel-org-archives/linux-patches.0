Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4022F0699;
	Wed,  3 Dec 2025 16:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777986; cv=none; b=uR5pTBT1OCzXEUQ4BoQugB98LTf9k40ax6rOs2DfYzCXODnj4Mxi7fiEC/Zo4TcmqIys39hlnT0Mhh66QK5Idr2PuLsUwXEXGYua0ipfihC/hXt4WVelp8d8LZx/EP4/+xBQgXfp++zUJ/dYIRHK9pxVlJFqmoINF9bjmZuUT5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777986; c=relaxed/simple;
	bh=6RrupVN9P89tCnRXACMhYDiiA+OtOlXq4EkwCBCyGAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTFuT/4MtzCKF3m3ns8qKrQBvADN1yCGGBoTPdyNQFZ2OBPxS2xRBA+OS7BRO2E2aZ2meDrLqMgQvyVBY2xyQaFNBei7+LowojP9IHavP+zHGFaCjZgviP6uc6zHBK5XGuUNtXg+qY8g0M7DxJ7LOUEuPeHwdZgnjL1ZyVmUy40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awF8dsOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awF8dsOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1230EC4CEF5;
	Wed,  3 Dec 2025 16:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777984;
	bh=6RrupVN9P89tCnRXACMhYDiiA+OtOlXq4EkwCBCyGAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awF8dsOLDJdILQXmctZBAZ+tjAm7Eie/pw/QKiZQSFOHHVoQcLNyJJHVY3uehdKgb
	 DyiwwflxPK1pfs3thUVsYPct07TqZ+O5vh2hdw89sUc0Sh4Lx046SrXFnsQvC3Cq0O
	 lUy0UB0TrJEApILXc5NkHLXhQuCRzpTZuyDxHFkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/392] NFSv4: handle ERR_GRACE on delegation recalls
Date: Wed,  3 Dec 2025 16:25:24 +0100
Message-ID: <20251203152420.480736117@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a98b10c85b700..1c62c4314173e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7613,10 +7613,10 @@ int nfs4_lock_delegation_recall(struct file_lock *fl, struct nfs4_state *state,
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



