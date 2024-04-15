Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BB98289B;
	Mon, 15 Apr 2024 14:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191652; cv=none; b=lNJHid2Tux78kwnkdmKa5IFpRrQw1Alzdjv6lyXn58ykxkbHxYGrxEYdXV3KwOk1tyiJucGDluu/AOrrZmv+vR3Za6kg6HwhkFtq4jwzJWcJTbUox89r7NOluLDqadwQ12xaK8I2BGtcygNCrSvgzeXmU8aYc+EvxN+wPZBVrWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191652; c=relaxed/simple;
	bh=BWE1kzF+lBndbedPA1nhoLB0ttz2t/qtPEeZ80SlEFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOFDIgsLZXWIL88KMWjfQdh8pBpTeMaJ+A0z0PRDf57s8SsjwUYj7Hq5ak7/oE1Nhds46bNMDpwDFjq6lDOhOPDzgfQbx3CML0+eoobitWn9KLH3tAHgCp/zufwwe6+nBQhIeXzX7wSiT5XrI9Z4Hd0Nfv9w5eN+VBdk+ZVO+1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vI73/IIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vI73/IIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8B3C113CC;
	Mon, 15 Apr 2024 14:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191652;
	bh=BWE1kzF+lBndbedPA1nhoLB0ttz2t/qtPEeZ80SlEFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vI73/IIfztV1KHp8WMwmxAEZ3UJy9hE4ucdcQMT5OXDI1AU/srRRAClQLzRF34Ewg
	 FhC7k/Ckz0dy7FHdlo5rGrVQSU4jAsSaOMeE6i/kH0LvR3vF34BgEkT3avKXiqh9VT
	 K99PcK2BEUIjKDJCzoLjzIUsJTMDeHb2lZJjoAAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/122] bnxt_en: Reset PTP tx_avail after possible firmware reset
Date: Mon, 15 Apr 2024 16:20:05 +0200
Message-ID: <20240415141954.570645670@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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
index dac4f9510c173..38e3b2225ff1c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10549,6 +10549,8 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
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



