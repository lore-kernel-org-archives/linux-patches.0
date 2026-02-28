Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4F839B959
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302570; cv=none; b=rMlvwsDIEiFvasL/VeXl8SB6kmqy15FGhksO2n4SnfVXb9kcT/jC7+0LoTc2Y5ZWJAgu6Mix+oBl4goQaY8SYJ09bFmef5hJ0xZWU5x/NO9s1LcdxvuX4rUbPfyzMFIw1IBqhM7ABQOIfqLDuSyEe0FaYv4lv9fh+goKImUuQV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302570; c=relaxed/simple;
	bh=/tLS5yl/av74YS5VI548bF5np6xk3+/IsqNga1XYK2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pd1pwvt16EgTgZQsVbjJmfLMof5rA4VISIKVQ0Xyjn/vru5C24+gcHrbTBaquLMIYv6+OUQT1UdFyqyrNo5jSJ8ZJb9kvkTX2gJjai0u0rSPsd8I8y2BDMQoL07fU2Ipx1h9Eo+GBNVmEjmR05NquZOzpKzCEtaMyVnpmHFwtEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6XqcYKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6XqcYKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC90C116D0;
	Sat, 28 Feb 2026 18:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302570;
	bh=/tLS5yl/av74YS5VI548bF5np6xk3+/IsqNga1XYK2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6XqcYKjPtz/LCrMH3o4G5MBWnrdc8FWsP00AdkOSLk/fi0LKehFT+f3NR0XVD3Y9
	 AQCzHCOI+E0aMYrAcAz+6v4AlYUKmpPSeJe3GGBycG/ZGDd9Uollnv3oXyBdRQPxyq
	 A/DfOMSXHA6/rKRHbzO9UoeILZNYe9rSPuPMWONV7+mnsG5EGGBOwlHxIYH+0gkJJA
	 l8PjPp8KGz5m0kuSThjo4b7pmAHJf8Wd+T6wDET6j5vRexsPWi6+vgMgpR5U+p7OC/
	 rVNnA8NisuUaeJKBarzRt0WWCUWXkZQzYzPR48ECtnPIB3HLMD249iL8WJZrnDNzdp
	 6odMy4dMajFRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Votokina Victoria <Victoria.Votokina@kaspersky.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/164] nfc: hci: shdlc: Stop timers and work before freeing context
Date: Sat, 28 Feb 2026 13:13:36 -0500
Message-ID: <20260228181505.1600663-77-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Votokina Victoria <Victoria.Votokina@kaspersky.com>

[ Upstream commit c9efde1e537baed7648a94022b43836a348a074f ]

llc_shdlc_deinit() purges SHDLC skb queues and frees the llc_shdlc
structure while its timers and state machine work may still be active.

Timer callbacks can schedule sm_work, and sm_work accesses SHDLC state
and the skb queues. If teardown happens in parallel with a queued/running
work item, it can lead to UAF and other shutdown races.

Stop all SHDLC timers and cancel sm_work synchronously before purging the
queues and freeing the context.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4a61cd6687fc ("NFC: Add an shdlc llc module to llc core")
Signed-off-by: Votokina Victoria <Victoria.Votokina@kaspersky.com>
Link: https://patch.msgid.link/20260203113158.2008723-1-Victoria.Votokina@kaspersky.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/hci/llc_shdlc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/nfc/hci/llc_shdlc.c b/net/nfc/hci/llc_shdlc.c
index aef750d7787c8..948cf4d210bde 100644
--- a/net/nfc/hci/llc_shdlc.c
+++ b/net/nfc/hci/llc_shdlc.c
@@ -779,6 +779,14 @@ static void llc_shdlc_deinit(struct nfc_llc *llc)
 {
 	struct llc_shdlc *shdlc = nfc_llc_get_data(llc);
 
+	timer_shutdown_sync(&shdlc->connect_timer);
+	timer_shutdown_sync(&shdlc->t1_timer);
+	timer_shutdown_sync(&shdlc->t2_timer);
+	shdlc->t1_active = false;
+	shdlc->t2_active = false;
+
+	cancel_work_sync(&shdlc->sm_work);
+
 	skb_queue_purge(&shdlc->rcv_q);
 	skb_queue_purge(&shdlc->send_q);
 	skb_queue_purge(&shdlc->ack_pending_q);
-- 
2.51.0

