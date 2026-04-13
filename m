Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F9A23E342;
	Mon, 13 Apr 2026 16:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098741; cv=none; b=rCvCn/PUXj7EGX0/fIy5AyCg0/icY1RvRr6UdKEZ25bQC/4c8+J1QyZNExOH6O17JG9EJN5rwre34Ss8MMCoSpbAg2jb9eM0dbeEnN4LpY+s+qFjLEaZ4gKkT0lymvwNpYZoRcudnGVD566Aqfhb1PnWTtM+Cc7e82z/0NgzJng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098741; c=relaxed/simple;
	bh=/1woAkbHAhnczVp8pC+epX8kOUDxJS19ofkkeQNWsCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWY9HnlHuluUwIBPYNW3oBwu9hRFLhIuiZC0/Ah5k+j2+XOhfIGT8yLX1QjfAStdPC34GyRbYIdi21fdW6x3N6V6iR558YBSyWWxfi0oIQu69k0s4ajW0AR7Y1M/4DPIckVPdDS4dE3F8Af/H3bywouxtHe6JT5hXcbUYhPWEuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPYpodG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPYpodG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62461C2BCB0;
	Mon, 13 Apr 2026 16:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098740;
	bh=/1woAkbHAhnczVp8pC+epX8kOUDxJS19ofkkeQNWsCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPYpodG/LVCdntb35EGfa8xozQziF10DXBWcyM3YmnxEznkeFew7mkTKeHIuaUPjZ
	 zetJdU5dcC31KiYJ8TSGbgr1I08jbbimMqEtuVaweoZVQbHctCemPc4/gEa3nUO5Ej
	 3OI+gjq3Dz5nSlRSGAdn1ibEDC19OAE4pdGR3Gwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5b11eccc403dd1cea9f8@syzkaller.appspotmail.com,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/491] can: bcm: fix locking for bcm_op runtime updates
Date: Mon, 13 Apr 2026 17:54:43 +0200
Message-ID: <20260413155820.479254929@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit c35636e91e392e1540949bbc67932167cb48bc3a ]

Commit c2aba69d0c36 ("can: bcm: add locking for bcm_op runtime updates")
added a locking for some variables that can be modified at runtime when
updating the sending bcm_op with a new TX_SETUP command in bcm_tx_setup().

Usually the RX_SETUP only handles and filters incoming traffic with one
exception: When the RX_RTR_FRAME flag is set a predefined CAN frame is
sent when a specific RTR frame is received. Therefore the rx bcm_op uses
bcm_can_tx() which uses the bcm_tx_lock that was only initialized in
bcm_tx_setup(). Add the missing spin_lock_init() when allocating the
bcm_op in bcm_rx_setup() to handle the RTR case properly.

Fixes: c2aba69d0c36 ("can: bcm: add locking for bcm_op runtime updates")
Reported-by: syzbot+5b11eccc403dd1cea9f8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-can/699466e4.a70a0220.2c38d7.00ff.GAE@google.com/
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260218-bcm_spin_lock_init-v1-1-592634c8a5b5@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/bcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 200b66e85c1c6..414a2bb17397b 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1123,6 +1123,7 @@ static int bcm_rx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 		if (!op)
 			return -ENOMEM;
 
+		spin_lock_init(&op->bcm_tx_lock);
 		op->can_id = msg_head->can_id;
 		op->nframes = msg_head->nframes;
 		op->cfsiz = CFSIZ(msg_head->flags);
-- 
2.51.0



