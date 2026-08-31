Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1AD47B425;
	Mon, 31 Aug 2026 13:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184552; cv=none; b=ijdixg+77+5ZskgJMdr9Pxv94LnvsZ/wM7BnTZpS6WcE+dLlJDUQTdqDcpOKFVpkTSAPvjOIbF+dZjFqnzgTaHm9mtuHhGotH6/H4XR3CtT1rYsoNOSv5ki0Vmv/j27LuLF7/7bJo8AvPe7RXmY4AyPoZ94dfTSnVu5rZybCbMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184552; c=relaxed/simple;
	bh=pOoi1MgJsxmoMjhDxo6zs9ZSpWwoxoQr15+TVQ6jqKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fI/znuizcW4M+qSVJ3QzWY/naKG3hhD5ay7vupwHHkw38K2GcGoT76dl2hH4AJQkSaryXw5SG4992E/emWyK2SDUAvEDIcJVsXsWE8xpjYVNLjPzdJR0WbjIn1MLVxn6bykmF/IMPrXWtwxvaz1BAREw22NmdJAKFKumNy4tKbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pq4RTdj4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pq4RTdj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E1C1F00A3D;
	Mon, 31 Aug 2026 13:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184550;
	bh=8dz+K2fwCtBZ+yY5cmUuMDgeXENjBzWl/g26IoHWeAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pq4RTdj48Fyr7cGbiRa1xgkwAcWkXXcM+D7bA2HQux7MSCSTjTgJbz2C3ozxPKgQS
	 7LBRG06DmULQ1uMmcJV/d0gw97U9Yhd+1Mw+9RcFXK5dQzIrBQve2Y0Yrs8oshKzDf
	 snXV1I68rp6918CAx6WjMCd83dqr69g4LKFPkvF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 47/91] HID: nintendo: stop device IO before hid_hw_stop on probe failure
Date: Mon, 31 Aug 2026 15:34:35 +0200
Message-ID: <20260831133402.176127479@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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
@@ -2350,34 +2350,34 @@ static int nintendo_hid_probe(struct hid
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
@@ -2385,7 +2385,8 @@ static int nintendo_hid_probe(struct hid
 	hid_dbg(hdev, "probe - success\n");
 	return 0;
 
-err_close:
+err_io_stop:
+	hid_device_io_stop(hdev);
 	hid_hw_close(hdev);
 err_stop:
 	hid_hw_stop(hdev);


