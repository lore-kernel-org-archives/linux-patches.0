Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B59233F8DA;
	Thu, 15 Jan 2026 16:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496381; cv=none; b=b3qH3lX3Leaa1rkUtwO/pZRl8Sg6owdwc+XpvBerqUA3e/3c+FVHamFAuOgPQqXWdP2uREnlmST7p/5xX7U0SA+FO2VtkPlozjQYpX89pi4bckAk4Np1GjFTDtrnadyQ/+Z+7ZoWuzBieK4+zW4u8r/unJ387m9TecLRe25UzsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496381; c=relaxed/simple;
	bh=KAi3myD4Va9ohcwOn/MdIlQYdTXAEkFCxaxGUKDlIBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9Zi2ja1Qe41vhuYE4naG1QMZmShJNfOd77xJd76YyMIsrkst0HbJ1kMhbX0Q+rcMYBOksFxZIpQn3WerzOlgAr6TjqoPdGjC2h6dnv1WV4N1NYqhbjN8ZggezqqharZIQkJfT60Vi/bSjX4bBZGDskKtGy+FzBkkAHAb/nby/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJIJDc1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJIJDc1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4A2C116D0;
	Thu, 15 Jan 2026 16:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496380;
	bh=KAi3myD4Va9ohcwOn/MdIlQYdTXAEkFCxaxGUKDlIBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJIJDc1xlCJASAvucZ8j6lbqJA6AdkplP+gST/fjiiWKYEB0T7SCIecWYnbiP4RY9
	 gNI9HTFj0O02fwciAKC6XIDkTb4wltH4qI20TwUoZbeGLq899hIT49Hsp1jRAuxbLu
	 0lihxE0KXnwMa8bDunaSi+hNIjdtbNOKV/4JyeOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/181] can: j1939: make j1939_session_activate() fail if device is no longer registered
Date: Thu, 15 Jan 2026 17:48:31 +0100
Message-ID: <20260115164208.596142601@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fbf5c8001c9df..613a911dda100 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1567,6 +1567,8 @@ int j1939_session_activate(struct j1939_session *session)
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



