Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8EB1C5D6A;
	Wed, 19 Mar 2025 14:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395011; cv=none; b=g1sYAaYZqkVNdnI4R9m34zVrX92Uu85uqXlw71s+QXDSsPQjfnUNze0xpQdiEAXJO2rCAf1H8WjWW30OitqmAxc52nVo71Q22tzsvwAMRM3cbHhikZafmO+n9pTnoSkniCUIhTR7j/WHDuL0boFkQ00IGFTTL6LRICSh1W0mx6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395011; c=relaxed/simple;
	bh=cXwYpJPd25zHNmQSkpdZGM6dFhvWexe1c0zHkGFStWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyIdR+Uf9Xn5/meq8+iY/L4OxRb3hDLlzHvReHL5qL+c5C7pQrIZcAiRJY5tfvJpmdU07IrNq7szssuGnsNeSctAZkkDTCoTv1HtikJxuSQjjojWKeO48ywhfq8vXoCmpK4AhZ0mitnIgb7+A6jJbSLu6AeeJwPf5iE92bjpHxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Awlmbhku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Awlmbhku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D884C4CEE4;
	Wed, 19 Mar 2025 14:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395011;
	bh=cXwYpJPd25zHNmQSkpdZGM6dFhvWexe1c0zHkGFStWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwlmbhkuhkgOCn2td5HQai2Jp9XCNWt/wucGLZIOsdL3SkHq7MNa58x6rRtzYmyNm
	 aOnbML10X0J/NG0dvDVMP0FxzkH2mPhxTxuDyuqBrzbf1Acpdnod/Kn6lWgUEoRLS8
	 RRx6L/PISDXszrogGeI/dQxQnePcCFweJ7wgIuYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/231] net: mctp i3c: Copy headers if cloned
Date: Wed, 19 Mar 2025 07:28:34 -0700
Message-ID: <20250319143027.359604491@linuxfoundation.org>
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

[ Upstream commit 26db9c9ee19c36a97dbb1cfef007a3c189c4c874 ]

Use skb_cow_head() prior to modifying the tx skb. This is necessary
when the skb has been cloned, to avoid modifying other shared clones.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Fixes: c8755b29b58e ("mctp i3c: MCTP I3C driver")
Link: https://patch.msgid.link/20250306-matt-i3c-cow-head-v1-1-d5e6a5495227@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i3c.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/mctp/mctp-i3c.c b/drivers/net/mctp/mctp-i3c.c
index a2b15cddf46e6..47513ebbc6807 100644
--- a/drivers/net/mctp/mctp-i3c.c
+++ b/drivers/net/mctp/mctp-i3c.c
@@ -506,10 +506,15 @@ static int mctp_i3c_header_create(struct sk_buff *skb, struct net_device *dev,
 	   const void *saddr, unsigned int len)
 {
 	struct mctp_i3c_internal_hdr *ihdr;
+	int rc;
 
 	if (!daddr || !saddr)
 		return -EINVAL;
 
+	rc = skb_cow_head(skb, sizeof(struct mctp_i3c_internal_hdr));
+	if (rc)
+		return rc;
+
 	skb_push(skb, sizeof(struct mctp_i3c_internal_hdr));
 	skb_reset_mac_header(skb);
 	ihdr = (void *)skb_mac_header(skb);
-- 
2.39.5



