Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98E31A314B;
	Wed, 19 Feb 2025 08:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954573; cv=none; b=InoROFPew/CUv33xaoPXCSyhBDwlSLHk5M7DoVT99Kne4dO9Y66sWLD0Q/OfuLCHMycqyfdaCpa2pWP5PA7YaTJfAKpB+Mt16UT+cgFkil5DfQmFBMiS228XeTBZXhZtjq+JXdFLhnuN3G/wJHuUUWVxmTn2Y3YWxkCEkWUcr3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954573; c=relaxed/simple;
	bh=cgi+o2Slgp5ovmsWDCI3GJrlQrfkA3rcIqOkpxG6chA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwHgvsCvXO733Ccyr/nvIUn/A8QsGL74Ts0jQ8pvbbJ7lRhTQfd/2Hk7zgpzPa30Y2cQfuFSWiQfQGeHi4vP+UwexIj4GfklDND7Xufmb7uChks/4cwJgYZQHfh4EqV+M7Hgu5RPdiac9073yABr3wKmK7hZM6JkuMLmQ1YP0BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HY13CiMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HY13CiMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0BFC4CED1;
	Wed, 19 Feb 2025 08:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954573;
	bh=cgi+o2Slgp5ovmsWDCI3GJrlQrfkA3rcIqOkpxG6chA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HY13CiMfBXVlihWKfLoXaFut2tJneWsrRsmq4M0bvn/j1Dj+MTlgbTvbP5gnWz9VA
	 ULGJcacVAgc+P7e0gTLWWOkpLbIYVtVGpJg9TrNn7XGifL9DJEtrfZafUx+KoZbDNe
	 VD2WiQzV7EQRSmNFW16cpFjdemorAyRGbm9Sc1SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 214/274] ipv4: add RCU protection to ip4_dst_hoplimit()
Date: Wed, 19 Feb 2025 09:27:48 +0100
Message-ID: <20250219082617.954819127@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 469308552ca4560176cfc100e7ca84add1bebd7c ]

ip4_dst_hoplimit() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: fa50d974d104 ("ipv4: Namespaceify ip_default_ttl sysctl knob")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/route.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 84cb1e04f5cd9..64949854d35dc 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -368,10 +368,15 @@ static inline int inet_iif(const struct sk_buff *skb)
 static inline int ip4_dst_hoplimit(const struct dst_entry *dst)
 {
 	int hoplimit = dst_metric_raw(dst, RTAX_HOPLIMIT);
-	struct net *net = dev_net(dst->dev);
 
-	if (hoplimit == 0)
+	if (hoplimit == 0) {
+		const struct net *net;
+
+		rcu_read_lock();
+		net = dev_net_rcu(dst->dev);
 		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
+		rcu_read_unlock();
+	}
 	return hoplimit;
 }
 
-- 
2.39.5



