Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF731E89C;
	Tue, 27 May 2025 17:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366429; cv=none; b=h1g2ULtoDjOAXSGvfbbbvgLSCzzOqoBFJYtSR3Cp594aEDrlWp1P/sZl/QadxFgEQcgG5wxjZEaeIAifr+lLqADQUE8FelzPtqlRjy1UYd1p9h1foVxCBXFIiHYVudmzmhl7waQiuE3cha53Rs86/1pyXNMSrxF2535HSvRAouo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366429; c=relaxed/simple;
	bh=3GmJJouPVlaZnrFPfN5CmdjgOIi/YfXEZyAWxFl+sdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7JGPzdFl3HwnAPrSWP28wFLOHpeGzRVajZV17uRKz4faUUmSARzYVq8EHb4ZwIA168PgG0EiWOD+17nffJ+qoivg+ZllxcO6afRU4t/OH8+9QWxtVJ8NpliWyoSDdpucRInPNXy7dtbnJyHzCH0h8nqWoiANnj7GXncg0J5QyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYyf1z8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYyf1z8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45E4C4CEE9;
	Tue, 27 May 2025 17:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366429;
	bh=3GmJJouPVlaZnrFPfN5CmdjgOIi/YfXEZyAWxFl+sdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYyf1z8DQzj46Gtb3rRi0lsol5by4PpDg1sma5t73C5n0uvUmH1LINiXFxILd//PN
	 qW6LfB/nQrwIZV3sR2aV6CN5jFk5+MDxWXQRRF3bMC23LAr0rpwXiXNQxV9VWet/ap
	 /NxOH37cCZDgPoIa9tVqIUL0TSoVU5lXA2IfktEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 065/783] mailbox: use error ret code of of_parse_phandle_with_args()
Date: Tue, 27 May 2025 18:17:42 +0200
Message-ID: <20250527162515.770131805@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 24fdd5074b205cfb0ef4cd0751a2d03031455929 ]

In case of error, of_parse_phandle_with_args() returns -EINVAL when the
passed index is negative, or -ENOENT when the index is for an empty
phandle. The mailbox core overwrote the error return code with a less
precise -ENODEV. Use the error returned code from
of_parse_phandle_with_args().

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index d3d26a2c98956..cb174e788a96c 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -415,11 +415,12 @@ struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
 
 	mutex_lock(&con_mutex);
 
-	if (of_parse_phandle_with_args(dev->of_node, "mboxes",
-				       "#mbox-cells", index, &spec)) {
+	ret = of_parse_phandle_with_args(dev->of_node, "mboxes", "#mbox-cells",
+					 index, &spec);
+	if (ret) {
 		dev_dbg(dev, "%s: can't parse \"mboxes\" property\n", __func__);
 		mutex_unlock(&con_mutex);
-		return ERR_PTR(-ENODEV);
+		return ERR_PTR(ret);
 	}
 
 	chan = ERR_PTR(-EPROBE_DEFER);
-- 
2.39.5



