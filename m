Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E162ED143;
	Thu,  3 Jul 2025 15:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555509; cv=none; b=SPcfdsKmIJzDKRJ2pzBIDLwp+Ys665jANCyd28CzX65RgCI8SE2/AnNnw49SdNEkggvpHiuiBqYV79AWcrxLF6TsHMXpAHtNTo2dmfikY9yjqA2WC1BrfrnpQUsc75XXZs0GTis7+nd66Xvp3HYOBDUkVuUjLQ+cJqHSy0vVkuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555509; c=relaxed/simple;
	bh=Rco2mw0jU5iwLsv6N/BocmTnW1DOQbM4HunamHDOVQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrGww1r/dVqWc1/MV9jiPyytOWoc4A+OicKxc4as9nV6QVLeD/LiKvJWv+trZ+l1R6jYokC29Nyc/YUHv0qfMIOt+p0D1HrJBN/yYYFqMG3L1CYvBurYPUIjNwBG9hts85RCwleipXrmpsPkPWkY/aiTEgdPd5b5lqz4RiN1lS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwqWqrWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwqWqrWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE169C4CEE3;
	Thu,  3 Jul 2025 15:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555509;
	bh=Rco2mw0jU5iwLsv6N/BocmTnW1DOQbM4HunamHDOVQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwqWqrWMoi3/goD/i2+r/MbOSwnF2Xh7RsX7cCiW0RdAr3LKoogcjmKX/bMXu7zTK
	 Z4oQAv4Zk0aElb+TsdJdwoR/YuTjWEbMuesEisiTuUcrLBk1dI/Sngg8I1S9U2yPiP
	 EvoXZHLxFYH06JbWVkb0lgDWO3rUQI1T19Rejcy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/139] mailbox: Not protect module_put with spin_lock_irqsave
Date: Thu,  3 Jul 2025 16:41:09 +0200
Message-ID: <20250703143941.429695460@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit dddbd233e67e792bb0a3f9694a4707e6be29b2c6 ]

&chan->lock is not supposed to protect 'chan->mbox'.
And in __mbox_bind_client, try_module_get is also not protected
by &chan->lock. So move module_put out of the lock protected
region.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index f13d705f7861a..cb59b4dbad626 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -500,8 +500,8 @@ void mbox_free_channel(struct mbox_chan *chan)
 	if (chan->txdone_method == TXDONE_BY_ACK)
 		chan->txdone_method = TXDONE_BY_POLL;
 
-	module_put(chan->mbox->dev->driver->owner);
 	spin_unlock_irqrestore(&chan->lock, flags);
+	module_put(chan->mbox->dev->driver->owner);
 }
 EXPORT_SYMBOL_GPL(mbox_free_channel);
 
-- 
2.39.5



