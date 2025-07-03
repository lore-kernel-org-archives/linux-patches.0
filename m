Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C6B2EF28C;
	Thu,  3 Jul 2025 14:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553933; cv=none; b=mESxugjK7YlGGHwLsvkZfFrx/gbf0k52HXAKCGRHq8lNQx63kO1IslVXeCbvWtcDzuAqpoGDbQZ+bS0yHDgRZWVl1m0D1Cly+TxnhM4C9mEkVc0DR+8exG+rOkTTdhUcYX4b3MF1dIdF/PIzOwwFM/0ekIkOo1XCDtg47Gqts4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553933; c=relaxed/simple;
	bh=vX5uxkpKnGjmNx6dQUIukU2uNLzXJw7Ix0f7qxIOdYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdOSkcRLnbAnvRTGgybClt7NTJEZ+MjYoQsnVyFdEU5bZigShXsKMuj1hw6v3j6cGlX/Fj9FBL4ifBN6ZPXt8IbnVFG1+cz9H897B4wfD9z2oQtvXzF1BBV6238BuNonEjizwFFPIlyaUdac+A1E+3DWt3ah42pev1Jxf5HMa9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVwu1OEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVwu1OEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A20C4CEE3;
	Thu,  3 Jul 2025 14:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553932;
	bh=vX5uxkpKnGjmNx6dQUIukU2uNLzXJw7Ix0f7qxIOdYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVwu1OEYQFa5lAD1Kj4wUFHpMc6BVEz1TfjWfNOQvkRRCfopeQQopSY2VIs1mr+Ud
	 irlxch5ThGs2FMCfwd5Xopds9m9vV9K+q4h452JcYQ1i/7Q7bz9IDfTvk8C0D5Er5w
	 w3SHFilmskbgBcUtY4y7qkCW8XEBcMEuHX4qaApw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/218] mailbox: Not protect module_put with spin_lock_irqsave
Date: Thu,  3 Jul 2025 16:39:15 +0200
Message-ID: <20250703143956.250486984@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cb174e788a96c..92c2fb618c8e1 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -490,8 +490,8 @@ void mbox_free_channel(struct mbox_chan *chan)
 	if (chan->txdone_method == TXDONE_BY_ACK)
 		chan->txdone_method = TXDONE_BY_POLL;
 
-	module_put(chan->mbox->dev->driver->owner);
 	spin_unlock_irqrestore(&chan->lock, flags);
+	module_put(chan->mbox->dev->driver->owner);
 }
 EXPORT_SYMBOL_GPL(mbox_free_channel);
 
-- 
2.39.5



