Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1944156C6;
	Tue, 13 Oct 2026 12:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894384; cv=none; b=pPPmZ1c2jhPfYTIr/5+585DzNBOIS0CW7tFUVMRFgOLySXnP3qKknsRJ5QskLnXk8MjgBxZ+v8VVJon5Wiqminwg16q7oF+d6HWTIkjic9Lj7s4UN1h82LkxomocRYEz9mgnS3KjMspMaBAxCClq5YhMW+q6vIxdCgh9oIFoXkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894384; c=relaxed/simple;
	bh=F5rLTb6a1hbVnDq1TkAmrxhbF1bpZ9uBS/+qV9t/324=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8gQb3lE/a9vhOIqBl0uu6JER3DbHGLcKOKN53n7G371M6teMiNUF/1iZgJY8jq3HT9GMZTOvNBfo00r+se3/vYZcxsJChySX997PkqQUbRiTz+zD+C2TNUca+2Q4KCKnQVhp6hlKMTx0FF90ClTZacl+MDKzajNrDhCIYO2p88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iP3fOBX4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iP3fOBX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C871F00898;
	Tue, 13 Oct 2026 12:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894382;
	bh=WsRtDrr85vCZ81t9mOho7zpGdPUKHAY7aXdP/l25gQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iP3fOBX4SLH8Nubd4SDRCaqWSicOBNc/NYrJvTX3A99FygFUQlADbBOrLXZLGSD/p
	 8LXHTI1iTXY3CZwjV9gEA2nxLceG3AaESOgvbSUe9j50WNjETg255Ou6sBPvqUNe/F
	 vt6RgQOqNsGQ+d7DbHnglpllRCZvTAFpKY2DRKT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 543/621] cxgb4/ch_ktls: disable softirqs around tid_list erases
Date: Tue, 13 Oct 2026 13:38:58 +0200
Message-ID: <20261013112933.705112038@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 4e2096e496844..4da7695db89ba 100644
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



