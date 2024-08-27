Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898E71C6F49;
	Tue, 27 Aug 2024 14:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770574; cv=none; b=nreS4H9PWj3FVMigORaojQOysjaKNiJXBoc1LRTg02AX3fe+K/hTAOcWz3bpj/JMzRiyic4p70qDK4+zzI3NOkcpHyG2H4AeS65GRPBTSHAzlEeWQfUuNZsGZ0XLNDw/jQwU2qyGYj9G8jepA24HlwCgOs3hsWOaI26WOTrXJ7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770574; c=relaxed/simple;
	bh=Li3zc/tJPbV87PArrPyMb0EXDKyNmOOY7aEG/C82ezQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRdx9pJwI1J7t0VxGyvjMr1Hk1guCbj6nEQikuzqZgAnjlpGg/uA4l6OWfvQxPHDEboDdcqZGMReVN6tUIekUQo3+mFeqo82SwRUCD4dbPti7vB4dww4A8mPgHg7cN7CQv5ieCDDGibDocTAFULPLTZNfDf0xsNVZt4ttsksfC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpMLE3q6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpMLE3q6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F122C4E699;
	Tue, 27 Aug 2024 14:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770574;
	bh=Li3zc/tJPbV87PArrPyMb0EXDKyNmOOY7aEG/C82ezQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpMLE3q6CHpA2yfxVa4k05tmf7qtCIRa6nC41oQ0MovMpHsVym9l7lWk8GUzrqFfO
	 WGDQO96NtJwxiB4JHdJsk2IMTGFnK4VrdD29TpObT8J4B2y71DKhR9vQLYXRvzjWft
	 Lq3Hl4DcZ8Vvv0KPtyYGW2oNQ0ItSWoLHb909nIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vasily Averin <vasily.averin@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 270/341] ipv6: prevent possible UAF in ip6_xmit()
Date: Tue, 27 Aug 2024 16:38:21 +0200
Message-ID: <20240827143853.675201065@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2d5ff7e339d04622d8282661df36151906d0e1c7 ]

If skb_expand_head() returns NULL, skb has been freed
and the associated dst/idev could also have been freed.

We must use rcu_read_lock() to prevent a possible UAF.

Fixes: 0c9f227bee11 ("ipv6: use skb_expand_head in ip6_xmit")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240820160859.3786976-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 9cff86c01abca..5d8d86c159dc3 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -281,11 +281,15 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 		head_room += opt->opt_nflen + opt->opt_flen;
 
 	if (unlikely(head_room > skb_headroom(skb))) {
+		/* Make sure idev stays alive */
+		rcu_read_lock();
 		skb = skb_expand_head(skb, head_room);
 		if (!skb) {
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
+			rcu_read_unlock();
 			return -ENOBUFS;
 		}
+		rcu_read_unlock();
 	}
 
 	if (opt) {
-- 
2.43.0



