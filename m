Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BBB281525;
	Tue, 11 Nov 2025 01:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825021; cv=none; b=k//HqRO3+s4nCeaTkByuYVKwh/d9msMns8USr8xl6aU6tzHo4n8qvSAS0d1WnJ3UEyiTiY3k2jEezfno191PXLHrSHiylLwCGucRc9T4AB0m3wDgXNXwX6WxZto8skNwL6U1VBB0GumWYyVOO9owal63r139O+xLzFgwH6He8pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825021; c=relaxed/simple;
	bh=+JZoKEr/9zng5Jtat8qiZdI83BJl2cNxWaIL2zeuC3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mj8jRJhZ9Lyjq4tS7ETMxmycO8cNukcULOZxcj/SOufOjwQaMkL5Lvj0a8/7w5KUV44G1WkROfsga5DjyfGlGhihIRk0XXb1MrTv71XxT+w/7gmkpkte6gkFXdj6QZX2tsdxYvOmNX2I1We+kZCl/4OGoiSd447sMpaD8iWkFZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mojmqpJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mojmqpJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CC5C19421;
	Tue, 11 Nov 2025 01:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825021;
	bh=+JZoKEr/9zng5Jtat8qiZdI83BJl2cNxWaIL2zeuC3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mojmqpJRtAkjNyLG/xplAXES6unRcc0ULNp8DxrD2MDf4Twwr95j1hpj1CDvp1fUQ
	 W9ev6nVzvTastWWNCWZ0WUbGVneTu39CUkWQyL6vZYPuFkKqZSUN6h9Io4UfGPoDrn
	 8YvxY6/LpSWrQoT4mcLmapQYNsHTGkGb5SFuybFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 628/849] NFSv4: handle ERR_GRACE on delegation recalls
Date: Tue, 11 Nov 2025 09:43:18 +0900
Message-ID: <20251111004551.616910703@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 611e6283c194f..4de3e4bd724b7 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7872,10 +7872,10 @@ int nfs4_lock_delegation_recall(struct file_lock *fl, struct nfs4_state *state,
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



