Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB9C3F39EE;
	Wed, 20 May 2026 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299348; cv=none; b=jXZJMyc47zGSDvTm24cf54HhojwfBx6fwUuO+WEDiqY7FkxGrrf6EWc+m79YT/txCxJyMBDQHL3mVjCwBGdIzYv8faz+iyg37PSDe6wfJ2HqWEgx8bMcng9/MuL6FEsTjCDwejWxpbQscl1g70G2wCruQJz87bQdgAYpZFL+Bts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299348; c=relaxed/simple;
	bh=mRZfdbYwgEQb8v7pUCj3NudVx/8RzSZlN3ZpOILSE1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDi0t4u3MpolMiDySanF65gZfneRkriOU83zR1ERSZSxYHUZuvKeeE5FE9V+FZ2EdC28eqW1xEAFL2LN59JG4pCu2GtkCvUznfkzK5+4unpNFwvdCbBu38TkRCE10jEE3InGEqkV0bhPjJORtbSdv93fdZII5DYsmP82gkUU8UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cTK+hKl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cTK+hKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6221F000E9;
	Wed, 20 May 2026 17:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299345;
	bh=alYdLh4LgRgDkoCi4gJBqdIu5hiSfxozDaoOvDeb5JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1cTK+hKlr1Tetj1bee4QmCwfTxi3PXVjYizzWQWJ6FKtKIvRiaP7EfNoXN/eG8Dtx
	 SHxveQ8+NywhF6QjX8pxdldL7ckVeXIYog64ldlI6gPPJk4e2R29AhGQJGz9CYKwDB
	 Q2ZeeEn7EC78ISPUg1pZ2UQfGYHXPXx6PJKNiLDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 736/957] mailbox: add sanity check for channel array
Date: Wed, 20 May 2026 18:20:19 +0200
Message-ID: <20260520162150.521559110@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 617ba505691d3..b77162db509f2 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -505,8 +505,7 @@ int mbox_controller_register(struct mbox_controller *mbox)
 {
 	int i, txdone;
 
-	/* Sanity check */
-	if (!mbox || !mbox->dev || !mbox->ops || !mbox->num_chans)
+	if (!mbox || !mbox->dev || !mbox->ops || !mbox->chans || !mbox->num_chans)
 		return -EINVAL;
 
 	if (mbox->txdone_irq)
-- 
2.53.0



