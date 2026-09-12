Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92264BEE2A;
	Sat, 12 Sep 2026 10:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209096; cv=none; b=ZtVhGnjcVEjVxgmT0UhHmK/wQMLMnMV4khHdHW2k1jGOSO5T8KsD7gsul7XKnpWd31VU3uMBuI/5FJwLd4qHOFT+mdAMEMOn+XYM7HqQDXVpJQIdlDZtVHituq1uetykP3YgsJXoGYY9p8u4lPEIyigKxGUKREzwfa1NW+D0W5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209096; c=relaxed/simple;
	bh=6iLlKBdKkiVgrtEtE6dKTakbs0sbTKe6WAOyQk3j1ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A83/Jci3Cll3dtM7HNOTVjegPX5fOOV3mdvfsY1uJ7WZhGIkxVyJN4V+yG2qBuJJkW1X36zJ1Wu0nRVsSnDnjtx1eB5Y6PMghuAqMZhkTKO5McnLcYEJKYS99D8wPPVDvMC6VDG3Yk9TtDxFfgs9JhcmSbnuX6HndN6XtSFP/7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3vz56el; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3vz56el"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5121F00898;
	Sat, 12 Sep 2026 10:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209094;
	bh=9484CAs+0PzPeaTfHwIzYgHQWQ6ewfo0PrxqU0EFDY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3vz56elWeFGXb9Q/iiiA6SOiEll1i++QzyXdI73uKDO0d6HxxqC1b2qQN51Jf7p6
	 KXymc4KcKeolZueU/sheWFPgTxw+jNXUtp/1QQlCZPRxBhxycMK3ArNMLeufC3yBaA
	 5beEdu26dUnsf+ctq9HIh6wJlIIM5VQ83m804Rlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0752/1518] wifi: mt76: fix uninitialised RXDMAD_C descriptor info
Date: Sat, 12 Sep 2026 08:48:41 +0200
Message-ID: <20260912065640.441954118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d3ecac68f73b11828e72eaf7952a9beb5caea12b ]

Unlike other WED-RRO queues, RXDMAD_C frames continue into the skb build
path, but mt76_dma_get_buf() skips the desc->info read for RRO queues, so
the uninitialised on-stack info was stored into skb->cb and passed to
rx_skb(); initialise it to zero.

Fixes: e50d4d710efd ("wifi: mt76: Add mt76_dma_get_rxdmad_c_buf utility routione")
Link: https://patch.msgid.link/20260722082610.2699628-16-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 0ba93290b00d3..3fcd0c46ecd94 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -988,7 +988,7 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 
 	while (done < budget) {
 		bool drop = false;
-		u32 info;
+		u32 info = 0;
 
 		if (check_ddone) {
 			if (q->tail == dma_idx)
-- 
2.53.0



