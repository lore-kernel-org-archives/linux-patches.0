Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFB336C9F9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302386; cv=none; b=FBO+CssDHdPrKFh6mh9iLG7sR3p1PnpOqrQZ0SKXWKGBAZ3X3rWQ0GaIuXN/LhTxB7hHel/oNayu06TCrOg9f5jwtDzQqxLGsJJyvYNSqaJZC5uoeQiPacNSkU6KEp7ZSC3xlx7+uRpcYtJer6WkamVLw9OKZv9LAMNDtuxadXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302386; c=relaxed/simple;
	bh=2ND13i84SypvNRbZZrQfr+MlM4RAq7zcw70kQ34VkYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9j/w4Xs20sVAIINE8Qx2m4+0gtnW8ROKXzXmx9xJAIaNPfeSaIexY2yUgQbmda45iF/UNnC7hwaZdV6tgCqUK50ORnmDoSkHWmfX+3XLdM8Olb2tb38uKGolSol2ln07EfXJgxGW6VMQz55y1eq2VfajbLSKDaGE4rVw1QKZis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GxvoH4AH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GxvoH4AH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6DDC19423;
	Sat, 28 Feb 2026 18:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302386;
	bh=2ND13i84SypvNRbZZrQfr+MlM4RAq7zcw70kQ34VkYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxvoH4AHmR3GNtI8SSRFfEj9VgvYwlW98GJtanuIWecB141cbaN+MR8fxanUBJhLx
	 5oU+iexTTLQkX0UgEUiRwHwPeMXolumTWkscxAHwoy3pSYuahNies0IKhR8bt4igdH
	 OU+aC/uDHuhCoHaWUr1KdLczoo9hQJxbeMJo4M5bwM5K3C2JHs9glg3D3Y7ShYmUz7
	 EUA8xhjQ/ZkwLZlZ6hqkMBZBSK5hQk+Y2WBtYp22MKL3l8AoX8/HZ2UmhBCVzn88VM
	 8hR23TtsBtFcs23wohTR79UQqqxUSzGshbl289KnYbq8rLUq6Y0KHi+bFmIe4nrvvF
	 TdkZJjGQp2HeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Votokina Victoria <Victoria.Votokina@kaspersky.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/232] nfc: hci: shdlc: Stop timers and work before freeing context
Date: Sat, 28 Feb 2026 13:09:28 -0500
Message-ID: <20260228181127.1592657-115-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

