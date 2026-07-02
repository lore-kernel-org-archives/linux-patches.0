Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B733A7590;
	Thu,  2 Jul 2026 16:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009954; cv=none; b=l/noo9jLxJdWoYQ/XlkCcLon3ZLLIDvspzGP69W+OqgBVlWz8DH8f3erLS5cVUfCR0r3yMeDTpS1yzltyEsWB43Jw/mgbH/REPh6067/zovcbjUU2EQT4PiP865CEaHctPjxgd2Rygv639RDmjS2eZ9sF/AVSQYZeL2L/dIqatQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009954; c=relaxed/simple;
	bh=hFT9LaZjHgaP/n9wQdIKlp02j3GCmY/amf5Cu17PkoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay6WO1iKlW+0Bg7A1bDHWDx/0wXIdMFnVwECHHISaAgUd4FthiZ/jVrzZYfaHG573Vu1K3loR3PTfwKTXIrQdEg3Aijg0j3UxK6yG4ISMLaBt3HzAHJo5JKfHAFklryF6SjPc/JeS03/rexNEwPKTXttzlzZ0WxIkUbcI1QcSvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHg9ANKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHg9ANKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488EB1F000E9;
	Thu,  2 Jul 2026 16:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009953;
	bh=UzwbiUpSHOL4GrMNte2laq52e52fyVMp6j9i5+A03zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fHg9ANKct2yXiUmNvYxGpEM834OD1SfSHH+QxY1atp65B8qqiWgIhfNlGu+eHtqbV
	 6ykSHBkRaP/FyXEFY827WuRGvrUhi095JuTWm4XQGj068vLYDnNbfAXN2MZiZmZ5FU
	 xOj2RFZfUzVPX0BeZdXXW7c34pepwPl+GRufESBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/129] batman-adv: tp_meter: avoid window underflow
Date: Thu,  2 Jul 2026 18:19:32 +0200
Message-ID: <20260702155113.245798220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 765947b81fb54b6ebb0bc1cfe55c0fa399e002b8 upstream.

In batadv_tp_avail(), win_left is calculated with 32-bit unsigned
arithmetic: win_left = win_limit - tp_vars->last_sent;

During Fast Recovery, cwnd is inflated and last_sent advances rapidly. When
Fast Recovery ends, cwnd drops abruptly back to ss_threshold. If the newly
shrunk win_limit is less than last_sent, the unsigned subtraction will
underflow, wrapping to a massive positive value. Instead of returning that
the window is full (unavailable), it returns that the sender can continue
sending.

To handle this situation, it must be checked whether the windows end
sequence number (win_limit) has to be compared with the last sent sequence
number. If it would be before the last sent sequence number, then more acks
are needed before the transmission can be started again.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index f6ccb639744a2a..0fdcafca3aa02b 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -817,10 +817,15 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 static bool batadv_tp_avail(struct batadv_tp_vars *tp_vars,
 			    size_t payload_len)
 {
+	u32 last_sent = READ_ONCE(tp_vars->last_sent);
 	u32 win_left, win_limit;
 
 	win_limit = atomic_read(&tp_vars->last_acked) + tp_vars->cwnd;
-	win_left = win_limit - tp_vars->last_sent;
+
+	if (batadv_seq_before(last_sent, win_limit))
+		win_left = win_limit - last_sent;
+	else
+		win_left = 0;
 
 	return win_left >= payload_len;
 }
-- 
2.53.0



