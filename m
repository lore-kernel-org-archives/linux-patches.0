Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496562EA46B;
	Thu,  3 Jul 2025 15:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555952; cv=none; b=BKRitI6RiXTrplpry48lZCXSEHcfsXUANdBu5KTFwKSkMc4XIXlQpYAdjAXuBAtfjNYacRT1tIejSu9AXUy8JaEvNzDGuSvxcEtrM3v6l1IVogs1uLu5SN+5saml303R7a31rdVVk49iyYZVkTT0tqQ/2IBX1bWKGIjlNLsFlh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555952; c=relaxed/simple;
	bh=H+BP69rgNvMPCVQACW+y3Zpf3KystQs1L4BUgDGdXZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWtVLGpVsYa311efVTvqxZqUYNIiY19moKC84/B12iYbSiGyW0cNIaFXGKQ1P9oebnKfRwHbmjvVcJAQLh09shumqqc2T1GO5W0h81egDzcs1qXuslGxdo11hOSyQOUE/Bez7HG90RDwev2tF5Pyn3qO6RkRSxWROhy86O8WzjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=py1ilsAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="py1ilsAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F7CC4CEE3;
	Thu,  3 Jul 2025 15:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555951;
	bh=H+BP69rgNvMPCVQACW+y3Zpf3KystQs1L4BUgDGdXZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=py1ilsAeYMnrti9df5ptxVOd93y6FldYmMJQL7o/p0cBYOGrRKpmquFu1Llxb7gdb
	 xO3Q5cGXT82x7oSr1gqO+qWQM7F9S7E9ozt/lQp9WnZ7zSOw9su1MFdFqi12lfX9LD
	 P+b/LLT3QVeqHdPNV2nT+gy3aJOTEoE1NQGw/rj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/132] mailbox: Not protect module_put with spin_lock_irqsave
Date: Thu,  3 Jul 2025 16:41:34 +0200
Message-ID: <20250703143939.596504104@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6f54501dc7762..cb31ad917b352 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -459,8 +459,8 @@ void mbox_free_channel(struct mbox_chan *chan)
 	if (chan->txdone_method == TXDONE_BY_ACK)
 		chan->txdone_method = TXDONE_BY_POLL;
 
-	module_put(chan->mbox->dev->driver->owner);
 	spin_unlock_irqrestore(&chan->lock, flags);
+	module_put(chan->mbox->dev->driver->owner);
 }
 EXPORT_SYMBOL_GPL(mbox_free_channel);
 
-- 
2.39.5



