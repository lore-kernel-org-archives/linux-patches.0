Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7534D47AF75;
	Thu, 20 Aug 2026 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243431; cv=none; b=DDG54ulrgrC+08M0svhFqKCbcAybcqD/0wKMfz1/a0qHOJAwzJ4j9UIuSj/cutdAUXBQPmSe8AsXnmeNZj/aQ596ChzKwjJuUsAbZpEwMuW8j9pn3gNvbj1kEj2GywWjnYuaA/rZYWSe5uTYlB5A7HaWT46gy1E9HGQFDzdHszs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243431; c=relaxed/simple;
	bh=8z48+1zZME9qjvvLYNX/ta9of2ObdmPln8aeskj80PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvZdbpF4MnPrqnQXOGz6RI99ueXFXo1qxZZvnXB9NsR383uo3YSxThQW70FYw4YAlgjscYrhZTR3yZn6RGuJpAp0GcM9E/EKpbjTrAv0WZsXoCGjwa/dmKgM3Vq0TcS/7wdQ//pR8Qf3/c6s8oqnI2TBlONC5fgmyCKN7M7sSts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RozoaBR2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RozoaBR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF96C1F000E9;
	Thu, 20 Aug 2026 16:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243430;
	bh=vReMGWiPdLmWfkzinAnsOnH/8I48x/p01Pf2CSYy2fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RozoaBR2LW4TmGOOdhx+5c1qhMNwcC4EL3de6eLh+bQD3sBdoljsRTt+jRQ0ET55Q
	 aipLjzXkAmrHBTRMqMVEFZ/RI7BJsNbn5hFuDjJw1EM3squl4V9qktl6rSOW0aL3+C
	 kv+98t5DB0iG+pZ/3KJZUTxjwjXvdZSeXhyY6AxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/272] netfilter: nf_conntrack_sip: remove net variable shadowing
Date: Thu, 20 Aug 2026 16:54:36 +0200
Message-ID: <20260820145234.034478603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7970d6aaf710db166de98c5356a260089896fae5 ]

net is already set, derived from nf_conn.
I don't see how the device could be living in a different netns
than the conntrack entry.

Remove the extra variable and re-use existing one.

Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: e5e24a365a5e ("netfilter: nf_conntrack_sip: validate skb_dst() before accessing it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_sip.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -948,9 +948,8 @@ static int set_expected_rtp_rtcp(struct
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 	} else if (sip_external_media) {
 		struct net_device *dev = skb_dst(skb)->dev;
-		struct net *net = dev_net(dev);
-		struct flowi fl;
 		struct dst_entry *dst = NULL;
+		struct flowi fl;
 
 		memset(&fl, 0, sizeof(fl));
 


