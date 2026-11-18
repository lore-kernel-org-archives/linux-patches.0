Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055338;
	b=f8pqYK1ONmWtY5IvQqL+hiylvBzJEhvPMB3VN9CjS4I1JfvY+Nv9Jrl5Vr5Rja6aeAqy
	 ougskSea8N0+kpJiXEQXo4lCkTFvjjWobAgeiT9gkL+JamPkhiLXYov7JwHCpMwJMRK8Z
	 uzHhTNmJVPW1EXMF0vhdw94p7v9ZEqemNno+ZUMuyUlxTqeGxbMTgzFdNw8AogmXURRNY
	 Phs798QL7J1+q9nCUMMeC1EJffxKqWo8ovr18UUMm46UTkCYBUqBHA5M7k4t9M6f+6uGX
	 KWsFEam+20PnBpkP6LSIeC8I/EZKAsduSlx3XsSYq2RnmpDoZ08EYs3c96sv5IZS6Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c7h5ZqsGLvG28WidCIfkAxj44dD5qNm4QCkkijFrVHY=;
	b=1BwbERljF3n33QhHWIF0dS/zZIlMEjHDeYX+wnseaIy+79UhJ5FRZ7Rzxq7zvNd9GPsv
	 gKeaLuTFr6mNf5Ff4iItscjHqSQy/Bs6WuJlqMCxVQZorVkDPzrG6beLBIQGvIZ68BsdC
	 kTULjY+gJF5lpiT/Ovl6648cqNkkZtdrTXMwUMsIlDeUTifZVkBftobrK5nNX/sMKYAYZ
	 ztAUwdaJ4Ise9cRL+oL5vsnTixgpbZYchSnDH9zGs30rS6DQJZyaRvwNFgUTMrgX0oqOJ
	 Rw3vkbmybj7YYU3TK7gjXmcyPR25c1Bso74zCm3d3QATMCZTWfzcnY7W7Vma79mm4fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NDqppLvp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44508606A31C;
	Thu, 19 Nov 2026 02:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NDqppLvp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5385E1F000C4;
	Thu, 19 Nov 2026 02:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055337;
	bh=c7h5ZqsGLvG28WidCIfkAxj44dD5qNm4QCkkijFrVHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDqppLvprE9hZD7qkt6MWF/AZGxxfQPgUQ9GOaofzy7Y+QQ2kr83ur2XPztafsNUK
	 xs7ASanMi+lTimic2ViuTtiz76P2wzEpL+b9BBfBttkzr+9MA7zXKzpvbLbx+IC17w
	 pdIpG6y8y9LiVcvntPwysGDOZHry9WqLorAgtqHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1555/2214] RDMA/cxgb4: Fix neigh reference leak in rx_pkt()
Date: Wed, 18 Nov 2026 15:53:51 +0100
Message-ID: <20261118150114.304815898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 5fb3051aa4611ae18e304814fb1b74a30065fd85 ]

If ip_dev_find() fails on the loopback path the code jumps to
free_dst without releasing the neighbour reference taken by
dst_neigh_lookup_skb(), leaking one neigh reference.

Release the neighbour before jumping to free_dst.

Fixes: ef42520240aa ("RDMA/cxgb4: add null-ptr-check after ip_dev_find()")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916183530.2092534-1-vulab@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 3efd06d5f7e70..2d651fce63f92 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -4162,6 +4162,7 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 		pdev = ip_dev_find(&init_net, iph->daddr);
 		if (!pdev) {
 			pr_err("%s - failed to find device!\n", __func__);
+			neigh_release(neigh);
 			goto free_dst;
 		}
 		e = cxgb4_l2t_get(dev->rdev.lldi.l2t, neigh,
-- 
2.53.0



