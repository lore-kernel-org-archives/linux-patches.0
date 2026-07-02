Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55A033B970;
	Thu,  2 Jul 2026 16:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009418; cv=none; b=SXpyfOKJBOqZ8fKyLXtETUfpToJpigHEdonPsKYcNYwNoLr/U8CZt52C3Uff9z5BtACtz3EU5p0K+DSSosXBrryk2DgXjoOGg5hBfeeyiRtCI+WGYz3Ww9BG7UA6s3+OUwszzy5M244P1jkKeCLnqIVv6qTNu1UFdHlVc5JRAAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009418; c=relaxed/simple;
	bh=TGwddRvcHvzmwxMi+W8tSS3IjQzdHdKjyUz6XFldvQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkmlwG4lx3OhKIiJw14yNdfpkgazZFDrsCBfzlQtxTTOdVl+OM+uw/XDY2BCE1HHTplJndETrnOEC8DPdeztO+RqRprWWoAhAgbpe5kqJmDrZqyC4FfFvgFzYrapq2AMcy+eS3qcBUeyILIXquSgjezMU/Yq0Z65orszPacb5r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9E1wy2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9E1wy2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C91D1F00A3A;
	Thu,  2 Jul 2026 16:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009413;
	bh=yRdDQo03XxJ4pdIbwHEe+V3dPePHJXB9iaxjOOzDC0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9E1wy2gaU6etBDBhcSTDiwywv6QK3n+IfQAqv3GeigvheaNzis44iHZo31JRUaPn
	 zXhIpvHjk3AFUzOZHXsI6mD4pYxmVf2aUyofCrajm4m4dGVlMnaZdGyDzCBdicy5WM
	 Y+3kyHK7pw20y8hXkcnLmQwMzSDt8Qq7jhmkPVgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/96] batman-adv: tp_meter: handle seqno wrap-around for fast recovery detection
Date: Thu,  2 Jul 2026 18:19:32 +0200
Message-ID: <20260702155109.827730456@linuxfoundation.org>
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
index cd196842478686..a4df826e4ece71 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -738,7 +738,7 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 		if (atomic_read(&tp_vars->dup_acks) != 3)
 			goto out;
 
-		if (tp_vars->recover >= recv_ack)
+		if (!batadv_seq_before(tp_vars->recover, recv_ack))
 			goto out;
 
 		/* if this is the third duplicate ACK do Fast Retransmit */
-- 
2.53.0



