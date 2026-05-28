Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614991DE4E0;
	Thu, 28 May 2026 20:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000843; cv=none; b=XH6P9qzQOdrnNaQm3Iak9lAx6Po1wRkVT3fIaW9TpRDoEqhydPurIy3uA/lsMFYmd8cbjLtH8gtHokFL0sSFLPBMJ+MZfCNikdHAxzi0txDBdoEW7eWynrN+p/hvS4MrPrEjXqEZE99NkztPjDakW5qVa49f60EFMVybFLy6DUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000843; c=relaxed/simple;
	bh=Op846GiqiE6h2wX26EbZDp4eWUtWuydbmJsxQSCJ6t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXaNtOBWpw2dJXlqonzGx0cA2Jq+Mr/3o0Bu0qn0iCukw8Q+SuHguB02CzR8M+wo+vnxHPov3Dit2nf5gT3KJVXRLqhsXXpPxuyr9eT3RDRFcK2tErqKk7utfOCrpqYUB2mZPrRPXqho++pUGrDHj6grCfJsVNVroUNPhoolMFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NG979PZQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NG979PZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBFB1F000E9;
	Thu, 28 May 2026 20:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000842;
	bh=5nnBAIfmIo8de7OS+y1H7Fuu8GNhGkba4Erm4Mp5L2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NG979PZQE69kGidfnVkNJ1rjXs67+nDVnq6UdIf3P67Cy1BbKdyd8a6hDWl3KiZI2
	 r+YHPb6DhLH/Rfxk6daq7F53iuOqrtJYt9CQUSqXDgIhodCXIH10Yv2Eh8zn1nGq6v
	 hDXVj2ILQPV7+Y1G4KoPz9VSNFkBWyWJpYtkEY/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 188/272] tcp: Fix out-of-bounds access for twsk in tcp_ao_established_key().
Date: Thu, 28 May 2026 21:49:22 +0200
Message-ID: <20260528194634.540350518@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 03cb001ef87b3f8d859cf7f96329acf3d6235d29 ]

lockdep_sock_is_held() was added in tcp_ao_established_key()
by the cited commit.

It can be called from tcp_v[46]_timewait_ack() with twsk.

Since it does not have sk->sk_lock, the lockdep annotation
results in out-of-bound access.

  $ pahole -C tcp_timewait_sock vmlinux | grep size
  	/* size: 288, cachelines: 5, members: 8 */
  $ pahole -C sock vmlinux | grep sk_lock
  	socket_lock_t              sk_lock;              /*   440   192 */

Let's not use lockdep_sock_is_held() for TCP_TIME_WAIT.

Fixes: 6b2d11e2d8fc ("net/tcp: Add missing lockdep annotations for TCP-AO hlist traversals")
Reported-by: Damiano Melotti <melotti@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260508120853.4098365-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ao.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 72957523c2eca..be38712265c37 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -116,7 +116,8 @@ struct tcp_ao_key *tcp_ao_established_key(const struct sock *sk,
 {
 	struct tcp_ao_key *key;
 
-	hlist_for_each_entry_rcu(key, &ao->head, node, lockdep_sock_is_held(sk)) {
+	hlist_for_each_entry_rcu(key, &ao->head, node,
+				 sk_fullsock(sk) && lockdep_sock_is_held(sk)) {
 		if ((sndid >= 0 && key->sndid != sndid) ||
 		    (rcvid >= 0 && key->rcvid != rcvid))
 			continue;
-- 
2.53.0



