Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16F97E785;
	Mon, 15 Apr 2024 14:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191276; cv=none; b=TWE4hcKap6bBqO2gWx6j96AB/cGYiCd17WnNv5r9QxT1cBYLtI0T2ldqk2B6NbCIX12eVOxv3FjESE0POadXZBuVBqhXk8M4ksgCu9RaiQOhUauS/7gj7BUUYksAmvSyx+jmKF/zjfRr8olG4ObY6obGlXKg0WGtfTZ9CO6/7V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191276; c=relaxed/simple;
	bh=jkor9aPgHXElctM4toAgIVbUJvCMtZ3uMduIgeMBG/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7HGvishxQQUrAgKz6gQrFBiG+QwjZEC+JVRyWSQgz5AyGIQqxKfPHylEWG5MV961mAz8L+jxNY9caYJeRSrhxHNaIibifKvwCrtG7VbL7Tnl4+5zi3rFdxXc6Xb7PL7ZSpQKm08le3fE6J66aP3LRGo0V+Pdo/ukxJ755gLeQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0T25Jte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0T25Jte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0868CC113CC;
	Mon, 15 Apr 2024 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191276;
	bh=jkor9aPgHXElctM4toAgIVbUJvCMtZ3uMduIgeMBG/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0T25JtecJPiYINJpnsexLSLrsRBu3AeWNeKmTEgTmwKTg+5woPuehCZPupkHkJo9
	 Ifv2nLBCECV9rmi17BA4NTsQAGIfBSL0tlho5j0z7MM61BrlLqwC8atpd84Ui0cob9
	 uMuCAj0H7Scu5OeP6AFgnZNWLhO2KrqqPtwrHWpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 053/172] bnxt_en: Reset PTP tx_avail after possible firmware reset
Date: Mon, 15 Apr 2024 16:19:12 +0200
Message-ID: <20240415142002.025097257@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit faa12ca245585379d612736a4b5e98e88481ea59 ]

It is possible that during error recovery and firmware reset,
there is a pending TX PTP packet waiting for the timestamp.
We need to reset this condition so that after recovery, the
tx_avail count for PTP is reset back to the initial value.
Otherwise, we may not accept any PTP TX timestamps after
recovery.

Fixes: 118612d519d8 ("bnxt_en: Add PTP clock APIs, ioctls, and ethtool methods")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 39845d556bafc..5e6e32d708e24 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11526,6 +11526,8 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	/* VF-reps may need to be re-opened after the PF is re-opened */
 	if (BNXT_PF(bp))
 		bnxt_vf_reps_open(bp);
+	if (bp->ptp_cfg)
+		atomic_set(&bp->ptp_cfg->tx_avail, BNXT_MAX_TX_TS);
 	bnxt_ptp_init_rtc(bp, true);
 	bnxt_ptp_cfg_tstamp_filters(bp);
 	return 0;
-- 
2.43.0



