Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009853EE1DD;
	Tue, 31 Mar 2026 16:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974362; cv=none; b=i+nnzAGaHdbn9TE+YD6U4CogPP1VS2BjgbO43gLb9ykOTahZkshQAbev+zKnLUvuH8nqPB10ovOzq6tvzt4/B4Vom76Y1Je5pKcooyQJA2kDFr73Z/iF9kGWffhkgREvFOigW5aA8ExRwPNwVM2vqbxEGUeQmaJsLupyCvls978=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974362; c=relaxed/simple;
	bh=kKUN6QV1jPtylDBtZSjrGvVl+sVpuxkqzdK88krgvxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWHUNNJC7yqx2gDYto3NvV+f62OmoPMHR/qBfRv5aTTtaWsKBsn1IFV+F8+ovCwq0k5RssniqOcS5kutAT9Rcwiw4JfTTNTULFRETp0ATUovvMW/1lFihqx4tvCKUatxNYztCyJP/Qvo++/oVLA/PceeXkL+ybD8YtFyQdhRniM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ad/INyEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ad/INyEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BD4C19423;
	Tue, 31 Mar 2026 16:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974361;
	bh=kKUN6QV1jPtylDBtZSjrGvVl+sVpuxkqzdK88krgvxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ad/INyEsmZf3Mx65dDYfRn8IbLr7P9Si3ZsuixRNdBgrvVrJpwneL+86UeaAqUt8U
	 jPzjBYjciIsJh1aEePgcPi8/70F4p6PHDkirzfjaQV55oJA9mL6Js21I22rlmItqsm
	 7OYu11OSQ0S4yYRYDpsP39zYgqDPCjk1xNawazeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/175] tcp: Use bhash2 for v4-mapped-v6 non-wildcard address.
Date: Tue, 31 Mar 2026 18:20:40 +0200
Message-ID: <20260331161731.843736907@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 5e07e672412bed473122813ab35d4f7d42fd9635 ]

While checking port availability in bind() or listen(), we used only
bhash for all v4-mapped-v6 addresses.  But there is no good reason not
to use bhash2 for v4-mapped-v6 non-wildcard addresses.

Let's do it by returning true in inet_use_bhash2_on_bind().  Then, we
also need to add a test in inet_bind2_bucket_match_addr_any() so that
::ffff:X.X.X.X will match with 0.0.0.0.

Note that sk->sk_rcv_saddr is initialised for v4-mapped-v6 sk in
__inet6_bind().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e537dd15d0d4 ("udp: Fix wildcard bind conflict check when using hash2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 7 +++++--
 net/ipv4/inet_hashtables.c      | 3 ++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index bd032ac2376ed..4a53c538dcaa1 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -157,8 +157,11 @@ static bool inet_use_bhash2_on_bind(const struct sock *sk)
 	if (sk->sk_family == AF_INET6) {
 		int addr_type = ipv6_addr_type(&sk->sk_v6_rcv_saddr);
 
-		return addr_type != IPV6_ADDR_ANY &&
-			addr_type != IPV6_ADDR_MAPPED;
+		if (addr_type == IPV6_ADDR_ANY)
+			return false;
+
+		if (addr_type != IPV6_ADDR_MAPPED)
+			return true;
 	}
 #endif
 	return sk->sk_rcv_saddr != htonl(INADDR_ANY);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 7292f70176251..ed253aa1f5d3f 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -845,7 +845,8 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
 			return ipv6_addr_any(&tb->v6_rcv_saddr) ||
 				ipv6_addr_v4mapped_any(&tb->v6_rcv_saddr);
 
-		return false;
+		return ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr) &&
+			tb->rcv_saddr == 0;
 	}
 
 	if (sk->sk_family == AF_INET6)
-- 
2.51.0



