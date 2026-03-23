Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84BA1D63F3;
	Mon, 23 Mar 2026 14:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275565; cv=none; b=p99Lu9xkOdD79zYie35nkWWCcqP6bg0XM15wVMGD66Xvfbz9Iij8uED41OkTeTUxNAmIbHK67AOjmOJfLfYl2zfAdi/50aAANY7KqLzUQVXSXyGVMqiIjW11MmdVn28ZP8FIGmu+OrSvmA+3dV6dyI3TiovhEs1HeSCU1tDSJ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275565; c=relaxed/simple;
	bh=tU6HKLqBcUNmc5pZOdQxtv404A8knkvrTx8mRzfVzgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXDS8p7O9VpSd+CwUbWrSj6OyNoLpJQDATkLlASi6f5A+0rPkWmdv+b39+lbFxa7arHaSXE6n5QE6+1aYpRgMRVWgyec7H7fkH1XvDYIjVZfufRCbiYaZAx18zmR9GkXT0vUxfPxCBi/T7uAUh2Xz4B9z876md1/uu1iK/a+NP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7UJ7jNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7UJ7jNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF7DC4CEF7;
	Mon, 23 Mar 2026 14:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275565;
	bh=tU6HKLqBcUNmc5pZOdQxtv404A8knkvrTx8mRzfVzgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y7UJ7jNzpJ4pM/LZ+Dveg611pNKpQ35LGgpc8fgb7uUKhBzOqYCATR+y6Vz//9oao
	 pXkQDH24YcRIQcUfPvkTd0BY8Rw6fo12nYTgRn24nv4jS6JbOKR642Z/NQ1a2s5wDX
	 t48b7kyYYg2JkrEq4W+dFeHDFzzF2sHKuHT3ITAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.12 143/460] drm/bridge: samsung-dsim: Fix memory leak in error path
Date: Mon, 23 Mar 2026 14:42:19 +0100
Message-ID: <20260323134530.098351215@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 803ec1faf7c1823e6e3b1f2aaa81be18528c9436 upstream.

In samsung_dsim_host_attach(), drm_bridge_add() is called to add the
bridge. However, if samsung_dsim_register_te_irq() or
pdata->host_ops->attach() fails afterwards, the function returns
without removing the bridge, causing a memory leak.

Fix this by adding proper error handling with goto labels to ensure
drm_bridge_remove() is called in all error paths. Also ensure that
samsung_dsim_unregister_te_irq() is called if the attach operation
fails after the TE IRQ has been registered.

samsung_dsim_unregister_te_irq() function is moved without changes
to be before samsung_dsim_host_attach() to avoid forward declaration.

Fixes: e7447128ca4a ("drm: bridge: Generalize Exynos-DSI driver into a Samsung DSIM bridge")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260209184115.10937-1-osama.abdelkader@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/samsung-dsim.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/bridge/samsung-dsim.c
+++ b/drivers/gpu/drm/bridge/samsung-dsim.c
@@ -1697,6 +1697,14 @@ static int samsung_dsim_register_te_irq(
 	return 0;
 }
 
+static void samsung_dsim_unregister_te_irq(struct samsung_dsim *dsi)
+{
+	if (dsi->te_gpio) {
+		free_irq(gpiod_to_irq(dsi->te_gpio), dsi);
+		gpiod_put(dsi->te_gpio);
+	}
+}
+
 static int samsung_dsim_host_attach(struct mipi_dsi_host *host,
 				    struct mipi_dsi_device *device)
 {
@@ -1771,13 +1779,13 @@ of_find_panel_or_bridge:
 	if (!(device->mode_flags & MIPI_DSI_MODE_VIDEO)) {
 		ret = samsung_dsim_register_te_irq(dsi, &device->dev);
 		if (ret)
-			return ret;
+			goto err_remove_bridge;
 	}
 
 	if (pdata->host_ops && pdata->host_ops->attach) {
 		ret = pdata->host_ops->attach(dsi, device);
 		if (ret)
-			return ret;
+			goto err_unregister_te_irq;
 	}
 
 	dsi->lanes = device->lanes;
@@ -1785,14 +1793,13 @@ of_find_panel_or_bridge:
 	dsi->mode_flags = device->mode_flags;
 
 	return 0;
-}
 
-static void samsung_dsim_unregister_te_irq(struct samsung_dsim *dsi)
-{
-	if (dsi->te_gpio) {
-		free_irq(gpiod_to_irq(dsi->te_gpio), dsi);
-		gpiod_put(dsi->te_gpio);
-	}
+err_unregister_te_irq:
+	if (!(device->mode_flags & MIPI_DSI_MODE_VIDEO))
+		samsung_dsim_unregister_te_irq(dsi);
+err_remove_bridge:
+	drm_bridge_remove(&dsi->bridge);
+	return ret;
 }
 
 static int samsung_dsim_host_detach(struct mipi_dsi_host *host,


