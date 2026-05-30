Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E868421ADC7;
	Sat, 30 May 2026 18:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165322; cv=none; b=PClLQtkN7bRXHJepm5oAkNk4DTnrjJ1L2xJq8mopnmZeru3lTArxV6KawIyLzTpcGn46bzLQMWQowS6hRLDKSe/2hZzlKrNeLKrfcvn60tSCmztjTUUoVZJnZpQusFSZUaO/Md6fYvSuFKr3ffp5S5oZ1Kmu4vjaoK4d3rx+sCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165322; c=relaxed/simple;
	bh=4lJzVo/UrtnnYbQGbFCGjFCVyRVC16aQJ5yPSLADIac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TC67k/d5JzOLmDJBMWTillYbvgxMj69soIaXE7sDu509zciaDMH03uUSBl/OhA0oarnDNDYQiv19BIDeuUgjijSfCbA56ZzWQpmitka3lfep4EZLGnz96lVHpn0InGVmjbOE2pCd5NDvaa83GTwOZKNQUfhd9AZyBmEbhXbKnb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lH2aN+7g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lH2aN+7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3B21F00893;
	Sat, 30 May 2026 18:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165320;
	bh=uBIaUg5eVd6FADOrr0srOeVhBhT2Kjq4riWxedIv5UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lH2aN+7gwFQmIzQCdMN8B5G693IRTPML0avBcz4lQi3WuN2n96LAMIKKKM9XQCC0T
	 jS+42YRSBpjl3kL1Sot/PhGajcZssbyqI9BOhPU00YEfeYrLMnulfcQXCcLavRdy9Z
	 TNpO4OHn3J9ApCtXmg7VQE4LkvG/Q489xvvOD6EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Page <sam@bynar.io>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 044/589] can: raw: fix ro->uniq use-after-free in raw_rcv()
Date: Sat, 30 May 2026 17:58:45 +0200
Message-ID: <20260530160225.748021319@linuxfoundation.org>
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
@@ -329,6 +329,14 @@ static int raw_notifier(struct notifier_
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
@@ -353,6 +361,8 @@ static int raw_init(struct sock *sk)
 	if (unlikely(!ro->uniq))
 		return -ENOMEM;
 
+	sk->sk_destruct = raw_sock_destruct;
+
 	/* set notifier */
 	spin_lock(&raw_notifier_lock);
 	list_add_tail(&ro->notifier, &raw_notifier_list);
@@ -403,7 +413,6 @@ static int raw_release(struct socket *so
 	ro->ifindex = 0;
 	ro->bound = 0;
 	ro->count = 0;
-	free_percpu(ro->uniq);
 
 	sock_orphan(sk);
 	sock->sk = NULL;


