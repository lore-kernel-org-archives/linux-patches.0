Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AA33FD143;
	Wed, 20 May 2026 18:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302684; cv=none; b=KtiZ/xD3UOSKDOpgsen2QAFS0+RS91LCu+D6TJGlZCPmFyCoIcD4qE2vC+TfYGYlJtx26wxzQ9P5h8EYRkNnMyBtWX96T0Mf5/Lzirpwwp4zEXYd5pI32pDOsVXX/HaLQHUcTRaPiMyVsh+RPfnKN9hXKtfzGA+PejY+Pjhjq38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302684; c=relaxed/simple;
	bh=23lFkKuCm68dNyafpxKPgroithiXgy/KavqWD+SD040=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMkL4kdo/zgFZIWp9QoJWCw1as+Pvfh/yEvllMVMlpa31pN6MGV2M0eyzDvBungOztb/s+GzTFRxRtSfITUIBFnpPB3FIR96OMxLkNKhCsmAG7VvdxvHxgsorDIADuguotnmw9eoZTSo5vcVg5WQ7MzqUXLFAx83c0iQGO2ixhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqDAyCIK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqDAyCIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C19A1F000E9;
	Wed, 20 May 2026 18:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302682;
	bh=Lh1evdzMdyf/AIiwuU7Etx2c0BnP4exr79cq/sucQ28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pqDAyCIKk/ZFiBZ16evQ6cuT0u1Eqn/Q1ppoM82o82IEV8VLBX44xi+/Cxg1eUY7X
	 gKh2s7+D0/YQN0VJLt85jkoyGb//5zFn5cuqQGdSrmTrwLZUiN8yIe2WoETiD6GzY9
	 2eO6J2OBP/7EiPpD0bZ0hgoZuQbikcayqLhs+X/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 361/508] mailbox: add sanity check for channel array
Date: Wed, 20 May 2026 18:23:04 +0200
Message-ID: <20260520162106.452262758@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



