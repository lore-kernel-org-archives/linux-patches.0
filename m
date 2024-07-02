Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E510A15218A;
	Tue,  2 Jul 2024 17:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940974; cv=none; b=RVW6QNnx5ZrPeOckmdi3cIuZnLQOXuNpAf7YjREsotzkXYwJWcacVjdmfxjxKuyeVbCz9VaI3vY2/mwytgtv2++0HSZ3SMhAKOYiiSQejp79lWqGtcYTzwshGSjTi+RTRekMYLuZ6skWx9wTnBZtz8EhKrpVuunvqpQMAlyQFyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940974; c=relaxed/simple;
	bh=qXKyAPiBLs5W1n8/wERxyLk/DhUjQvlvuILs+Ln+WBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUHPMAkBDmo4b6eKNowM9LQaEZpzw74m83/yTorvnm1nDE6tcrUM+FklKeoaUK2dY9s1fxp19+qWljBSc4DXnvaIXI0WE5OJqCpOWQwEE4sxpxp4pzaMesJ0fuiw/MO/pN+iHq7iFwyN0XkP323kwWqhJE9yxiokyNFHheA6iNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3P36TXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3P36TXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EC7C116B1;
	Tue,  2 Jul 2024 17:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940973;
	bh=qXKyAPiBLs5W1n8/wERxyLk/DhUjQvlvuILs+Ln+WBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3P36TXbxK8unsWLvOrkMJbjv3qy1zf/rSGE81smD6Eogydj0Hh3AIjRGm+K/gRPK
	 hxRzDZxJ04XA6DJcSKjokNwF0UOp0bubNbRugWugnn9zBGJ1AuJ80O3Bt0niyEGsiv
	 jDJFgNnaG33VlX/4/7ltI+VsU/S1fhxJZG9LA2n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	David Lechner <dlechner@baylibre.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/163] counter: ti-eqep: enable clock at probe
Date: Tue,  2 Jul 2024 19:03:25 +0200
Message-ID: <20240702170236.507227732@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 0cf81c73e4c6a4861128a8f27861176ec312af4e ]

The TI eQEP clock is both a functional and interface clock. Since it is
required for the device to function, we should be enabling it at probe.

Up to now, we've just been lucky that the clock was enabled by something
else on the system already.

Fixes: f213729f6796 ("counter: new TI eQEP driver")
Reviewed-by: Judith Mendez <jm@ti.com>
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240621-ti-eqep-enable-clock-v2-1-edd3421b54d4@baylibre.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/ti-eqep.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/counter/ti-eqep.c b/drivers/counter/ti-eqep.c
index b0f24cf3e891d..4d3de4a35801f 100644
--- a/drivers/counter/ti-eqep.c
+++ b/drivers/counter/ti-eqep.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/clk.h>
 #include <linux/counter.h>
 #include <linux/kernel.h>
 #include <linux/mod_devicetable.h>
@@ -376,6 +377,7 @@ static int ti_eqep_probe(struct platform_device *pdev)
 	struct counter_device *counter;
 	struct ti_eqep_cnt *priv;
 	void __iomem *base;
+	struct clk *clk;
 	int err;
 
 	counter = devm_counter_alloc(dev, sizeof(*priv));
@@ -415,6 +417,10 @@ static int ti_eqep_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
 
+	clk = devm_clk_get_enabled(dev, NULL);
+	if (IS_ERR(clk))
+		return dev_err_probe(dev, PTR_ERR(clk), "failed to enable clock\n");
+
 	err = counter_add(counter);
 	if (err < 0) {
 		pm_runtime_put_sync(dev);
-- 
2.43.0



