Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D2A1D7E41;
	Wed, 19 Mar 2025 14:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394861; cv=none; b=J4iY7f5TDDc9icFsj4LJlwHClQymrpMWs4ul7UhHZN2+Zom0cCyOrz5Rj5LHWdg13wSl4Lp2G6iVin/a6lUNYbXp6hjAg1elv02iD+x6UuveR4RSyusr2CcBnCJ07s7Ucwk5gWxOYGRb66lfaIS6VMsCDpiYKY5/hVc8FhGlvao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394861; c=relaxed/simple;
	bh=Bl+5qF2SYGMgR9V4edQqCbAKLU52/r9fKclI44j/g2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLUUBfkwzFRclqZv8zk4Tgbb9wQWVc0rWrmxvZrj4hsZkztsHPLcO2jMzudQvADKzhj+oYecAfILu1Mt/LaTFE4r0KQCAw4Gal8nEmi7GR5GuwOADm4bmqsRTPgGqOfp2ctgMD9sI/3GSbioOqGdrgR6ldsxA+cSO+0P3xbtl2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjRJ/iio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjRJ/iio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8793C4CEE4;
	Wed, 19 Mar 2025 14:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394860;
	bh=Bl+5qF2SYGMgR9V4edQqCbAKLU52/r9fKclI44j/g2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjRJ/iioa+P7P27+hztnaginKccPKV8omAGOqE6LUaJHssMxZdBfzNRfikTCciwWk
	 r8KS4WoPvH9FHZgS6cdTiiLroRZM62gQRYbtWkJwmzD6d+RV4vIrts1Hn7CKHRzFBl
	 ZCN09rTvYYjI85OO1USslgcfin9lJ/wcpd6CmpP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 024/241] net: mctp i2c: Copy headers if cloned
Date: Wed, 19 Mar 2025 07:28:14 -0700
Message-ID: <20250319143028.307830068@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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
index d2b3f5a591418..a0dba912aecea 100644
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



