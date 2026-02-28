Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66089333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301810; cv=none; b=S/JRXTb0HpYBhqp/qWF/s+Fmti+VIHy0e2+MbRvvBNdn81r4gGxowH6xGFRN0IhsMihmdhxyaIz07zmXGUh2HAhINk4s9o9MySZWeQtMiORRi+rQ/KI/JwG+m5yv8hrjoF8nTK6I5EZMLOXcayx8q/Um9TRemBBlSEmd8DpYtTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301810; c=relaxed/simple;
	bh=2ND13i84SypvNRbZZrQfr+MlM4RAq7zcw70kQ34VkYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETSoZsWXHp8iisk4qer3cG14PsLRc1N9bE6hspQfSL9+tptSlLLcwbLSJ/Dv9i2UTqzdbNxwSLt9oIzEOJjjxN1d0Oe5520oJXLrDLE/PYwhZY6mlari27FH9B6CmRsKAyeChAccytXVDRiqcSHiTj83mHjJTDDipXj/Kd3OnkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rHtVqo5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rHtVqo5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98FCC19425;
	Sat, 28 Feb 2026 18:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301810;
	bh=2ND13i84SypvNRbZZrQfr+MlM4RAq7zcw70kQ34VkYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHtVqo5sCEkn4K0sVbr90ZKWRExra4qIeF4lSMLIwJ44O4m1cgUo/Efk8UZG38DkN
	 yyeHAgbC6/3k1VRNHweSUfwWemyhavUO8+IoeqeYH1dsZPgH52bw/33ir3sEZluCQ+
	 hSECDHRchHXk581fC+Jz6/c1QZFUICftPVDHxYQiJaql+n/7xlDPJeT373HUut3pu6
	 oPYfkDFx3oqXGh5k3HiUzLRgihSsEl3qgvH4HnKbMy67lZaG7coVfr5Qv0x4Tmx3yA
	 n2+eJwtTJLrObGQuteRdD/x3iuANl+Os6rvYcmXVCyawdY/RX085wwMN+kxwv8ZtY8
	 dbBAMRuP99MiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Votokina Victoria <Victoria.Votokina@kaspersky.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 223/385] nfc: hci: shdlc: Stop timers and work before freeing context
Date: Sat, 28 Feb 2026 12:57:25 -0500
Message-ID: <20260228180011.1568201-223-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index e90f70385813a..a106f4352356d 100644
--- a/net/nfc/hci/llc_shdlc.c
+++ b/net/nfc/hci/llc_shdlc.c
@@ -762,6 +762,14 @@ static void llc_shdlc_deinit(struct nfc_llc *llc)
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

