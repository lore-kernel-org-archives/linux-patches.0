Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E829F2D6402;
	Tue, 15 Jul 2025 13:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586317; cv=none; b=efWRSSTisVeUFhBQLDuvIajqa2LUgHJX1rPLpB/+ssxbdUfWb5Ep3DhggiiKxtJ1Se4aERw9il1O09URw3QnWKsZMtFKb7jROG1cPDpm00u5+qFjywh3/MJTTGtrBSTY8lB+SzeQI4RQGkIr4TC9zR7y0fY7jjSLT+D9vkJaaxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586317; c=relaxed/simple;
	bh=344FI2j1Uw6yv9QHByEET6XU+zhPEMsAIRZCnfRP8yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwtpG6Hb6CiiNvtkZKaYkOJa18OhGHa0mMCcI8cMsvChuF6Cy1fs+HFh2ObCJqY1Bg3BIiU3poEVXsWDxs+cWtgigDvXEkRdjKgFN9Q5iffafDwhBMIkP5qMV19ehQh+trZ6ssIye3EjTxbR+vxcPX0XRE4FGoLgNd30JpxjP6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIfJB/eM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIfJB/eM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF66C4CEE3;
	Tue, 15 Jul 2025 13:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586316;
	bh=344FI2j1Uw6yv9QHByEET6XU+zhPEMsAIRZCnfRP8yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIfJB/eMfbWkXnC0jnZ7gpAVfD+t3W5QFdyipBiw2SJJsA/toMdZXoXO2IGJvpv0H
	 f72O860JYXkEBLHk6gx8DXkhAHCIs/lwAPGjtu87v4qV8VDo0+1eV+p2CREydnqBs+
	 jm4LIe+FukXs/8grzGN07iws5FuGx0pSZQFqRMAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/148] mailbox: Not protect module_put with spin_lock_irqsave
Date: Tue, 15 Jul 2025 15:12:04 +0200
Message-ID: <20250715130800.395507290@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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



