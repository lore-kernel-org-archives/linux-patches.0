Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55043FBB5B;
	Wed, 20 May 2026 17:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296663; cv=none; b=Fzg2qi0a/+O7W05GMvGaBKutTzzLdp6i/6nOxIqAPj/0PFPbuHaoXE01Zfw1yhxL4JnQLx+Hc/Bg5iGInf9HifaZyvKKhH2jcLCRWrZFPEMJXXd0Wjg2+faLuNLDd2bqEgh+aJgLU4kHQ/e9nWj4xonK4Zz+bGI53+wC4w8coW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296663; c=relaxed/simple;
	bh=RWrX7nB0vnSCyEfNolrujF9LXbwgOWos7LFrTw2tP5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdqqFWSlNrrlUYhf6td3jy3rUxH7FyMa6bey/7yDcSaDI9bQonPMMY6CM5mmfogI9h/P3H53yR+LVOJdIgr1S0bP3SGaD6hXnImDxkfZ9Jnn/LaMcyfpgwdhYna3AK25TQu1wTqwsrtiOfCm3YFP601GkA36YRGwPLezTUGvH0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLap/QHe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLap/QHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A321F00893;
	Wed, 20 May 2026 17:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296661;
	bh=ZLAczHtZj4Z0vsInxcJZY+MMdWYOjHIDQXg7c2239Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rLap/QHekTZ539JLMsh61WQVIqMWNAgS8rTFb3xFm4+qGiaUkowUTSh9r8Fo+Tu6n
	 JDj31ooI//VAbAUpbx6y0RIdFdALhf0hdVVAtuZ3ztNtep+YW0fpC4Aq8U9q/RmlJ+
	 l1Ong1YBKJUGtehodTO22ExTJsPyOBu09qNUszLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0885/1146] mailbox: mailbox-test: dont free the reused channel
Date: Wed, 20 May 2026 18:18:55 +0200
Message-ID: <20260520162208.267610819@linuxfoundation.org>
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
index 1ceb58994772a..95238edec68ab 100644
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
@@ -435,7 +435,7 @@ static void mbox_test_remove(struct platform_device *pdev)
 
 	if (tdev->tx_channel)
 		mbox_free_channel(tdev->tx_channel);
-	if (tdev->rx_channel)
+	if (tdev->rx_channel && tdev->rx_channel != tdev->tx_channel)
 		mbox_free_channel(tdev->rx_channel);
 }
 
-- 
2.53.0



