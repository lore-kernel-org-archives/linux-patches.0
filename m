Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA08D3FD147;
	Wed, 20 May 2026 18:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302687; cv=none; b=Zqj/5gvD4cyW916VeT5RwP/CXVJ30XqYdMA8/eYbai2IJH8sLT2ZS9eDeyxdr2zQKJ2a9bn+U6ZJ7oVPGxbyHE8rG9Yu5zGY+Ryx17OaP+ZeQ3Kv6StrWRIOrrFrTMCT/+cjiD1DbHQ4E7eaLpaZK2KJbnfzLgdHjqvBaXfgbFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302687; c=relaxed/simple;
	bh=XoPB1ZLHpiBK3pK0fH4si/8ucsAZy/J6ilcBcRg+XzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGMBb0MmTg+I8xTdWOMl2xG4c30tlpfwHC6p6Kv94M4lkDdZBH0Uok3G1sFB4fH55rn9ANIy9VMbxrR1rcBICXDFrdOGfx+ptMW6pjad1/H+e2loGdPqoYyxjb/f6WG3dfudF7HViYN4K+z0ANfJqCovyUgibB4RW3lm46cDYII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHmBvZIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHmBvZIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CFF1F000E9;
	Wed, 20 May 2026 18:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302685;
	bh=bkhGaHKAbemsgZy/pu0uTYbBf+aTKRQVKYsCFWLQAoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHmBvZIShGTskWV1fbHus6JlKlKvNHInaMRn4o6ibz8FXyZg4F4E9wiyfJ7uXQ81r
	 VfOZkYAJioq7nqvgHPnVSzXpHrn+hUc5a3ca/8WoBw+hQHz0mmDqFm1CcyW/qDxTa7
	 9FXunYAlR9i5inFIbR9ioGtFoCDmncJTe3FH7CB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 362/508] mailbox: mailbox-test: dont free the reused channel
Date: Wed, 20 May 2026 18:23:05 +0200
Message-ID: <20260520162106.474642879@linuxfoundation.org>
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

[ Upstream commit 88ebadbf0deefdaccdab868b44ff70a0a257f473 ]

The RX channel can be aliased to the TX channel if it has a different
MMIO. This special case needs to be handled when freeing the channels
otherwise a double-free occurs.

Fixes: 8ea4484d0c2b ("mailbox: Add generic mechanism for testing Mailbox Controllers")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/mailbox-test.c b/drivers/mailbox/mailbox-test.c
index 6d431a8b275c7..c06d128c44764 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -422,7 +422,7 @@ static int mbox_test_probe(struct platform_device *pdev)
 err_free_chans:
 	if (tdev->tx_channel)
 		mbox_free_channel(tdev->tx_channel);
-	if (tdev->rx_channel)
+	if (tdev->rx_channel && tdev->rx_channel != tdev->tx_channel)
 		mbox_free_channel(tdev->rx_channel);
 	return ret;
 }
@@ -435,7 +435,7 @@ static int mbox_test_remove(struct platform_device *pdev)
 
 	if (tdev->tx_channel)
 		mbox_free_channel(tdev->tx_channel);
-	if (tdev->rx_channel)
+	if (tdev->rx_channel && tdev->rx_channel != tdev->tx_channel)
 		mbox_free_channel(tdev->rx_channel);
 
 	return 0;
-- 
2.53.0



