Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653153B287;
	Wed, 21 Feb 2024 14:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525577; cv=none; b=TSkvBvMnCmtl+t9HnYKgX0Aqm7rxDDKefODUQ954IVO7dwo6NaG2ikYNE//6j3ogwd+EuMB9R2zDh8cajRW4aMEp2plqCmW6EnPIcbTGyxRNE7lTaWz1Id+jTHqtFWHPVP6tTnYqmH1p+AReN3dEitKLReJBTtMSabGZkfdlO5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525577; c=relaxed/simple;
	bh=vXnxTispsMbJPYakJG9wY3zCWagkmKz3G47BLI4n7Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLm767tZsJaQJu9WPoZgjDbOXrkxQ8giEDXHgbmtVCOIFCl3qqz/6A1138DyPM9CGMq5GGrD87Mly9iDo8aVXjv1TutC4NQr6u69Tsf0gr7m3Hwqbmx7FEf6TB0F7ZUgEjGNjAoVLezof0cxZMluigmsH6mRH3gU+/EqAJhWz5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNRMRxPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNRMRxPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D381C433C7;
	Wed, 21 Feb 2024 14:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525577;
	bh=vXnxTispsMbJPYakJG9wY3zCWagkmKz3G47BLI4n7Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNRMRxPZDXTO7FXWv5P+zW0Tvzv+HDdyCC0PXWdO6i/yRxyQUq3jdwN8nzr4q2ZHR
	 GmLOJYFGX59pgyOemCRZaHJY6tEy+1KksGxK0H5bCFY4ZKGnq4nMvnaKHbpm2owFWI
	 hyS+Vhf5T0LMW6xRl4h2oKc4C3DLbqoL6tpiv38k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 169/267] net: ipv4: fix a memleak in ip_setup_cork
Date: Wed, 21 Feb 2024 14:08:30 +0100
Message-ID: <20240221125945.440654326@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0f70c2dbbe5b..d57d484a929f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1255,6 +1255,12 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
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
@@ -1271,12 +1277,6 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
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



