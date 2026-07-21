Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801463358C6;
	Tue, 21 Jul 2026 18:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657654; cv=none; b=ChFdfvMybwwImqayhgFoSTFrMcBMQsmmcLomrPsOY7f6CCPbhdQD+aEmjRKhSJvqvFJrfRuLb/i1DmGvB7UOE69LBqrn9EvVxPAhxMskAe8ofMgT8vhMi9lnERVxp+eDQy0A529HxU5hn48H1surW8Wq+Moik0XpcrKjzOratYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657654; c=relaxed/simple;
	bh=D9Llx6kye9OiPsgQ7x9BrqmtglXFA0xXJowhQRkAp98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtSPTK7Wru/I6WVahyLWvbW5VyIsuJI3vm7P/s2L4gF/SBumyLNmvYo7HQrkBdDxPyhhiug+Aa7V1ma9zH84uLjY5FNg2lsmUlEj57So11vbaCwdIaeW5HHpouP1eMfIAT7UaKqglutnFzK132zSFcQSCAL7ccsgQ0ffnYfu7sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKjaodxO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKjaodxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D3F1F000E9;
	Tue, 21 Jul 2026 18:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657653;
	bh=4kMzu0Wu9XENt2M+wy1MIwlTJLODEgGbcm9ZASHA9ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKjaodxO5B6Ti+rtaxINkdHPLc3XqaPqE0fYYgdracJEQ8gFeZ0JBSTj9wAhG1sDx
	 9lTGbKekgvmH5fG36ZqISkAzE0HUy2RImIltAIJOSPIoImXBaWvcp/MTMjm4Yocpic
	 helb/zdGeje9hjs/ePhI/Z3ex+k9d6oZpocCTUKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0847/1611] mailbox: imx: Forward the timeout/ error in imx_mu_generic_tx()
Date: Tue, 21 Jul 2026 17:16:03 +0200
Message-ID: <20260721152534.437008233@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 003f9236c35e09..a80cb2c9df6ee9 100644
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



