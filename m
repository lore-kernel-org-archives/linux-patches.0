Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDBBC142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6E2C433C9;
	Mon,  4 Sep 2023 18:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852292;
	bh=xh7FTiBO+JqBg7/IeztxraGmj40UonZHDM2v2P+qZVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvDQXfY5Ap+6ZP3mFugUn8CYcSx7j5f0c8hHN9m7JzBoXak0E5MSmvubC02Ws8E1l
	 EENkXCQaD+llTGJAMhnCTvZJJp2b3IKOH+A0ksV+ZYY2elrPYFXlbql0BXAVLui3wy
	 EZS8L3L5FeS6gjc883GR97wIv+m7swQvhsRul7wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luke Lu <luke.lu@libre.computer>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.5 15/34] usb: dwc3: meson-g12a: do post init to fix broken usb after resumption
Date: Mon,  4 Sep 2023 19:30:02 +0100
Message-ID: <20230904182949.281528840@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>
References: <20230904182948.594404081@linuxfoundation.org>
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

From: Luke Lu <luke.lu@libre.computer>

commit 1fa206bb764f37d2ab4bf671e483153ef0659b34 upstream.

Device connected to usb otg port of GXL-based boards can not be
recognised after resumption, doesn't recover even if disconnect and
reconnect the device. dmesg shows it disconnects during resumption.

[   41.492911] usb 1-2: USB disconnect, device number 3
[   41.499346] usb 1-2: unregistering device
[   41.511939] usb 1-2: unregistering interface 1-2:1.0

Calling usb_post_init() will fix this issue, and it's tested and
verified on libretech's aml-s905x-cc board.

Cc: stable@vger.kernel.org # v5.8+
Fixes: c99993376f72 ("usb: dwc3: Add Amlogic G12A DWC3 glue")
Signed-off-by: Luke Lu <luke.lu@libre.computer>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230809212911.18903-1-luke.lu@libre.computer
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -926,6 +926,12 @@ static int __maybe_unused dwc3_meson_g12
 			return ret;
 	}
 
+	if (priv->drvdata->usb_post_init) {
+		ret = priv->drvdata->usb_post_init(priv);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 


