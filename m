Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D44407CDA;
	Tue, 21 Jul 2026 22:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672564; cv=none; b=AaLji/8/YBjzAjr2GT12QxQUUer8HLaj7BMDPm3xda0Da5q29gl8d3ljGu8vbfBVpPeJicgFMiQ1Q/AQZXtOpY8FV5NzUOH/Eh0J/ttxPWJtkkjQIo2xcTykljKvmQ6ZXn7Rh3FGl63ZI/rMeRiMCT5z6mmMwQ0NSTxCtpVGTJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672564; c=relaxed/simple;
	bh=uCLBSLpdZhFBKEiTnBOEDRZPgBApeUesTi8K1SPKFSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GU161JuAUXBaEmiZWveg7rm8gtJN6Fj7rmSW3myDu670nI3yuANu88j5t/cFWe3vb1rXSHl9dhNcyD79/bPM/hiZQV99H10FWNfCqM+YDVlXBB3IUooBS/dV0WqeC3bN07pKAwNvm3kml1CWAr6dsbgavBUwtoep6hJ16JLbJu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRi71Pof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRi71Pof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8141F000E9;
	Tue, 21 Jul 2026 22:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672563;
	bh=hbqP74JLxGV3nWPGfMreguLZxfDkCyahbHjKPvoat0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRi71PofdgjEFeIRwEOd5NejQWWdoeLPR5hr4eHe/9nh6xexzm0mku5rYSCE5XSfI
	 QptzMZ5cUIJZhwsLxSfZ/N1B056JRydinu6+e+1MMasSWpmoEoh01ScxecVWWAqH2h
	 1O/huyr+CAHYkCjdDYuJx5vyFFHZ+d62ra7gO2mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 670/843] Input: ims-pcu - validate control endpoint type
Date: Tue, 21 Jul 2026 17:25:05 +0200
Message-ID: <20260721152421.134566892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit baf56975806534268e24acf9a8abb1c447ce11e9 upstream.

The driver currently assumes that the first endpoint of the control
interface is an interrupt IN endpoint without verifying it. A malicious
device could provide a different endpoint type, which would then be
passed to usb_fill_int_urb(), potentially leading to kernel warnings
or undefined behavior.

Verify that the control endpoint is an interrupt IN endpoint.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1676,6 +1676,12 @@ static int ims_pcu_parse_cdc_data(struct
 		return -ENODEV;
 
 	pcu->ep_ctrl = &alt->endpoint[0].desc;
+	if (!usb_endpoint_is_int_in(pcu->ep_ctrl)) {
+		dev_err(pcu->dev,
+			"Control endpoint is not INTERRUPT IN\n");
+		return -EINVAL;
+	}
+
 	pcu->max_ctrl_size = usb_endpoint_maxp(pcu->ep_ctrl);
 
 	pcu->data_intf = usb_ifnum_to_if(pcu->udev,


