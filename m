Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3973C54BFE;
	Tue, 14 May 2024 11:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685436; cv=none; b=HwgLEjgz4Jr66rKgkaVx94sa1E2LVbfQa78N3aEIz2W3WqllNYyb2A8hL4rgdPeBUTmQRUZ45i2K2gtOWCkNGofvTlWW3FbcA6An+nKiivAs8AdhfBD1IaTzVHu/8ys1qAjdizPHNa9zoHSHizTeIiUqS1z5btGcDb1XvOBPETM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685436; c=relaxed/simple;
	bh=cQ1kG9PFK0z2eJGgZ/SIJp8C+pYqRdcEkcu5N/Qsu+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aQuU1kk+6ae+mm6ylv9q6Oz3yolKTjdjyum7tlTTXKMJPinARBgJ/9LaRlT/5KHwcJdsMPFwXe/JyZVKWW1KiWjn2B96dSR0IMaZSrYwfBLTQYn1Ljvz5n9JX4nl+b/gtvs/0ygmxYuOxSWxx3TwkHffral2h7PwKkt+FoMEp94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gh/cpdNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gh/cpdNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67698C2BD10;
	Tue, 14 May 2024 11:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685436;
	bh=cQ1kG9PFK0z2eJGgZ/SIJp8C+pYqRdcEkcu5N/Qsu+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gh/cpdNjWF7k04gw6CtNONLSv6OYWa7IKv6HqaxZnvfkjd6J4WJHgQoHcWRdLE2La
	 hqGj0Y9z6DFwIJn+aGQ5ROWgnhpt5oWxaUKCXvLFb1Uu8zzUi/d/AaVhaznvWe0Uqf
	 KpazvNlJ4AttoPqqCkXGC1DKDlGdvDRRiVorTinU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <courmisch@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/301] phonet: fix rtm_phonet_notify() skb allocation
Date: Tue, 14 May 2024 12:17:39 +0200
Message-ID: <20240514101039.352896279@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d8cac8568618dcb8a51af3db1103e8d4cc4aeea7 ]

fill_route() stores three components in the skb:

- struct rtmsg
- RTA_DST (u8)
- RTA_OIF (u32)

Therefore, rtm_phonet_notify() should use

NLMSG_ALIGN(sizeof(struct rtmsg)) +
nla_total_size(1) +
nla_total_size(4)

Fixes: f062f41d0657 ("Phonet: routing table Netlink interface")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Rémi Denis-Courmont <courmisch@gmail.com>
Link: https://lore.kernel.org/r/20240502161700.1804476-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/phonet/pn_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/phonet/pn_netlink.c b/net/phonet/pn_netlink.c
index 59aebe2968907..dd4c7e9a634fb 100644
--- a/net/phonet/pn_netlink.c
+++ b/net/phonet/pn_netlink.c
@@ -193,7 +193,7 @@ void rtm_phonet_notify(int event, struct net_device *dev, u8 dst)
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
-	skb = nlmsg_new(NLMSG_ALIGN(sizeof(struct ifaddrmsg)) +
+	skb = nlmsg_new(NLMSG_ALIGN(sizeof(struct rtmsg)) +
 			nla_total_size(1) + nla_total_size(4), GFP_KERNEL);
 	if (skb == NULL)
 		goto errout;
-- 
2.43.0



