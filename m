Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2897C4E2F1B;
	Fri,  9 Oct 2026 14:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556842; cv=none; b=N8sFKevsEk/GMjHD5OKTU/qRSdtWzBia/hQdJii+hEu0sy2GtdDfj81T5ekqiCoc6XX7ugjrvg3DpF3AHHgvs5YkwGp5n9Eb9AWf8tqQ3KZ0TNr3dHzJUIKUwsZWHjV/nQuKVCe8v559NlgdRx4F+k7d8hlP16v2w6XZ7bZSpwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556842; c=relaxed/simple;
	bh=nbIJMTCDPfGHCp9shJaqRnY8laRpYkld1dGudnCi2lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHNGcRzHc7kwNM+lHRHsnpHriCbEFbjexa0Vne1yJEoX1KEQz/cLqcqiR2jHaE8PTbmgztOv2VZ0G48uD4BjkwFxmVGFIVwjvNPyxAB3X3Us1Qr95qQJFKSIFzc3tpBLBeVRQ+7wIG0bIukpyPLq5Hq8c5auW7ppEeC4tE6HM64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6wRMgJ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6wRMgJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8749F1F000FF;
	Fri,  9 Oct 2026 14:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556841;
	bh=H2bnkAfOf/2B705j/MnxkQrjcm5MLQjdIcUAio+igcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a6wRMgJ/eUWbPX+CEPJoLOcU+VIKs8w4KeQnTjoM2GIamenVLiIxMMksUdDKt9U75
	 pXa17eQql0H6tAl2D//ISSHN/cZl2Dro1opYCHeR0PyL+ilLlxuM0m2RVAKZ6eRwcW
	 MD6GhCDXfXi6oexF0YRttrjDNYB1qqNUvrIG+zP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marian Rotariu <marian.c.rotariu@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.2 228/428] usb: typec: tipd: dont send GAID when probe fails in APP mode
Date: Fri,  9 Oct 2026 16:09:25 +0200
Message-ID: <20261009140951.121979726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marian Rotariu <marian.c.rotariu@gmail.com>

commit c5df31f10880737d13b75eff42faee7accb9f956 upstream.

When probe fails after the chip was already in APP mode (booted from
EEPROM), the err_reset_controller path unconditionally calls
tps->data->reset(), which for tps25750 sends the GAID 4CC command.
GAID transitions the chip from APP back to PTCH, causing a second
probe attempt that sees PTCH mode and tries to load the firmware from
/lib/firmware, instead of reading the EEPROM as it should.

The err_reset_controller path can be triggered by -EPROBE_DEFER from
the probe sequence. GAID should only be sent when the controller
actually loaded firmware at probe time.

The abnormal behavior was seen on a tps25751d that has an EEPROM
connected to it.

Fixes: d49f90822015 ("usb: typec: tipd: add init and reset functions to tipd_data")
Cc: stable <stable@kernel.org>
Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260806085302.1307606-1-marian.c.rotariu@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -1752,6 +1752,7 @@ static int tps6598x_probe(struct i2c_cli
 	const struct tipd_data *data;
 	struct tps6598x *tps;
 	struct fwnode_handle *fwnode;
+	bool patch_loaded = false;
 	u32 status;
 	u32 vid;
 	int ret;
@@ -1804,6 +1805,7 @@ static int tps6598x_probe(struct i2c_cli
 		return ret;
 
 	if (ret == TPS_MODE_PTCH) {
+		patch_loaded = true;
 		ret = tps->data->init(tps);
 		if (ret)
 			return ret;
@@ -1892,7 +1894,8 @@ err_clear_mask:
 	tps6598x_write64(tps, TPS_REG_INT_MASK1, 0);
 err_reset_controller:
 	/* Reset PD controller to remove any applied patch */
-	tps->data->reset(tps);
+	if (patch_loaded)
+		tps->data->reset(tps);
 
 	return ret;
 }


