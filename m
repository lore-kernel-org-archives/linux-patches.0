Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C351126C02;
	Thu,  3 Jul 2025 14:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554624; cv=none; b=HpxZ8Jr63S39R4XBLOTp/xBn+6QV3P1gbycZKAY9dLwSsUMCB6y8RuVWPZLdBVYkB1wxj4YDpW9nsu/mlmXb0vPa6wmyWopMbm2bwlJS2PkTjRfI1nN3dLEF3ZmeGgg4OarSIxpX+deEBtnUyMFDYjhXcjPfQ7Emz8Z4SlgBXHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554624; c=relaxed/simple;
	bh=B9ZKmT4EOBIWJOWwLu2wo4Y+EpPJiJ9QM2NkQlo9o0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCp7a+mh3F1OHFVYFD0x0PpeTQVUu8Ugq9EvXGPefPDFcl1pq7c5pSJdcbvVCimkf2cvJ/A3IQxj4p1nkBJpD+pWD0HI5DqDx7Kwaa/OrZNeSJUDVyqe1PLVJeIO6FGP8EdQmvHmdLcey0sfS9RYi1IpOpUO0QkJHTIAyYyuWqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7v1fgZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7v1fgZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71330C4CEE3;
	Thu,  3 Jul 2025 14:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554623;
	bh=B9ZKmT4EOBIWJOWwLu2wo4Y+EpPJiJ9QM2NkQlo9o0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7v1fgZe95WsgOWkgPCVaohrNL/gUVhoW8XMF6GXA96GIHnZRZaEJo2L+sUzHg76E
	 6pGNrmjr/78+wbeJTdGIf7oGQpWhaRZz5Pri/gNvDpULx30zvLhua+c431uYwWvPh7
	 X0gDOlyihF4b1Y3ys0k+X4aQMa8dmFUokPOc/Zgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 007/263] mailbox: Not protect module_put with spin_lock_irqsave
Date: Thu,  3 Jul 2025 16:38:47 +0200
Message-ID: <20250703144004.588637900@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0593b4d036859..aea0e690b63ee 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -486,8 +486,8 @@ void mbox_free_channel(struct mbox_chan *chan)
 	if (chan->txdone_method == TXDONE_BY_ACK)
 		chan->txdone_method = TXDONE_BY_POLL;
 
-	module_put(chan->mbox->dev->driver->owner);
 	spin_unlock_irqrestore(&chan->lock, flags);
+	module_put(chan->mbox->dev->driver->owner);
 }
 EXPORT_SYMBOL_GPL(mbox_free_channel);
 
-- 
2.39.5



