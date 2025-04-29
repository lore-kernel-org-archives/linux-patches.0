Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E2B244683;
	Tue, 29 Apr 2025 17:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946991; cv=none; b=kznh+VqzOL1T+TIjvwGAUy0hp/viBtQs4qXaiqSDX44k6xuhJ8camYcRvZ5rDEEosF8/svPhvo08BR2W/Oi8wp3j0ESsZ6JVSsXtzfIQ1LNT98OPeQmUmkvidTpR/gYPis5+Mj6ZMduLo/kLHPE0YnITpJHvVr+bjfDNJUdh2mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946991; c=relaxed/simple;
	bh=s2OqyQrj31sv2ekquy/fu7OdAkzgF+N3q4WKu8oQ+oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEj/2F/O7QjNlK6OSDqUqLkAHVceBGKD+tjOxP3LcEbtMypf2sTX3gmXRE3NY4o3rqoJ+jYu9B537HcOeBt0p07xCeDV5fC5970t69saWbX8BQ97z6SvlVTOZh3LhLnqNcL6DiCt442e4uCCRSd/iRxbQCKqWPJmwao+1IOfBx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9DUgj6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9DUgj6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD258C4CEE3;
	Tue, 29 Apr 2025 17:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946991;
	bh=s2OqyQrj31sv2ekquy/fu7OdAkzgF+N3q4WKu8oQ+oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9DUgj6Y2yV7pca8U4SWIY5vZ1IhAkrcmGcr7c0xDx4sh1Meyyk527kFlY+zNpoX1
	 7ZOB2aESd9Wt+dIRHiYHVvonu8PJw6J0hZu5r9dAn8+srKhV1DcUF6G5GFcSZN2ld4
	 4khrpA33J61E93yG6crVLUj4RoeFIGqiy+g0KOp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Michael Nemanov <michael.nemanov@ti.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/286] wifi: wl1251: fix memory leak in wl1251_tx_work
Date: Tue, 29 Apr 2025 18:40:09 +0200
Message-ID: <20250429161112.176081045@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



