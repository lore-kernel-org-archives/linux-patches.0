Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2974218B0A;
	Wed, 25 Feb 2026 01:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983265; cv=none; b=huiPCcyoOMHSHtpVehmFKjM1m5Cl6AxCvRHIux108o7tB03Zj/QyhII3b41LPGGsR6W3O9lnxXQ779fpwlW0AYO73C3M9qAN6qO9yJt1+AHjMmmxegQ8dyINJ+3r2DNnF3u17tVMTbSBd+cnW+ezIKiCp+FAs9JW0tY2D+979Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983265; c=relaxed/simple;
	bh=DPwHtrFjDeYAVDSePcu4J4Qb6ZcokRbjknEDYprJjOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btbz3cmcVzE/+ArNOd2w3C9y8uI3t1D0k5N4xzFCfvddU5d9ZIjeuj7aV1ykVYtOwIjPLnsJdS0UypQ9fBJSqBj5pSwVxHV0ibo4cfOEa1aZIg7gDlxqGllH+Qb+1Fjmk9O/BGpOZ53AuP+ZdR71VySHEOnryL7YsaJ3ILTDiWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vZjfKCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vZjfKCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE28C116D0;
	Wed, 25 Feb 2026 01:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983265;
	bh=DPwHtrFjDeYAVDSePcu4J4Qb6ZcokRbjknEDYprJjOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vZjfKCgthoLhjcuiocJyAHgDoK7o2yT0S89Wksy7sJrTozbhgFDVstrp2VnInrSm
	 ABoMXd2K/VXkxsaGj0hIW8kky/MAwpFHTuESwG2uk/fluzbaaSv7QXdrjuY9qjWoP4
	 R7Zu7MjthzBMC2fMdNlK041FBPuY9lcFoWHGbhF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Votokina Victoria <Victoria.Votokina@kaspersky.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 406/781] nfc: hci: shdlc: Stop timers and work before freeing context
Date: Tue, 24 Feb 2026 17:18:35 -0800
Message-ID: <20260225012409.661419848@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 4fc37894860c9..08c8aa1530d8a 100644
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



