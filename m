Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C68513DB92;
	Tue, 27 Feb 2024 14:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043566; cv=none; b=IWiG7j8RK6nyu5yX2tWQVwM524gUXlv6N4RtZTGBSy28LkvUOqQTjk+E1odixoKBMdVGCOb5MAUE7oSMAKOxkQteGGFMFTtr213VL1795tz877m+S5+BiZeO0Y4rxJ15oMtKSeQ3IlfuOYFMx8kTbWZm3QvTb+33l8gX5GLIC3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043566; c=relaxed/simple;
	bh=prNmeAtcyqbITo5HJDDyGiNTsJoXR9qqjY3XZ+9qebQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I88uH9q0aww5b/kjNfn6Is6v/cLP6eUSkmBESgvim76Kh7pcn6V6EPTyp32ZCthfWsqzC74qTe57EppJS7Jz27Dlub/Y1wVg5E3BprFZ+ambvscvWjFOdGM+29zL1IrgvuP/XDIIcQeMl3DMssTOsK2Hhz11nucpOPiqXaMP+To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNg9xKkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNg9xKkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14272C433C7;
	Tue, 27 Feb 2024 14:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043566;
	bh=prNmeAtcyqbITo5HJDDyGiNTsJoXR9qqjY3XZ+9qebQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNg9xKkqo8lljvJcCG2E1aV1LPjBe5kFWOkKXTs+wCuYSGlxaJvErgK2OW15FDtqB
	 ZBWfI7mY+yuNepWO4g9MS2tJYOCKVWVkTivkz0k4XTASavXzSi1uqQmqke9iCX7Pi2
	 CFAoZEelvUScEFjdzReJaYwZD3NgjELxZwCtIYJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/195] ipv4: properly combine dev_base_seq and ipv4.dev_addr_genid
Date: Tue, 27 Feb 2024 14:26:55 +0100
Message-ID: <20240227131615.505167092@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

[ Upstream commit 081a0e3b0d4c061419d3f4679dec9f68725b17e4 ]

net->dev_base_seq and ipv4.dev_addr_genid are monotonically increasing.

If we XOR their values, we could miss to detect if both values
were changed with the same amount.

Fixes: 0465277f6b3f ("ipv4: provide addr and netconf dump consistency info")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 35d6e74be8406..bb0d1252cad86 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1804,6 +1804,21 @@ static int in_dev_dump_addr(struct in_device *in_dev, struct sk_buff *skb,
 	return err;
 }
 
+/* Combine dev_addr_genid and dev_base_seq to detect changes.
+ */
+static u32 inet_base_seq(const struct net *net)
+{
+	u32 res = atomic_read(&net->ipv4.dev_addr_genid) +
+		  net->dev_base_seq;
+
+	/* Must not return 0 (see nl_dump_check_consistent()).
+	 * Chose a value far away from 0.
+	 */
+	if (!res)
+		res = 0x80000000;
+	return res;
+}
+
 static int inet_dump_ifaddr(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nlmsghdr *nlh = cb->nlh;
@@ -1855,8 +1870,7 @@ static int inet_dump_ifaddr(struct sk_buff *skb, struct netlink_callback *cb)
 		idx = 0;
 		head = &tgt_net->dev_index_head[h];
 		rcu_read_lock();
-		cb->seq = atomic_read(&tgt_net->ipv4.dev_addr_genid) ^
-			  tgt_net->dev_base_seq;
+		cb->seq = inet_base_seq(tgt_net);
 		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
@@ -2257,8 +2271,7 @@ static int inet_netconf_dump_devconf(struct sk_buff *skb,
 		idx = 0;
 		head = &net->dev_index_head[h];
 		rcu_read_lock();
-		cb->seq = atomic_read(&net->ipv4.dev_addr_genid) ^
-			  net->dev_base_seq;
+		cb->seq = inet_base_seq(net);
 		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
-- 
2.43.0



