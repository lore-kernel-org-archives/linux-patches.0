Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FFC296BCD;
	Sat, 12 Sep 2026 08:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200043; cv=none; b=nHKy7/YiJ4jnin7zKl5CLkjacze8vExKQT5DO1luOTwRKgdbSDrSqoTspSNI0nRGsuSjtAzLoVIznOqiLjctbxyW2UZlqE/4VCOivMRi/ecP9EVy00eJkgUPi7agfl6RRdJ4+efbyZYBZzLslPl8oDVeXrpXQFLbpg7YTu/fH3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200043; c=relaxed/simple;
	bh=Eu207ETwMiL6Z0VlaSgYJ31Kb16YVjcvs/K7ak4tEK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wg0bpWdFv4o9gBSW61BlAOnShD/cuhUkXpJK86YehJE3uFMMbNCiLQ2+QJHWs3ZZ0FsAmrwWhmbxNLl2ZSIS7U9pQWhEsR58Q5aPP0XQP5dJatpFJDvQ3A5yxfQXrJjrGTSvc5Gn7qYdobJ4hnr73Kx4/D3SCdpEQqliks0jKJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chF+KGeE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chF+KGeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FF41F000FF;
	Sat, 12 Sep 2026 08:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200041;
	bh=lPfxIG8m7dj34zM0KBSgkNyv/t1d8raOXN2NsJKuib4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chF+KGeEdCMLLG+nZUYRVpTxgB7uPzUKuaJUsfZ6f1Szujv0IlwlklOf/XufH6aOP
	 nverQYhjzm+s3hAeU7bFuHKQAUoctmJs9fp5q75lnli9PsSqrG5DL9K6Iuf43zhII0
	 0aCZUsVTWTilFDlsVhaaQBnJpi5tmA5jNt5qO8sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0709/1815] RDMA/rxe: Fix UAF in ODP init error-handling path
Date: Sat, 12 Sep 2026 08:40:59 +0200
Message-ID: <20260912065705.539603921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

[ Upstream commit 51f2c8d2c99fc1f452f7113c08a35edcc4bf8732 ]

rxe_odp_mr_init_user() stores &umem_odp->umem in mr->umem before
calling rxe_odp_init_pages(). If rxe_odp_init_pages() fails,
rxe_odp_mr_init_user() releases umem_odp and returns an error.

rxe_reg_user_mr() then unwinds the error through rxe_cleanup(),
rxe_mr_cleanup(), ib_umem_release(mr->umem). There is an
IS_ERR_OR_NULL(umem) check at the start of ib_umem_release().
But since mr->umem is NOT reset to NULL in the error handling
path of rxe_odp_mr_init_user(), the check passes and it reads
already-freed fields like umem->is_dmabuf, causing UAF.

Fix the UAF by clearing mr->umem after releasing the failed
ODP umem so the MR cleanup path does not release it again.

Fixes: d03fb5c6599e ("RDMA/rxe: Allow registering MRs for On-Demand Paging")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Link: https://patch.msgid.link/70CB6DBCB19624C7+20260727050659.1543627-1-peiyang_he@smail.nju.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_odp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index ff904d5e54a73..1b1c4a0c71100 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -114,6 +114,7 @@ int rxe_odp_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length,
 	err = rxe_odp_init_pages(mr);
 	if (err) {
 		ib_umem_odp_release(umem_odp);
+		mr->umem = NULL;
 		return err;
 	}
 
-- 
2.53.0



