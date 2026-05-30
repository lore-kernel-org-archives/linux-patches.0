Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40577233952;
	Sat, 30 May 2026 18:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166752; cv=none; b=a2XXSgjsxcFWZ9axfz5Ydd/zTklQ62i8hxRK8LS0IAjLx9pFENnuOxDrfJQ5uODkuxn5acLmUm9E1FFreScjLe+RgJvpQaBEFyaXaTsSvcMP20cXCF4XxKC36z0DvyEsYKhxjdS5ydteUSAWw4AczlZgHAW84L2WWUvb8qjxkJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166752; c=relaxed/simple;
	bh=9o3phrC7WMSwtqoPQXLtu2nQLU2+5d+Lo+D9xqBUQwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCwVFhmwBwW0kCMh/W6weG+JLWcg4+pSa77bUzUINk3EVmXbBOgdOnssiRUxu9yWvOQPnhJcVefSCEOVZk0SgfqRzMhWg3VHITh/bbNuV9g5e5YGL4DkJZ//OP8Nsst15QvC6RaM192ovuw6esj3beo6n7t//LFmBW4aJQ3iejk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDv8ouLH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDv8ouLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFEB1F00893;
	Sat, 30 May 2026 18:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166751;
	bh=Qcm3s7Z7NHyqFkVDKZtcp+sAecVEh10yR7KsEgKs9OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDv8ouLHq6y+XBIM2xTdfET7vnugHjSupRNVn/5gYa08Hd7ej8p0dG+pWFbi7UqIE
	 /ie7DQ5JxpOG8ENeyO4TG0QL37hYmYsCHXeXVvCL9yic26CiZomwsXGr2dqzgzJzcN
	 En0tFnEgKjZs0MoiyDv+xh1Mjl7jq5JHRMDqHI7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 460/589] mailbox: mailbox-test: dont free the reused channel
Date: Sat, 30 May 2026 18:05:41 +0200
Message-ID: <20260530160236.764104771@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



