Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D733C4E01FA;
	Wed, 30 Sep 2026 18:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793225; cv=none; b=K0An7ZPgAqUtz/t+kZr/0laRmBz4qWBDWsZEd8lLM0K7Rgtk7H6MzPh/P6/9dJSR8NFZKNJU/ml8/Mf5tjxwE5H2GaQt/2VqrEEfTletv9ijb/RmTnYN+CDDYOAwFxBkDuUTv98HrX7b4rDXBs//3ZAW0MOKqrxgi94/q87MySI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793225; c=relaxed/simple;
	bh=AImmCSMpa1OIqTTOUZ4FijSieeBv23jsFznx5wwVFRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5m/WFCb+TeCuhTCuAnv0ZYrbSpqp6QxLrD16d4R3J28YDdtuwN8fKI5bkilT3jk/0vwUbZ1S09cD41pp6osRn94fbQvIUX4Q8/CzXFb3jX2DtBvUSv6mo0tqUdAEdYr2RLHpO8i0bLmx9mFeooRCFSWnc+K0xFemmO+ffYdZdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOuUHcQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOuUHcQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D5E1F000FF;
	Wed, 30 Sep 2026 18:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793223;
	bh=Mpwa38OOO1NxaQbLZV5VvMDvkZnAz2ooNNEXXq4gtpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aOuUHcQLaLChn5caV5ReO0CScwkWye4/oPdNp/EG4LWBDuHcYFrD8f/SS0TPdIzuc
	 SVaZvDKiXavYdGbIsWOhWho+9AUkjk6oat5OWKdRcRKs+9+MvUtA6H9xET+//5rzG2
	 MSQxk+FPQS2N7xiQ8XWiUwZH4SQiPykmgJ7czI7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 180/395] net/smc: fix UAF on lgr list traversal in smcr_port_err()
Date: Wed, 30 Sep 2026 17:27:22 +0200
Message-ID: <20260930152344.557178992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Sidraya Jayagond <sidraya@linux.ibm.com>

[ Upstream commit 61cb282fe97b3b0ba32ca09417a693162bf4ae3f ]

smcr_port_err() traverses smc_lgr_list.list without holding
smc_lgr_list.lock, allowing a concurrent smc_lgr_terminate_sched()
to free an lgr while it is still being dereferenced.

Hold smc_lgr_list.lock across the traversal. Update
smc_ib_gid_check() to call smcr_port_err() after releasing the lock.

Fixes: 541afa10c126 ("net/smc: add smcr_port_err() and smcr_link_down() processing")
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Signed-off-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Link: https://patch.msgid.link/20260922073149.474762-1-sidraya@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c |  2 ++
 net/smc/smc_ib.c   | 10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 34fa809e95047..fff84df00cab3 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1835,6 +1835,7 @@ void smcr_port_err(struct smc_ib_device *smcibdev, u8 ibport)
 	struct smc_link_group *lgr, *n;
 	int i;
 
+	spin_lock_bh(&smc_lgr_list.lock);
 	list_for_each_entry_safe(lgr, n, &smc_lgr_list.list, list) {
 		if (strncmp(smcibdev->pnetid[ibport - 1], lgr->pnet_id,
 			    SMC_MAX_PNETID_LEN))
@@ -1849,6 +1850,7 @@ void smcr_port_err(struct smc_ib_device *smcibdev, u8 ibport)
 				smcr_link_down_cond_sched(lnk);
 		}
 	}
+	spin_unlock_bh(&smc_lgr_list.lock);
 }
 
 static void smc_link_down_work(struct work_struct *work)
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 0052f02756ebb..845f15ed06bf1 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -333,6 +333,7 @@ static bool smc_ib_check_link_gid(u8 gid[SMC_GID_SIZE], bool smcrv2,
 static void smc_ib_gid_check(struct smc_ib_device *smcibdev, u8 ibport)
 {
 	struct smc_link_group *lgr;
+	bool stale_gid = false;
 	int i;
 
 	spin_lock_bh(&smc_lgr_list.lock);
@@ -348,11 +349,16 @@ static void smc_ib_gid_check(struct smc_ib_device *smcibdev, u8 ibport)
 				continue;
 			if (!smc_ib_check_link_gid(lgr->lnk[i].gid,
 						   lgr->smc_version == SMC_V2,
-						   smcibdev, ibport))
-				smcr_port_err(smcibdev, ibport);
+						   smcibdev, ibport)) {
+				stale_gid = true;
+				goto out;
+			}
 		}
 	}
+out:
 	spin_unlock_bh(&smc_lgr_list.lock);
+	if (stale_gid)
+		smcr_port_err(smcibdev, ibport);
 }
 
 static int smc_ib_remember_port_attr(struct smc_ib_device *smcibdev, u8 ibport)
-- 
2.53.0



