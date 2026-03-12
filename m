Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2AA1F4181;
	Thu, 12 Mar 2026 20:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346529; cv=none; b=ThJzEqk2hlPT3yBmkU1Eh56OHddZfjkY+GEl6zte6Y2rulBRcmmhKCG8BsSyCt9ZuNdET7qdsrYXOYrZY0tCMiDhF/oN99AUPYGoDltbVRnKjHlQZzKZn1cOed0lA+ZyCLmm52PxLOoRZbxB7Yn2TqjhKu+8R14p7m1xkS0W8cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346529; c=relaxed/simple;
	bh=yNFzCaxWCPjaFUkzK1u0YNDMU1p5V1EwjzUpg0rTbOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b405BwMUDEMdBUIn/8RDNg/xVUkicZ9TPv8isdhIRKbVHNpNZ4WNq5XxRYfKKSfEho2/MhtWpNCAYjlJ/592ggwFyUozEOAECdCa5mayebcWkrIbCTzYROzzqjLBwPwADpAXQC/1Bkc/w4I2IZRPMXXFn8Hbc4iani2KW5d4dzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=of6RDWdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="of6RDWdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F013C4CEF7;
	Thu, 12 Mar 2026 20:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346529;
	bh=yNFzCaxWCPjaFUkzK1u0YNDMU1p5V1EwjzUpg0rTbOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=of6RDWdhxB0q3CR9Lb9INEWpIv521tW9MgV03YXNScDVPGJqJkgqnBfV1bP3ClsCV
	 4sixtV3biQX6zwoN/nb/3BgVNfS0FqlRtebkRyd3UJ88YY/UzKcpC0D2dh9W+ja/VZ
	 QTXotdKmHe6OzN52zj0US4e9zKtOzjcZbuurS6sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/265] mailbox: dont protect of_parse_phandle_with_args with con_mutex
Date: Thu, 12 Mar 2026 21:07:33 +0100
Message-ID: <20260312201020.597870434@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 8c71c61fc613657d785a3377b4b34484bd978374 ]

There are no concurrency problems if multiple consumers parse the
phandle, don't gratuiously protect the parsing with the mutex used
for the controllers list.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: fcd7f96c7836 ("mailbox: Prevent out-of-bounds access in fw_mbox_index_xlate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 92c2fb618c8e1..87de408fb068c 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -413,16 +413,15 @@ struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
 		return ERR_PTR(-ENODEV);
 	}
 
-	mutex_lock(&con_mutex);
-
 	ret = of_parse_phandle_with_args(dev->of_node, "mboxes", "#mbox-cells",
 					 index, &spec);
 	if (ret) {
 		dev_dbg(dev, "%s: can't parse \"mboxes\" property\n", __func__);
-		mutex_unlock(&con_mutex);
 		return ERR_PTR(ret);
 	}
 
+	mutex_lock(&con_mutex);
+
 	chan = ERR_PTR(-EPROBE_DEFER);
 	list_for_each_entry(mbox, &mbox_cons, node)
 		if (mbox->dev->of_node == spec.np) {
-- 
2.51.0



