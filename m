Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F59DF71;
	Wed,  5 Feb 2025 14:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767141; cv=none; b=oGBEcb/dx7I5cdrmGXyiBvBftroXt1rUVFy+RBtl//WM1VB0VJ4ZDzL4n37TZlDWYYmS+/MS4w6vMUikZkpzH5mhkCibrbYkAbW5KMMNZGwF9OvAKsCy+Tm1GigN9KXzlga78/vqvm6QHGp1TMVxPKEL+LO+Dmw+YjCfCK9BsnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767141; c=relaxed/simple;
	bh=fof3NXma/IDYEnxVkeCFyM4SCb89SBpWXzO2nEd2jfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChsBty5dhWeWNeUmf9ggLG1siRdsFPqKMJvRKQP2a0B7hOgu27xBt+SqoEU33A2FQrHOGgPfg+3VO+s9yoU9v4v+watkSaPbnVJDMH66ASGHIWlLFkd9ahXYlus8cWuP7vgdSATaO3gf77OzoJlFNSuHBB8uSBufeAKox4gEfkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPv0UhKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPv0UhKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EAEC4CED1;
	Wed,  5 Feb 2025 14:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767140;
	bh=fof3NXma/IDYEnxVkeCFyM4SCb89SBpWXzO2nEd2jfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPv0UhKuzFPQYAL3b7mYaL3hcpVM+8YITpBXVwvHMTAofWSQReK5mwX8YfEGKFGjk
	 GParsDLRcNhhkrveYf9pGMk50PO8cpVxLA+H6bOGOIjAC9FO2kJkCjTO9b5k76498q
	 5gs49cL+iVs0uXSZrbXkmThxiIhxvORBbch+miKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 344/623] rdma/cxgb4: Prevent potential integer overflow on 32bit
Date: Wed,  5 Feb 2025 14:41:26 +0100
Message-ID: <20250205134509.387430370@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit bd96a3935e89486304461a21752f824fc25e0f0b ]

The "gl->tot_len" variable is controlled by the user.  It comes from
process_responses().  On 32bit systems, the "gl->tot_len + sizeof(struct
cpl_pass_accept_req) + sizeof(struct rss_header)" addition could have an
integer wrapping bug.  Use size_add() to prevent this.

Fixes: 1cab775c3e75 ("RDMA/cxgb4: Fix LE hash collision bug for passive open connection")
Link: https://patch.msgid.link/r/86b404e1-4a75-4a35-a34e-e3054fa554c7@stanley.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 80970a1738f8a..034b85c422555 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -1114,8 +1114,10 @@ static inline struct sk_buff *copy_gl_to_skb_pkt(const struct pkt_gl *gl,
 	 * The math here assumes sizeof cpl_pass_accept_req >= sizeof
 	 * cpl_rx_pkt.
 	 */
-	skb = alloc_skb(gl->tot_len + sizeof(struct cpl_pass_accept_req) +
-			sizeof(struct rss_header) - pktshift, GFP_ATOMIC);
+	skb = alloc_skb(size_add(gl->tot_len,
+				 sizeof(struct cpl_pass_accept_req) +
+				 sizeof(struct rss_header)) - pktshift,
+			GFP_ATOMIC);
 	if (unlikely(!skb))
 		return NULL;
 
-- 
2.39.5



