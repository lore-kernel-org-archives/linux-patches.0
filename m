Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA28336EC9;
	Mon, 20 Apr 2026 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699873; cv=none; b=o9COqc6OYVjdg65prf+btJIx1s9/z0xRcrPjsJx/HO5Gbnem2gold4A/qlTgl2CVvreFZ+blXoJlqbPjndJq+0ATWMzWaaeLN1adfpLUADfJa684ahHBzd0V3aaIuTvFMWMLd9YlXIp64TY0aZ0TDbdG/Qi0In6oZ+hHf59Z9uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699873; c=relaxed/simple;
	bh=3GxLfuP92OAOwFm6L8NFODOWJxEZ7Y0Oat142DkDTvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpAVYtTgPGNvsGemlzM1BNzmhoiIaslu6KbBZE+EKU+by7tpzNAn1b20UgLqvZ2yl1EAbrwBUSoHQbMLxsXUo0R2S10KmNCJJTz9Nv01RmhH1UR3mYpRoqCri99VHMZ6YkAi42iPDkqlxuX3BHqryUSIIhxukRz5NsbVQsw7fdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqdJtZsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqdJtZsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A906C19425;
	Mon, 20 Apr 2026 15:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699872;
	bh=3GxLfuP92OAOwFm6L8NFODOWJxEZ7Y0Oat142DkDTvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqdJtZsS6BKCGJWPAeH0Xv+jlpnMt3ZWteOdYPwMcei2wPRXlaKoRfe+6cscdO3U4
	 INzmTfMxykKPOOGwaw0MFZIsC1/FByQ5YeNcJvlHPZGNlNSaAaGB5DQm7pe2rhugJo
	 wUSzxaLiaS8Nh60fUgNN6UIMojycsdH4qEnxdyY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Page <sam@bynar.io>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 7.0 03/76] can: raw: fix ro->uniq use-after-free in raw_rcv()
Date: Mon, 20 Apr 2026 17:41:14 +0200
Message-ID: <20260420153910.939809989@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Page <sam@bynar.io>

commit a535a9217ca3f2fccedaafb2fddb4c48f27d36dc upstream.

raw_release() unregisters raw CAN receive filters via can_rx_unregister(),
but receiver deletion is deferred with call_rcu(). This leaves a window
where raw_rcv() may still be running in an RCU read-side critical section
after raw_release() frees ro->uniq, leading to a use-after-free of the
percpu uniq storage.

Move free_percpu(ro->uniq) out of raw_release() and into a raw-specific
socket destructor. can_rx_unregister() takes an extra reference to the
socket and only drops it from the RCU callback, so freeing uniq from
sk_destruct ensures the percpu area is not released until the relevant
callbacks have drained.

Fixes: 514ac99c64b2 ("can: fix multiple delivery of a single CAN frame for overlapping CAN filters")
Cc: stable@vger.kernel.org # v4.1+
Assisted-by: Bynario AI
Signed-off-by: Samuel Page <sam@bynar.io>
Link: https://patch.msgid.link/26ec626d-cae7-4418-9782-7198864d070c@bynar.io
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
[mkl: applied manually]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/raw.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -361,6 +361,14 @@ static int raw_notifier(struct notifier_
 	return NOTIFY_DONE;
 }
 
+static void raw_sock_destruct(struct sock *sk)
+{
+	struct raw_sock *ro = raw_sk(sk);
+
+	free_percpu(ro->uniq);
+	can_sock_destruct(sk);
+}
+
 static int raw_init(struct sock *sk)
 {
 	struct raw_sock *ro = raw_sk(sk);
@@ -387,6 +395,8 @@ static int raw_init(struct sock *sk)
 	if (unlikely(!ro->uniq))
 		return -ENOMEM;
 
+	sk->sk_destruct = raw_sock_destruct;
+
 	/* set notifier */
 	spin_lock(&raw_notifier_lock);
 	list_add_tail(&ro->notifier, &raw_notifier_list);
@@ -436,7 +446,6 @@ static int raw_release(struct socket *so
 	ro->bound = 0;
 	ro->dev = NULL;
 	ro->count = 0;
-	free_percpu(ro->uniq);
 
 	sock_orphan(sk);
 	sock->sk = NULL;


