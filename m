Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DC02580F6;
	Tue, 25 Mar 2025 12:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906121; cv=none; b=uIXEkhFN9frVzTJ0SQZIF4bxOEOBd129T7knOwpNHFy+JO3y0AKN4tVARD84eY80atJnLlOBoeSR0FROvO3Y0kTTOMpZtAkIa2ybNf7pSGUaWBOsnpPvcbjXxAz3i9wYcRaNmvUw2a8WWD5GGRWfWWFcgsQOPBamJ9zaD3O/6k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906121; c=relaxed/simple;
	bh=Oe8pMpKKihjt2nECnK9Z41jbBmrF877qxWDgNpBKLbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCiWNTEirzzcNGxiIu0srEAle4Hfs3v0jFUpZ7DhcFtxn/54xqPTSNi/EYf8Iw8ML6tRug6sEtmU5TpHyp6/ArQa7X/VFvd60xOV9/Ihrc7sxaJJb9PPFzPqw50SX+Jq41wgl36Lq7c7wQ8I1+d5oC26xG8Oqj7U0dEr7QBcjD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4/pYoaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4/pYoaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B030DC4CEE9;
	Tue, 25 Mar 2025 12:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906120;
	bh=Oe8pMpKKihjt2nECnK9Z41jbBmrF877qxWDgNpBKLbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4/pYoaNSez9MhtqQmw/75uKWAyc1dJQwXK9L16kDfz96alm32uln5j5W7zIUwgx8
	 XH0fJz1NGfZZn961rmZtSss2WpO2dNYih0cNM4A5EKj4U65Qvpv/HQ+ungdbKo/XTY
	 drF/e/rdoH0g/NBJgVKOYCQqyiUuLtSkqjNWPC9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 25/77] net: atm: fix use after free in lec_send()
Date: Tue, 25 Mar 2025 08:22:20 -0400
Message-ID: <20250325122145.011024764@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6257bf12e5a00..ac3cfc1ae5102 100644
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



