Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D3A19E98B;
	Mon, 23 Dec 2024 16:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969805; cv=none; b=cKa8clg8f5cNy3LcbfEwM/bqech9gpgVmHcql5kbos+Lyglf35vwpeOLS3nX4z9jPkIl0f/tL0bncFjYSiknkuWBO94PGDPFpY/3OsXVbcyaHeulMs88pDeX0DKgfnRKDDwooLOXeamlOBDaaGB91rCYBwo4UhLE3sifelihozk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969805; c=relaxed/simple;
	bh=sD/yvxoOmU1lmHTcZZkV/tdLQNsoV7oTuKkM9HM4X5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FEOwUHqQdeQ+UrA9Ik+L33t2nWnjYzBmJn7JGdgCB10niSNIAr3aFtR7y2biV9hPpAxiQWQDa9NUbbJqQ2Rx37Tv5+7hmoS+GQl3z8yDSHO3nREnPHmtFrmta2uo0l6f8Ze98dqy0AHiV1BusA37TxuA2wqFRCs+dHyFzOkYPww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tsLjKxrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tsLjKxrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0335EC4CED3;
	Mon, 23 Dec 2024 16:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969804;
	bh=sD/yvxoOmU1lmHTcZZkV/tdLQNsoV7oTuKkM9HM4X5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tsLjKxrTmvwXyDj87q+AfxQbiTvu95qTeuYp44TOh3ChCXbw5XxG1DAhhQZaWADf1
	 GTqoWfGAeUk8tEdr9p/Mrldi/Bt/sftjGsoK+f5Zkf1teBQIDshffu4Y96zZXXUeR6
	 jpKnGNZkAcmrwdtLZchnDtMuIpFPxNrbE1SSqwpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0a884bc2d304ce4af70f@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/160] netdev-genl: avoid empty messages in queue dump
Date: Mon, 23 Dec 2024 16:57:51 +0100
Message-ID: <20241223155410.994785098@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5eb70dbebf32c2fd1f2814c654ae17fc47d6e859 ]

Empty netlink responses from do() are not correct (as opposed to
dump() where not dumping anything is perfectly fine).
We should return an error if the target object does not exist,
in this case if the netdev is down it has no queues.

Fixes: 6b6171db7fc8 ("netdev-genl: Add netlink framework functions for queue")
Reported-by: syzbot+0a884bc2d304ce4af70f@syzkaller.appspotmail.com
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20241218022508.815344-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 224d1b5b79a7..7ce22f40db5b 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -359,10 +359,10 @@ static int
 netdev_nl_queue_fill(struct sk_buff *rsp, struct net_device *netdev, u32 q_idx,
 		     u32 q_type, const struct genl_info *info)
 {
-	int err = 0;
+	int err;
 
 	if (!(netdev->flags & IFF_UP))
-		return err;
+		return -ENOENT;
 
 	err = netdev_nl_queue_validate(netdev, q_idx, q_type);
 	if (err)
-- 
2.39.5



