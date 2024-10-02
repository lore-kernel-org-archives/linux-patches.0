Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578E61D551;
	Wed,  2 Oct 2024 14:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880047; cv=none; b=MS0NJaNt2F3GdExbS+QjlenjodDdiKthbJjKFis0TriZSl0Fs+FNkqFjye8NkueIQ5guRMO+59eCD5kCKVF/G1hc6B7F9oQERAC2pNwjn8C032YGsqv1GhvbTwdnl6YCDEpcdBjkBCqj97uewNFkTwAfNjITUnzOQ0F20pU7Jmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880047; c=relaxed/simple;
	bh=CY55P4g2wRBCeA+vN4eg/uF7XZ+lxQFfmBB9M/ttFF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccJ+ml6i5vpYZBcX97JIzAT8+qdh8bmAdgWw7Il3MrqG5xfDLf9zHOWurjr6Z7y70eE3P9sRowDOIHIf55P25m/z5r/KFSkoOvzrxSzlTz6DR+DYhCgOlT2YJH1pPyDOpN+0312KJ0setxXlGDkBLRHhka6/iBm24AXu84bLEJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0knsuAIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0knsuAIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A3FC4CECF;
	Wed,  2 Oct 2024 14:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880046;
	bh=CY55P4g2wRBCeA+vN4eg/uF7XZ+lxQFfmBB9M/ttFF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0knsuAIMXkgFEJcv4ePQ1wzbXlBr1BBO+WqptxBm82nqA/qZA0bAiaXFvmQU1rqc7
	 3bcJoNGHmLV2JArSpBuW20+SsifI3OqdVt1mDsEW1ygVKY6eyh6f3YefWZr8C3jdSK
	 H0CFeQDxe4F/bIwgvandYR98xrBO9HWPt2iqkmK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 325/538] RDMA/cxgb4: Added NULL check for lookup_atid
Date: Wed,  2 Oct 2024 14:59:24 +0200
Message-ID: <20241002125805.258376799@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 040ba2224f9ff..b3757c6a0457a 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1222,6 +1222,8 @@ static int act_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	int ret;
 
 	ep = lookup_atid(t, atid);
+	if (!ep)
+		return -EINVAL;
 
 	pr_debug("ep %p tid %u snd_isn %u rcv_isn %u\n", ep, tid,
 		 be32_to_cpu(req->snd_isn), be32_to_cpu(req->rcv_isn));
@@ -2279,6 +2281,9 @@ static int act_open_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
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



