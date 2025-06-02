Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E41290F;
	Mon,  2 Jun 2025 14:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874647; cv=none; b=tIFlwX0MH0b1lVaYtGWUBlJItC1m4lDxjskaWOsFm2+WG7hacVfkjLTtWjDTtm/UHjuUYSaAeMgU0E7EsLelUPzZgIDFu0I7UboraPq/1HdSclAOc0JXuL3GVXSnz7mYJ2uDR0IE6h+OkYcNI3lEKRtRAug4bs0Zwh3YlhS8NfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874647; c=relaxed/simple;
	bh=WQgfgAoj0EDU+hxLDexSV/1XMvNsrmiTru1CYIhlJoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMyejWSAnR7AFnvMAj/6IVbgD0rgIIrgSBes4FxU1g7CJRqXyF0EJeX4WEX3CGsKNuI4iMyKTHMV734QQSbprJTJK/dNeCbu3DaJclqMxYy+kkV8lBu5llaRVlKLk4MjTYBIMx3tItYZt2EqUc+uD0H2N6ZBj07SiewGM6U3z1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EppcpbKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EppcpbKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8C3C4CEEB;
	Mon,  2 Jun 2025 14:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874647;
	bh=WQgfgAoj0EDU+hxLDexSV/1XMvNsrmiTru1CYIhlJoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EppcpbKGeAK6YW03se5Lpz0HrcHxKl1osNFHAuUhP2/DE7j748zIAW9Dh2xlA00+U
	 6f4vP072OeSLBznG+4ThajfHwi2l0mIm7FDbnAthRdlvBgMEhx3kPsL1wLpyB7WQH+
	 Z6G5iM3hG/Aemo8Nd9GdHO/hjW44oBKYphOjx/0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/204] mailbox: use error ret code of of_parse_phandle_with_args()
Date: Mon,  2 Jun 2025 15:47:03 +0200
Message-ID: <20250602134259.198800184@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4229b9b5da98f..6f54501dc7762 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -350,11 +350,12 @@ struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
 
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



