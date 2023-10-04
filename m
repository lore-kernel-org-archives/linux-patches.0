Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FD91DA24
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2R2qwZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E69CC433C7;
	Wed,  4 Oct 2023 18:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444137;
	bh=GkfID3NuDmMQd6zrhZyl+6eUSMPfzGV8Zwipui1W4HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2R2qwZ01IFjfqpQddRVntp38ZnZats1ASdlZzBfpqsnU4xdlT4HL1gvZVOqtMB62
	 g8N6OVAgtArm7Fal57IBUXXKmfmfMen1BQCUf4ysyWBEgV4c+LwvLx5o6IQPt1Gtk9
	 MkEiGyx14WHCzY9XH/n64JF3XMP53NptNrsaDWsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Chris Morgan <macromorgan@hotmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 143/321] power: supply: rk817: Fix node refcount leak
Date: Wed,  4 Oct 2023 19:54:48 +0200
Message-ID: <20231004175235.870477367@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit 488ef44c068e79752dba8eda0b75f524f111a695 ]

Dan Carpenter reports that the Smatch static checker warning has found
that there is another refcount leak in the probe function. While
of_node_put() was added in one of the return paths, it should in
fact be added for ALL return paths that return an error and at driver
removal time.

Fixes: 54c03bfd094f ("power: supply: Fix refcount leak in rk817_charger_probe")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Closes: https://lore.kernel.org/linux-pm/dc0bb0f8-212d-4be7-be69-becd2a3f9a80@kili.mountain/
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://lore.kernel.org/r/20230920145644.57964-1-macroalpha82@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rk817_charger.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/rk817_charger.c b/drivers/power/supply/rk817_charger.c
index 8328bcea1a299..242e158824222 100644
--- a/drivers/power/supply/rk817_charger.c
+++ b/drivers/power/supply/rk817_charger.c
@@ -1045,6 +1045,13 @@ static void rk817_charging_monitor(struct work_struct *work)
 	queue_delayed_work(system_wq, &charger->work, msecs_to_jiffies(8000));
 }
 
+static void rk817_cleanup_node(void *data)
+{
+	struct device_node *node = data;
+
+	of_node_put(node);
+}
+
 static int rk817_charger_probe(struct platform_device *pdev)
 {
 	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
@@ -1061,11 +1068,13 @@ static int rk817_charger_probe(struct platform_device *pdev)
 	if (!node)
 		return -ENODEV;
 
+	ret = devm_add_action_or_reset(&pdev->dev, rk817_cleanup_node, node);
+	if (ret)
+		return ret;
+
 	charger = devm_kzalloc(&pdev->dev, sizeof(*charger), GFP_KERNEL);
-	if (!charger) {
-		of_node_put(node);
+	if (!charger)
 		return -ENOMEM;
-	}
 
 	charger->rk808 = rk808;
 
-- 
2.40.1



