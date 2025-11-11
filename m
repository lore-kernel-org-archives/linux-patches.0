Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BF1346E60;
	Tue, 11 Nov 2025 01:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824241; cv=none; b=CAXFfytRKSM3woS87bQcQj/cH65qM3r0j84LS1gH4Q0PZS4RBMaBLXe55Ab62bH05Vwo8kTm9i+lYPiuaI27DPLCs8g8pZpIPK2YZyTEayjYpyp0afhY4LHCxgNahUq0LLykSeD4Iah1tETUpDXdaCvCWi2KdF11m7VNDmapuxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824241; c=relaxed/simple;
	bh=bTp+c6Yo039Y1sMmDPwOXXsS8MddBF2EAaRVi4F+ii8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAhWNi/HnFkaEhOMXDzIHrXtHEDHn6b3xt1Kwi2cBk9XSqOisHN/mVOnCIYDUjXZeNc8dPvLrHOodf9FxAE7QPBxgynVfuw3tvrKeqj7PgeQZX1IFyw8wOZmLXiHc9bmrceCFrY64icHHaSzZlTggOt/innn8+Piqa0cx875kxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kN/c5Uvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kN/c5Uvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A95C113D0;
	Tue, 11 Nov 2025 01:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824240;
	bh=bTp+c6Yo039Y1sMmDPwOXXsS8MddBF2EAaRVi4F+ii8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kN/c5UvxE1GIRotr6AaCB/qEmJonOqsTZ0Ec1rIk+a8Dsb8aSiPCOXQ21a6N0gl8x
	 di/ZecsKgqKk98YmfloHMURiUokCtGSBiAOe18VuCvNxIJQDQ6N69wyWPkBL+mBAs0
	 dtWgR4WEmaelrvzjOdfGf+8ujBoOBknJXl56snWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 417/565] NFSv4: handle ERR_GRACE on delegation recalls
Date: Tue, 11 Nov 2025 09:44:33 +0900
Message-ID: <20251111004536.244568571@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c21e63027fc0e..2b71d39fe8c01 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7823,10 +7823,10 @@ int nfs4_lock_delegation_recall(struct file_lock *fl, struct nfs4_state *state,
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



