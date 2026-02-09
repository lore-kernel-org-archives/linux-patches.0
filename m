Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F07F28725B;
	Mon,  9 Feb 2026 14:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648703; cv=none; b=Pywf05tb3bOAYfc4YtBvfpTctmzDwGMPkvT24A3AE2oda1Qkz/w95+pQGt17ZCl99uAOuMS0SG9cvCEM9ET8p5v9spCA5WPxl6zIuclPU3Prfn0JyfsZADtEgAUC6s1XaWX33GeVDoNzKJ8SdOmNFpqXWyyIOrAbIEhEaUAzJPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648703; c=relaxed/simple;
	bh=4ZYeDHK7M9ePp0qoqV4Q2VF39RQIxScGfAwZ3fk90d8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0WABO0w5UcOqryt6QLpmlS6RP12zRN4QjEapFPnoGdScswGrTXrW3Lf7/5yzG8kMeLRPeugdfzoL80tI+PnFyxba7sgXOTbtw4QSTHgR6LGKlRN+FspGtxrbC9Dp2cCaDS83xfSlApM2Cyvwzp49v8x6lqhCO1f5e1R2vv8EG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQHvA3fS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQHvA3fS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96220C116C6;
	Mon,  9 Feb 2026 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648703;
	bh=4ZYeDHK7M9ePp0qoqV4Q2VF39RQIxScGfAwZ3fk90d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQHvA3fSD5mu3AR7WkrEQN0JmG1N+fSjEzonQAzeeW9ECwQs9rhttfL5T2bovvNj3
	 edhRgWmUxqRXvxi4E6yvnDs/WtCcbyW1O7CxLdlw+LnwC2BySiP8RSStcCCxF1L1IV
	 x+GhzvT0euTnM0NXWffUfaA0jS1+EolIxDNQsq6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/41] net: usb: sr9700: support devices with virtual driver CD
Date: Mon,  9 Feb 2026 15:24:29 +0100
Message-ID: <20260209142257.104860180@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d4f0dfe1175ab..4d860d5bbcd73 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -538,6 +538,11 @@ static const struct usb_device_id products[] = {
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



