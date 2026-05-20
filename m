Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FE33FADF7;
	Wed, 20 May 2026 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296660; cv=none; b=efaoQRR6rMru9vkRPrLJF9GLV5VSfjQu+SU7O4eVlibfembR7FUtrIF7wN/PXNeQPbyEFOmjbce2iN9+R2tQOEc8hiEkvm7To/tQO0ae+gXv7kcLPMQfCdMAaffzRVRC9WQ8SZcWqUBGZ8/Kt2U1Y/QYG6L6qkbneTnw5eDzEVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296660; c=relaxed/simple;
	bh=DIrDYK4lZk9aCq29THU5qS7ZCCv4Jb1YKnxsRiuh+A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NycaiFNbuN5fHsctpjueq6OMRMLTI5xC/tisexJRg7h4oEk+3N4eE74+FsEFmGIE1spdIVECJ6sLMWeLbCgMKJIY0AZ03+zocg0TH9JtYVebKsSuFuwqlJbyRlmkIAjSAm8qYcKCr/IrWHvFfpSXjsJL9V4axEiYd+LWKnjQt3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bb/Gg/EN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bb/Gg/EN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6C91F000E9;
	Wed, 20 May 2026 17:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296659;
	bh=R2/msuBgbAEtqsTXAfFapTWRiQatrVFtcebs1z5Qf8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bb/Gg/ENfDo/9nmiMoHhlmhD0ReNIEOqp2OSks190fMuX5PFTA2oyxp6Ew3Mq0upv
	 Xo5kULnRYInSO/HJvpo4UUv7VeG/4elU6LW98irki2+LD0YL9yc7VKuxCIZ0/1oqyj
	 XsnNahmRQmUM9xCSfkd9Om+kPPSRYqpLYVnYNx3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0884/1146] mailbox: mailbox-test: handle channel errors consistently
Date: Wed, 20 May 2026 18:18:54 +0200
Message-ID: <20260520162208.245615806@linuxfoundation.org>
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

[ Upstream commit dd9aa1f269000d679f4ec12b32abacfc8d921413 ]

mbox_test_request_channel() returns either an ERR_PTR or NULL. The
callers, however, mostly checked for non-NULL which allows for bogus
code paths when an ERR_PTR is treated like a valid channel. A later
commit tried to fix it in one place but missed the other ones. Because
the ERR_PTR is only used for -ENOMEM once and is converted to
-EPROBE_DEFER anyhow, convert the callee to only return NULL which
simplifies handling a lot and makes it less error prone.

Fixes: 8ea4484d0c2b ("mailbox: Add generic mechanism for testing Mailbox Controllers")
Fixes: 9b63a810c6f9 ("mailbox: mailbox-test: Fix an error check in mbox_test_probe()")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/mailbox-test.c b/drivers/mailbox/mailbox-test.c
index 197cad7b3d401..1ceb58994772a 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -336,7 +336,7 @@ mbox_test_request_channel(struct platform_device *pdev, const char *name)
 
 	client = devm_kzalloc(&pdev->dev, sizeof(*client), GFP_KERNEL);
 	if (!client)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	client->dev		= &pdev->dev;
 	client->rx_callback	= mbox_test_receive_message;
@@ -388,7 +388,7 @@ static int mbox_test_probe(struct platform_device *pdev)
 	tdev->tx_channel = mbox_test_request_channel(pdev, "tx");
 	tdev->rx_channel = mbox_test_request_channel(pdev, "rx");
 
-	if (IS_ERR_OR_NULL(tdev->tx_channel) && IS_ERR_OR_NULL(tdev->rx_channel))
+	if (!tdev->tx_channel && !tdev->rx_channel)
 		return -EPROBE_DEFER;
 
 	/* If Rx is not specified but has Rx MMIO, then Rx = Tx */
-- 
2.53.0



