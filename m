Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79041292C8;
	Tue, 30 Apr 2024 10:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474127; cv=none; b=WtUZAil1Lv68pkfainTx0tnRHYmzcXoA/J7skYW7VcEVyZRlIR3ot5usMd7AwjMLkBRwigLFGMoQ0bHaqx5zNFeHXIv+kCDhhMbUzP3eLkuSXlBWMwxtOCF13ntjd5NCYiPUv9D0Jb/wOnOul0z4e4v0RZv7o+x+vRoMbg4h2s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474127; c=relaxed/simple;
	bh=CsriC+bCgyf+fEtUaR779fxRac7ZForcrd/tkpe4yvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FX+KsPLMVs9loC+J42wqeBvesHbKb9sqKIjBvbEz4luQfxKQc+1Pu6R6KebLYK/nXrM5G2vwASFCuJGdRN9wGAkocSZVlxn4HXNne0570nuiGUw6AtESKZjSvf2MhAbEiP8zHtA2zbZ+UbbrhLZWLXY0xbd1AoKghLrqThu+NJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uk/owx2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uk/owx2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007ADC2BBFC;
	Tue, 30 Apr 2024 10:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474127;
	bh=CsriC+bCgyf+fEtUaR779fxRac7ZForcrd/tkpe4yvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uk/owx2w3CXjqmVVWo84N+4QuftpreG/7Vito9MK3eGDGWGEGL6e/rsGtMviif1H7
	 8R5CZFTZ50ymFf8zU2qNPSfLooblBPSt5saeqQaJYhbsDw2289mfiPpqPPyDD7JGKh
	 MRjODvJHOtUQYvZXcE3bPBYPZSXhZBQheuLyQeAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 057/228] bnxt_en: refactor reset close code
Date: Tue, 30 Apr 2024 12:37:15 +0200
Message-ID: <20240430103105.454745732@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 5e6e32d708e24..260ffd71e2a89 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12776,6 +12776,16 @@ static void bnxt_rx_ring_reset(struct bnxt *bp)
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
@@ -12789,12 +12799,7 @@ static void bnxt_fw_reset_close(struct bnxt *bp)
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



