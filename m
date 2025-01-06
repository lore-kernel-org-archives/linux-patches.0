Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1AA1DE8BD;
	Mon,  6 Jan 2025 16:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179288; cv=none; b=G4h0XrdlVPcEXkQ402I9kq0J35n8ghH95tnPnmUTPoYYqpVloJpA/uPJTt9FrBvdfvxYeTXID0pq12pqkRK3TcE65IVRUNyEQfu3RucZbDuqamsKJWZqrUfovTx6Yn9wns6lI0sOtQ3RLfWMQjdiVQaRNVKOKRvmkaLaN0V5Lls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179288; c=relaxed/simple;
	bh=ZHx348gsxSZXoXDn2LaNi9NcO1mflrofWBtxy/f4QaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCc5L1ZIePVYT86vz5Ro8UNA5bmqpM2vnUxciOZX7LgcN4yHFIQSuIP5ma6BEmv1j0ULRxo6IG/IPwDOEclkh25XKkTYMMT7cCQt8ukDx9LKLRZmIkUNXlpZQfUufpcAKrEBbHce2tAjVoT0lpw2Kf9YjxX06y4m5Cxe0LMIB/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5Rzcf4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5Rzcf4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9C3C4CED2;
	Mon,  6 Jan 2025 16:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179288;
	bh=ZHx348gsxSZXoXDn2LaNi9NcO1mflrofWBtxy/f4QaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5Rzcf4dBXy7rvdzLwU8CSSnP77doawEyNj7huBY3Gn5TTmRxxHEQCIWI+llN4fcG
	 102HhEPtoPoCdt28hNdaCew2n5SgVGrT2rLelxJ2/I5RhaNmfs+iw705fI9Ae57u/d
	 f09TaWp0pr3/xAyCnRWSelM0hfBk4jcFR+VyKTbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vasily Averin <vasily.averin@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Subject: [PATCH 5.4 56/93] ipv6: fix possible UAF in ip6_finish_output2()
Date: Mon,  6 Jan 2025 16:17:32 +0100
Message-ID: <20250106151130.819280334@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e891b36de161fcd96f12ff83667473e5067b9037 ]

If skb_expand_head() returns NULL, skb has been freed
and associated dst/idev could also have been freed.

We need to hold rcu_read_lock() to make sure the dst and
associated idev are alive.

Fixes: 5796015fa968 ("ipv6: allocate enough headroom in ip6_finish_output2()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240820160859.3786976-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
(cherry picked from commit e891b36de161fcd96f12ff83667473e5067b9037)
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index a88c3988cbbd..45622cc03e96 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -68,11 +68,15 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 
 	/* Be paranoid, rather than too clever. */
 	if (unlikely(hh_len > skb_headroom(skb)) && dev->header_ops) {
+		/* Make sure idev stays alive */
+		rcu_read_lock();
 		skb = skb_expand_head(skb, hh_len);
 		if (!skb) {
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
+			rcu_read_unlock();
 			return -ENOMEM;
 		}
+		rcu_read_unlock();
 	}
 
 	hdr = ipv6_hdr(skb);
-- 
2.39.5



