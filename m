Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9F33F485E;
	Tue, 13 Oct 2026 12:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895986; cv=none; b=UK9IHZgfJsFaS6Wj0bjqSH2uJqWh6v5ctF5emLKPYCEmMFz18ImZip5UaW/fHPTEJNNjwqpegY7OGTB0UvFFNJ/M+8CjykQpm0jqbQ10J8/cixXpSz1JlYPKds7xYpXpTOleFRbNSmzCYSmdLSCh23yUWANHv9cgapbEbe1obVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895986; c=relaxed/simple;
	bh=RDTQF4w8Qff90EVd8Ro33EBVjZXtM5tIzf5hlgNqB1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMbCg37jTEznsySapsglQ+Fw0wo3d2PJR482oOdP3ndT3zC3eCzHPvqoSft9rwWEQtg9T6BmMcfJVTToZadOxffji/Njv/FxIK648r1NMlFd7wTYaC9XQ6nkrWuZxSA6mKzkix5l2xuhixXPXO5g0arR0bH0NfEZCND9hrddNmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mN1jV8nJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mN1jV8nJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAC71F000FF;
	Tue, 13 Oct 2026 12:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895985;
	bh=vYFv2JBSEc93m1SZUKM0e5oXmbTfzMrZ6xizjbnNfgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mN1jV8nJkbFrGaxvAMAFdplbBM7XUN6KxoeQ6MpH3RcU6SR5QRH3w1s1YUo6I8TMA
	 vldfL4YYFcG7t926TMJsn9gQjPL+tHdRYZRQ/eBcC4mXfM6Ix0JmPz9FMCKbPDVFDu
	 Yb6c4V26uLuG8fh3rm3sf+r9C6GATaYQJFog/zBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 457/497] cxgb4/ch_ktls: disable softirqs around tid_list erases
Date: Tue, 13 Oct 2026 13:40:24 +0200
Message-ID: <20261013112918.727890204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index e8e460a92e0e4..9c63126ca2e71 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -389,7 +389,7 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 		cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 				 tx_info->tid, tx_info->ip_family);
 
-		xa_erase(&u_ctx->tid_list, tx_info->tid);
+		xa_erase_bh(&u_ctx->tid_list, tx_info->tid);
 	}
 
 	port_stats = &tx_info->adap->ch_ktls_stats.ktls_port[tx_info->port_id];
@@ -577,7 +577,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 			 tx_info->tid, tx_info->ip_family);
 
-	xa_erase(&u_ctx->tid_list, tx_info->tid);
+	xa_erase_bh(&u_ctx->tid_list, tx_info->tid);
 
 put_module:
 	/* release module refcount */
-- 
2.53.0



