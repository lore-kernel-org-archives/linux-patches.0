Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE24F1C5D6A;
	Wed, 19 Mar 2025 14:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395012; cv=none; b=K3eAZdDUkfswslhE+UHAv3UEXtKaTYo686BcloDzh+dsWU5vj+NQScb+nUo4o/PPNT+9m9Dv6nguZcfQ0kFoIBFvj3lvh3/Ig+UcisH9tGpSkiC1ma6HoQxiFh3y1SgBZYwcXo6Yn8QH91j+t0DGF+cKzMNh5tRWvfY9zhjq5Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395012; c=relaxed/simple;
	bh=zLI51xr60ZgUMhVmy5i13lq6JpN3ZeUlxGSzBInTd6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b41dXdbKdAZm/vAX3pgLbzWa8lpcHSQUdOTVAwqL64Zy0fzc1c1Tt4+69FH7Y4IwEjFqWtgHLe6YIvcTW56X15ERAfhRocLOs/GEkKyh7EJjk71VU8vmLENq112JTz9sjepupZDz0Qgjj8lVtQ70jS25zofwyiRmGnOCBhXVc20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bRdrM4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bRdrM4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15BEC4CEE4;
	Wed, 19 Mar 2025 14:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395011;
	bh=zLI51xr60ZgUMhVmy5i13lq6JpN3ZeUlxGSzBInTd6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bRdrM4hCUUSPaMdOFby0CxyU2emHI3l4iVVg3bqeogGI+gO91YL268tCNth6mTtk
	 /WJa030W4RW+iPF8VqZuEAgzgmO38SQjBbfj6k+Yio8KD1wOYqmk2L5HVYEK2Yrx7K
	 Nm+QOlEb76PbksnOv8Iiw9Yz4adEaBQAbdECt/dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/231] net: mctp i2c: Copy headers if cloned
Date: Wed, 19 Mar 2025 07:28:35 -0700
Message-ID: <20250319143027.380326973@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit df8ce77ba8b7c012a3edd1ca7368b46831341466 ]

Use skb_cow_head() prior to modifying the TX SKB. This is necessary
when the SKB has been cloned, to avoid modifying other shared clones.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Link: https://patch.msgid.link/20250306-matt-mctp-i2c-cow-v1-1-293827212681@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index e70fb66879941..6622de48fc9e7 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -584,6 +584,7 @@ static int mctp_i2c_header_create(struct sk_buff *skb, struct net_device *dev,
 	struct mctp_i2c_hdr *hdr;
 	struct mctp_hdr *mhdr;
 	u8 lldst, llsrc;
+	int rc;
 
 	if (len > MCTP_I2C_MAXMTU)
 		return -EMSGSIZE;
@@ -594,6 +595,10 @@ static int mctp_i2c_header_create(struct sk_buff *skb, struct net_device *dev,
 	lldst = *((u8 *)daddr);
 	llsrc = *((u8 *)saddr);
 
+	rc = skb_cow_head(skb, sizeof(struct mctp_i2c_hdr));
+	if (rc)
+		return rc;
+
 	skb_push(skb, sizeof(struct mctp_i2c_hdr));
 	skb_reset_mac_header(skb);
 	hdr = (void *)skb_mac_header(skb);
-- 
2.39.5



