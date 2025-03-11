Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEEA25D908;
	Tue, 11 Mar 2025 15:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705700; cv=none; b=tKy+V5L2y8i62YaQAEP+gRmqR4+4Nqj5RhBKXUWy5RTp0sMsQBvjtq9bjbOJW8aa7H6nVNRPAYPR2Qshq2o1GMva+d3uMrn+Pui+IpdkNvODEVMezgOsMiAJzGWJ9U/TV3PUEvkf0OLTwrwJP0UFUjEaT54McHYaNgM+J1fsJcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705700; c=relaxed/simple;
	bh=qhdHe21oNq9cCTRf62YcsANo0iRE3krjSlxhYIE5jZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouvNMKyarKZE2KyeSHB6O0jCyRvP49kSsxLKHcrQwMcwu+jtShOQu5CmjsNCKtc3aohDseuXrkp86iShPTlTfuMApg5G4uz3FIr5Mv8uiK3xzIFnyqlBYWXpBeS1B8Mrp11ZVHoxdQFUHvUlfeNAx4urxpBQsz8QZ2A/Y1LnWAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGk9IJiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGk9IJiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86640C4CEE9;
	Tue, 11 Mar 2025 15:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705699;
	bh=qhdHe21oNq9cCTRf62YcsANo0iRE3krjSlxhYIE5jZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGk9IJiH15HfBfLPmXzumWk+f+6PMrs3X1SCVpp5j5Hn2YeyzW836b7WgH25911ur
	 iMGbPtEJy8PjolGkdbVbNxdicdgS1oO6TzbybuYFUPhPNHrR3r2AADOgLNpafaupCu
	 Jg6yHJ6pLTlsHMTfwZZlCVA/svtkQSjamMSxBH8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Renner Berthing <kernel@esmil.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 105/328] net: usb: rtl8150: use new tasklet API
Date: Tue, 11 Mar 2025 15:57:55 +0100
Message-ID: <20250311145719.070654024@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Renner Berthing <kernel@esmil.dk>

[ Upstream commit 1999ad32d4ff00581007543adffc465694b2e77b ]

This converts the driver to use the new tasklet API introduced in
commit 12cc923f1ccc ("tasklet: Introduce new initialization API")

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 90b7f2961798 ("net: usb: rtl8150: enable basic endpoint checking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rtl8150.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 387091cb91340..cbadb53bac441 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -597,9 +597,9 @@ static void free_skb_pool(rtl8150_t *dev)
 		dev_kfree_skb(dev->rx_skb_pool[i]);
 }
 
-static void rx_fixup(unsigned long data)
+static void rx_fixup(struct tasklet_struct *t)
 {
-	struct rtl8150 *dev = (struct rtl8150 *)data;
+	struct rtl8150 *dev = from_tasklet(dev, t, tl);
 	struct sk_buff *skb;
 	int status;
 
@@ -899,7 +899,7 @@ static int rtl8150_probe(struct usb_interface *intf,
 		return -ENOMEM;
 	}
 
-	tasklet_init(&dev->tl, rx_fixup, (unsigned long)dev);
+	tasklet_setup(&dev->tl, rx_fixup);
 	spin_lock_init(&dev->rx_pool_lock);
 
 	dev->udev = udev;
-- 
2.39.5



