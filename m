Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D83763FE;
	Wed, 21 Feb 2024 13:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521570; cv=none; b=SOSdFEeLlObpWl9PW89KOmfdGYe44gpvdYYbOkd+7b6F1uEg4vXC+SZzj0KcLUYUpHd8cA8592NPGoSiFLIHIz0c8vok9v7CZKQHomGOAKJADNNbvAUQnBUssDV7xDi8xW7BuVq+/GWGIWqcYbWSdAZHz6VGNgrHSMdIZvmhNFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521570; c=relaxed/simple;
	bh=3DPCDP7jgIXMhXjYrzbVjv+qMWEKNoAjVz3UneBK6N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQ/8/4X5WNFIBsFLoU3i0sTHen64QDJ+7fhjQqF+xIZ+Y7JKwcifHWi4nIwpmPZskOrAEiXSvmMGPZ4x54EkJCKwZ/64gKaXeL4f4Hbr8v1LIuTRuQkX8R+3405Q++rdvIV9+ljwM1M+eYXfkQlKJ89GZTk7t6o4TALS9Gbm8XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfvYG0c6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfvYG0c6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940E7C43399;
	Wed, 21 Feb 2024 13:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521570;
	bh=3DPCDP7jgIXMhXjYrzbVjv+qMWEKNoAjVz3UneBK6N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfvYG0c689MWf7IjUAfACbDY/ESkCO3aONgJPG3s6ECMzVcew4OxhOZs0HjnTqj7c
	 1TlRDa6nqwV5gGcY2x0qjuHuR88vmg3WhP4D/2HCHTL1q1OtQe8bLAjTYoUduM4xTZ
	 LYzQ5otOzdwsJN0ndtKzeIFMx1D/YWhK1IHV9YEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 139/202] net: ipv4: fix a memleak in ip_setup_cork
Date: Wed, 21 Feb 2024 14:07:20 +0100
Message-ID: <20240221125936.199476476@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 5dee6d6923458e26966717f2a3eae7d09fc10bf6 ]

When inetdev_valid_mtu fails, cork->opt should be freed if it is
allocated in ip_setup_cork. Otherwise there could be a memleak.

Fixes: 501a90c94510 ("inet: protect against too small mtu values.")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240129091017.2938835-1-alexious@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 6936f703758b..3e15c1b388ae 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1140,6 +1140,12 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
 	if (unlikely(!rt))
 		return -EFAULT;
 
+	cork->fragsize = ip_sk_use_pmtu(sk) ?
+			 dst_mtu(&rt->dst) : READ_ONCE(rt->dst.dev->mtu);
+
+	if (!inetdev_valid_mtu(cork->fragsize))
+		return -ENETUNREACH;
+
 	/*
 	 * setup for corking.
 	 */
@@ -1156,12 +1162,6 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
 		cork->addr = ipc->addr;
 	}
 
-	cork->fragsize = ip_sk_use_pmtu(sk) ?
-			 dst_mtu(&rt->dst) : READ_ONCE(rt->dst.dev->mtu);
-
-	if (!inetdev_valid_mtu(cork->fragsize))
-		return -ENETUNREACH;
-
 	cork->gso_size = ipc->gso_size;
 
 	cork->dst = &rt->dst;
-- 
2.43.0



