Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7250120F5AF;
	Tue, 12 Nov 2024 10:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408327; cv=none; b=RuAUE7uyqY5Ig2PhhwrUloqMHm9s8U+55p8/N/Ps4q9ouEU/SjQl/29HE3RESQhgT4pAvx0Rkq3mUCzTewlpOon9X/ZQY9MAJtuALAo75OORJ0I3oQjM509YYO4mCIdKBBnwBES64UKcOm6nnBdtd51TH26Dcc4y7soqnjuspbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408327; c=relaxed/simple;
	bh=m6fxlWHYizo5nwFoO4U29SmHcBAtcoK9ZxvhPzBMAjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQRK62wSiKjaFcVeD8edU+m4RSGC4AWqXA25Yar4E5TeIRtmcJga6P7kvhBj+l7MbmVag0a3i5GUDDyUbgoNiTxHIX4Av3QUQC5k30Dt9gp++mD74AlIgEpqEYOIeAMqp4/ZBBLM8IHbIGLRGzFoh877zlM7O7rAr2tHF4Ip5mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVrN5GNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVrN5GNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDC2C4CECD;
	Tue, 12 Nov 2024 10:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408327;
	bh=m6fxlWHYizo5nwFoO4U29SmHcBAtcoK9ZxvhPzBMAjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVrN5GNSCNDJwkDua5FpkLzN/WNkkxBnh9aIFpXo008wND9sFVJeuh7n1bcNCyvTr
	 K6Tv5MyyleHj1a2zjA+U10Z832Yjq9bEqxOTh/mkz5NlgDYb3A3Hr13xnVZjuIda5L
	 Z6zolLx5GINNRppUGmBDwM3fNXjifqhd6qQ7i6Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 127/184] net: vertexcom: mse102x: Fix possible double free of TX skb
Date: Tue, 12 Nov 2024 11:21:25 +0100
Message-ID: <20241112101905.740564168@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

commit 1f26339b2ed63d1e8e18a18674fb73a392f3660e upstream.

The scope of the TX skb is wider than just mse102x_tx_frame_spi(),
so in case the TX skb room needs to be expanded, we should free the
the temporary skb instead of the original skb. Otherwise the original
TX skb pointer would be freed again in mse102x_tx_work(), which leads
to crashes:

  Internal error: Oops: 0000000096000004 [#2] PREEMPT SMP
  CPU: 0 PID: 712 Comm: kworker/0:1 Tainted: G      D            6.6.23
  Hardware name: chargebyte Charge SOM DC-ONE (DT)
  Workqueue: events mse102x_tx_work [mse102x]
  pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : skb_release_data+0xb8/0x1d8
  lr : skb_release_data+0x1ac/0x1d8
  sp : ffff8000819a3cc0
  x29: ffff8000819a3cc0 x28: ffff0000046daa60 x27: ffff0000057f2dc0
  x26: ffff000005386c00 x25: 0000000000000002 x24: 00000000ffffffff
  x23: 0000000000000000 x22: 0000000000000001 x21: ffff0000057f2e50
  x20: 0000000000000006 x19: 0000000000000000 x18: ffff00003fdacfcc
  x17: e69ad452d0c49def x16: 84a005feff870102 x15: 0000000000000000
  x14: 000000000000024a x13: 0000000000000002 x12: 0000000000000000
  x11: 0000000000000400 x10: 0000000000000930 x9 : ffff00003fd913e8
  x8 : fffffc00001bc008
  x7 : 0000000000000000 x6 : 0000000000000008
  x5 : ffff00003fd91340 x4 : 0000000000000000 x3 : 0000000000000009
  x2 : 00000000fffffffe x1 : 0000000000000000 x0 : 0000000000000000
  Call trace:
   skb_release_data+0xb8/0x1d8
   kfree_skb_reason+0x48/0xb0
   mse102x_tx_work+0x164/0x35c [mse102x]
   process_one_work+0x138/0x260
   worker_thread+0x32c/0x438
   kthread+0x118/0x11c
   ret_from_fork+0x10/0x20
  Code: aa1303e0 97fffab6 72001c1f 54000141 (f9400660)

Cc: stable@vger.kernel.org
Fixes: 2f207cbf0dd4 ("net: vertexcom: Add MSE102x SPI support")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://patch.msgid.link/20241105163101.33216-1-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/vertexcom/mse102x.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -222,7 +222,7 @@ static int mse102x_tx_frame_spi(struct m
 	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
 	struct spi_transfer *xfer = &mses->spi_xfer;
 	struct spi_message *msg = &mses->spi_msg;
-	struct sk_buff *tskb;
+	struct sk_buff *tskb = NULL;
 	int ret;
 
 	netif_dbg(mse, tx_queued, mse->ndev, "%s: skb %p, %d@%p\n",
@@ -235,7 +235,6 @@ static int mse102x_tx_frame_spi(struct m
 		if (!tskb)
 			return -ENOMEM;
 
-		dev_kfree_skb(txp);
 		txp = tskb;
 	}
 
@@ -257,6 +256,8 @@ static int mse102x_tx_frame_spi(struct m
 		mse->stats.xfer_err++;
 	}
 
+	dev_kfree_skb(tskb);
+
 	return ret;
 }
 


