Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10E92D7386;
	Wed, 20 May 2026 18:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301316; cv=none; b=tF2umhUwuCwXcYFHRLczOT1jpVv90cUYhk3/wobhcyDUrY8PUqD32MDOwEzZUzVHrFd+RKxgn+oTv8/Z7Egwy12WBaJApoO8o9LalQZTNYfff1foAaCpbyDqyFGIg8pkzSl0i+7nc0EA090CeZnmlo8GjKT8IE8Mm68onti7mWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301316; c=relaxed/simple;
	bh=TDo+bd0QADoRQ984tNFjtE/J6Qfgne6JECkNYgRPlqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5/TUk+GppyURaXmFZvZIkQANjFvPmz8ojOR+COxZR+mvNY5a6GpmFSnGdkjiLq7XRPQYDhe0yQA4HEYa2lJ1/5Db6oq9t66Qf87CuahKHWyST3QnCA7kzARAaK6TEG4u9Y+VupKN8u4Roy3ZcCTbmqZYXXIUbD/XO3i9xRB6kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUODhMGf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUODhMGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620D81F00896;
	Wed, 20 May 2026 18:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301314;
	bh=rVVJIZOnws6mdVmRVMaa2Fcoy+FgdLwsYKdTHAO86/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rUODhMGfMJLKKxHaUPP6HLWT8zRl4lOR/I89+N0EoEN6cCvdC7PKQLTMH8OEXxWGF
	 42Dd2wq5msy2eK/s6UcJWa6D36F1Z1s2+gy3zqvQGJYfnzBYpB3ZIAiDHesQJiuy3t
	 /np8Caz903vflT0bGVlAASaR99Fu2g1Q7jyNuc48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 507/666] mailbox: add sanity check for channel array
Date: Wed, 20 May 2026 18:21:58 +0200
Message-ID: <20260520162122.253555435@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit c1aad75595fb67edc7fda8af249d3b886efa1be9 ]

Fail gracefully if there is no channel array attached to the mailbox
controller. Otherwise the later dereference will cause an OOPS which
might not be seen because mailbox controllers might instantiate very
early. Remove the comment explaining the obvious while here.

Fixes: 2b6d83e2b8b7 ("mailbox: Introduce framework for mailbox")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index b4d52b814055b..39269359e3a64 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -520,8 +520,7 @@ int mbox_controller_register(struct mbox_controller *mbox)
 {
 	int i, txdone;
 
-	/* Sanity check */
-	if (!mbox || !mbox->dev || !mbox->ops || !mbox->num_chans)
+	if (!mbox || !mbox->dev || !mbox->ops || !mbox->chans || !mbox->num_chans)
 		return -EINVAL;
 
 	if (mbox->txdone_irq)
-- 
2.53.0



