Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B37263F44;
	Sat, 30 May 2026 17:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161793; cv=none; b=hO1kFxi0E6S3S/Jv0XToWQ4qOwFCZaPCOfvvuPtniyZZFQg1t/2f6mBSp5c3VREJL4+pbYeKtqRsCUH/VHsrLNZwao1ldY/me1iAay5qvLmH69vsmnWfAhaNpe587q/Mv9FOJnH7VAqmCKKCtl/fooiVVaqrDgX3wlWatKKU+Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161793; c=relaxed/simple;
	bh=hDEk6Vt0Vju1otv4Iq1nLRHcDTNzQStNSlMXFL0+FGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQQZcbdBQESyDJKPEgdML5XSjz9NNuR3YgOqV2lraikMVrWqCrNdbFo3OK/kC2oUtYwBf+3aCmv35knEih6PlAdH8wFO9f2vdzxpDy5ZtX1y8S0h5lyIq06vlYVpAYdOgqc6RXGRr6I2AQfRKFHDZix8ZPqEU/6lDrsZtRCloZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPsPsPl3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPsPsPl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2431D1F00893;
	Sat, 30 May 2026 17:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161792;
	bh=g2mh84x+oTkOPa1ufjdMuvK+1ucfBU9dfhkkhIK3/PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPsPsPl3/G281JK3H15At+e+rx6ZrJGiuppC54nmyk745wbt9Nmmn5BrETMployRU
	 XWdqLm6YIVld4NYNM+QnBxFA3l3cCDtpHMLgrVoLnoSJnur3CcGurmFWri4vzwjOHI
	 SMxbbJUBqFCo5sf8+o5rwxZK+dgPKp6JENiIQZB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 727/969] mailbox: add sanity check for channel array
Date: Sat, 30 May 2026 18:04:11 +0200
Message-ID: <20260530160320.618769380@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ac8c162b689b2..c5b9d24efb69c 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -524,8 +524,7 @@ int mbox_controller_register(struct mbox_controller *mbox)
 {
 	int i, txdone;
 
-	/* Sanity check */
-	if (!mbox || !mbox->dev || !mbox->ops || !mbox->num_chans)
+	if (!mbox || !mbox->dev || !mbox->ops || !mbox->chans || !mbox->num_chans)
 		return -EINVAL;
 
 	if (mbox->txdone_irq)
-- 
2.53.0



