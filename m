Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC1B480DC3;
	Mon, 31 Aug 2026 14:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184813; cv=none; b=LXgIY8z7ZQL1KHIS4jowzIdJA8vqb+sqa8DjO4WUEVVKG6Xj/5lUeimUEZ6lsJJbESdXBnDgw3FkBOb5znNoZkFgLr+ekY62Mkm4UO/pDy283NzmuTizsAIP5WnmPWQ2mVcRlicfH5cRFHBFhQdPjRKbYjEctBlO0Ui9aVZ2IFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184813; c=relaxed/simple;
	bh=woAolU+c9r/l+VCID5VyBwvSgtIKPPUi9ov/RINftXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYF658PPw9xXRkADM6SVXcr7TnraihoLjV3sm7OBOn+DhpdeE0quwJs79IHMfO/Fx72WT1innHfF3jOQXyzP5OLz5tHtU5110koS3gGcEz36o9Z0qImQLKgcnNjJh2DxIKZYe9o4C7pPgWL5BUiHF1yA8XbukQps/m7K/qa/5kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wE+NbGLe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wE+NbGLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7745E1F00A3D;
	Mon, 31 Aug 2026 14:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184812;
	bh=uXuXEV9GACVSzu3OIyNni+Q6O+nTLjZcHru7nWx6i8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wE+NbGLepYi8FB29jmW85XctLkkZFquS+EZSXhlakWbr0ySeT1GWyPhIkVA15j1/r
	 +sQU/L7KRZk2eziBW2sMd3ci9t621aFeyF6kNRjFDLfL7MF5CGaZVq8DMaQFzOaE1p
	 BrE1yC5PKxrpXRcFmdLGIihfjgYcAyrrh5obj/RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 46/92] HID: nintendo: stop device IO before hid_hw_stop on probe failure
Date: Mon, 31 Aug 2026 15:34:44 +0200
Message-ID: <20260831133402.099698484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

[ Upstream commit 1f74d3bff6fe04a64e02ab3661d2e0d554565aa6 ]

nintendo_hid_probe() calls hid_device_io_start() before joycon_init()
and joycon_leds_create().  If either fails, the error path jumps to
err_close which calls hid_hw_close()/hid_hw_stop() without first calling
hid_device_io_stop().

hid_hw_stop() does not stop device IO, so hid_input_report() may still
run and access driver data that is being torn down, resulting in a
use-after-free.

Add an err_io_stop label that calls hid_device_io_stop() before
hid_hw_close(), and point the two post-io_start error paths at it.

Fixes: 2af16c1f846b ("HID: nintendo: add nintendo switch controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[ dropped the absent `err_ida:`/`ida_free()` context and retargeted all five `goto err_close` paths to the new `err_io_stop` label ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-nintendo.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -2273,34 +2273,34 @@ static int nintendo_hid_probe(struct hid
 	ret = joycon_init(hdev);
 	if (ret) {
 		hid_err(hdev, "Failed to initialize controller; ret=%d\n", ret);
-		goto err_close;
+		goto err_io_stop;
 	}
 
 	ret = joycon_read_info(ctlr);
 	if (ret) {
 		hid_err(hdev, "Failed to retrieve controller info; ret=%d\n",
 			ret);
-		goto err_close;
+		goto err_io_stop;
 	}
 
 	/* Initialize the leds */
 	ret = joycon_leds_create(ctlr);
 	if (ret) {
 		hid_err(hdev, "Failed to create leds; ret=%d\n", ret);
-		goto err_close;
+		goto err_io_stop;
 	}
 
 	/* Initialize the battery power supply */
 	ret = joycon_power_supply_create(ctlr);
 	if (ret) {
 		hid_err(hdev, "Failed to create power_supply; ret=%d\n", ret);
-		goto err_close;
+		goto err_io_stop;
 	}
 
 	ret = joycon_input_create(ctlr);
 	if (ret) {
 		hid_err(hdev, "Failed to create input device; ret=%d\n", ret);
-		goto err_close;
+		goto err_io_stop;
 	}
 
 	ctlr->ctlr_state = JOYCON_CTLR_STATE_READ;
@@ -2308,7 +2308,8 @@ static int nintendo_hid_probe(struct hid
 	hid_dbg(hdev, "probe - success\n");
 	return 0;
 
-err_close:
+err_io_stop:
+	hid_device_io_stop(hdev);
 	hid_hw_close(hdev);
 err_stop:
 	hid_hw_stop(hdev);


