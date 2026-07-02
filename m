Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C9F30B50D;
	Thu,  2 Jul 2026 16:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011061; cv=none; b=eoWpZFWI15RZ8HmxEDzX4NemICToyuFpIJ0d3z8P/8/Q3acnpYquUsCnBW/WXd2gcNstXrswwU365LBnvDfcJ63/DiaFB5lI/gq7xnse1xHp+yoH/k2u3X2v0E12euEFS+Va9FDv9tyEIL57U4gnAjx36bmVewoXwjR2tc/LuCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011061; c=relaxed/simple;
	bh=N4BY8pQjd6vzQHRrHjXRY9Vi9HixWFsV5u7ePtKDVSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ5cY8+65uXvJ6bHi3qdbQSZtADJ0xBFxhLYENF1w1jFknQCGhwaMVFNgd+7RcZmumdbn8JDKGAxntrB/WnRqxc0K170oGGV67U0fvn+27cOoG9GjpaqPubP852Z2xmBA95ijw60g0YCnEsQZ6mjiiE4cQ5jjF+UzVlkcE2sM9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUyKSTGh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUyKSTGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFC71F000E9;
	Thu,  2 Jul 2026 16:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011060;
	bh=AN1XVcJMO7lVeqRBtrqzy2oZx2XCC4M64pRCt7nrAbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uUyKSTGhm077i9nGmeuNS3bmU7R7PiG6QdmDjxswjbfaPSKCsnm15+bvG7hr0VWRC
	 DkQGMB0dNwRK3egqOqeEnff2oplsYVrpb4aow3pEI5GcRj6c5fcWi6qR4oO18qHGgA
	 kSGqDpZNV35KdG9+AZciab5LqxVDdn8R89jC3pLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/175] batman-adv: tp_meter: handle seqno wrap-around for fast recovery detection
Date: Thu,  2 Jul 2026 18:19:58 +0200
Message-ID: <20260702155117.817865864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit f54c85ed42a1b27a516cf2a4728f5a612b799e07 upstream.

The recover variable and the last_sent sequence number are initialized on
purpose as a really high value which will wrap-around after the first 2000
bytes. The fast recovery precondition must therefore not use simple integer
comparisons but use helpers which are aware of the sequence number
wrap-arounds.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index c79352cfddc4ae..089ac7cc9fbebc 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -733,7 +733,7 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 		if (atomic_read(&tp_vars->dup_acks) != 3)
 			goto out;
 
-		if (tp_vars->recover >= recv_ack)
+		if (!batadv_seq_before(tp_vars->recover, recv_ack))
 			goto out;
 
 		/* if this is the third duplicate ACK do Fast Retransmit */
-- 
2.53.0



