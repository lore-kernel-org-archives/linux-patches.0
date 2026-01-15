Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8092F3BF2E4;
	Thu, 15 Jan 2026 16:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496276; cv=none; b=MBUQwB8V3O6AJ1q9/xku6W1F+4DSDsfUYcAOJwOHciTOREPiWrZPrbwVckRcgRgwWTIl4QDThsVgacRvc3iz36buLrrojJTE6EB+M62O0hFiZWwSBqMRt2WXoYe6YjV8OFtrZ7jr7DYge4OopRWuNqE+XOdpLqAqBiEvXpnLaw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496276; c=relaxed/simple;
	bh=rpDZxSeZWGnHDebiYCenXH0pSRMUbsVvsclJ+qNPeyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGjlWTmQZgMEZN3P9lvhS+ojUBWQBQtlVEiowq/2JXAikTu2oKvXKhc2dIYyTDxEmpvaFMlJqd6XdO1IFKTC6wdazOW9HPyl6q7tR0O5msNinPlgyfjGkyI/bdRvrwNwsa/aUA4OfcUJ+09dGXPCZP8eNLXNHMLgWkwjGpgwQx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNw1O2Of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNw1O2Of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBCEC116D0;
	Thu, 15 Jan 2026 16:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496276;
	bh=rpDZxSeZWGnHDebiYCenXH0pSRMUbsVvsclJ+qNPeyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNw1O2OfwWWHi24TRz+xCVn17ILKfVAWG0RRJetsa38uF8XnBP0vsx5blP5uUFGdV
	 X3JE6xLqwYXMq4QtyV+C2RMXMVNChv0GYFRJKxCAGL8qm1tQfd2HVn8tU3s6WSo+Mc
	 GO7AoTd46QRtMh+iLxdOU9eP516z2pcbzzCnUWmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3e68572cf2286ce5ebe9@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 138/181] udp: call skb_orphan() before skb_attempt_defer_free()
Date: Thu, 15 Jan 2026 17:47:55 +0100
Message-ID: <20260115164207.300678858@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e5c8eda39a9fc1547d1398d707aa06c1d080abdd ]

Standard UDP receive path does not use skb->destructor.

But skmsg layer does use it, since it calls skb_set_owner_sk_safe()
from udp_read_skb().

This then triggers this warning in skb_attempt_defer_free():

    DEBUG_NET_WARN_ON_ONCE(skb->destructor);

We must call skb_orphan() to fix this issue.

Fixes: 6471658dc66c ("udp: use skb_attempt_defer_free()")
Reported-by: syzbot+3e68572cf2286ce5ebe9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/695b83bd.050a0220.1c9965.002b.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260105093630.1976085-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 30dfbf73729da..860bd61ff047f 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1851,6 +1851,7 @@ void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len)
 		sk_peek_offset_bwd(sk, len);
 
 	if (!skb_shared(skb)) {
+		skb_orphan(skb);
 		skb_attempt_defer_free(skb);
 		return;
 	}
-- 
2.51.0



