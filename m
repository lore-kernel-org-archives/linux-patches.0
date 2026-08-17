Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3079D41F7EE;
	Mon, 17 Aug 2026 13:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975083; cv=none; b=tT0edFTFJtJG1fHJaIpPKVvAnH29I+luuPFMPxfAHLjJ217Ui4NSLv1ifcjqX4S9kSRvJKKxgTOnA2Q8clh5D/pYNjDfIjjtck2xMvtksmYFpxOzVhvmroTDvKzWrI7YN8eTI50bw+mtQR8dNdBVC3ypHLZ15LJXqsbx1Ugmr+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975083; c=relaxed/simple;
	bh=zv4jegNrIChM10jQuBLSjq2O90l9KBO6it/8qm7jtDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RMaxKUP/cRdvOUjFX1CLHdntK5hWAe8zaTokp7Xwx43YgbLxZ0O1Pvqtr5iviI23zf47SPM1p74Bwq0Mojj/uxh7TgGLkECMo7iOjOeVkKPnMYDgum1uSBEco8ia7sk31b/L6PmX9+O7Y7G5ONicHCMi+ixZa2RyNF9SKUOty+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrqUHjge; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrqUHjge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B071F000E9;
	Mon, 17 Aug 2026 13:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975082;
	bh=YQRTAbOXCvnJE+fj4z4ehddB2mutw7QoY1JUHRiP4Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CrqUHjgeX7UTLOh679Z1F/4wWITWdedGW9wE2wZ5CLc/r7AkWqW9R+EYuZHb57rrD
	 6nLqzAHrIWW3l3HF0kjZP37YiMolgXT1bdqFzLKev/CNvXt/Xunwe7OA4c/OI03bXt
	 g/KRE3Xkg+Ra02TzXlcI1+7pkUJH21BPa6xl+gYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Antti Laakso <antti.laakso@linux.intel.com>
Subject: [PATCH 6.18 116/250] usb: misc: usbio: check ibuf_len against rxbuf_len in bulk msg
Date: Mon, 17 Aug 2026 15:31:17 +0200
Message-ID: <20260817132541.311759884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit 7e22c9f79b200672f3e477421b6c9050d8cf70a5 upstream.

ibuf_len is the bulk IN (receive) buffer size, but the EMSGSIZE check
in usbio_bulk_msg() compares it against txbuf_len — the bulk OUT
endpoint size.  Both are taken independently from different endpoints
in usbio_probe(), so the check is wrong when they differ.

Use rxbuf_len for the IN direction.  This matches the buffer that
actually holds the response data.

Fixes: 121a0f839dbb ("usb: misc: Add Intel USBIO bridge driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Tested-by: Antti Laakso <antti.laakso@linux.intel.com>
Link: https://patch.msgid.link/20260722101810.458634-1-yijiangshan@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usbio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/usbio.c b/drivers/usb/misc/usbio.c
index 3c2474dca810..fe093e7760d5 100644
--- a/drivers/usb/misc/usbio.c
+++ b/drivers/usb/misc/usbio.c
@@ -265,7 +265,7 @@ int usbio_bulk_msg(struct auxiliary_device *adev, u8 type, u8 cmd, bool last,
 	lockdep_assert_held(&usbio->bulk_mutex);
 
 	if ((obuf_len > (usbio->txbuf_len - sizeof(*bpkt))) ||
-	    (ibuf_len > (usbio->txbuf_len - sizeof(*bpkt))))
+	    (ibuf_len > (usbio->rxbuf_len - sizeof(*bpkt))))
 		return -EMSGSIZE;
 
 	if (ibuf_len)
-- 
2.55.0



