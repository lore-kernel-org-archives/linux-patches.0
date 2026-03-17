Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101AF2116F6;
	Tue, 17 Mar 2026 17:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767638; cv=none; b=UEvcDfGIhIczPUXy/SGONIl2UEAzDkaDDofAmqaHbe6sAHTgQBPFNmg7NAIfent7G/lxy7YhMwbaJGC+XAWRqBJYZ5B201SDONZ39exmwDc/pk0mdedA1SzVy7HNxG8aR/o3YF4C5SfdfE9rkupEkaYKQCntX9JTltDyREeOO+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767638; c=relaxed/simple;
	bh=iRhUBJ/o4IqCR9cRjEq9nbmqhNhdQXqJ/mY09LdQ93s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=du+vJ+rrFVjw1MU49IFPTruiYzzSk0iBTRuk1+YC5iS14UznW4gNEluEC2qcDerGdqyeK6Y9Qtll9lzlvdPzTjz/8HEjEgxO4KAqr/Ze3Jb9JGCDF/CHtSYbN+A9xwt/WelWdqaOEbXqMcIE98DcI6vQjVtF6PvBEz32WcjcrNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+EKRM6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+EKRM6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDA2C4CEF7;
	Tue, 17 Mar 2026 17:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767637;
	bh=iRhUBJ/o4IqCR9cRjEq9nbmqhNhdQXqJ/mY09LdQ93s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+EKRM6gDvKVnpeBMDcsQGQbol6aDi1FIr6dzQJrckIy+OIOUtC5fmWgzTn8XbXd5
	 yqFiKqD1dwwdSsSvduR4tapcdphvJ++VOfCRCfXAs7d+xujec8XQ8HC2G0pzYAfPM/
	 lxnYEnI+eGTXyI2jmPDgqLVxoiAu6sqJjnl0FZbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Vahnenko <vahnenko2003@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 128/333] USB: ezcap401 needs USB_QUIRK_NO_BOS to function on 10gbs usb speed
Date: Tue, 17 Mar 2026 17:32:37 +0100
Message-ID: <20260317163004.111444273@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Vyacheslav Vahnenko <vahnenko2003@gmail.com>

commit d0d9b1f4f5391e6a00cee81d73ed2e8f98446d5f upstream.

Add USB_QUIRK_NO_BOS for ezcap401 capture card, without it dmesg will show
"unable to get BOS descriptor or descriptor too short" and "unable to
read config index 0 descriptor/start: -71" errors and device will not
able to work at full speed at 10gbs

Signed-off-by: Vyacheslav Vahnenko <vahnenko2003@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260313123638.20481-1-vahnenko2003@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -588,6 +588,9 @@ static const struct usb_device_id usb_qu
 	/* Alcor Link AK9563 SC Reader used in 2022 Lenovo ThinkPads */
 	{ USB_DEVICE(0x2ce3, 0x9563), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* ezcap401 - BOS descriptor fetch hangs at SuperSpeed Plus */
+	{ USB_DEVICE(0x32ed, 0x0401), .driver_info = USB_QUIRK_NO_BOS },
+
 	/* DELL USB GEN2 */
 	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
 


