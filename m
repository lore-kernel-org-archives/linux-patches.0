Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503E92222B2;
	Mon,  9 Feb 2026 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648146; cv=none; b=aUW4TD1Dd3+6jRPily8QICoE9jD5/uaQSFN6c4rmmR4xcadzvojVaoIEwCVTanXe+FuMfQtPd+bmLcgOJH24hD3Kc67qdIhIEDGVcrvvW0dnggWtXEPnu/tIgmfDZavVnFYKuQSvSc81dyQVIfboRnRxh9CHIZ9oL6IxYrx6PLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648146; c=relaxed/simple;
	bh=n8TDFrI6FMBXguhr3CiUl28ukJ7P1EnRKFeT3+QY+Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJwv3ZmCTbbrPD5tdq+4GIC09S9XowcCRatMhRAe6vPNCa6oYtjQhX+RGGfropI/WSw4P5k7GUhcUS1RYiXL8bhFDniSe4k61DpGVq+RehrakU+5F2uuG/rDhAPjt3FWR+B83dqmiGCuT7umvDb4ddlzPfGOZHVb83pma1Agwlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urODWAFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urODWAFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8E8C116C6;
	Mon,  9 Feb 2026 14:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648146;
	bh=n8TDFrI6FMBXguhr3CiUl28ukJ7P1EnRKFeT3+QY+Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urODWAFhZWDEulVVbov/1u41cAcnapceBkAvTniSjUq+axu403xp0P+kptJ/Q0Be4
	 NPjrUAaXZR9esNTUfrdEzA3O50Fqpmiln0QM/g9UPPS6NxJJKD4FjOSSWwnxfKJLyi
	 q2f5i1TyvwNNlh9+ZsrDpvJPd1wH86VTUGokOhDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 20/69] net: usb: sr9700: support devices with virtual driver CD
Date: Mon,  9 Feb 2026 15:23:48 +0100
Message-ID: <20260209142302.655509515@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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



