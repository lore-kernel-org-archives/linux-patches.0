Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9642BCF4C;
	Mon,  9 Feb 2026 14:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648507; cv=none; b=lqItv7181lWSnlQXZzgNg3R/NPtr8Wt1M5r+nvqmRUnhg2HfozDNUD22MlNCSnqhTtwzcpCnQjXm1C0L0nV6ah4n2F2zoIZFeZPDj64kdwWZaae0fvy1clRmv/KlnByCMz8egZTZVG53r16xwgghHMVDGdyxtKPf1BYzHMkbRcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648507; c=relaxed/simple;
	bh=cCLNDg1Gn/J1oOrtQB7+Yh0yD0bubGE7WVDO8EkadQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lr168dwS+pzcJDxCVqA25QEZY/w6ZsDm3izqyS+WZ18SAxdU7BDFI3YJKor7PUmfeCb2JfY2Cy+39FA6m/podH00SGMV9fA1No3QZSUhtcVfe7TfFIzdm5BkxZn9gw+9FGia8tXeF1pwJcYSTgsnmKPRizps36ewpCTdcYsZ1Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnohwvWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnohwvWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E77CC116C6;
	Mon,  9 Feb 2026 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648507;
	bh=cCLNDg1Gn/J1oOrtQB7+Yh0yD0bubGE7WVDO8EkadQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnohwvWgAupVI6zWqSmWycDjpXn1LsvXIJ41CbhkPrrIWPukUEDtDwHkxa4R8DiAT
	 eCkvBb91qFDeWySIYCzgE2FExa1LqPR0FbUJcresNTGGAu42Eq30Wnjj5rBnAWlxsO
	 RDr1aNO7dyZ8qmet/kR3DFl0Q0I7MhYdFhB6p3sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 24/86] net: usb: sr9700: support devices with virtual driver CD
Date: Mon,  9 Feb 2026 15:23:47 +0100
Message-ID: <20260209142305.656941952@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

[ Upstream commit bf4172bd870c3a34d3065cbb39192c22cbd7b18d ]

Some SR9700 devices have an SPI flash chip containing a virtual driver
CD, in which case they appear as a device with two interfaces and
product ID 0x9702. Interface 0 is the driver CD and interface 1 is the
Ethernet device.

Link: https://github.com/name-kurniawan/usb-lan
Link: https://www.draisberghof.de/usb_modeswitch/bb/viewtopic.php?t=2185
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Link: https://patch.msgid.link/20251211062451.139036-1-enelsonmoore@gmail.com
[pabeni@redhat.com: fixes link tags]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/sr9700.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 9587eb98cdb3b..213b4817cfdf6 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -539,6 +539,11 @@ static const struct usb_device_id products[] = {
 		USB_DEVICE(0x0fe6, 0x9700),	/* SR9700 device */
 		.driver_info = (unsigned long)&sr9700_driver_info,
 	},
+	{
+		/* SR9700 with virtual driver CD-ROM - interface 0 is the CD-ROM device */
+		USB_DEVICE_INTERFACE_NUMBER(0x0fe6, 0x9702, 1),
+		.driver_info = (unsigned long)&sr9700_driver_info,
+	},
 	{},			/* END */
 };
 
-- 
2.51.0



