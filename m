Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B7546D2D2;
	Tue, 21 Jul 2026 19:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661014; cv=none; b=bXZ8DvjcRLDcDK96XO0TSb5+WKGltgDv4gme/qCzkInvJ04Z12vURP6ns6xYkbyOecsE8LXfoAIweJCo6m26midTd7QsnatBUWFDyal7U//hCBHccJL4p9AbHmtypwY/4EePtX8H2g3GAoUl1ghFteSgxmtgz8zPvjvuP2WoaP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661014; c=relaxed/simple;
	bh=3as0GrVCRaxo1xUgBDgJlWIktrmS8pqI1zqSuphh7c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oo9YBIlNAde7001Agk7WTz3qFYCksrkd/SCHz4X9gIIF+VwhCze+ekkk/754PrlXMjyWphid/rDCUgkyHmshO5UxjA6rJ5ErVOUlcdyxfJ9s/N5EkHtKUmHT3w9B4aXpYixX2qrlNeGP8IjHzgOQDGHJDWq9BxMSn9tKKGTpML0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKZl8RPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKZl8RPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E41D1F000E9;
	Tue, 21 Jul 2026 19:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661013;
	bh=GBpOTxuUGENdEYpJsFBbOPcogrUUp+5abky5KrqlbPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKZl8RPuA0X5I420YRJ+bx1wwyF427wSopbWLg0fRrbsLTj1xUqTRdErt9GuhUB6k
	 kG5bjTPHfZjBu98Zc9Zh6y92cjjmb0DLP/Gvb2ncWkrctf+2L1Ytedg00Cs2EgDNVQ
	 lAnFz3T7cZSJFwbiwYwBo7rn0g0zsE6wrKhT+4QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1156/2077] mailbox: imx: Forward the timeout/ error in imx_mu_generic_tx()
Date: Tue, 21 Jul 2026 17:13:49 +0200
Message-ID: <20260721152620.087491884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 246a9a9e395206..0028073be4a717 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -227,6 +227,7 @@ static int imx_mu_generic_tx(struct imx_mu_priv *priv,
 	u32 val;
 	int ret, count;
 
+	ret = 0;
 	switch (cp->type) {
 	case IMX_MU_TYPE_TX:
 		imx_mu_write(priv, *arg, priv->dcfg->xTR + cp->idx * 4);
@@ -259,7 +260,7 @@ static int imx_mu_generic_tx(struct imx_mu_priv *priv,
 		return -EINVAL;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int imx_mu_generic_rx(struct imx_mu_priv *priv,
-- 
2.53.0



