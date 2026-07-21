Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C341846D0AD;
	Tue, 21 Jul 2026 18:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659853; cv=none; b=bD00hxEf/k8mEKsAZ8LkX3tpgZtdoEXL5pBRNJtNYy7CjZxHOwrYFQ5b1ODn8DMbYUPYp5lFQXwzkVgVoRO5yytz5W73MNT/2SOn8qSPvv1F2D/vQt5ksCckvLSF5qeejTzrqTia2u9C7Dw35sV4F0x9TKJ14yZ8hGZn4pWS9NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659853; c=relaxed/simple;
	bh=HURnfMKAOCwHDxFVxNzPR6y9/OTmcpKcizoSAoJYbwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ie+7ZaD3jkRk2NHxXMkUY1oXuxFSUsgZz/xEjyx4hZRrGhqcDnrij8+sSo/W1bE2dsSrVY0WLz4Eb2u+HsJzDOu5f0/2FSwGPX4OGtoGdR2nRQb6LcGuXwHN1+uDCwSXSItIunxJQwIaaDtiU5/MI4eb+4e1PGX6z9Zw75nyFsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYCYQGLC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYCYQGLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97981F000E9;
	Tue, 21 Jul 2026 18:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659852;
	bh=eQxmHDM7+Qam2mnCuEjfVyAGpiyYKH9FPUWsovfVEAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYCYQGLCgWboHurBsA5mOjFUjGRcuhjRI3pv6K8bmtO8il/fXS/ZALzqoslQi3CjC
	 M9Qyoc2nWhiRsWqTjob8TFpMpGgUKnDOGgzDeOMBmOljblnI4wTtBkGcr3sCv2qAvz
	 8QLMR0TnW08x9Su46DHoYBTP5zgRrIrsJFvkU8oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0758/2077] net: wwan: t7xx: check skb_clone in control TX
Date: Tue, 21 Jul 2026 17:07:11 +0200
Message-ID: <20260721152610.667655469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 05f789fa90d95d5771230e78453cedff2486039d ]

t7xx_port_ctrl_tx() clones each skb fragment before passing it to the
port transmit path. The clone is used immediately to set cloned->len, so
an skb_clone() failure results in a NULL pointer dereference.

Check the clone before using it. If previous fragments were already
queued, preserve the driver's existing partial-write behavior by
returning the number of bytes submitted so far.

Fixes: 36bd28c1cb0d ("wwan: core: Support slicing in port TX flow of WWAN subsystem")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260612035613.1192486-1-ruoyuw560@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_port_wwan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
index 7fc569565ff99a..d2529df7592a7f 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
@@ -106,6 +106,8 @@ static int t7xx_port_ctrl_tx(struct t7xx_port *port, struct sk_buff *skb)
 
 	while (cur) {
 		cloned = skb_clone(cur, GFP_KERNEL);
+		if (!cloned)
+			return cnt ? cnt : -ENOMEM;
 		cloned->len = skb_headlen(cur);
 		ret = t7xx_port_send_skb(port, cloned, 0, 0);
 		if (ret) {
-- 
2.53.0



