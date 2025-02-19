Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FCD1D90D9;
	Wed, 19 Feb 2025 09:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955827; cv=none; b=nW5xWESVm3zIQpBgVOe7mwU4p0b+r/jp9DYr047wARucwSnf+y8LgRwsE0qX99CHwTbZwtbopHPDwyc5oSJ1oNa90d0P6hhz0wJ9XxcKMDXLJSU8/acQeErNdB0+hphGKsUAj1KQjYWlMhXOXqRbaCJ5gIwBpErhF0lPapba1b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955827; c=relaxed/simple;
	bh=Q9a3zzWjYqVZXHTDz13PL+w8CeUTvfYa92InAZKJyq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukcBtHl54NIAahzxCBP1QUQSDt9id0M+7W1RTkN3HcB2mPW1ecmN5UVE48RnuZUZHSPwNFODfBRxaWnRRME0MnXzDnFggWOpXkFbed1faB6u485CbACkaxwPSqVQ6plBsdk3WOjUBRcrgHYpz9Bsop+hKUSaaRamagP5LfuezUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWqGY/Z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWqGY/Z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCFFC4CED1;
	Wed, 19 Feb 2025 09:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955827;
	bh=Q9a3zzWjYqVZXHTDz13PL+w8CeUTvfYa92InAZKJyq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWqGY/Z/ndov9x7oF5MCSWDm947s7djPXyDoP6Wkcr4USoQVGqKIOvJH9rXXzpwsE
	 AKp36ucvzarfCbxW7ksBskyZV77BCZaf/54ZIecbTqQZI067LlNnowQ69o7n41W29U
	 uf9iiKx7wYGTRhPzSCFJDYDEXRAD3koL7UssrQIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/152] ipv4: add RCU protection to ip4_dst_hoplimit()
Date: Wed, 19 Feb 2025 09:28:32 +0100
Message-ID: <20250219082553.975726891@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 51a45b1887b56..0171e9e1bbea3 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -357,10 +357,15 @@ static inline int inet_iif(const struct sk_buff *skb)
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



