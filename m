Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF43E47F70;
	Sat,  3 Feb 2024 04:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933698; cv=none; b=DjK2ECE60uuTgNQcugRe2qDqln36YuQxLkZ4BcO9ASwisT5ON9soKaGLIWcvfi+ByYD/IJdWKfQq7Qq9lM/BHqWWjKpzo4v+HZzQe+sZsncbXtS8/evVSxhv7M9oxJwULd5SOqkYrl+Y/YkQmEbw6/rbXr35+XZGZl3uS4EkySI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933698; c=relaxed/simple;
	bh=4CwPTVQ0WtvN5ZlBVgdYRsq5k1pYWy2BbXC13oEeGYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5LFBX2T7a1IYTXndPOcZbiMmvECtecYnuBMdcO3vaXceJOtyeXFl9u77jjjLzsagV4QrIYREIEyjiqb0kCGBwgK0oD0ZPlhJRiGN2XwS6V3CQzUn5VNlZn6oQ8VR29sd63hxIbKUnYWKPg+UWogcwyZwE5mfEkclIZGE7lRwPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzTji8BG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzTji8BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D63C43390;
	Sat,  3 Feb 2024 04:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933698;
	bh=4CwPTVQ0WtvN5ZlBVgdYRsq5k1pYWy2BbXC13oEeGYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzTji8BG7SGEjhIWJFDlibNkQUuL0KDY3tbLRJ+OUeBrZI6GYvXffsTqj0zOh6AxO
	 SpaK7baf9jOeuJP71/gHotG/adWN/1vVmmsHYs8qy9ghUxNa48rSxb6tQOEPVLiVK8
	 OE95PNro6r0gQ7uKt3Q0qdWoOl4k2lptesCgsuh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 298/322] net: ipv4: fix a memleak in ip_setup_cork
Date: Fri,  2 Feb 2024 20:06:35 -0800
Message-ID: <20240203035408.692674792@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4ab877cf6d35..ea0247485757 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1285,6 +1285,12 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
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
@@ -1301,12 +1307,6 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
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



