Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053AF151988;
	Wed,  5 Feb 2025 14:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766178; cv=none; b=E6MPdlP/w4Za1GimaLM5dwrn/CyHAqeMJFdi0/zt2bp02Rn0OEtlYxH4rO6rx8oVyITw4K23sl7SXvVuPsJKoGbGOGdAbqUFz18tIpx9PclGP06d7T63YG5vDxMPgL589DPcUmSJSpqO+ZX5QbdwAKIjUkKgLAxjc8cboYd5iaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766178; c=relaxed/simple;
	bh=52r+JlhetmPg0ghRr438q+qVBYYUlcYvQ0d8+3ih9NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtcgfIREJ1v6aYIq5o8yufEDluNKDoOHO8hKfg3jp1D6VGGw+/ziK/6oTqRSTdsvCuc68oyszlOipRwa9aYBtB3Z+6BMf3bZbi1bpXmAlZDyfJH9pSxR07UV6MgiscWTIIMOsG3e0ppaiGPfdBwtRw+Zl/I1lj9beXnVdkr7JJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvXil6e5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvXil6e5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760B4C4CED1;
	Wed,  5 Feb 2025 14:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766177;
	bh=52r+JlhetmPg0ghRr438q+qVBYYUlcYvQ0d8+3ih9NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvXil6e5eg1FCBHPYn1rZI4VppmCnkmAO8ap3zxfsolwJpe5dvH6Dl6DQRVtpSdFm
	 MQh7OLEB/IlqZjRZGdtlP5IPJ56ykiH/5Krc9jiCVUiyp6MuHIyqeZEY1hsJX1/Fhe
	 DuhqXpLpkTza/2B1fhZudQzorLSOuF74OCJXVX7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Qu Zicheng <quzicheng@huawei.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 294/590] padata: fix UAF in padata_reorder
Date: Wed,  5 Feb 2025 14:40:49 +0100
Message-ID: <20250205134506.525099255@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit e01780ea4661172734118d2a5f41bc9720765668 ]

A bug was found when run ltp test:

BUG: KASAN: slab-use-after-free in padata_find_next+0x29/0x1a0
Read of size 4 at addr ffff88bbfe003524 by task kworker/u113:2/3039206

CPU: 0 PID: 3039206 Comm: kworker/u113:2 Kdump: loaded Not tainted 6.6.0+
Workqueue: pdecrypt_parallel padata_parallel_worker
Call Trace:
<TASK>
dump_stack_lvl+0x32/0x50
print_address_description.constprop.0+0x6b/0x3d0
print_report+0xdd/0x2c0
kasan_report+0xa5/0xd0
padata_find_next+0x29/0x1a0
padata_reorder+0x131/0x220
padata_parallel_worker+0x3d/0xc0
process_one_work+0x2ec/0x5a0

If 'mdelay(10)' is added before calling 'padata_find_next' in the
'padata_reorder' function, this issue could be reproduced easily with
ltp test (pcrypt_aead01).

This can be explained as bellow:

pcrypt_aead_encrypt
...
padata_do_parallel
refcount_inc(&pd->refcnt); // add refcnt
...
padata_do_serial
padata_reorder // pd
while (1) {
padata_find_next(pd, true); // using pd
queue_work_on
...
padata_serial_worker				crypto_del_alg
padata_put_pd_cnt // sub refcnt
						padata_free_shell
						padata_put_pd(ps->pd);
						// pd is freed
// loop again, but pd is freed
// call padata_find_next, UAF
}

In the padata_reorder function, when it loops in 'while', if the alg is
deleted, the refcnt may be decreased to 0 before entering
'padata_find_next', which leads to UAF.

As mentioned in [1], do_serial is supposed to be called with BHs disabled
and always happen under RCU protection, to address this issue, add
synchronize_rcu() in 'padata_free_shell' wait for all _do_serial calls
to finish.

[1] https://lore.kernel.org/all/20221028160401.cccypv4euxikusiq@parnassus.localdomain/
[2] https://lore.kernel.org/linux-kernel/jfjz5d7zwbytztackem7ibzalm5lnxldi2eofeiczqmqs2m7o6@fq426cwnjtkm/
Fixes: b128a3040935 ("padata: allocate workqueue internally")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Qu Zicheng <quzicheng@huawei.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/padata.c b/kernel/padata.c
index ada4a0d137d9b..e2ae2c3747a85 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1128,6 +1128,12 @@ void padata_free_shell(struct padata_shell *ps)
 	if (!ps)
 		return;
 
+	/*
+	 * Wait for all _do_serial calls to finish to avoid touching
+	 * freed pd's and ps's.
+	 */
+	synchronize_rcu();
+
 	mutex_lock(&ps->pinst->lock);
 	list_del(&ps->list);
 	pd = rcu_dereference_protected(ps->pd, 1);
-- 
2.39.5



