Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687993B6BE5;
	Tue, 21 Jul 2026 20:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666174; cv=none; b=gxc/c0s0fJeTlwvpzPXsHAlkUu0oj7SvPR8OC8wc+Ho9EirBd6IYZDjHGDCvbZRVxif3x1nmVU8eq1WK455+FaPhIn0D72MXs8ptglffYHOBOCXqYoRP5f06KhqQ8o8u9M2tBDkRlndVBzucf1Qvh8gBMr0Eq9y8KQaCAW2rTzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666174; c=relaxed/simple;
	bh=CNZKHkXa4C2UpV3K/U71Hw1EVayYlbmi0/gL3MKNTuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1ZkLaVA/g4ToWlyTAR6IXzGdOhh2+RaWFurrwujEStzjbAiUr1ejWFSZRP8OHoA8Bl4mt2pT5sM0q9acVBmvv7QkKIHb0GGj7s0GVKkLUu7O28RmyJIMHSNEDGuKHqdXIbRYlL/63IqgvbXcm98iwfkj5K6zvuCXKi+j2aXen0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/iaTJvR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/iaTJvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68AA1F000E9;
	Tue, 21 Jul 2026 20:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666172;
	bh=UjisezASq9N/FlO3dRhNpd3vlVTLMbHe5HvaKulAfzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/iaTJvRTFM7CQIUsBYF4OXwLlsbxiBecUWvdspiUwZ5r1JDKZsvh5MbT0fXj9i5Y
	 3EJuvw0sqqUQZXe0BA+C0oXZh6h0EcCb+znjZjy04l/8axa8GUd4FhBVJF4WeyvhvN
	 /TbBHSltzLy1kIRLyaQdWKe0zXE2fETwSChYsI64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0581/1266] net: wwan: t7xx: check skb_clone in control TX
Date: Tue, 21 Jul 2026 17:16:58 +0200
Message-ID: <20260721152454.867625469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 17389c8f6600a3..597a06e86f6ec0 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
@@ -74,6 +74,8 @@ static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
 
 	while (cur) {
 		cloned = skb_clone(cur, GFP_KERNEL);
+		if (!cloned)
+			return cnt ? cnt : -ENOMEM;
 		cloned->len = skb_headlen(cur);
 		ret = t7xx_port_send_skb(port_private, cloned, 0, 0);
 		if (ret) {
-- 
2.53.0



