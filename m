Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242D92C11C6;
	Mon, 20 Apr 2026 16:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701261; cv=none; b=EKp6Shla7JbuSi0GV99DO7waYFQWaS15pGYwWwPAtyHYhk9EP/okeBnSvhjwXX/L17sSNKySvuSDFN3g1oVROFMNqGU0okbNwi7N5jofr2vt0vWSR9u0VTCQFlb9KRqEXYHRa+RE7jmUsYADJA+F19qhwVbDqvCeVrtYvFmq3zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701261; c=relaxed/simple;
	bh=yYVAYPLx5reyrC++WXtBL/zEXlahWPw6V6ZX2/PIUHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSi95X7Kfy0nTfd6pa+1mhzMHzvId2QR7TxF27ABYA8KsRXJpKqolYDDxUhfdBOy8PeDdnc6h1Mn510HChsx9d5CK+0umvbSMLr0cBBkwY5MVt2vhsTI2B16sNfOJrN3rQ17orr1VrNi9FjvDopsBrRMHvPTpNrIjdwFIAoR5JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqOEqrzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqOEqrzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3B1C19425;
	Mon, 20 Apr 2026 16:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701261;
	bh=yYVAYPLx5reyrC++WXtBL/zEXlahWPw6V6ZX2/PIUHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqOEqrzio+S/KdxNHRxdyMi/HxPlaf4vSiLcKpdv8kjZqaTPaBngryEzTs5tZQPh2
	 RB1wibRf1Jr8oGy9JAxph+prd4LuwKDvV8ARg3UjDaGrOV59zs82zQEtjjKAmITeRr
	 VEfmpzcDrei/9ehX+yBypJWD97fpWW323VOrKNn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/162] xfrm: account XFRMA_IF_ID in aevent size calculation
Date: Mon, 20 Apr 2026 17:41:15 +0200
Message-ID: <20260420153928.587622754@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Keenan Dong <keenanat2000@gmail.com>

[ Upstream commit 7081d46d32312f1a31f0e0e99c6835a394037599 ]

xfrm_get_ae() allocates the reply skb with xfrm_aevent_msgsize(), then
build_aevent() appends attributes including XFRMA_IF_ID when x->if_id is
set.

xfrm_aevent_msgsize() does not include space for XFRMA_IF_ID. For states
with if_id, build_aevent() can fail with -EMSGSIZE and hit BUG_ON(err < 0)
in xfrm_get_ae(), turning a malformed netlink interaction into a kernel
panic.

Account XFRMA_IF_ID in the size calculation unconditionally and replace
the BUG_ON with normal error unwinding.

Fixes: 7e6526404ade ("xfrm: Add a new lookup key to match xfrm interfaces.")
Reported-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 6aed7ae900130..9516655e92f19 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2601,7 +2601,8 @@ static inline unsigned int xfrm_aevent_msgsize(struct xfrm_state *x)
 	       + nla_total_size(4) /* XFRM_AE_RTHR */
 	       + nla_total_size(4) /* XFRM_AE_ETHR */
 	       + nla_total_size(sizeof(x->dir)) /* XFRMA_SA_DIR */
-	       + nla_total_size(4); /* XFRMA_SA_PCPU */
+	       + nla_total_size(4) /* XFRMA_SA_PCPU */
+	       + nla_total_size(sizeof(x->if_id)); /* XFRMA_IF_ID */
 }
 
 static int build_aevent(struct sk_buff *skb, struct xfrm_state *x, const struct km_event *c)
@@ -2713,7 +2714,12 @@ static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 	c.portid = nlh->nlmsg_pid;
 
 	err = build_aevent(r_skb, x, &c);
-	BUG_ON(err < 0);
+	if (err < 0) {
+		spin_unlock_bh(&x->lock);
+		xfrm_state_put(x);
+		kfree_skb(r_skb);
+		return err;
+	}
 
 	err = nlmsg_unicast(net->xfrm.nlsk, r_skb, NETLINK_CB(skb).portid);
 	spin_unlock_bh(&x->lock);
-- 
2.53.0



