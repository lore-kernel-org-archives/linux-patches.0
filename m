Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0491D153836;
	Fri,  6 Dec 2024 15:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497925; cv=none; b=p+ae0XDsByW4DjtqPGGaDpFxn0yBNtaBDVQsxbOuBNQMp+uhVd/4wZiYe2J4tqZf6w2BX7AyMM/jLFiZ8pkFeTHqRl4u9BbiOfErE3Lc9xQYerEJa1LPPO+Izol91JVmKDjSf4O0QZZM92CbS/I4c+8rs37SFgoLZXEjkVLLZMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497925; c=relaxed/simple;
	bh=RP9dilAXecx/BLdZPQW62sCiRhODFK1o8cDshhyfSI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwTYH1Tuh0toV5oUS584O0NL5zCjuN2nPdGrGiIf2l8aIlHAR0MSlWVtzf4V4LcrRuXBQdWmTeAciD7Q6+VSljA+jYTwyqoUmExVRyy/ZRuYRegz7uKvOQWoqpMFChhvmakHCItsZaRe1Ttj1SMsBnC1kcu7sB8QlCBhE4DJryI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dllDYQVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dllDYQVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123E2C4CED1;
	Fri,  6 Dec 2024 15:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497924;
	bh=RP9dilAXecx/BLdZPQW62sCiRhODFK1o8cDshhyfSI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dllDYQVGdMrPoQIUocGS4PtCMTxMQ31JiwqKvIP+0E/DSgroST45qG/+sZ31xQs28
	 /9VbUuwNLxV3PavtqxYanz23+Yz1Imp2oaHTYfbxzF65gFqqv8kJpQ7BcaR2/1x1oG
	 72SyaAxgvThpjCLMXu6Pm17RPsRa9Odj5hZkmeTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 416/676] bnxt_en: Reserve rings after PCIe AER recovery if NIC interface is down
Date: Fri,  6 Dec 2024 15:33:55 +0100
Message-ID: <20241206143709.598685005@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravanan Vajravel <saravanan.vajravel@broadcom.com>

[ Upstream commit 5311598f7f3293683cdc761df71ae3469327332c ]

After successful PCIe AER recovery, FW will reset all resource
reservations.  If it is IF_UP, the driver will call bnxt_open() and
all resources will be reserved again.  It it is IF_DOWN, we should
call bnxt_reserve_rings() so that we can reserve resources including
RoCE resources to allow RoCE to resume after AER.  Without this
patch, RoCE fails to resume in this IF_DOWN scenario.

Later, if it becomes IF_UP, bnxt_open() will see that resources have
been reserved and will not reserve again.

Fixes: fb1e6e562b37 ("bnxt_en: Fix AER recovery.")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 58a7bb75506a3..bc6206543e8e9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -14102,8 +14102,12 @@ static void bnxt_io_resume(struct pci_dev *pdev)
 	rtnl_lock();
 
 	err = bnxt_hwrm_func_qcaps(bp);
-	if (!err && netif_running(netdev))
-		err = bnxt_open(netdev);
+	if (!err) {
+		if (netif_running(netdev))
+			err = bnxt_open(netdev);
+		else
+			err = bnxt_reserve_rings(bp, true);
+	}
 
 	bnxt_ulp_start(bp, err);
 	if (!err) {
-- 
2.43.0



