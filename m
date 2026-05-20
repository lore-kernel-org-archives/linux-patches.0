Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976A03D88FC;
	Wed, 20 May 2026 18:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301318; cv=none; b=rCsGCosaof2Z9lnADAm06Hi7o8BRpx6hn4bH/H+pqhNh3lqMw0ZD5VO9ELLxsGqMiFtB7chPfjZXhIN6xdBQKhoCDvv2iQjUWEEvVw81rVka46NGqzLQ66S4wg3X8SKpy2S2cAL7eN0EVx4P4S2wbLgUuBg9ihne+C8GvoFoBCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301318; c=relaxed/simple;
	bh=I6ncKxnLxOZdj8TypzcEq+gsKWv/RYETF4qd7Ohkv/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HB0y51apnJFLDGSnl9aWXy/X9TEw+Pc4qbBwiXoX7LPePyOPd8L5whkilSAqm9SMSgjkSBvL8Lsct+TBfQ/FU0UfHtE2epTcmLESMMAIhnGdHxdpCqIRzQdMQ7nf8i4W67Y/bSNHaEf3ATqvv1FUwnLgPsStA6J1czS238l+nVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bh01b+N6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bh01b+N6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071771F000E9;
	Wed, 20 May 2026 18:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301317;
	bh=z5eLktjGi2EElqa6yvN3+zNiGh8OKoQP9CG40ZQ/kSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bh01b+N6wpRHyAnb4fO761ib0uIn4xmvkUkmOi+Qf9gmCffI7mO4mRuGUAz4ou8kg
	 Q2oZiEySJdHJxzbN3Wp3maDivHOYF1XwjkgUtEv0HE1rFhI+XqmBEozeDjfaYXo0oF
	 PqGUsu9i1mfTktyoCdFJ+neZLTq7OHElsgVSnDHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 508/666] mailbox: mailbox-test: dont free the reused channel
Date: Wed, 20 May 2026 18:21:59 +0200
Message-ID: <20260520162122.273677917@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index 2e0ce6c590485..30b0a230a3e28 100644
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



