Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94473F660B;
	Wed, 20 May 2026 17:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296658; cv=none; b=Tigec/O06r1QtRHKhA+212lvlwn3y/2glZzma98NGKAQ3IJuEjI+jTA3sFpYjjG9D0tDNfr4y1be8hgS3sHTlxjAImOpn1bB/pqJ9qB1JgV+DqJizmgIrUnnPdeDKmcuEK3W39sQaoIl8L0TVKkCYiwtC1jY9QPhNvrsgLSHi2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296658; c=relaxed/simple;
	bh=OleFYEpppXabVZ/zr7Mn68p3Y5a2rXBjfyndeIWfaD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHT95EfWToIOQHmbgEcuMxwNCZLAT/VJ4+qSYpy7hFSOlfWe+a8jGFpkKmtgfuXNTaEKFXO8pJnyLl/EX0LB2lvR4qy8l4cWVtjhQSU6nlRCfRbQlfrJC0IwEoBJ0bpFDfk9neio8Rqi/NaGb69nXAUwkM8UBL1ERxtUCVrw6Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rs/02Tlc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rs/02Tlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048851F000E9;
	Wed, 20 May 2026 17:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296656;
	bh=Wtag2Ti3XBrrwdeDa2+4XAX0GvsZgK/3KOtLs1lQjq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rs/02TlcK56Fe1RwWRWN4J1UmiG63herx1qvJigj+jeQaGF2yEa3ihMmkX/oD4fml
	 HxGFM+vm5+hQ6nWj624jquusdQ0o7Q4AOypo2GrRhoOBRZHXB2mrJGx8GcE/cYGPAx
	 Speu6xEIVeNDXPQLETVFMmfXVJx6MvALxfXaMCKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0883/1146] mailbox: add sanity check for channel array
Date: Wed, 20 May 2026 18:18:53 +0200
Message-ID: <20260520162208.222230865@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



