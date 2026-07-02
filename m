Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E95175A68;
	Thu,  2 Jul 2026 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010417; cv=none; b=p6y1rdrhJRXkSjUGm0XnmmmjsFL0+8lHGGS4mZyGMGiv6g3TXZXnHiPnmCLZEtI5uLLDISoCfweZk3cvODeLf5YPEyvt6VMSezLlOpjvaSKfM74cfxwHqLVSgV+S1zYNPIX/hLsHYK5LqS6I2aVdDweqUJiI8rfPhML3vv2lURs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010417; c=relaxed/simple;
	bh=iPqEySn3yyzZaXFfnbjWBnkLgM3303g16w0p02Vnnho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNjwWsWBto8R/gYhdfvdKJgbSumWgLn1ySapBc4R/Cs5yEnArK5j2rG5Cz7wOgDqaI4xw7J9cGdk1+MPTLO3h4bJ/cpRiWxrDN0lpokcIAHqwSYlumVKsJvkhe47ZvIxt3GSlDZuq5WOQWEHyzBvXYVgmluBhnpfovh01tJL/bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+SFw07F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+SFw07F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAEB1F00A3A;
	Thu,  2 Jul 2026 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010416;
	bh=hr1nD7a6e2Net5gawIJr9abGcvtQ8dmFKCy6Wo73Rlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1+SFw07FCJ+h+7dXp6PqWyUVJMRkqAoYs0c5DeOUIhU5j3alozedmD/pFxHY9wieA
	 FJZwbCiGHLDyA/OzfnLBNrRj1qFUElUS9gOfxBjVmlRuJLKLQXv3tpPH/cbPqIbbwO
	 nKzuSzFWLgQs4s9PICX4Nma/uihLGZ9yPNW0Qs0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/204] batman-adv: tp_meter: initialize dup_acks explicitly
Date: Thu,  2 Jul 2026 18:19:17 +0200
Message-ID: <20260702155120.760615632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f350a60e6c76b9..750e5e9d3dc9d6 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1045,6 +1045,7 @@ void batadv_tp_start(struct batadv_priv *bat_priv, const u8 *dst,
 	tp_vars->icmp_uid = icmp_uid;
 
 	tp_vars->last_sent = BATADV_TP_FIRST_SEQ;
+	atomic_set(&tp_vars->dup_acks, 0);
 	atomic_set(&tp_vars->last_acked, BATADV_TP_FIRST_SEQ);
 	tp_vars->fast_recovery = false;
 	tp_vars->recover = BATADV_TP_FIRST_SEQ;
-- 
2.53.0



