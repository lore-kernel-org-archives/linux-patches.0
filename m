Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC7518B00
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avuYYWWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D71C433C8;
	Mon,  9 Oct 2023 13:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856904;
	bh=Hden6CgiCaO+jFBUv3UltTHq8BRRwjEiSMs2wAFqDzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avuYYWWDtWbXnwuGthR/Mp0wONbZRG4umAaPAq/kLKO2+b6WvhE+SFmdiRNZ3o9nm
	 bHVQSE30qKyAyKhfGsanBUAEuwH7SLAnVkNgNLRUXNTj6puUPbBLyPls0F4+JRD1IS
	 5eHg9doygHC14k4iQbYspp6d5+Xfnzn+CfLvJSG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.5 029/163] net: mana: Fix TX CQE error handling
Date: Mon,  9 Oct 2023 14:59:53 +0200
Message-ID: <20231009130124.809346249@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

commit b2b000069a4c307b09548dc2243f31f3ca0eac9c upstream.

For an unknown TX CQE error type (probably from a newer hardware),
still free the SKB, update the queue tail, etc., otherwise the
accounting will be wrong.

Also, TX errors can be triggered by injecting corrupted packets, so
replace the WARN_ONCE to ratelimited error logging.

Cc: stable@vger.kernel.org
Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1315,19 +1315,23 @@ static void mana_poll_tx_cq(struct mana_
 		case CQE_TX_VPORT_IDX_OUT_OF_RANGE:
 		case CQE_TX_VPORT_DISABLED:
 		case CQE_TX_VLAN_TAGGING_VIOLATION:
-			WARN_ONCE(1, "TX: CQE error %d: ignored.\n",
-				  cqe_oob->cqe_hdr.cqe_type);
+			if (net_ratelimit())
+				netdev_err(ndev, "TX: CQE error %d\n",
+					   cqe_oob->cqe_hdr.cqe_type);
+
 			apc->eth_stats.tx_cqe_err++;
 			break;
 
 		default:
-			/* If the CQE type is unexpected, log an error, assert,
-			 * and go through the error path.
+			/* If the CQE type is unknown, log an error,
+			 * and still free the SKB, update tail, etc.
 			 */
-			WARN_ONCE(1, "TX: Unexpected CQE type %d: HW BUG?\n",
-				  cqe_oob->cqe_hdr.cqe_type);
+			if (net_ratelimit())
+				netdev_err(ndev, "TX: unknown CQE type %d\n",
+					   cqe_oob->cqe_hdr.cqe_type);
+
 			apc->eth_stats.tx_cqe_unknown_type++;
-			return;
+			break;
 		}
 
 		if (WARN_ON_ONCE(txq->gdma_txq_id != completions[i].wq_num))


