Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1573161A3;
	Sat, 30 May 2026 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161797; cv=none; b=hpE3qKMDUFKrONHMobI54hfmm7EDHgxnuMokhiMrdqmxhCBCmTz96Jx1eOc5LMZsTDHrG/3d18UD49qgmiADcJ0bDwefBIENLoy3Ow2tnng7ub3husA8nr5YehZMKBpNteGt5smYpMdLjuwnqQBb1h1kI03Y5vm+Z3M26W15XsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161797; c=relaxed/simple;
	bh=aTmgSLHsZZOARm9h4+GyDG5t7Wa+6Fr3ie4arliefA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gw/JjdPEtvWN1YhyfxsyGloOimXBunpCjQs/ByxZg38ZdiBlWUKz19xRublzV70FH4c+cumlyrlNZqRQ2mgWJOkgWsEYeuikFKNOJMGSaRQSAt982CTAItzTxKaDxT5xHo9SQKHgFSzLvoHFalqVYWNrvvZOAr6Tiw8nM4RloFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3B5CQJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3B5CQJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D87B1F00893;
	Sat, 30 May 2026 17:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161796;
	bh=/OHqN1ZwUoKLtNDRglXhN0v1IbjNG7GW5g7r0Qm1pZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3B5CQJCvZ6pYcIsaCSRtV4ZNgq3lMh9WBT0Fs1y232a7YtZmvNGmhe6DEbZ5WnS0
	 C+h7JPH6i8CEKxBLLSHK9lKLacfybmPReIAKEIZxxqJQhIk50YqwFcICZx4CbOpXuX
	 Kyp7WbsMp5dd4LOUn5Jir01RBrwRoM8VD7z/Mf90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 728/969] mailbox: mailbox-test: dont free the reused channel
Date: Sat, 30 May 2026 18:04:12 +0200
Message-ID: <20260530160320.645913475@linuxfoundation.org>
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
index 1d546cae922ce..247e83af060e3 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -423,7 +423,7 @@ static int mbox_test_probe(struct platform_device *pdev)
 err_free_chans:
 	if (tdev->tx_channel)
 		mbox_free_channel(tdev->tx_channel);
-	if (tdev->rx_channel)
+	if (tdev->rx_channel && tdev->rx_channel != tdev->tx_channel)
 		mbox_free_channel(tdev->rx_channel);
 	return ret;
 }
@@ -436,7 +436,7 @@ static int mbox_test_remove(struct platform_device *pdev)
 
 	if (tdev->tx_channel)
 		mbox_free_channel(tdev->tx_channel);
-	if (tdev->rx_channel)
+	if (tdev->rx_channel && tdev->rx_channel != tdev->tx_channel)
 		mbox_free_channel(tdev->rx_channel);
 
 	return 0;
-- 
2.53.0



