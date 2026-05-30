Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A124320CAD;
	Sat, 30 May 2026 17:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163997; cv=none; b=THg389OggMmTWnAcEAbwKqVlx8PncRMMM8+9Qgdg4tWnsjxkV6kcSUHl9PQlD0QsO3CZu97lUaiABapkkmhqfdx/xwjmv05s3ior4k7zgRVSXimE0nyHjPe5rZCoxNMIbeli0c0tstfDNGXufT0ioikbsTqLxkg2oxxbUfqMouA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163997; c=relaxed/simple;
	bh=ZkXPczMRJlP+YOsKMRtkieuZCaxGAsC/eioNexdILaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaAfskpTKFOn8OT7tm2K28o+a6k0IFP4NtbqrWITeT7BacTbNETJhRKlaomc6Oi+hsGBY7OPAYJLcp26lWy32aHunSBJagndZ6ENdiem/lTfrlexaKtd9j87pfIUffuspNADGxSddFQJCo18j8S6fxV2cnlSUAFzzmd7HfybsPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SS/cyfZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SS/cyfZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAEF1F00893;
	Sat, 30 May 2026 17:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163996;
	bh=IhQqiZJoBKV8zm5ERAmM+vDsqTN2ViCu9hQmL+lFfY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SS/cyfZ/Y80OdXmzlFgDWQ9fQiD4sF6WtL0jtCGBhSExVhg5FIfTR2ngESaMEMm79
	 ktQQPpstpWFH4nJOzuYRWlLeokyyky5GaxA1aDfw4lLXpBov506gsbO2menwPWk4pp
	 SJK5UlM/u6DJ24UhwuWjTXlX/m+sRgogWHR1sQzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 423/776] Bluetooth: L2CAP: Fix printing wrong information if SDU length exceeds MTU
Date: Sat, 30 May 2026 18:02:17 +0200
Message-ID: <20260530160251.392960178@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 25a6a5fe7caf9..9bb9301414f8e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7676,7 +7676,7 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 
 		if (sdu_len > chan->imtu) {
 			BT_ERR("Too big LE L2CAP SDU length: len %u > %u",
-			       skb->len, sdu_len);
+			       sdu_len, chan->imtu);
 			l2cap_send_disconn_req(chan, ECONNRESET);
 			err = -EMSGSIZE;
 			goto failed;
-- 
2.53.0



