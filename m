Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012E9198E72;
	Thu,  6 Jun 2024 14:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683080; cv=none; b=RFeCYCdBA7H5QQ2JUKDNdc5CMPHkuwLtFyPTf/WwVSABnJ2aPsBOGXEUxrci5TXDv6s1aNEstONrkMShu/Kr1chQhZjTlCcU2UzfQUnFJ/hUY+0zUWRUlA1kY4gtdQnv1tEXUlIXu+xFtmLhvvliNjAZs35JqfxckRZ2ANasI+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683080; c=relaxed/simple;
	bh=oclEVQw6qDtOEyOSB1v+cIyQF2Q9B5zRW+TAKJn32BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XYmAflDP33OZcSKUzvraFc9AHWcMaBK+cGRbo79L1Z1EtMZo/ymctyiIeEiJK1gND558qnnkMH4W7KlBuNXAaybaP0DVGoFiYOvhTZdJzLfCESZ4IAhRliIj9DJ+0yFg7FS6j9BgLcLzUpWeM6xe+2kjiZYTDhcL/m9Lmbv+JCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVU/HELY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVU/HELY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AAFC4AF0D;
	Thu,  6 Jun 2024 14:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683079;
	bh=oclEVQw6qDtOEyOSB1v+cIyQF2Q9B5zRW+TAKJn32BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVU/HELYlJLhnDUqSUPUZehDhNviJNhR4BpbnUNA9qT2xqsrE+QiLEaZeQ9HvlVet
	 T52BcbOQEGtzifSIxkc9AuBEDT5mcpIA/ET3BeS9JYjnZtD8nUgzSuvBoJAAIGwMR2
	 4zg24Tv917h28ZF7CiW4sa9lyYE/yiIlQjvGhWO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@stgraber.org>,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Christian Brauner <brauner@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 349/374] ipv4: correctly iterate over the target netns in inet_dump_ifaddr()
Date: Thu,  6 Jun 2024 16:05:28 +0200
Message-ID: <20240606131703.555499038@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>

[ Upstream commit b8c8abefc07b47f0dc9342530b7618237df96724 ]

A recent change to inet_dump_ifaddr had the function incorrectly iterate
over net rather than tgt_net, resulting in the data coming for the
incorrect network namespace.

Fixes: cdb2f80f1c10 ("inet: use xa_array iterator to implement inet_dump_ifaddr()")
Reported-by: Stéphane Graber <stgraber@stgraber.org>
Closes: https://github.com/lxc/incus/issues/892
Bisected-by: Stéphane Graber <stgraber@stgraber.org>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Tested-by: Stéphane Graber <stgraber@stgraber.org>
Acked-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240528203030.10839-1-aleksandr.mikhalitsyn@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index ee5fbc19b85fc..8382cc998bff8 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1898,7 +1898,7 @@ static int inet_dump_ifaddr(struct sk_buff *skb, struct netlink_callback *cb)
 
 	cb->seq = inet_base_seq(tgt_net);
 
-	for_each_netdev_dump(net, dev, ctx->ifindex) {
+	for_each_netdev_dump(tgt_net, dev, ctx->ifindex) {
 		in_dev = __in_dev_get_rcu(dev);
 		if (!in_dev)
 			continue;
-- 
2.43.0



