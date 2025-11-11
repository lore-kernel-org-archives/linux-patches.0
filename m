Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED7330C34A;
	Tue, 11 Nov 2025 01:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823899; cv=none; b=XUZ2T4cFcLH1hG2a4GZjuA0vvEWE268/q8ywZBVo0DH5eiJ+SThzMFkPJAtfB/RDWG5HHGKnZWP2cYipNB4IYBjg4ZrEprx9I+EvF4sqhvFXJm24f/ze4+pmnpEI/uAP5ob1ku9yStRcNCZC1Uk4U/YmA1ZmcU/Mdlj1UwqJr+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823899; c=relaxed/simple;
	bh=3ouu/204WfrLlJBp1t5rwtcnZv9Hhp4u8pDepuswf1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6uWLrJoKClUIR2P6xxXsqnxXO6RsIW91Io78vPjqSc7s5/ErpK8NJILbQiOVo+w+cGvb7EKJiNX5B//OVe/5yJFkRsy5cGX0sZTFMo/rAuybpyIQ0dsvyENn29pZEBqYITi04N/Qcffylvw9OXeUWu6wtoL4EX5Agf7en5weS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JY63qf46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JY63qf46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C0CC16AAE;
	Tue, 11 Nov 2025 01:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823899;
	bh=3ouu/204WfrLlJBp1t5rwtcnZv9Hhp4u8pDepuswf1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JY63qf46oatdRyOJxy2ZQwtZImiTmbtMt4DegFEO26fLuEBqA+N6BMWa/+KClIaUY
	 H/YCLAB+WwXfskyEHxUPpYaWz9nqsQkTnUv8nHmJBmi70IzOWrzbNX8kvjNIWHs0v8
	 l3N0cOc6c1k0utrJsWK1JgMW1LY8hT77f530GXHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 346/565] net: devmem: expose tcp_recvmsg_locked errors
Date: Tue, 11 Nov 2025 09:43:22 +0900
Message-ID: <20251111004534.658894871@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit 18282100d7040614b553f1cad737cb689c04e2b9 ]

tcp_recvmsg_dmabuf can export the following errors:
- EFAULT when linear copy fails
- ETOOSMALL when cmsg put fails
- ENODEV if one of the frags is readable
- ENOMEM on xarray failures

But they are all ignored and replaced by EFAULT in the caller
(tcp_recvmsg_locked). Expose real error to the userspace to
add more transparency on what specifically fails.

In non-devmem case (skb_copy_datagram_msg) doing `if (!copied)
copied=-EFAULT` is ok because skb_copy_datagram_msg can return only EFAULT.

Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250910162429.4127997-1-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 795ffa62cc0e6..ad5f30cefdf96 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2780,9 +2780,9 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 
 				err = tcp_recvmsg_dmabuf(sk, skb, offset, msg,
 							 used);
-				if (err <= 0) {
+				if (err < 0) {
 					if (!copied)
-						copied = -EFAULT;
+						copied = err;
 
 					break;
 				}
-- 
2.51.0



