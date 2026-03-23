Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB22C2741A0;
	Mon, 23 Mar 2026 14:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277647; cv=none; b=Gh/PPVqpxLgyvPfyRW/nltuBmp5yh5sN8+LdwUF4kmIIcgEAEe628NIGgSoH+xaRkrwUtWNSKoPvAcgNWJnQcfJ+uRHe67d9n0RwhoHSoZ6kymeGHy8WFkYe6PtUMUciol/Mq1OYZkzMF+k/VwweBLdKiyt8iqeoUs0hM71YQ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277647; c=relaxed/simple;
	bh=qOLhFkW5WOqFYJnIfI1t1+vHy+WrqRtUD4M3RUinMi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKbjSJCqppX1UOD08buROqh/nTcWuVyyHgSJ4c7TYI10VrsPgpvS1GAYvY+UfWPLKv3lHS82Z07bg+4x4UoxFaQceK+7XCssU5DDYtaHhgpJU3xbB1VyAIrCRrEp3ZuSC0jROOKq6J/McxEDd6LwksNyUsh49Ekoq5jGJZIBRG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxEhZrey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxEhZrey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460D3C4CEF7;
	Mon, 23 Mar 2026 14:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277646;
	bh=qOLhFkW5WOqFYJnIfI1t1+vHy+WrqRtUD4M3RUinMi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxEhZrey+iqVsUUSbZIZzIzGP4qgYhz2XZ9PzBkgWKzZvU2zLyVtO5IdnBGrEMOw4
	 KZFohpzwuqxUrZLIQIBBKSRqMeL8GSXWOA+Yk1cdheSkZbeNhpcI88McEfM48Eic0G
	 maphUOoxp2NPgRn8MvdSTm9zOsklk1Yv7tH1ODww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/567] mailbox: Use of_property_match_string() instead of open-coding
Date: Mon, 23 Mar 2026 14:39:39 +0100
Message-ID: <20260323134535.276359831@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 263dbd3cc88da7ea7413494eea66418b4f1b2e6d ]

Use of_property_match_string() instead of open-coding the search. With
this, of_get_property() can be removed as there is no need to check for
"mbox-names" presence first.

This is part of a larger effort to remove callers of of_get_property()
and similar functions. of_get_property() leaks the DT property data
pointer which is a problem for dynamically allocated nodes which may
be freed.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: fcd7f96c7836 ("mailbox: Prevent out-of-bounds access in fw_mbox_index_xlate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index cb59b4dbad626..92c2fb618c8e1 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -451,30 +451,20 @@ struct mbox_chan *mbox_request_channel_byname(struct mbox_client *cl,
 					      const char *name)
 {
 	struct device_node *np = cl->dev->of_node;
-	struct property *prop;
-	const char *mbox_name;
-	int index = 0;
+	int index;
 
 	if (!np) {
 		dev_err(cl->dev, "%s() currently only supports DT\n", __func__);
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (!of_get_property(np, "mbox-names", NULL)) {
-		dev_err(cl->dev,
-			"%s() requires an \"mbox-names\" property\n", __func__);
+	index = of_property_match_string(np, "mbox-names", name);
+	if (index < 0) {
+		dev_err(cl->dev, "%s() could not locate channel named \"%s\"\n",
+			__func__, name);
 		return ERR_PTR(-EINVAL);
 	}
-
-	of_property_for_each_string(np, "mbox-names", prop, mbox_name) {
-		if (!strncmp(name, mbox_name, strlen(name)))
-			return mbox_request_channel(cl, index);
-		index++;
-	}
-
-	dev_err(cl->dev, "%s() could not locate channel named \"%s\"\n",
-		__func__, name);
-	return ERR_PTR(-EINVAL);
+	return mbox_request_channel(cl, index);
 }
 EXPORT_SYMBOL_GPL(mbox_request_channel_byname);
 
-- 
2.51.0



