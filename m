Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D8F2309B0;
	Mon, 10 Mar 2025 17:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626977; cv=none; b=aPgUNlBsSoN1wvVqkN4Au1O1Tu0ralbt2v3+ztkHssjY/RYenBBzcqAiuSlVix5Tw7ARR/WW1G+196GVEoNEqcR5uTP77U863oNxMGqtLA1/IgFGEUB2Sa85Eggu00w/5rTJ5cv480yxjI9SS0kA4c7BWfPR7NAOsjNj6nG8zHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626977; c=relaxed/simple;
	bh=dcKqITZSswVY4xtZKaNruNqFhvmPi2oxGo3uXsggFuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0/4r0EKY+KDFQ8doV9eawmk8P2k7x7W18ewXzIrc8VXff61wpyvfnS09HYA18FULCfC042BIzkhR+anNVh7ZNR/IhRwWpItELwihzdAOcEIbcZrhCGSuvLEz7zXVWcnJkSzJSiHrBkNJowZqmKwn+9xriw1zxf7hoxxHzoZ624=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/S9yTEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/S9yTEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB4CC4CEE5;
	Mon, 10 Mar 2025 17:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626977;
	bh=dcKqITZSswVY4xtZKaNruNqFhvmPi2oxGo3uXsggFuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/S9yTEta88w+hqfqHYQ9PyGJMYUWbMGSBOf/EfJk4ONJ7JBwkUXKe8gB/97Ynhn0
	 5VNXiEueXgq/LsbCgaqLsKUbsVXH+qwxrduEXi9FSp43m+wbxWyV7OxA3vhDCFEDeZ
	 dhoIaTfdSFoMN0e6JNJ+LKZ2a7HpebgbhTywAufA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 147/207] mctp i3c: handle NULL header address
Date: Mon, 10 Mar 2025 18:05:40 +0100
Message-ID: <20250310170453.639472748@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit cf7ee25e70c6edfac4553d6b671e8b19db1d9573 ]

daddr can be NULL if there is no neighbour table entry present,
in that case the tx packet should be dropped.

saddr will usually be set by MCTP core, but check for NULL in case a
packet is transmitted by a different protocol.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Fixes: c8755b29b58e ("mctp i3c: MCTP I3C driver")
Link: https://patch.msgid.link/20250304-mctp-i3c-null-v1-1-4416bbd56540@codeconstruct.com.au
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i3c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/mctp/mctp-i3c.c b/drivers/net/mctp/mctp-i3c.c
index d247fe483c588..c1e72253063b5 100644
--- a/drivers/net/mctp/mctp-i3c.c
+++ b/drivers/net/mctp/mctp-i3c.c
@@ -507,6 +507,9 @@ static int mctp_i3c_header_create(struct sk_buff *skb, struct net_device *dev,
 {
 	struct mctp_i3c_internal_hdr *ihdr;
 
+	if (!daddr || !saddr)
+		return -EINVAL;
+
 	skb_push(skb, sizeof(struct mctp_i3c_internal_hdr));
 	skb_reset_mac_header(skb);
 	ihdr = (void *)skb_mac_header(skb);
-- 
2.39.5



