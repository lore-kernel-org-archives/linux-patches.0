Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0294925FA13;
	Tue,  8 Apr 2025 11:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112503; cv=none; b=oXVXm6WDoU+r7OqOPRvNwgr9ZbbqB5L2ivt3fGcii965d4gNmPuOvkwEsOBgASOh2v1MKFCx3EBAEV0vJ4as46E8WAYv3fSnRoodEAILRNY05HF/1T//9TzQX+NiaPPiGZ3peXQTwIhIRt7nNCNRQUfXgSL8tME1Vu6J7jTduUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112503; c=relaxed/simple;
	bh=86OBg5Lk28xeBNar22JHP706luZoebYF2ZIcXjk5SDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8fOzdSdS51d63cwtwobq5mWeqcMW2iYDM4t7OLTOAISzTfzEMUVAqJdJ7D6zS+wB10nm/fnivQxfA9M+pFFTBT7G/Rc+ij1yfjWZMK3EqcFpu7aiU9sVxOqw9FeCjt97FYpdQunw8+YquaTE+9PMnJGtueMt2a8J1NSha6gLqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeBgDGf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeBgDGf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8819DC4CEE5;
	Tue,  8 Apr 2025 11:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112502;
	bh=86OBg5Lk28xeBNar22JHP706luZoebYF2ZIcXjk5SDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeBgDGf9+ntGVKYYLj1aswqBrfG811Eq1uxwJTeYMBfqpOPhIXwDO3Mi0dsTbjBNM
	 AKMV/A8EFr7R+B8/IBIi/paVEcl9awrM93emF/r1P0oJpOmX+rhAIUHjrv/0tpRv7G
	 9Le6K4iP8+EwgtuIOw93/mOJl2gbFYC1Hz66jncQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/279] net: atm: fix use after free in lec_send()
Date: Tue,  8 Apr 2025 12:47:56 +0200
Message-ID: <20250408104828.865794424@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit f3009d0d6ab78053117f8857b921a8237f4d17b3 ]

The ->send() operation frees skb so save the length before calling
->send() to avoid a use after free.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/c751531d-4af4-42fe-affe-6104b34b791d@stanley.mountain
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/lec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index 7226c784dbe0c..ca9952c52fb5c 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -181,6 +181,7 @@ static void
 lec_send(struct atm_vcc *vcc, struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
+	unsigned int len = skb->len;
 
 	ATM_SKB(skb)->vcc = vcc;
 	atm_account_tx(vcc, skb);
@@ -191,7 +192,7 @@ lec_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	}
 
 	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
+	dev->stats.tx_bytes += len;
 }
 
 static void lec_tx_timeout(struct net_device *dev, unsigned int txqueue)
-- 
2.39.5



