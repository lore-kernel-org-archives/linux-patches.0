Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AFF17C;
	Sun,  1 Sep 2024 17:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210304; cv=none; b=Ihu8BED3rHSmHbK9JeVx9ubTB59SLrPkZVRLwIfVhIhFxxhz4fMxNBZYaB+2xvqjCfdFWxErN1yuQ8NaNmPdr6dUlYaz8CSD3PJjUmWW8KDT8LGdHBcjKt/6J9N4fwTkddSG6pa5WivC+pBnQOQDhhFhd7yosKJmfYpBISZFd9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210304; c=relaxed/simple;
	bh=1I3eIxTO3FNIovp2ztQQABkZyzb4yc7iwJAFTFYJeNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGoPM5pXgcTbnLDd3N5vm+Z6a37PQpvYrlSUZrMSsQ7YK14neEVG0R69yGzqrquChR5ma04UgWMIHwKACl5/SzbyrqY0+VF7QTVusVgpetI4IZ3gGUOzk8JhVA7SxpZ2NvbbuftWeDkew7ooq2B9PPHFfYfCfv0me49HehtpYsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mfk65Ftn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mfk65Ftn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3765C4CEC3;
	Sun,  1 Sep 2024 17:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210304;
	bh=1I3eIxTO3FNIovp2ztQQABkZyzb4yc7iwJAFTFYJeNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mfk65FtnhUbSgeDAayzkhxkbL1nKU4B4cvxfOzpK+ZYoXyN20KQZ2RHl0V5PoTxcP
	 BQUOsMahINZ8dJ8oI0znBpSZeRHFEAROYgPAJGqVSqVPBK5BbCnWOvzsW9Xowj1pH6
	 ogmlTGxLsgJq5e5QbIMIQ2+IijSu/ejd09qdd9t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vasily Averin <vasily.averin@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/215] ipv6: fix possible UAF in ip6_finish_output2()
Date: Sun,  1 Sep 2024 18:17:42 +0200
Message-ID: <20240901160829.035195033@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit da273b377ae0d9bd255281ed3c2adb228321687b ]

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
---
 net/ipv6/ip6_output.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 1d06b71c1adad..8054a4a2f2a5e 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -69,11 +69,15 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 
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
2.43.0



