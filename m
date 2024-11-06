Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F6D1D416E;
	Wed,  6 Nov 2024 12:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895139; cv=none; b=gcCy1/DUYiPwDGXnUL/1sYipTxdnTbznKq/0sT3OGLZZK2pW4fvbl8Jr2YS/qw6DowxkoI+YRoxrfHhCBCyNkM6d3rjy4Ra6XNObstJOznReFOkxGEttpe5tgGos3BEC/WxywPDPJK8xz1FVpEVCdnhYRhJE96zTxmiKDB9uTK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895139; c=relaxed/simple;
	bh=y4Oc5Yd9pM4ProhXTNNhQTos1SHSBQchzpBEZnbHfn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7I+RqPBeBmeY36Z9VXIl5QgWPx077ebDudLUtFXeLs3huQpoxeIqeUCdSCXSmAPQwVbugy0329CB9Oi34d+/V0fXPZ3aF58cX+QLzMkS2ksfQC7ACsDiK/608AHO+bAMvYSKLU8GdabjKdBGCgjP1lPv9EH+ZPs0YLkJDykhjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLGCIj2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLGCIj2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2320BC4CECD;
	Wed,  6 Nov 2024 12:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895139;
	bh=y4Oc5Yd9pM4ProhXTNNhQTos1SHSBQchzpBEZnbHfn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLGCIj2CrVUMMpeeLNX44KBYIT+Kjdgsg1SMW/qwJvCjMOw5W1n53rL55NMneKyEN
	 fcBJm6N1tt7jNYw8ctS0hfjwmWS9j3piJomfok0+GL97KhIyd4RMh5ZVd4JqFS32yX
	 bmITaSKykrp2nuSxY3bidQAlHMoK98SSTvzZoB9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 091/350] RDMA/cxgb4: Added NULL check for lookup_atid
Date: Wed,  6 Nov 2024 13:00:19 +0100
Message-ID: <20241106120323.147142555@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Lobanov <m.lobanov@rosalinux.ru>

[ Upstream commit e766e6a92410ca269161de059fff0843b8ddd65f ]

The lookup_atid() function can return NULL if the ATID is
invalid or does not exist in the identifier table, which
could lead to dereferencing a null pointer without a
check in the `act_establish()` and `act_open_rpl()` functions.
Add a NULL check to prevent null pointer dereferencing.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: cfdda9d76436 ("RDMA/cxgb4: Add driver for Chelsio T4 RNIC")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>
Link: https://patch.msgid.link/20240912145844.77516-1-m.lobanov@rosalinux.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index e8d2135df22db..f9ea863a80885 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1180,6 +1180,8 @@ static int act_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	int ret;
 
 	ep = lookup_atid(t, atid);
+	if (!ep)
+		return -EINVAL;
 
 	pr_debug("ep %p tid %u snd_isn %u rcv_isn %u\n", ep, tid,
 		 be32_to_cpu(req->snd_isn), be32_to_cpu(req->rcv_isn));
@@ -2235,6 +2237,9 @@ static int act_open_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	int ret = 0;
 
 	ep = lookup_atid(t, atid);
+	if (!ep)
+		return -EINVAL;
+
 	la = (struct sockaddr_in *)&ep->com.local_addr;
 	ra = (struct sockaddr_in *)&ep->com.remote_addr;
 	la6 = (struct sockaddr_in6 *)&ep->com.local_addr;
-- 
2.43.0



