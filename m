Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9667B3A6B65;
	Sat, 17 Oct 2026 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257384; cv=none; b=ZDApwkJpQm3AJuYYkO2q8boss7Pzaz1QxQ0j7bqsQ51kJ5pBB9vbgdRzYFP8LktI5enic78DcoypyeQpOh8ECsgLglVf6PPNF3QTZ6XcKVV2HjhhF+IsiS5JHv2/hRvi4tA2rxDuqwfZr5ja860cXjGslyrUJVBnXWAupbBEFA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257384; c=relaxed/simple;
	bh=LeRcvaD+YsA41wyU64LaxLIpG4xQiyYT6X3ZqcNHNpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGdqNFFz5VOgjibQNsflKxWSdIA/urYimaWxcRs9zOlvaCYaSPjO5gS1Pepoy0NFhlJtrutV/x94Q8cWEo9xGuEa8B2dI3RyPbYAZfvLG+AdybKkl3ekdJUh+5MAlLaQVaRnGxo3P4/Rtk4tY6ja9aBRr2XxFmBrwSoRi4yZ9l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwGq/bph; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwGq/bph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984221F000C4;
	Sat, 17 Oct 2026 17:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257383;
	bh=m48XxChLoMVcVu23ROyuti8CjKIZoKmzTMSxMoKTP0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RwGq/bphUk12w7n5D783bjuMtDeXGHlQfaCpK0AnWCHg2XEfB+IvFCeMaQrfEMEDr
	 iBbx3LNk2suGqJbXpdDrhWT/evQBA64LZex5Is1SrLH3hpgneIv/fU0G9jiE9zzEPD
	 C1xbxYK2b85x9uWA26TsqZ9oTpDYWqwDBlESnhSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0542/1674] cxgb4/ch_ktls: disable softirqs around tid_list erases
Date: Sat, 17 Oct 2026 17:46:54 +0200
Message-ID: <20261017160445.011142351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 4c9dc0faca98084922caeb689579d338cf3e1c29 ]

chcr_ktls_cpl_act_open_rpl() inserts into tid_list from the receive path
using xa_insert_bh().  The array is shared by the adapter's connections
and initialized with XA_FLAGS_LOCK_BH.  However, chcr_ktls_dev_del() and
the chcr_ktls_dev_add() error path use xa_erase(), which takes the XArray
lock without disabling softirqs.

When cleanup runs with softirqs enabled, a receive softirq for another
connection on the same CPU can interrupt the erase and spin on the lock
held by the interrupted task.  Use xa_erase_bh() at both sites to match
the insertion path.

Fixes: 65e302a9bd57 ("cxgb4/ch_ktls: Clear resources when pf4 device is removed")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Reviewed-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index bcdc7fc2f4276..649d05b3fea72 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -390,7 +390,7 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 		cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 				 tx_info->tid, tx_info->ip_family);
 
-		xa_erase(&u_ctx->tid_list, tx_info->tid);
+		xa_erase_bh(&u_ctx->tid_list, tx_info->tid);
 	}
 
 	port_stats = &tx_info->adap->ch_ktls_stats.ktls_port[tx_info->port_id];
@@ -581,7 +581,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 			 tx_info->tid, tx_info->ip_family);
 
-	xa_erase(&u_ctx->tid_list, tx_info->tid);
+	xa_erase_bh(&u_ctx->tid_list, tx_info->tid);
 
 put_module:
 	/* release module refcount */
-- 
2.53.0



