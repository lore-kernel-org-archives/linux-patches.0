Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E67D1D54EF;
	Wed, 19 Mar 2025 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394853; cv=none; b=q+fZkKU88vv4Qo9E0OH6jCu8Sw1poF2b8ZsJmmLQNMRqssBE3XM4R5/iFKdPp0GRbzxhAVPJM1AOgwaamCsQgF2GrxjCAEaVd+aPzItdhxwzecDCritUesDfOtlrp1fktLFIEotvx1HZQ4hYRPQDYNR+zxo48T/kDXFPpgmwW+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394853; c=relaxed/simple;
	bh=op0fHuWkVAbsTkunmFFnElDJCZ4c/46CQonnWqq+0EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQ40Y4CrB/+KG58JJjXymfjIEjcloC353/FT/jFuiWoPF0iTFkfs6ERUDLWRmdaurwJuu0aHf4s4ZQ5XLnUFcAyvhdpJZRtmRD4I5APrZ8+w0978ifUOsBDEVHiMg3Aik3hh9PgahhksV2Y+setHA/ZM/PuuRf7YoQ/yogZzGlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjdaRwmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjdaRwmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4048CC4CEE4;
	Wed, 19 Mar 2025 14:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394853;
	bh=op0fHuWkVAbsTkunmFFnElDJCZ4c/46CQonnWqq+0EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjdaRwmcTTUfg5JxCsGnL7ov6gyQqVRzUi6kdHq0WoxgbqkFe0x7y8RLbPX/ODwNB
	 RPUMUrFdPyjaHZYmbfDq2UvTEJMZLIGdwMafPvTlmgLqV6BtO9qFTzOpK2jj6rtrkv
	 ZpL6d16uui+njsWG60bmtLg9DFdfPl4RGsObU3ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 023/241] net: mctp i3c: Copy headers if cloned
Date: Wed, 19 Mar 2025 07:28:13 -0700
Message-ID: <20250319143028.281741690@linuxfoundation.org>
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
index c1e72253063b5..c678f79aa3561 100644
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



