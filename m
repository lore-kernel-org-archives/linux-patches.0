Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F141B95C;
	Sat,  3 Feb 2024 04:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933480; cv=none; b=fFJXX2E4WTJUB3A/gTGU8+VBK5W+tS5yZImSEUpjmTiEENw529SyueEgYRXllNB6k/ng5/YPMwQAUu3k+zgqVfPP2AOZFnxnV7uFujiQwWVh7berqadjPV1USbdFZ9T+pCC59tHZwcsAHztmBw+P9lTyfILe91cDvZEhcm704a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933480; c=relaxed/simple;
	bh=RZFun7pK2C8lS8Ut7qrKqqT/B0ivzYS+ZmBsrdAe9Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqFnjjx6NOpyYa6MMs2Wnwf+Pky7gNYSK59wNxIpvyXzCgFHC7UgVr+7FZXGpWC1drYDKqf95ySe26VTuof8Yw9x8CabRIZEBN/JWR51BD7cAdjkwoLitb9RafOlhye5h59mZVVEsgSnBDMT+a3G+QABDGFKQQw1ifWZMILXEVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3gufmZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3gufmZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68ACBC433C7;
	Sat,  3 Feb 2024 04:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933480;
	bh=RZFun7pK2C8lS8Ut7qrKqqT/B0ivzYS+ZmBsrdAe9Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3gufmZATMYR/Pm7zwegfSZjW1q0dmRnnB+la4vSDrGUVC+HLsShezdsTf2WS2iF7
	 ckXdRFT82uYh1hgTd3xCVtjZIQDCj9mOa+Y1nwh0D51wWpwi2qufmJ+kHDfwe++990
	 QQndwJmzoA0wM5ctq9J5BX6YE7InLXUi+4Nb672c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/219] net: ipv4: fix a memleak in ip_setup_cork
Date: Fri,  2 Feb 2024 20:06:20 -0800
Message-ID: <20240203035346.006349072@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e19ef88ae181..a6d460aaee79 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1268,6 +1268,12 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
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
@@ -1284,12 +1290,6 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
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



