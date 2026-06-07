Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD432D8378;
	Sun,  7 Jun 2026 10:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829249; cv=none; b=hBI2q6M2fl8WnpAPh1AgSlkWvReEUKhKhKzkqZ4+jebSiAjSwWzQoUQueUDfHPoGV1JgygdZS8RHaVMJxvl7CfUx4z71TZB+3wsEGwvvsP/ul8JO8pVES9xfmx8oZhijTJNIW5YXALxrma9qN1Z2iNMthggxFIUmCKPMDABYklo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829249; c=relaxed/simple;
	bh=c7EJGWsXZM/5TJzbChpcuHATKq2uc86UHdwUercSUj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyEbSWs06+L/1hCZrjxTACKjakkNc/FCEvBF/W+YW8DjM8kpL4P1BNKtrFTzfU2LI4M0YPaKxF2KUgyHFTmcgPfpg1EfOyLHssvC1AXwZdkGLWqMzhZt6euDL2qyYSUPwoeHXWN/X6ibtD8KzXfPGuBGFoR1NRuYYa3YTMa++wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xr0uBYTI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xr0uBYTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CD51F00893;
	Sun,  7 Jun 2026 10:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829248;
	bh=F/ZQSysSnNKXK/78dGsfx76KmmOgVjVRXX+k2YtO/og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xr0uBYTIwW+l8ool9CyddB33CHsG3d0D2jUf/R3Tv1YEVFBFfbnzOmAI4++RhysxK
	 IlKItUwu5WGf7lUHZvdnP/vgIt+S+L6cIOljchknUeD9M1c4B7MQ5M4D5N8D7Vkr2v
	 SmlAJGn1Dxo+pZyuuxUcJMh1R3NqDqkGzwH7ijEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michal Pecio <michal.pecio@gmail.com>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.18 229/315] usb: usbtmc: reject interrupt endpoints with small wMaxPacketSize
Date: Sun,  7 Jun 2026 12:00:16 +0200
Message-ID: <20260607095735.983623585@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Heitor Alves de Siqueira <halves@igalia.com>

commit 121d2f682ba912b1427cddca7cf84840f41cc620 upstream.

The USB488 subclass specification requires interrupt wMaxPacketSize to
be 0x02, unless the device sends vendor-specific notifications.
Endpoints that advertise less than 2 bytes for wMaxPacketSize are
unlikely to work with the current driver, as URBs will not have enough
space for interrupt headers. Considering that any notification URBs will
be ignored by the driver, reject these endpoints early during probe.

Fixes: 041370cce889 ("USB: usbtmc: refactor endpoint retrieval")
Cc: stable <stable@kernel.org>
Suggested-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Link: https://patch.msgid.link/20260505-usbtmc-iin-size-v3-2-a36113f62db7@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -2444,6 +2444,12 @@ static int usbtmc_probe(struct usb_inter
 		data->iin_ep = int_in->bEndpointAddress;
 		data->iin_wMaxPacketSize = usb_endpoint_maxp(int_in);
 		data->iin_interval = int_in->bInterval;
+		/* wMaxPacketSize should be 0x02 or more as per USB488 Table 22 */
+		if (iface_desc->desc.bInterfaceProtocol == 1 &&
+		    data->iin_wMaxPacketSize < 2) {
+			retcode = -EINVAL;
+			goto err_put;
+		}
 		dev_dbg(&intf->dev, "Found Int in endpoint at %u\n",
 				data->iin_ep);
 	}


