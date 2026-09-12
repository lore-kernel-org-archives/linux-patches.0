Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E7142882B;
	Sat, 12 Sep 2026 10:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208386; cv=none; b=Mfc41FK8o5dE5uHWZt+2gvPzGKLbG0UStfwfdkdCMxrr3T0pb6pDjq0bv73rx3ZKEEsIC98f6Y1GawHXhCFOM6Le2Ie6RrdwlLMNyddYU3l6ry6I7hL5YyNsWn8F/au7gjKVKG8uuVPhIBkmSIEtqIhAzqw+esjftWfFdaRsXsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208386; c=relaxed/simple;
	bh=q4kS70JsomPnS7809ubCN026EQis1yzuJFIsQUU6c/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=St87DMPdedHv8XVhKLURQwy3MTsrkeG8zAmce+V7NAH8ANZULIBJZVLWhrCDvxZcAJYEsjhIJjy3coaEkxYHqdwfY2A6PDztvXZRcM3yQTLYGQ8NYmJ30+b2mheUEMC/UbqgkAAoKQ04zn7+po5ISsvfv6VOyWsKb6HHMkS5eSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZQXuaCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZQXuaCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1534D1F00893;
	Sat, 12 Sep 2026 10:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208383;
	bh=PBga822UkM4jVe/ySMTLtsAgmNaLOuj3jfVvBI+p6sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZQXuaCIp+61LMzXXeyQp+SMZ6oWLIO1gKZ2xKhAD77uYyLxF1xLP4n2n0TjzazqU
	 m5zOiQM5ToksEqDVyRwTiMM5O+Woux78mK+JK1vXpnybIZUxK62rbZ2WyXq9TpAssx
	 vxrD4gKiCagzbx9udSUvxmh7iN9F8vyjWfjm5Euw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0607/1518] RDMA/rxe: Fix UAF in ODP init error-handling path
Date: Sat, 12 Sep 2026 08:46:16 +0200
Message-ID: <20260912065637.157012946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4d4e3b324dd29..16b3fbdf2f867 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -115,6 +115,7 @@ int rxe_odp_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length,
 	err = rxe_odp_init_pages(mr);
 	if (err) {
 		ib_umem_odp_release(umem_odp);
+		mr->umem = NULL;
 		return err;
 	}
 
-- 
2.53.0



