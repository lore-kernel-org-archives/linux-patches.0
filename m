Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CED19F485;
	Tue, 27 Aug 2024 15:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772561; cv=none; b=tpEaeAK7qy1Mv1X8kl4n+MD+pqsTypSvjCU23ey+CfE9fPx/d6uIuRSBr411I/KZUIW0cJPJoJjQ1xvxMCVDIu6RsXrtyMgXMxGEjqyPgkLnckGkPaHaRbzkLQQNSgcFWPV+qDRrl3bAg5aLVi67uS5o/PE6BktjJV5XVmCGCQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772561; c=relaxed/simple;
	bh=LGTexLJ4HVhM+rSEsGpGBcAnRUX9YjsjZA5+tw3ppoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIqjn+IoTK0gpsBHjDVilnItIrH/XkHTxPGN/uEbYu0xRy/3Qx1WZKiroucZ1DUwn1RgPPaZ7h+suQ0JQzmSYmUmH+jAN44l3num+zaqRCrhAC40A470qraUNS0EynNPEkYHM7QNgK3jZ3hGnFBecw5Ho4oDN1c4Zep71Mdx7jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVf2swvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVf2swvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED25C6107E;
	Tue, 27 Aug 2024 15:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772561;
	bh=LGTexLJ4HVhM+rSEsGpGBcAnRUX9YjsjZA5+tw3ppoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVf2swvF+xsIBosbXVw6YidWUhO2uP24Lej5Qwhbm+J1ZvqiZjXF244qTzG6+5Xvv
	 aPm1eK8HVCM8h2m5h8yXqaDVXtVTH/t6a+S9qD4dW6ZNEx6pXI2Ee6OwKBXAKrKRRL
	 VKX8J8pkm7yD2sxhiNblZCSi+I4828IvF33jakns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vasily Averin <vasily.averin@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 252/321] ipv6: fix possible UAF in ip6_finish_output2()
Date: Tue, 27 Aug 2024 16:39:20 +0200
Message-ID: <20240827143847.836699540@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 796cf0a0a4225..cfca9627398ee 100644
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



