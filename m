Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F9C38B7D2;
	Sat, 12 Sep 2026 10:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207421; cv=none; b=EQU1AJOeISleLXzELoh3Wv4a7V3wh5dW0fjbc60sLkX4k/xtTmc2rWQ7rS1cntLyIuvRoYfLjNeCEWbDEogApbw99wRx8W/QxZEgBeKEQsSgVnCHCI/r/xrRqifiYwG44XlueF6PGclartEsYUhqXgfVDF12G99LxkS8d3BZaaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207421; c=relaxed/simple;
	bh=UkpgvzmaGBIoDuE46SJYLxyop2QmEAbopFRq6FaHla4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWDnlMYOg3JasMxXO0BigLUN1wPyAh+PGojZddlqvHPq14q74etbYtZvMXTrU9w9DXwT7oDQxgoZ/pJAgboBhvbYeXcjDdHQLK4M438lOdJx8MMYscDvBba+jSLOISBBmfTo81yVNEoI9+JHa+WoKnXeOloFthlS38JUya0XBiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rz3SSwBf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rz3SSwBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA77F1F000FF;
	Sat, 12 Sep 2026 10:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207419;
	bh=FpczM3C71pljPFzruJhqfUHLnlPz7oR9y1R8VlzjadQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rz3SSwBfPfdiDd6bxG7dKg+fTK7kaGRR2HI52I3+ibrZArfxTmlmnY0/0eA7PdHBr
	 UCRnbOtbmriYzHUPbHw6/Unu6OxKjVN60BFVKbJXvRfXBKAJrIkNUPHp6VoJ6PP914
	 xD7mvNsWyzUnydmkCCvI7YaQo1MJPz2JApjvit6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0407/1518] remoteproc: qcom: Fix glink->node reference leak in qcom_add_glink_subdev
Date: Sat, 12 Sep 2026 08:42:56 +0200
Message-ID: <20260912065632.665724056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uday Khare <udaykhare77@gmail.com>

[ Upstream commit 44f4911ab8e6f4d69afad5f2571bbd2da421c918 ]

In qcom_add_glink_subdev(), the device node reference acquired via
of_get_child_by_name() is stored in glink->node. If the subsequent
kstrdup_const() allocation for glink->ssr_name fails, the function
returns early without calling of_node_put() on glink->node, leaking
the reference count.

Fix this by adding of_node_put(glink->node) on the error path before
returning.

Fixes: cd9fc8f1b35b ("remoteproc: qcom: Pass ssr_name to glink subdevice")
Signed-off-by: Uday Khare <udaykhare77@gmail.com>
Link: https://lore.kernel.org/r/20260618132054.11010-1-udaykhare77@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_common.c b/drivers/remoteproc/qcom_common.c
index 5bbbe36d09640..506678d1633e1 100644
--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -242,8 +242,10 @@ void qcom_add_glink_subdev(struct rproc *rproc, struct qcom_rproc_glink *glink,
 		return;
 
 	glink->ssr_name = kstrdup_const(ssr_name, GFP_KERNEL);
-	if (!glink->ssr_name)
+	if (!glink->ssr_name) {
+		of_node_put(glink->node);
 		return;
+	}
 
 	glink->dev = dev;
 	glink->subdev.start = glink_subdev_start;
-- 
2.53.0



