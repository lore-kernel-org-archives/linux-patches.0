Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29A0146A85;
	Wed, 19 Jun 2024 13:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802750; cv=none; b=OinvwFLR3o5G+QcfWYIKwIDj5etv+7HNzf5aEkrjXLN+nuevfeYPWPrp/yNjiREaLolj1KNif2eMgyfZZQq6a0hdzl5/SlWMSLXmbWhfkI7pbYKxSyhwv3uk9nWfZTWdOhtD6KcU0vah8MsZODvIkYuJboYu0Jkl89nWL4WfNxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802750; c=relaxed/simple;
	bh=84xj3XJacx1thjNIADIUyZqpgb7tPWLzd/VOd2cNHxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEN3OASK5wVHpl9Mbwz8D0MpByOuVmsc9cDAl11qhOB65/R6jE1VFaLNFcpA+JfuZDnD1Cq/UILiXiN5eJr7B1+c5ipjDoHjLajJEdw+omgekb6M7+Ahwy0QOcw1/dwIdOAz2hUb6s+ZYUV3t8ImPOxbwg/sdVzpClrLknJTvLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gm+CtSxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gm+CtSxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E34C2BBFC;
	Wed, 19 Jun 2024 13:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802750;
	bh=84xj3XJacx1thjNIADIUyZqpgb7tPWLzd/VOd2cNHxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gm+CtSxWYa55gEkT5a4z9H5E6bnL3eDqJtJLYWoxS5ldfG7i4a4zJ+m1g27wWR7kd
	 O7dfE0e18LgaJNOhvFHigdW+mhEIh7EDLVao6WWLvP7CckzUa81rbob9WMP6j58x2q
	 nmJhd9XVDlnrEcsz0ynY2kEehf5MUvF8YTcoBVY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 034/281] net: tls: fix marking packets as decrypted
Date: Wed, 19 Jun 2024 14:53:13 +0200
Message-ID: <20240619125611.162651081@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a535d59432370343058755100ee75ab03c0e3f91 ]

For TLS offload we mark packets with skb->decrypted to make sure
they don't escape the host without getting encrypted first.
The crypto state lives in the socket, so it may get detached
by a call to skb_orphan(). As a safety check - the egress path
drops all packets with skb->decrypted and no "crypto-safe" socket.

The skb marking was added to sendpage only (and not sendmsg),
because tls_device injected data into the TCP stack using sendpage.
This special case was missed when sendpage got folded into sendmsg.

Fixes: c5c37af6ecad ("tcp: Convert do_tcp_sendpages() to use MSG_SPLICE_PAGES")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240530232607.82686-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 66d77faca64f6..5c79836e4c9e7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1159,6 +1159,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			process_backlog++;
 
+#ifdef CONFIG_SKB_DECRYPTED
+			skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
+#endif
 			tcp_skb_entail(sk, skb);
 			copy = size_goal;
 
-- 
2.43.0



