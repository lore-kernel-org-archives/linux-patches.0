Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732D5376BF0;
	Tue,  6 Jan 2026 18:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722405; cv=none; b=aQXCZ0RYEVNNh7KOGWtUa0V5XAnV3ky+lUdaS5weQ7DPDEzOOCL4uUUunOE+Wsxls37+Nmnw4uv1EYt7QB++nr1R3hBKDGBU2qn9XdEQZIiIxmY/M75hbre+xnAtc6JJtqs0rcv7V7zIaMRoIHhUTMvs3O1jfAKr46Px+O+kaSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722405; c=relaxed/simple;
	bh=xeXn8aQlrMZd8s80clJJC8Z+fyxnHA3aXmGK7w0W+RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYPVCezzCtz1X0ac4MtWv01MM+/D0Oyt4iDIJ5wjnEF4CoJN1Ub6uXr5XtsmG0NVTf9APB69z0TgJ20TpWpTIENz02yYBpaB4n3SfHuEYHJwYZX5/gGmak5CfzZqaVFbFPyRS3VR1nCs4XERzN/G05evp2c7H9sbPInCEFZbD+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=km4BPgOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="km4BPgOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B34C16AAE;
	Tue,  6 Jan 2026 18:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722405;
	bh=xeXn8aQlrMZd8s80clJJC8Z+fyxnHA3aXmGK7w0W+RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=km4BPgOwi8MBcKHZLHTe4nf65AZ64khepwfpMER1ETytobGMNaol/Lux+EmAH5RAp
	 O/KWxQSZz7XlCg6IojkRCiNAmCG+fUbUrKKGuYN47a57Yp2jyMhDeeqFBzNzG7zj3B
	 7sOSngsFQmDxYckQrZRdkJGXJS6E31stKJMBGXiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 254/312] net: usb: sr9700: fix incorrect command used to write single register
Date: Tue,  6 Jan 2026 18:05:28 +0100
Message-ID: <20260106170557.037573289@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

commit fa0b198be1c6775bc7804731a43be5d899d19e7a upstream.

This fixes the device failing to initialize with "error reading MAC
address" for me, probably because the incorrect write of NCR_RST to
SR_NCR is not actually resetting the device.

Fixes: c9b37458e95629b1d1171457afdcc1bf1eb7881d ("USB2NET : SR9700 : One chip USB 1.1 USB2NET SR9700Device Driver Support")
Cc: stable@vger.kernel.org
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Link: https://patch.msgid.link/20251221082400.50688-1-enelsonmoore@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/sr9700.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -52,7 +52,7 @@ static int sr_read_reg(struct usbnet *de
 
 static int sr_write_reg(struct usbnet *dev, u8 reg, u8 value)
 {
-	return usbnet_write_cmd(dev, SR_WR_REGS, SR_REQ_WR_REG,
+	return usbnet_write_cmd(dev, SR_WR_REG, SR_REQ_WR_REG,
 				value, reg, NULL, 0);
 }
 
@@ -65,7 +65,7 @@ static void sr_write_async(struct usbnet
 
 static void sr_write_reg_async(struct usbnet *dev, u8 reg, u8 value)
 {
-	usbnet_write_cmd_async(dev, SR_WR_REGS, SR_REQ_WR_REG,
+	usbnet_write_cmd_async(dev, SR_WR_REG, SR_REQ_WR_REG,
 			       value, reg, NULL, 0);
 }
 


