Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D269433BBCD;
	Thu,  2 Jul 2026 16:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010982; cv=none; b=c6WgvjpDt8DjiPHy7iTC72pND/mk1c0qrE5QgrXWDV1kaBnXlLMsviV0WGnxFqbNbgCbg+tO6bND/UokF0ytfEdWRdGiyYZSyKkE9WKGbrEUCCaKj6B0hCV25pS2IZ35xftz74FPqc6aRqLd5Xuz3OVz5wFeSCoQP+InkLGHLHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010982; c=relaxed/simple;
	bh=adQ8f506rioI+At2HcdsUz08KxEtIOD/nJqLYnZL3Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Phv6qyVLCnBkauyowRUB8rjNkKNqVJS3E8CAwWQWoQcROPTolbUxb5fwR/vjSagcOKsEmX327aO7YzAfDVfm1QGpzmJHM/SWkNse6gNg8Tut8/6mKdIT8R2SM38jE8qCC3GBX90Q8th10JKGiKAJjzrzGFHKR7d8eIjWnftZhLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+PHC4ik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+PHC4ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECC91F000E9;
	Thu,  2 Jul 2026 16:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010981;
	bh=3FH4w3bPehkG1ICbQGVxDP70jeMtjdIj+0dd9Ur1XKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+PHC4ikV10ekAzbdsQ+PGBQFBZdyiUhDjzGLehZU7G2wCrBXIciEifppZjAP7Ky9
	 h0gmb4MUvLJ/0ogATpA9gQSTqoZtkI9Y5blOHeoCEA4s2iFgPhGb6XpGoG8A7qA5uD
	 YfBi4xr/MAbB4dZU+ApKBdSboVk16/EdERM2Vkes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/175] batman-adv: tp_meter: avoid window underflow
Date: Thu,  2 Jul 2026 18:19:55 +0200
Message-ID: <20260702155117.756657928@linuxfoundation.org>
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



