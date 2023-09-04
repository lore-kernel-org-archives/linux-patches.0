Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F1EC142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB45C433C7;
	Mon,  4 Sep 2023 18:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852621;
	bh=wUZwVMacqXqHcfkOoznSwPEVqjzf7v0cy7R9/qlre+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pa9QABfYSFR21t1qZ3HBE80KBcJasjEJjE8qXd2ynklryPFvC8vCNSf7K+ywFS3Rd
	 +M06N+MH1bnT3ZL1zdClw2uhsDSxrQtsF1zxNrUS5b5LdZMYg59IOmVxglZJSWhWvw
	 jcxgn+O9EL52uw20HnoMxSnInR3RFD50m4ytiHR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luke Lu <luke.lu@libre.computer>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.15 12/28] usb: dwc3: meson-g12a: do post init to fix broken usb after resumption
Date: Mon,  4 Sep 2023 19:30:43 +0100
Message-ID: <20230904182945.753587103@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182945.178705038@linuxfoundation.org>
References: <20230904182945.178705038@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -938,6 +938,12 @@ static int __maybe_unused dwc3_meson_g12
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
 


