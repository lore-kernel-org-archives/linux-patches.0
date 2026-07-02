Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460BE33D4EC;
	Thu,  2 Jul 2026 16:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010433; cv=none; b=QZNOnRvnnC7HfKeGFGpH1D7350noe39DmkuvaAnqP/J5RfrF9U8lrSLW8INlhKZbQVCd6k0jTOg45wBIl1xoU4C6P7Jc0Q6H/Xj/NsnHsg/Rb0fSAgYnITyxmuhtua/M5wByp+qJG15Dlvref5rvPeCx5WH34QHQFspBxwboZiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010433; c=relaxed/simple;
	bh=gCuRmYfQkJ0YOxcG1bVVNgWGCTBDp/8ATNpBGjbk4HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSYlUOlhpxEErYtihOwL+Gx+cFizWUfpGDp3PHgS8Hn7PBmCeFmuChhS5dtIfZHM8rnb+4ybH77+XBlj6YBG3WE9eYmQ2uAgQoSIoUNuYZGh63cca1DZpTTDyjr0pnnrTQQY+TCfQbQy27Mg9r0SNhjPWXuXvfGtZrW2JUeIfTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKbhNyGt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKbhNyGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD951F000E9;
	Thu,  2 Jul 2026 16:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010432;
	bh=pkzeiS3W7nRbHT2KgYfpS5uT/SOs19rWliyJSyUZ6Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKbhNyGt8NBS7uL59RFQMqZ5rmrYy7D9kW/8q3k/DxHNb/6d6XQbD4OaoDVlobe/H
	 ObT2xzw5TBeXXeZru0TDVI01rj3CS6Y1QS+LwFVNzmZxU354Tyv1mq3yC/i1Uqm2Ps
	 cIeNKfk3xw1p8gbSlecG5xjY8VG8gkqHq+CMgkd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/204] batman-adv: tp_meter: handle seqno wrap-around for fast recovery detection
Date: Thu,  2 Jul 2026 18:19:22 +0200
Message-ID: <20260702155120.862187625@linuxfoundation.org>
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



