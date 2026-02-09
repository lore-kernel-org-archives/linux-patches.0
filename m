Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF8C2222B2;
	Mon,  9 Feb 2026 14:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647916; cv=none; b=CFLL8iDQQZ3xfEqOMCnqqJcfPIPzXiuaxIUp5fUaW+CLUqm77R71koWTaz7Kqi8+42EnERILSTw0qfhMnCs9SOqP2SvoiwM2/sBOaUBT6kKP2F8nnpIJaQ/E3OUvmLXRJ0X/5WE9bXPojJ0rIxX+7YZhtOr5pkQD1uL/lWVn1cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647916; c=relaxed/simple;
	bh=YC/jPmGHshhP2Yy2OiOx61yJV5reh1EGI/URdZHiiQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xpm9aBOrCOsmOQzdhBVJOQWUGlQHYoS/28vVgdTBzHTbuhRnfxHjlXMepysMZQfHHxWXPNWk96CjVBMYvquPwEPKeYNMsH+tTj2l5RY1U3OJ+Mw6I6z097GnWnkwQX9EmHf3EQsJRdOv6H/YActNnEHMZJlS4V8K7rPxOxaCccw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+PIvoXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+PIvoXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A037C16AAE;
	Mon,  9 Feb 2026 14:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647916;
	bh=YC/jPmGHshhP2Yy2OiOx61yJV5reh1EGI/URdZHiiQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+PIvoXeU9TT2JAil2jvpbLPWTeEXiiavrTo2vGQkRDnDycAmIo1kzsvPrf0KvXcj
	 l7TZq5XaPdE5F0hL7rzPvuHsP9gOqe5RFjDmH3ZtTRikAWm4UKwFsHYwsK+z/lP143
	 NVw+NLJux+lPVVlQoaE5BRmUcIdnDKD1CLfhoFZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/113] net: usb: sr9700: support devices with virtual driver CD
Date: Mon,  9 Feb 2026 15:23:01 +0100
Message-ID: <20260209142311.363561165@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



