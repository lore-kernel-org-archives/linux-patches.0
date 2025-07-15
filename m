Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4AD2E3AE9;
	Tue, 15 Jul 2025 13:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587477; cv=none; b=sqszngoHbGq4yzC4mXBDozKxydTiuGqh+nSJURs17AD/tYERpVOJaFizRjX27xxP0on4RHNfPcxbrcwjWs1Mb85yHC+F3UISW2gPDA1N/cdMzyF3PwI1nJn4CQn8Pl5I7gLXZQjGHEM8Qn30zC7KNDtqhYc9xRxD5pONSWAVKeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587477; c=relaxed/simple;
	bh=oGZRDYXYPWBlhNuHKvwnOkOb0Da/2PitfdoFSI0CRRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyPmS8SiqAhAU0h2Pv1+Zho9537ZOZ1NZyLfmu7VaNO22vRuU+ebgvCy5IVHGdn46ruxvE6m6NJAK8x+WWEi8+mjkgCMLTcQxE34j5Vp9c8Esjc8ku/rPqTzstrdp6arWwQp0toieKYqNK3ukNWltTn2VqeJAGl2qZdm/cABZIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMQm13dI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMQm13dI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED4EC4CEE3;
	Tue, 15 Jul 2025 13:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587476;
	bh=oGZRDYXYPWBlhNuHKvwnOkOb0Da/2PitfdoFSI0CRRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMQm13dIuFydmapAJh2rytLBcln10GUjo2KAzRLNiHQZiKmnEgXAnicBk+aM5wnk8
	 NwqAY1Wdrcd52rpy9bMEDphxK3zCoRSncSRUAiyX+VlfjEzxunzSFVzynyqdkeMcgA
	 J9C6FmhtJ1qRPbMtVm+Zo5u6/0JwbmKG73qLY14M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/208] mailbox: Not protect module_put with spin_lock_irqsave
Date: Tue, 15 Jul 2025 15:11:52 +0200
Message-ID: <20250715130810.972534538@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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



