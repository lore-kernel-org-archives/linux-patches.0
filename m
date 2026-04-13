Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8512BEC3F;
	Mon, 13 Apr 2026 16:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098681; cv=none; b=HHaDYW06dnxG0u4fwJjuh5FTaeCWjHJXtK4aB/7CBtFaBZCfxbPU7ppX/f3hp26CFSNDD5IWirlA4bg57y86GrcZTLHhnuwIhqvuP3+KPCN+DjxTyL9++fnQtPkK0hMBk4pyqurmW7AhntnjgEjxw0Ru/CRLAt1pvV2YgatvSK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098681; c=relaxed/simple;
	bh=MvgQ9Kzu2VJh6XFR4GC7VkTRVvPM1G5xFhfFSY7Nmw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXj1EKp8yXA/JoNP89kShPERY+OGmS8i+tb+i+THkp0zkBrfEYC5RhNJst3iXO48UFojlfGT+pLorypDwOnTKPd8mKmkGx6GPM1L19MpIVI85Om5o12H+KF+7oKIEXFsnPlB9qy2K+gRdN66Yis86kfW7oOnNf74pXl4BSUrGhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdfbsdBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdfbsdBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2174C2BCAF;
	Mon, 13 Apr 2026 16:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098681;
	bh=MvgQ9Kzu2VJh6XFR4GC7VkTRVvPM1G5xFhfFSY7Nmw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdfbsdBY734cgHlKtuugRYDWDC1lxLJHitpxx0iztB0JZKW7ZebR90mWdkrVBBtc/
	 kmSC5gyhlwbUi0aazfh9YL265TRlQyDcyuW4egLcsbLJz1/DJiY7loCSSpGh5OSnk2
	 M+j/uBAiTdC7O6R+A6Tjt9oZcuU08kOiC1BX3VEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/491] nfc: nci: clear NCI_DATA_EXCHANGE before calling completion callback
Date: Mon, 13 Apr 2026 17:54:53 +0200
Message-ID: <20260413155820.850853362@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0efdc02f4f6d52f8ca5d5889560f325a836ce0a8 ]

Move clear_bit(NCI_DATA_EXCHANGE) before invoking the data exchange
callback in nci_data_exchange_complete().

The callback (e.g. rawsock_data_exchange_complete) may immediately
schedule another data exchange via schedule_work(tx_work).  On a
multi-CPU system, tx_work can run and reach nci_transceive() before
the current nci_data_exchange_complete() clears the flag, causing
test_and_set_bit(NCI_DATA_EXCHANGE) to return -EBUSY and the new
transfer to fail.

This causes intermittent flakes in nci/nci_dev in NIPA:

  # #  RUN           NCI.NCI1_0.t4t_tag_read ...
  # # t4t_tag_read: Test terminated by timeout
  # #          FAIL  NCI.NCI1_0.t4t_tag_read
  # not ok 3 NCI.NCI1_0.t4t_tag_read

Fixes: 38f04c6b1b68 ("NFC: protect nci_data_exchange transactions")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260303162346.2071888-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/data.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index b4548d8874899..4f06a2903ae75 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -33,7 +33,8 @@ void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 	conn_info = nci_get_conn_info_by_conn_id(ndev, conn_id);
 	if (!conn_info) {
 		kfree_skb(skb);
-		goto exit;
+		clear_bit(NCI_DATA_EXCHANGE, &ndev->flags);
+		return;
 	}
 
 	cb = conn_info->data_exchange_cb;
@@ -45,6 +46,12 @@ void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 	del_timer_sync(&ndev->data_timer);
 	clear_bit(NCI_DATA_EXCHANGE_TO, &ndev->flags);
 
+	/* Mark the exchange as done before calling the callback.
+	 * The callback (e.g. rawsock_data_exchange_complete) may
+	 * want to immediately queue another data exchange.
+	 */
+	clear_bit(NCI_DATA_EXCHANGE, &ndev->flags);
+
 	if (cb) {
 		/* forward skb to nfc core */
 		cb(cb_context, skb, err);
@@ -54,9 +61,6 @@ void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 		/* no waiting callback, free skb */
 		kfree_skb(skb);
 	}
-
-exit:
-	clear_bit(NCI_DATA_EXCHANGE, &ndev->flags);
 }
 
 /* ----------------- NCI TX Data ----------------- */
-- 
2.51.0



