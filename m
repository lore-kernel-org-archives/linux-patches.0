Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B306433D4F0;
	Thu,  2 Jul 2026 16:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011179; cv=none; b=L1W+UCQ1RgPggpZEvqcTVtFGXdXr8wndx2zgjfpAD8hPPiJ3rSOaDsH3ajmBqAFp0BxGxOCcZL48pPhCHR44xk1el5uvimw/gMPBaymxM+PTe/BWg2TJwdlrMZAsdb8kz7OcoWf1lHHqqr8IQv2ZDXLS+sXo9Poxg6jLMSHr0XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011179; c=relaxed/simple;
	bh=4+5Y0mP1jR8N3Jg0yKEzMjbq8Y6igatp0iZyL2dMCVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUKlZg4Niq/93d+UFF1uorZcYzYqUnkKkJYJpUH+W3XwqI0kQBk/2f284EyZkeBORC34ApUs/RhScIEgxWMVrWdE1BWmhN9whti9kjwRPdW0ZQ7kwfd3H+/B7IAIFOzQNNiP+wIgeCB3gckSoadsFHMO8wjOeP8JiZfkzIQJSco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKuQyJR4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKuQyJR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246351F00A3A;
	Thu,  2 Jul 2026 16:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011178;
	bh=+Pz3D0LLhnt7DSPf1TYNDdwghV8/lntcDpR+rraov6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKuQyJR4pUR+YOBgVjyCROLbqDmMOxOZ/1iob2+OVeNhQ3sZq/r3emahMt8O5BvVX
	 sWVPlULEs/dMghm9Mw9NUCVwSM4cnc+Y47wGc2keCyolB+Lkpt/EQdYb2Vd9yJoo89
	 yT52Eo7jLSVML2PdPBs1Ie8ONvhILjg3/qg27Uh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/108] batman-adv: tp_meter: fix fast recovery precondition
Date: Thu,  2 Jul 2026 18:20:08 +0200
Message-ID: <20260702155112.346053874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 2b0d08f08ed3b2174f05c43089ec65f3543a025b upstream.

The fast recovery precondition checks if the recover (initialized to
BATADV_TP_FIRST_SEQ) is bigger than the received ack. But since recover is
only updated when this check is successful, it will never enter the fast
recovery mode.

According to RFC6582 Section 3.2 step 2, the check should actually be
different:

> When the third duplicate ACK is received, the TCP sender first
> checks the value of recover to see if the Cumulative
> Acknowledgment field covers more than recover

The precondition must therefore check if recover is smaller than the
received ack - basically swapping the operands of the current check.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 00d8bb01611f99..a85622267ba655 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -733,7 +733,7 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 		if (atomic_read(&tp_vars->dup_acks) != 3)
 			goto out;
 
-		if (recv_ack >= tp_vars->recover)
+		if (tp_vars->recover >= recv_ack)
 			goto out;
 
 		/* if this is the third duplicate ACK do Fast Retransmit */
-- 
2.53.0



