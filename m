Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621B1511E61;
	Wed, 30 Sep 2026 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787392; cv=none; b=JTpYXhQoaLfukY0zgGGn2Rq3zJltAFGFaVnwftAkOi2W2j/6VZC8Fm6L4Bu1qapZ4Gz+SmpFxeIt/ndaAh0+fStj9er+GF2y/lp5zemyexUj8K0CglAqHR5HyRIHEZGpxLESaCWDjTnp13Pd2I4YeufeV/uK0B0IxQzVaG6ZBIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787392; c=relaxed/simple;
	bh=giYPf+IcI0PVgXJSfTeBvpfEeOqKUWHYNB60NOO1R/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRJhUYh/8oKO+pZ7TRyToFHARn9sjGCKi4jlApGhAw9UFRzFUWG9otG3ao++/rK0rAJFbk6hCx7+JPSnnULEhWIbniw3ZriFzbOLyUxRAgnuBxiEtVEKYwPiwDPjOmvYkefACO0uXeHciK3yC447PV/ADbJYJD+lubNhP/LAIiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C31KSdRY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C31KSdRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27371F000FF;
	Wed, 30 Sep 2026 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787391;
	bh=tppjZs8+AW/+NnHDktZokxSr+LgyreMk3usWgaNEO50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C31KSdRY1jrsd+VGgbHhAHP/e//iuMtsQbMY8z58kJaMKKeqfB6sVzbvfELQ/MaPU
	 bBMNlcIsDenIZkxmt0OnOpWlHceuNDtNjsv+e5mPqHnhhOlz5O7wptVOOoDxtDgEAH
	 LwvI20cw0iipbMD4uYRcHZuhRB8xzIcQApCtL2Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 215/457] net/smc: fix UAF on lgr list traversal in smcr_port_err()
Date: Wed, 30 Sep 2026 17:25:20 +0200
Message-ID: <20260930152350.688349199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
index 04aedd957543a..9974149659c2f 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1849,6 +1849,7 @@ void smcr_port_err(struct smc_ib_device *smcibdev, u8 ibport)
 	struct smc_link_group *lgr, *n;
 	int i;
 
+	spin_lock_bh(&smc_lgr_list.lock);
 	list_for_each_entry_safe(lgr, n, &smc_lgr_list.list, list) {
 		if (strncmp(smcibdev->pnetid[ibport - 1], lgr->pnet_id,
 			    SMC_MAX_PNETID_LEN))
@@ -1863,6 +1864,7 @@ void smcr_port_err(struct smc_ib_device *smcibdev, u8 ibport)
 				smcr_link_down_cond_sched(lnk);
 		}
 	}
+	spin_unlock_bh(&smc_lgr_list.lock);
 }
 
 static void smc_link_down_work(struct work_struct *work)
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 9bb495707445e..daaa8a72da90f 100644
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



