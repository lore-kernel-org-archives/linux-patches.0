Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDB82E7379;
	Sat, 30 May 2026 18:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166245; cv=none; b=Zse8KJRedyo4b6rIk9ifdfs3Z/9Xvo6sV0HULRlg5Uzxh3UOJzdY+4S8wXgr6vEzjPOWs3Qde2+Ljdh3y1K1cYRUHVX1pzUo1NwQcXqVsiWnYuHwpQTRZ35uhfgZ724aO9QDImZbqPtEwSaBzGsc0ig2k8ySd06XSO7oaKieUOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166245; c=relaxed/simple;
	bh=DW06VCi5ziIEoH+UiQ1/2hXN+UTizdEX9IU3UwoACMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dl6vw+ZRCxQ3inNVq3hOFZhxxv7mTEgnKgvxXtdDEO+zqcKVls5QrxN4C5zKnFJL7uwVpJr3rhg4zfaFMHYU5ssINUTJJLIVKAiZr3lFyglf0K5Eb/hpozyuavTSLO5B6vSEbOOiO9oLfaKoVv+e97NOqr2EsoDf8z71B/5RFC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0ZIYkxJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0ZIYkxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFED91F00893;
	Sat, 30 May 2026 18:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166244;
	bh=sh2mjZ6k32nep3jbB3cj4Si/4GYduO3ubS9z40h6dRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0ZIYkxJ01nLKZanjr+X+7jxDzhVYnQYmvBsddAn9h15lFZtyd4IBhT9cog5zHemM
	 F1Az2NzXZqjCbd3URm5ZZET3ZGBnm4xYiN//NolnnJO1+Ay/ESQ5Fp6kBBnlg4uwLO
	 HTqP84kKQpmlrkTsAzpanwx5ns7PaQiunouZ3o3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 315/589] Bluetooth: L2CAP: Fix printing wrong information if SDU length exceeds MTU
Date: Sat, 30 May 2026 18:03:16 +0200
Message-ID: <20260530160233.218138728@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 15bf35a660eb82a49f8397fc3d3acada8dae13db ]

The code was printing skb->len and sdu_len in the places where it should
be sdu_len and chan->imtu respectively to match the if conditions.

Link: https://lore.kernel.org/linux-bluetooth/20260315132013.75ab40c5@kernel.org/T/#m1418f9c82eeff8510c1beaa21cf53af20db96c06
Fixes: e1d9a6688986 ("Bluetooth: LE L2CAP: Disconnect if received packet's SDU exceeds IMTU")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index a6efb5b42f9b3..24ee019c0b696 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7686,7 +7686,7 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 
 		if (sdu_len > chan->imtu) {
 			BT_ERR("Too big LE L2CAP SDU length: len %u > %u",
-			       skb->len, sdu_len);
+			       sdu_len, chan->imtu);
 			l2cap_send_disconn_req(chan, ECONNRESET);
 			err = -EMSGSIZE;
 			goto failed;
-- 
2.53.0



