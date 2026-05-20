Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D9D285CBA;
	Wed, 20 May 2026 18:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301957; cv=none; b=hePh64rmxfaqfyGdBM9VQGAUEIWVW4pz1xDxY5TuSlgQEyawsXyH0he+J1JPthAzelcPR+oHhDkaGGoru+vJeFU3WY9N8r8xZgUHpRV9bbJuMyZzPqi7Ebgeb9D3ARNW7XwNAx8ZXnyv0tJkOTJw2Zm4wnA2tP9VoQyacj6avTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301957; c=relaxed/simple;
	bh=P5zlKwgkAHu0eMX54cTKLeO7w0jW6QiXLoX2nHDyqz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSvFg1e6aHLvJbISEoWeAl9r16Cm3TdptkDjT9M0rPFlUOANxQfxQ35CXPXsknBQZ1pwW4SvNYJc7Xe5IeDI6cL5nTrP5Hif9IsjsJ0Taw4Gx8hSyP080+KiRD+ya/S2MYz9x/fTNWQ127bkFOvjSjeptkLesh2l2lVI9Rc30bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+zk8VvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+zk8VvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11201F000E9;
	Wed, 20 May 2026 18:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301956;
	bh=/A/4eoFGogxYftRxZDUc6UvNJGWOEc4nJgKW/Y9Spbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+zk8VvBmEMpejIzP5VOSCK2JYg0vKXr/Ab6cYllXc1ubNJmDA/Kzyz6LUvDa3FV3
	 xHwGowGQLsmCoioAKSrH7favjSVjBo1yRZzhwt2Hqu2BHQQUzFax2gjOAaVQOFL3kL
	 ub9T8LbnCD/KVzdCDqo5HMaUAZ6l9ZPb4Vn2zFOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/508] Bluetooth: L2CAP: Fix printing wrong information if SDU length exceeds MTU
Date: Wed, 20 May 2026 18:18:20 +0200
Message-ID: <20260520162100.279102001@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 3da3e9fddd049..2a15863a882d6 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6658,7 +6658,7 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 
 		if (sdu_len > chan->imtu) {
 			BT_ERR("Too big LE L2CAP SDU length: len %u > %u",
-			       skb->len, sdu_len);
+			       sdu_len, chan->imtu);
 			l2cap_send_disconn_req(chan, ECONNRESET);
 			err = -EMSGSIZE;
 			goto failed;
-- 
2.53.0



