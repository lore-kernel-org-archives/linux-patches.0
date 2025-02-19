Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77021C3C00;
	Wed, 19 Feb 2025 09:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956286; cv=none; b=S+AnfuWftOREfAKphRTNcWHZwjZ0imYXO6fR46xUw/qMaD265YfTE0rCNdo0pNcRtX1+cDhH+9t2F+qIl5tVcSyhgkDiWsx74ByTIHiTkWqJXeXnBZtEJVVGsX8C5ZxXqNMCkJL8C+zfyPZ0Y3jUUW2zvXOxLtj5pSQJiXUQVlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956286; c=relaxed/simple;
	bh=u+Hhpkju9BEy3djWwReFqDOHOhL4ETJKSugEwnb/IyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Noy5FZT6FTpIXN3iGxFxyeLEFKZwrubekO6aijScZEuuvikHklnMANJney7k38nKVhsqEA4oIHqNKdVgbiv9Q1C73r59u3ignli9eZxzYIcNHW1MjAnlNWWlvXCocUbbYHohO2C9R9OP1jgtPXVXW4vZftnxY7VwR/nHWKTVzpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOmblBG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOmblBG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47E7C4CED1;
	Wed, 19 Feb 2025 09:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956286;
	bh=u+Hhpkju9BEy3djWwReFqDOHOhL4ETJKSugEwnb/IyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOmblBG1libpdzF/7w6cg4A5UGLuHhRu7Gdg8SXiz3mXX0iFidz3iDC/oXv1ZSmUE
	 7c1CaIluc0wHQnsHtH29ajYsopnqdcFrcUit4e0QGeD0L/Tr91hyZYZZ1FQr4GeW/m
	 fP4DCd6ed+iPpTKWYbU3aK15S2dVSgQ7fTk/9Gps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Qu Zicheng <quzicheng@huawei.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/578] padata: fix UAF in padata_reorder
Date: Wed, 19 Feb 2025 09:22:12 +0100
Message-ID: <20250219082658.023572412@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 46b75d6b3618c..5f3069907d497 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1110,6 +1110,12 @@ void padata_free_shell(struct padata_shell *ps)
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



