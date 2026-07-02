Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1239D3B9617;
	Thu,  2 Jul 2026 16:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009402; cv=none; b=PnfIrhVaUxdPeZBZPY24jT+SjOFH3SpnzsAqPbT1DQjYUJS2cmVEXDIqEIKjaminw4d8yP9j5RoJ5y9aekcX9z7XeoTsH9tMSB4QYbsEHIrCRdCNSAnabKKHPYGZ07Cj/6l1WAXwmJAOgHodir3UXnhrWLuRSvx0ZgDnmAOVqxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009402; c=relaxed/simple;
	bh=VK+922xdWtMSM4XM1KPnkd82IDhXEpR2qCSKnimoKuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cxv0EGC1BeoffZ8Tn1tWP1TkMpOpJsnDC5EgLYYaLbikXhmOALPTHJ+/QZVfyB1cBqmzCvdvToUaGHv8r9cxKs7yU/SH16DhzQSZ8nQdss1BCd8b5PmflU2k+Z98Uz7aciZTeuJfQy98nNnqFeM4LYalcJhvIB5TndCMjjTL4yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4J7RA5f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4J7RA5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7861F00A3E;
	Thu,  2 Jul 2026 16:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009397;
	bh=ARTLHyw5WvpTtC0DzraqTBKFpvNBbScDPO0CbF33tAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4J7RA5fYYFTLYXlRH3l2/HxV5dnqNvEQvhKSs84XTzHRmWk4gURQnIpq+b2tZiAK
	 xanxBWFsRtwW75NeaAI3h9rlMUNxC6Iq6z3S7D5h2+t9/0ZI1D7DI4RbxE29II7CpG
	 amaqDr7cm8H1OjayaxXxYf2QR3ifU3bSk6qlW0vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/96] batman-adv: tp_meter: initialize dup_acks explicitly
Date: Thu,  2 Jul 2026 18:19:27 +0200
Message-ID: <20260702155109.725141096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit b2b68b32a715e0328662801576974aa37b942b00 upstream.

When an ack with a sequence number equal to the last_acked is received, the
dup_acks counter is increased to decide whether fast retransmit should be
performed. Only when the sequence numbers are not equal, the dup_acks is
set to the initial value (0).

But if the initial packet would have the sequence number
BATADV_TP_FIRST_SEQ, dup_acks would not be initialized and atomic_inc would
operate on an undefined starting value. It is therefore required to have it
explicitly initialized during the start of the sender session.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index c837a91879ac2f..1699fb8f8c82d4 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1055,6 +1055,7 @@ void batadv_tp_start(struct batadv_priv *bat_priv, const u8 *dst,
 	tp_vars->icmp_uid = icmp_uid;
 
 	tp_vars->last_sent = BATADV_TP_FIRST_SEQ;
+	atomic_set(&tp_vars->dup_acks, 0);
 	atomic_set(&tp_vars->last_acked, BATADV_TP_FIRST_SEQ);
 	tp_vars->fast_recovery = false;
 	tp_vars->recover = BATADV_TP_FIRST_SEQ;
-- 
2.53.0



