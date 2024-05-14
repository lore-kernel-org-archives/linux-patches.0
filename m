Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206441CAA4;
	Tue, 14 May 2024 11:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686909; cv=none; b=uKCvNEM0W9y2LbLVh68SJ3KzTxGXHraAquP4p/kByaFGEGtcEY7xSJZaGEJepFjjrrf73KcKF29AOt13eWeCwbkgvjMIeMUyWIZL8y7Ab9Ezj9cropzc57QWwDOKp3wL2y5mCBBN5+YTNLNQWBbVoHEhACa6iheCbZVEppE1cwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686909; c=relaxed/simple;
	bh=HVDWuweWn+ZcX5UI1pubIoOS5qc6gUkyHA7T4HOj0w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z2XJh5mX2+lSwbn68zY4BIjUxnbAgLK7BxUmw1n47HN2tr/wjgjnox8xxtTlCB5bj7BGcqh7khcpaj5qAwD+q2tRXvjOmm/pGginr9rWCFIH8mC2cO4vIm7lQA6vbJh1tNKNiojN6ha0PhFdtrm5oMrj31QOqzFL+/la8yy/7oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H62ZiE01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H62ZiE01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91841C4AF09;
	Tue, 14 May 2024 11:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686909;
	bh=HVDWuweWn+ZcX5UI1pubIoOS5qc6gUkyHA7T4HOj0w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H62ZiE01YZNo07ywgibQwgJ8kXvCt6VxQEObV+JdCK+iJ24z8PLlVbEsCSSa0n3V0
	 aTQiftOMWWJ4isTRux99nI6k3FcBUg83wu7JoBNQJUKBX3tj2O6x6iP0jFhIGDjXsl
	 YoRACgwci9tPStQj84IPTEtherRoodLDSrtomSxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <courmisch@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/63] phonet: fix rtm_phonet_notify() skb allocation
Date: Tue, 14 May 2024 12:20:12 +0200
Message-ID: <20240514100949.939018633@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 871eaf2cb85e4..5e50f9ea7484f 100644
--- a/net/phonet/pn_netlink.c
+++ b/net/phonet/pn_netlink.c
@@ -206,7 +206,7 @@ void rtm_phonet_notify(int event, struct net_device *dev, u8 dst)
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
-	skb = nlmsg_new(NLMSG_ALIGN(sizeof(struct ifaddrmsg)) +
+	skb = nlmsg_new(NLMSG_ALIGN(sizeof(struct rtmsg)) +
 			nla_total_size(1) + nla_total_size(4), GFP_KERNEL);
 	if (skb == NULL)
 		goto errout;
-- 
2.43.0



