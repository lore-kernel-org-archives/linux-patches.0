Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907C8284B59;
	Sun,  7 Sep 2025 20:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275806; cv=none; b=CB73JJr82S7rRMhEE3jEv3ecqGPE4buaeOcS0zy0vxxpKFz0d0diKDUoONrVk5+Y6Epk1BQPT9P+buQvkNWozO+mYLab5/rMEZzLe5x34JMKdd38MUvpX0ZrYHuhGluylNcGBOpVkmVE9VwfjdinvKje6u63IJzZb83M2Uap5Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275806; c=relaxed/simple;
	bh=USU7n1gkmPMEXK+B6aTNSdgKPxooUtiv+ho7BtVtxTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLle7oL5c/IMUuS469qOnecUZVAV0TqWjIRXjUeYRvdXggtwZiaZIARFv6Fq0njWT46SbYchz5+62y9AZBT4dO90+evbDjOZRwC6zg/LFYBow/uZOwZFIFv5CFxytICtfJ6we2uyIKOQqxnIe9/yxoZm76EGXWiXHQkOB7/0/S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTfbymxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTfbymxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDFFC4CEF0;
	Sun,  7 Sep 2025 20:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275806;
	bh=USU7n1gkmPMEXK+B6aTNSdgKPxooUtiv+ho7BtVtxTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTfbymxYxbwzxnbZjZ80TQ88nPveXT7Yz1McyBqnMFVM7Z/HVBnCibdWSj0SjpNed
	 u6PEuYY3x4wtdxJaKttx1Zcv42ZUG5cCpfSw930o/lXWWb+7DvROcwbWZoiv2O2nFv
	 6P5LBzprNnCCT6SqNY5ZtmfsOpWH9hErvOi3YU8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/45] ppp: fix memory leak in pad_compress_skb
Date: Sun,  7 Sep 2025 21:58:03 +0200
Message-ID: <20250907195601.461669050@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Qingfang Deng <dqfext@gmail.com>

[ Upstream commit 4844123fe0b853a4982c02666cb3fd863d701d50 ]

If alloc_skb() fails in pad_compress_skb(), it returns NULL without
releasing the old skb. The caller does:

    skb = pad_compress_skb(ppp, skb);
    if (!skb)
        goto drop;

drop:
    kfree_skb(skb);

When pad_compress_skb() returns NULL, the reference to the old skb is
lost and kfree_skb(skb) ends up doing nothing, leading to a memory leak.

Align pad_compress_skb() semantics with realloc(): only free the old
skb if allocation and compression succeed.  At the call site, use the
new_skb variable so the original skb is not lost when pad_compress_skb()
fails.

Fixes: b3f9b92a6ec1 ("[PPP]: add PPP MPPE encryption module")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Yue Haibing <yuehaibing@huawei.com>
Link: https://patch.msgid.link/20250903100726.269839-1-dqfext@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 7b9337e16d6e1..dd7c84e4b4986 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1528,7 +1528,6 @@ pad_compress_skb(struct ppp *ppp, struct sk_buff *skb)
 		 */
 		if (net_ratelimit())
 			netdev_err(ppp->dev, "ppp: compressor dropped pkt\n");
-		kfree_skb(skb);
 		consume_skb(new_skb);
 		new_skb = NULL;
 	}
@@ -1630,9 +1629,10 @@ ppp_send_frame(struct ppp *ppp, struct sk_buff *skb)
 					   "down - pkt dropped.\n");
 			goto drop;
 		}
-		skb = pad_compress_skb(ppp, skb);
-		if (!skb)
+		new_skb = pad_compress_skb(ppp, skb);
+		if (!new_skb)
 			goto drop;
+		skb = new_skb;
 	}
 
 	/*
-- 
2.50.1



