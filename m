Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8732719DF92;
	Thu, 15 Aug 2024 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731633; cv=none; b=VS596LcoXUUrHqWYyTJDo2EBFuVj6W836H4McUv0Woxju1RH0I00fM9SSokgRQ8c8CNdo2+UoELMPxieMOJfq77iV7Q7DFh+gd4uAYA0UC9Q+sKc4PWYbwmKUBcA+0DvusDeBnA9uoDLrREB/3ogQb305jebMfdoAi8QwLJROMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731633; c=relaxed/simple;
	bh=1625YSnUNmWcwDHvfr2Lon89lN+eYCcNI3L/Cwygod8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7Ylk3RVQj6iD6M/3NaPxts1hbxJB8CrSNlCPFSyWEg+dUk+8EAtKRCpZZppLDCa2Hx88oDr2UtblwgeKn8As0+miiKvlXo53f5q8izs2rM9jte03/7qfc9X1Bly1adVVRSU6Cc/VtnbKhWDt/Asd1LU/UW70jgmqeFk/OJjdNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyPJLnPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyPJLnPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51B7C32786;
	Thu, 15 Aug 2024 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731633;
	bh=1625YSnUNmWcwDHvfr2Lon89lN+eYCcNI3L/Cwygod8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyPJLnPtbnh/Gzqe3xnhuOrnEJz1l83MSD2Njfy3IZnFypOEYIas79/rhL2Ax1B2e
	 eOVluaxX2SxzUD1apijivvv9woAdltEjvRN7tyRPU9Lk8YJBWg6uZwbW8GrSAtKdUT
	 bbss6MeJVG6pYcMAHuTpnaS5UIpWBZiQHgeE3PE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45ac74737e866894acb0@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 190/259] Bluetooth: l2cap: always unlock channel in l2cap_conless_channel()
Date: Thu, 15 Aug 2024 15:25:23 +0200
Message-ID: <20240815131910.117206431@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit c531e63871c0b50c8c4e62c048535a08886fba3e ]

Add missing call to 'l2cap_chan_unlock()' on receive error handling
path in 'l2cap_conless_channel()'.

Fixes: a24cce144b98 ("Bluetooth: Fix reference counting of global L2CAP channels")
Reported-by: syzbot+45ac74737e866894acb0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=45ac74737e866894acb0
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 2eea802a9cb2f..874f12d93bfa2 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7089,6 +7089,7 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 	bt_cb(skb)->l2cap.psm = psm;
 
 	if (!chan->ops->recv(chan, skb)) {
+		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
 		return;
 	}
-- 
2.43.0



