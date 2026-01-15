Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822783BFE3A;
	Thu, 15 Jan 2026 17:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497189; cv=none; b=CpFh3ITZKERi9bC06XEp+f81uQdBFyS09j5dQJ0J6NfNi9rzi48m8e21GpGVTg5EfCcAnLMYKj6w0rb2ObeWSA76Gb2SSZ5fhSTDu3HiSTwlTIIFXk2pNmU0nGwybX82GvSN+Qr7ZjU/ZhxVLZ1P2uN9DD2bL/DJOG++YeIoEDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497189; c=relaxed/simple;
	bh=6QEIpFpV+AiP7M2oBU3JH5uV/wC15GiNMd3o28wiyeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbaKI7ra0tOMvqg4Hyt0ei/lgStyuR9aA9TUeJMrBCfvVXk8V99eliK3S+QDwlmb/8C/fdkMfw6pSUGIVjxRjMmyyDAjafi+i4Uigds/Io3AS5EKdnO3flScfHwHdo23rGjS3lfjZz4kiY+qqrVrn+l+yebNIkcFj/8RA/xSHk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljKp4U7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljKp4U7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D050C116D0;
	Thu, 15 Jan 2026 17:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497189;
	bh=6QEIpFpV+AiP7M2oBU3JH5uV/wC15GiNMd3o28wiyeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljKp4U7mRk7ZOebrvbPfAsCTczaA+m4vEWWFi/k5vbtB4EVc8gnfnLnqM0Ul5ScYi
	 fj1sugavQ5Z70QZJ0aB3Ffm6Spba4v7zWpN1zD3edIa4yZVCFeuYGyJ24GtzgHCSm5
	 3KbNjHj2pmIRcyQeRYzBl2zUjK06ljZul85s4Dho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 68/72] can: j1939: make j1939_session_activate() fail if device is no longer registered
Date: Thu, 15 Jan 2026 17:49:18 +0100
Message-ID: <20260115164145.968915397@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 5d5602236f5db19e8b337a2cd87a90ace5ea776d ]

syzbot is still reporting

  unregister_netdevice: waiting for vcan0 to become free. Usage count = 2

even after commit 93a27b5891b8 ("can: j1939: add missing calls in
NETDEV_UNREGISTER notification handler") was added. A debug printk() patch
found that j1939_session_activate() can succeed even after
j1939_cancel_active_session() from j1939_netdev_notify(NETDEV_UNREGISTER)
has completed.

Since j1939_cancel_active_session() is processed with the session list lock
held, checking ndev->reg_state in j1939_session_activate() with the session
list lock held can reliably close the race window.

Reported-by: syzbot <syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=881d65229ca4f9ae8c84
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/b9653191-d479-4c8b-8536-1326d028db5c@I-love.SAKURA.ne.jp
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 76d625c668e05..0522c223570c7 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1571,6 +1571,8 @@ int j1939_session_activate(struct j1939_session *session)
 	if (active) {
 		j1939_session_put(active);
 		ret = -EAGAIN;
+	} else if (priv->ndev->reg_state != NETREG_REGISTERED) {
+		ret = -ENODEV;
 	} else {
 		WARN_ON_ONCE(session->state != J1939_SESSION_NEW);
 		list_add_tail(&session->active_session_list_entry,
-- 
2.51.0



