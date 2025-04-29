Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13059126BF7;
	Tue, 29 Apr 2025 16:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945412; cv=none; b=ndvNcdonlv4lNJYjk9yt1VGq/u7oqwFvf8NvxPCIkXMT6L9u9vP7kRlr/LhljYs9ucs48lWKOqCSM4mQE8trZrVusOaRcEypd1iunlHtio+87kQQFGA1OSeuv81RW0vwKiABiJQFQcZbIshOfiCPfD3zGfLQDwBu90yrYdvmF68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945412; c=relaxed/simple;
	bh=G6ulf52i+UGO8vrquq55V5U09biQjSKzChapjHkd8Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eis+VZLwrAypZc7v1+3kRfGyRoBoKmtzEeFxv/Ky6DXBtkGYY3Bj/PIrMZzH9Q/9ObIf2UK2s0koDuBKuuLdQPXyHuHbYfuY55O0xxRwn0R6iCeK4w8xTbu3Qm1XL4TXCc9QwJrTrY5gJIFrcPC3Qk2S+VvWe2y8CoI9y6qbEZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SW7AWOOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SW7AWOOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BD8C4CEE3;
	Tue, 29 Apr 2025 16:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945412;
	bh=G6ulf52i+UGO8vrquq55V5U09biQjSKzChapjHkd8Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SW7AWOOycSPiVLF+aDnuBFxS+zSmDB+ZK1K0uaJzOI3WRKhqhp9WpJHqOaX+u1gfm
	 H4V95ENIhBgJhnbKevak3IzEIFm7tbtt28mGXax/xhxPwvFNqXJADM+iyF2ABih7yv
	 z7uHWYi6jtiuxgpT8zvzbOr6g2jTJR+6Qwn+mQuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Michael Nemanov <michael.nemanov@ti.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/179] wifi: wl1251: fix memory leak in wl1251_tx_work
Date: Tue, 29 Apr 2025 18:40:27 +0200
Message-ID: <20250429161052.881697150@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit a0f0dc96de03ffeefc2a177b7f8acde565cb77f4 ]

The skb dequeued from tx_queue is lost when wl1251_ps_elp_wakeup fails
with a -ETIMEDOUT error. Fix that by queueing the skb back to tx_queue.

Fixes: c5483b719363 ("wl12xx: check if elp wakeup failed")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Michael Nemanov <michael.nemanov@ti.com>
Link: https://patch.msgid.link/20250330104532.44935-1-abdun.nihaal@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl1251/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
index 98cd39619d579..5771f61392efb 100644
--- a/drivers/net/wireless/ti/wl1251/tx.c
+++ b/drivers/net/wireless/ti/wl1251/tx.c
@@ -342,8 +342,10 @@ void wl1251_tx_work(struct work_struct *work)
 	while ((skb = skb_dequeue(&wl->tx_queue))) {
 		if (!woken_up) {
 			ret = wl1251_ps_elp_wakeup(wl);
-			if (ret < 0)
+			if (ret < 0) {
+				skb_queue_head(&wl->tx_queue, skb);
 				goto out;
+			}
 			woken_up = true;
 		}
 
-- 
2.39.5



