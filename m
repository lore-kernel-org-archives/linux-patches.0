Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695EB3AE18C;
	Mon, 23 Mar 2026 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274943; cv=none; b=U73fAjh9TYa+JA2HnYV2EnJq7Wcba5VIGlLKQ0T0H2w1xi/HwIJ/HdFDF8jnYoxz43P+YF2JpH4KblJGV2Sm9+awH96F7xb2LO5rcvnThxBYgXXq3t6uO5bRGub/dIDZHqcv2wp+k0FFuyPj+bPmtuWjIw5Mmpl1JVIgGa8dyD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274943; c=relaxed/simple;
	bh=C7LyFwxtZ72f/usbSW5jayaK48ULsLcks4Db9WGOFOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQdgsSeuVGKpsQDScnxdMvgzXeH4G9CQKm1xBRzHuNlU2keqxgy54/2Kk/fU7j2D0Ukxib5jrKD+FR3eGZFQJ32f+L3R9ugo+VZexDmzGmjikwvZwaEu+EkaYNu2NnFpf95S4Jw0doiHCVaU/dapt2BvIYoMS02cag8SUegCkfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COFQyD+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COFQyD+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA82C2BCB5;
	Mon, 23 Mar 2026 14:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274943;
	bh=C7LyFwxtZ72f/usbSW5jayaK48ULsLcks4Db9WGOFOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COFQyD+6QG5m23dhGPedwLdWhCmI+pcN4kstb7Yr900tjcahP9MlpPlnVIPRNzuo+
	 9k+eoappqGAJn/aTi3fsa7Zq/ZdNtJC4nNZTF8la/A50eDlzwbOFYWh/9IyVp4wqdG
	 tg8dQRtKKFvi/TK9ehDJL/Cph5z+8bGpcJfsSgiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Atwell <atwellwea@gmail.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 164/212] netdevsim: drop PSP ext ref on forward failure
Date: Mon, 23 Mar 2026 14:46:25 +0100
Message-ID: <20260323134508.916705622@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wesley Atwell <atwellwea@gmail.com>

[ Upstream commit 7d9351435ebba08bbb60f42793175c9dc714d2fb ]

nsim_do_psp() takes an extra reference to the PSP skb extension so the
extension survives __dev_forward_skb(). That forward path scrubs the skb
and drops attached skb extensions before nsim_psp_handle_ext() can
reattach the PSP metadata.

If __dev_forward_skb() fails in nsim_forward_skb(), the function returns
before nsim_psp_handle_ext() can attach that extension to the skb, leaving
the extra reference leaked.

Drop the saved PSP extension reference before returning from the
forward-failure path. Guard the put because plain or non-decapsulated
traffic can also fail forwarding without ever taking the extra PSP
reference.

Fixes: f857478d6206 ("netdevsim: a basic test PSP implementation")
Signed-off-by: Wesley Atwell <atwellwea@gmail.com>
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20260317061431.1482716-1-atwellwea@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/netdev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index fa1d97885caaf..06446b03cd9bc 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -109,8 +109,11 @@ static int nsim_forward_skb(struct net_device *tx_dev,
 	int ret;
 
 	ret = __dev_forward_skb(rx_dev, skb);
-	if (ret)
+	if (ret) {
+		if (psp_ext)
+			__skb_ext_put(psp_ext);
 		return ret;
+	}
 
 	nsim_psp_handle_ext(skb, psp_ext);
 
-- 
2.51.0



