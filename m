Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12457470102;
	Tue, 21 Jul 2026 19:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662892; cv=none; b=gV9+1jIm7b5/hPgrIKktK+KVZoXsRWbfSqFqBDjF5pkH6FZJ/pc/QibWhXOjQsS7ulP9hTWV9kjQSM2cpd0pGPMKM0mIiJEoFwGXPTkks11gvZRt7Y0vrSp4QFuYaFg7lt3mIbT+1HmwaZGHrIhu6xx54ggirHgTFEbnxuB9Xl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662892; c=relaxed/simple;
	bh=dIEGLlk2FGacQOqYGGUjDH0L4NqQxtCsVjXCKqmCP/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgV48XzWqmSEILeK2fy/GVev6cYu3Hfi6cqu/0uI6qVYpam3zuhLIM8nSJCCeyDcfvBxE9tEXB/aKpMEkUUieyYRb/9PDxkZkUjxBKWEgw1Btut8ss0hRQ8mKBMNbkoqebewelZCfxHr1qQK+FdMv6IojEQSI7MeNbuDHTAFCsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+ImfWVg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+ImfWVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AC41F000E9;
	Tue, 21 Jul 2026 19:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662891;
	bh=OUS5p/E/N6VML9NxuAUBuze/oG10SuMt0EPFYFpMJyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+ImfWVg3lXj5ubwl5/vpdJVi8rEwI+NYBEzSEV9EO3Gco6nWImxpmKuLZsphwBTu
	 xC4/+86wKkjor4yGxuH8xWm658F9HoBGtHw2xly81cUov+FMwFZqMpIrCgdZQUizZC
	 LwMQX8UZJ9mfqHaZ3U72UosVJbak3Noo0vzeOZBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0599/1276] mailbox: imx: Forward the timeout/ error in imx_mu_generic_tx()
Date: Tue, 21 Jul 2026 17:17:22 +0200
Message-ID: <20260721152459.519692641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 82ef9a635d7130ca27ec9dd88c16afc39c83a4e8 ]

imx_mu_generic_tx() for the IMX_MU_TYPE_TXDB_V2 type polls on a register
which may timeout and is recognized as an error. This error is siltently
dropped and not dropped to the caller.

Forward the error to the caller.

Fixes: b5ef17917f3a7 ("mailbox: imx: fix TXDB_V2 channel race condition")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/imx-mailbox.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index aa9a299859d6a0..056c71ec97d1de 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -229,6 +229,7 @@ static int imx_mu_generic_tx(struct imx_mu_priv *priv,
 	u32 val;
 	int ret, count;
 
+	ret = 0;
 	switch (cp->type) {
 	case IMX_MU_TYPE_TX:
 		imx_mu_write(priv, *arg, priv->dcfg->xTR + cp->idx * 4);
@@ -261,7 +262,7 @@ static int imx_mu_generic_tx(struct imx_mu_priv *priv,
 		return -EINVAL;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int imx_mu_generic_rx(struct imx_mu_priv *priv,
-- 
2.53.0



