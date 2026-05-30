Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D91231A21;
	Sat, 30 May 2026 18:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166997; cv=none; b=WOB3kFqKcEUMLfcVFGmqog6wxYBGeh2vPbvYOykKd9M/TuINQSJPpF2U9CGEiGT+bLGvHKSvy9pkbBaFfgdwdZcKWRF/rnf3VVmjn8l1ZCKDsaXLbwk4t2HLOD/fVtvg92ABkIjtdJHUU8NVw3YbO8GMV0Wb5KsBO0q3t2Jdis0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166997; c=relaxed/simple;
	bh=/MIrFaaW6ThFfJBL1N4hS2SyuOHMAQG0KmdMRaPZR24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OmMY0xLsrDl0VK6uYbeDctbegvrPGT2odYoU0Aa3ixXueG/v1cuH0Bb71D4kiS6phvzljbz4n4I3O6Cp0dk2wLCMGODS3M+V/xxSZyobSkZ2liHGZGi83aeQtfztOnDO8zrjgZF+WBqo16PptXZIc/h22gP3pnFXEspwyiQ77NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VyPdWHid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyPdWHid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADAA1F00893;
	Sat, 30 May 2026 18:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166995;
	bh=ogScIAtDNOjGutdffX/0GWUgIUuNomAeZYO4Uwxlhy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VyPdWHide1VAJ7Qld/5wWqyI7AR6jiPfxysw9Q256MiqvISNKLgp1PC37UGLAErbX
	 Ym5Y3zh4MRDbF9orAg8ewvAOQXw/3dkVjA12g84GJ1QFsr8z0Pw6vfemndgc/3DIXe
	 5IT4Zd/gz7+JPw+HogNLsOPlfPsN4WTUTIeQWoTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijing Yin <yzjaurora@gmail.com>,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>,
	syzbot+9f4a135646b66c509935@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 533/589] phonet/pep: disable BH around forwarded sk_receive_skb()
Date: Sat, 30 May 2026 18:06:54 +0200
Message-ID: <20260530160238.710140006@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijing Yin <yzjaurora@gmail.com>

commit dbc81608e3a653dea6cf403f20cae35468b8ab9c upstream.

The networking receive path is usually run from softirq context, but
protocols that take the socket lock may have packets stored in the
backlog and processed later from process context. In that case
release_sock() -> __release_sock() drops the slock with spin_unlock_bh()
and then calls sk->sk_backlog_rcv() with bottom halves enabled.

Typical sk_backlog_rcv handlers process the socket whose backlog is
being drained, so the BH state at entry is irrelevant for the slocks
they touch. pep_do_rcv() is different: when the inbound skb targets an
existing PEP pipe, it forwards the skb to a different *child* socket
via sk_receive_skb(). That helper takes the child slock with
bh_lock_sock_nested(), which is just spin_lock_nested() and assumes BH
is already off. The same child slock therefore ends up acquired with
BH on (process path) and with BH off (softirq path):

  process context                   softirq context
  ---------------                   ---------------
  release_sock(listener)            __netif_receive_skb()
   __release_sock()                  phonet_rcv()
    spin_unlock_bh()                  __sk_receive_skb(listener)
    [BH now ENABLED]                  [BH already disabled]
    sk_backlog_rcv:                   sk_backlog_rcv:
     pep_do_rcv()                      pep_do_rcv()
      sk_receive_skb(child)             sk_receive_skb(child)
       bh_lock_sock_nested(child)        bh_lock_sock_nested(child)
       => SOFTIRQ-ON-W                   => IN-SOFTIRQ-W

Lockdep flags this as inconsistent lock state, and it can become a real
self-deadlock if a softirq on the same CPU tries to receive to the same
child socket while its slock is held in the BH-enabled path:

  WARNING: inconsistent lock state
  inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
   (slock-AF_PHONET/1){+.?.}-{3:3}, at: __sk_receive_skb+0x1cf/0x900
    __sk_receive_skb              net/core/sock.c:563
    sk_receive_skb                include/net/sock.h:2022 [inline]
    pep_do_rcv                    net/phonet/pep.c:675
    sk_backlog_rcv                include/net/sock.h:1190
    __release_sock                net/core/sock.c:3216
    release_sock                  net/core/sock.c:3815
    pep_sock_accept               net/phonet/pep.c:879

Wrap the forwarded sk_receive_skb() in local_bh_disable() /
local_bh_enable() so the child slock is always acquired with BH off.
local_bh_disable() nests safely on the softirq path.

Discovered via in-house syzkaller fuzzing; the same root cause also
on the linux-6.1.y syzbot dashboard as extid 44f0626dd6284f02663c.
Reproduced under KASAN + LOCKDEP + PROVE_LOCKING, reproducer:
https://pastebin.com/A3t8xzCR

Fixes: 9641458d3ec4 ("Phonet: Pipe End Point for Phonet Pipes protocol")
Link: https://syzkaller.appspot.com/bug?extid=44f0626dd6284f02663c
Cc: stable@vger.kernel.org
Signed-off-by: Zijing Yin <yzjaurora@gmail.com>
Acked-by: Rémi Denis-Courmont <remi@remlab.net>
Reported-by: syzbot+9f4a135646b66c509935@syzkaller.appspotmail.com
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260519172635.86304-1-yzjaurora@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pep.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -671,8 +671,23 @@ static int pep_do_rcv(struct sock *sk, s
 
 	/* Look for an existing pipe handle */
 	sknode = pep_find_pipe(&pn->hlist, &dst, pipe_handle);
-	if (sknode)
-		return sk_receive_skb(sknode, skb, 1);
+	if (sknode) {
+		int rc;
+
+		/* pep_do_rcv() runs from two contexts: from softirq via
+		 * phonet_rcv() -> __sk_receive_skb() with BH disabled,
+		 * and from process context via
+		 * release_sock() -> __release_sock(), which drops
+		 * the listener slock with spin_unlock_bh() before draining
+		 * the backlog.  The child pipe slock is taken below via
+		 * bh_lock_sock_nested(), which does not itself disable BH, so
+		 * disable BH here to keep both acquire contexts consistent.
+		 */
+		local_bh_disable();
+		rc = sk_receive_skb(sknode, skb, 1);
+		local_bh_enable();
+		return rc;
+	}
 
 	switch (hdr->message_id) {
 	case PNS_PEP_CONNECT_REQ:


