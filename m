Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6205763BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD244C4339B;
	Mon, 20 Feb 2023 13:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901025;
	bh=QHxUkiFZJVVlK/8ceOzkd2zhME6SGmkPGRYz4skPD3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTf8fai0i9T1QNwvjNDjBPkUxHTxPKvWW6b4Wp/do4TDZMMCEpxwg64DfzxOMLC7v
	 SkGkXCvphEFTWvUbyeUM69S4oNU4mY8CUHpHAajsASzIl6wEi0XIP93NNXljPhOTWX
	 s/5i7b+sHclAbK5ta+SmcTOdtMRSzwMcF8Ch6iZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Riemann <felix.riemann@sma.de>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 136/156] net: Fix unwanted sign extension in netdev_stats_to_stats64()
Date: Mon, 20 Feb 2023 14:36:20 +0100
Message-Id: <20230220133608.291694955@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Riemann <felix.riemann@sma.de>

commit 9b55d3f0a69af649c62cbc2633e6d695bb3cc583 upstream.

When converting net_device_stats to rtnl_link_stats64 sign extension
is triggered on ILP32 machines as 6c1c509778 changed the previous
"ulong -> u64" conversion to "long -> u64" by accessing the
net_device_stats fields through a (signed) atomic_long_t.

This causes for example the received bytes counter to jump to 16EiB after
having received 2^31 bytes. Casting the atomic value to "unsigned long"
beforehand converting it into u64 avoids this.

Fixes: 6c1c5097781f ("net: add atomic_long_t to net_device_stats fields")
Signed-off-by: Felix Riemann <felix.riemann@sma.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9467,7 +9467,7 @@ void netdev_stats_to_stats64(struct rtnl
 
 	BUILD_BUG_ON(n > sizeof(*stats64) / sizeof(u64));
 	for (i = 0; i < n; i++)
-		dst[i] = atomic_long_read(&src[i]);
+		dst[i] = (unsigned long)atomic_long_read(&src[i]);
 	/* zero out counters that only exist in rtnl_link_stats64 */
 	memset((char *)stats64 + n * sizeof(u64), 0,
 	       sizeof(*stats64) - n * sizeof(u64));


