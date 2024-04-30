Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F77317592;
	Tue, 30 Apr 2024 11:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476432; cv=none; b=gtQmo3i/IGFy2hejMxSZyVBKvFlEHebT6uD30loKO8BrjbDdpny7gcV4uwEzynehloySFv0S6OWNMjERw0QMAuhBxGBmOi/KedWR2R9MgZkLGxoqgCSdMqdI9MRTBDQdPU4VjstqPG0/uGeiiMWZKRRi3jUyF5CmzwnbseiTq6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476432; c=relaxed/simple;
	bh=ntpSzpZKu82fmNVeMkLF7nt0dvdDJM443KAGlDQjqNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdeYircAEUZeyoyugpVxN8SZWC6o4owizqCFshlbftuYamOWYdzaG3Ay5CsAi2hhZi7wlE/MECsVYLXLQ5L0VfuPTKgqXKmil3AlNFcY+l+jBEy7A8Del5YwK/41ya1nadqNyzjYiv4hN2Bu5QOaLNucq1tlyfoae4mtX0l2ZIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxZoHKT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxZoHKT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8518BC4AF1A;
	Tue, 30 Apr 2024 11:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476432;
	bh=ntpSzpZKu82fmNVeMkLF7nt0dvdDJM443KAGlDQjqNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IxZoHKT4iEbtLbh1ciUsFCm+IPNlWkglqSYwuVLDF4iZB6aIYj99f7g6ad67Qz5W6
	 M/xOQdDqAkSD63iu7s+Ti5N09UbiHqfRZ56s0KZypLqJWO99RsDAPQm8v9Inzokwha
	 AzvMOGrgE23rpza40B7V8iEKY5snmRvpVxGbJ9kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/110] bnxt_en: refactor reset close code
Date: Tue, 30 Apr 2024 12:39:59 +0200
Message-ID: <20240430103048.458751219@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit 7474b1c82be3780692d537d331f9aa7fc1e5a368 ]

Introduce bnxt_fw_fatal_close() API which can be used
to stop data path and disable device when firmware
is in fatal state.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a1acdc226bae ("bnxt_en: Fix the PCI-AER routines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0d0aad7141c15..e889017e3a7fb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11812,6 +11812,16 @@ static void bnxt_rx_ring_reset(struct bnxt *bp)
 	bnxt_rtnl_unlock_sp(bp);
 }
 
+static void bnxt_fw_fatal_close(struct bnxt *bp)
+{
+	bnxt_tx_disable(bp);
+	bnxt_disable_napi(bp);
+	bnxt_disable_int_sync(bp);
+	bnxt_free_irq(bp);
+	bnxt_clear_int_mode(bp);
+	pci_disable_device(bp->pdev);
+}
+
 static void bnxt_fw_reset_close(struct bnxt *bp)
 {
 	bnxt_ulp_stop(bp);
@@ -11825,12 +11835,7 @@ static void bnxt_fw_reset_close(struct bnxt *bp)
 		pci_read_config_word(bp->pdev, PCI_SUBSYSTEM_ID, &val);
 		if (val == 0xffff)
 			bp->fw_reset_min_dsecs = 0;
-		bnxt_tx_disable(bp);
-		bnxt_disable_napi(bp);
-		bnxt_disable_int_sync(bp);
-		bnxt_free_irq(bp);
-		bnxt_clear_int_mode(bp);
-		pci_disable_device(bp->pdev);
+		bnxt_fw_fatal_close(bp);
 	}
 	__bnxt_close_nic(bp, true, false);
 	bnxt_vf_reps_free(bp);
-- 
2.43.0



