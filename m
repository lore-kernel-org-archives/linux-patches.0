Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624622DE1FA;
	Tue,  8 Jul 2025 16:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993772; cv=none; b=FyOCZ4IjbayOdmU4E29rR3KGuutaJEhJOmn4W/uyx9aYaPIYdYFwRzZHUQSMqno9frEeEhO9+fmv218vqbuqYCLs+d7n9nLn0kR6nTwaaxaEjWeNyfzhZdMY8QqnGAK6jk80ivMVRkZiEZnjhpZvLhS0I+Y/u7KQzsWTwjgAgEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993772; c=relaxed/simple;
	bh=o78DTNbxZXtms7/mPPMmLDwK3EsbrUEgWbKVVQB7S1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzePh5nm6Uf5YkSYoZ51AUUqH9eMHjwOb3UdJltWjiq3fnyMgnkw0h12jPxLYvTynRO4UiUd3Zwrbgkwu4CEdWBD5U7BWKDl9xphFr5bGTl42cNjGIdZ373k9BdbE6JMVEwPd3rT7GG2eY/gvtHxMomuhfXsdZF9+iAq/WZ363Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCxXH62F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCxXH62F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF39C4CEED;
	Tue,  8 Jul 2025 16:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993772;
	bh=o78DTNbxZXtms7/mPPMmLDwK3EsbrUEgWbKVVQB7S1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCxXH62FhZgpnOl+PIxjwGeTNrJfHY7qdyfzgzApCpMWsxmjbMxvivTqCVPFtif7g
	 Mx7U0ob2y9AkT/9Vrnfx7/TfPST04hEmpUo3zLGoOeFK33YRWI7hCNRIFB6L1w+xms
	 OrIFwmilrZh7x+d9fpf+L4Lfcold+/dD3xW/X8es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/160] mailbox: Not protect module_put with spin_lock_irqsave
Date: Tue,  8 Jul 2025 18:20:41 +0200
Message-ID: <20250708162231.628895447@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



