Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69BC3A35A4;
	Thu, 15 Jan 2026 17:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496713; cv=none; b=V589tWYzu3A7AWD15iWJLMfLLvAj2zqmc/38Mn88pQ/n0tz5gF9MsLKyRcRRTMimH0aZ1O7/L4iyqHLSGxWNPHtzMp+dAbUbVjzZse1ub6pLPN5TSKZfS0EKC8m+9AHPTe7esLyoWTSY26PfshTrC52HZum6Yf3yxvypB1Ju1fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496713; c=relaxed/simple;
	bh=LNFqcMPg16GJduqx4/9MfbwgOVRlyVPJd2Nf1jp3Ds4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEVetf2MpI6H77njz7Dw7Elz5G35KIMbNvBARLg77URUVZmO/ICAMhxw+GLtj5NTbu5ONkuI8tbopqPh54UfU6HXOYMtw37E4289jMYEnGC24mwTaQZFJg8w1vBEEMasCYm1YkakMY/b0mVZd7PbOWY9QA9crRl924cW4gddYac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03SWSi0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03SWSi0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551F5C16AAE;
	Thu, 15 Jan 2026 17:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496713;
	bh=LNFqcMPg16GJduqx4/9MfbwgOVRlyVPJd2Nf1jp3Ds4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=03SWSi0lKO3Xr37pAYx1s0Li7/8XFjKUH/mzZv5Q3bG3G/93H1mTrweUWjvytVuZ6
	 1W6vmbySxH27Uo02TnTEc/mTQ1fvV8fMMNs+ZDEGLKyglIbwFCg07GCYcedMSsooVO
	 5hDWYn9Cf3fx5tvG1UQfGyT6KjDYgpNRttj5f3Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/119] can: j1939: make j1939_session_activate() fail if device is no longer registered
Date: Thu, 15 Jan 2026 17:48:45 +0100
Message-ID: <20260115164155.922124067@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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
index 9b72d118d756d..1186326b0f2e9 100644
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



