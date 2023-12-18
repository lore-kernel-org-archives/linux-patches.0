Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F7437897;
	Mon, 18 Dec 2023 14:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8e+8EgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23B2C433C7;
	Mon, 18 Dec 2023 14:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908251;
	bh=L4KdS2q/BQKJc2utAD2glC/wSpcsycSc7YM35kTRvcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8e+8EgH4/8owAq9tjgkEGvuYXTiD3gSBD/ekCocmZGnezRxQBtopl7ccRS78oiht
	 yjs1HTrZQzuu4VXaPZ5BajiNleVMT8VzWGtJWnB8ec5IcqLzkE2E/sva/RntRA4/kw
	 FE6Z/FoggN+x0gZaOlNahnfLtlsSWWeG8wdPlzjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/166] HID: mcp2221: Allow IO to start during probe
Date: Mon, 18 Dec 2023 14:51:14 +0100
Message-ID: <20231218135109.860006601@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Hamish Martin <hamish.martin@alliedtelesis.co.nz>

[ Upstream commit 73ce9f1f2741a38f5d27393e627702ae2c46e6f2 ]

During the probe we add an I2C adapter and as soon as we add that adapter
it may be used for a transfer (e.g via the code in i2cdetect()).
Those transfers are not able to complete and time out. This is because the
HID raw_event callback (mcp2221_raw_event) will not be invoked until the
HID device's 'driver_input_lock' is marked up at the completion of the
probe in hid_device_probe(). This starves the driver of the responses it
is waiting for.
In order to allow the I2C transfers to complete while we are still in the
probe, start the IO once we have completed init of the HID device.

This issue seems to have been seen before and a patch was submitted but
it seems it was never accepted. See:
https://lore.kernel.org/all/20221103222714.21566-3-Enrik.Berkhan@inka.de/

Signed-off-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-mcp2221.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index b95f31cf0fa21..aef0785c91cc2 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -1142,6 +1142,8 @@ static int mcp2221_probe(struct hid_device *hdev,
 	if (ret)
 		return ret;
 
+	hid_device_io_start(hdev);
+
 	/* Set I2C bus clock diviser */
 	if (i2c_clk_freq > 400)
 		i2c_clk_freq = 400;
-- 
2.43.0



