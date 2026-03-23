Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C903BA220;
	Mon, 23 Mar 2026 15:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279407; cv=none; b=mEnlUSsKHcV0ZZXQNY7wRL5NjFZ9WPcQBxCnq7a3lYS4DXlcuvTHB/EgZwxr4o9vT5mo+K40QkQYu3w+CKxYqdmqVRSmyVAM/FYGCyFJt1/x5jmPJiERDdzYD785Ls+ymGlwjpWYw4nsr+6UII1agOIMbDC1V+aGhTBKFJ7N96g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279407; c=relaxed/simple;
	bh=2jV94pvHXSOuYCuL0dG1jhNApS3Izqa6yDKjYZUKFtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fk+/0VF2qv7Y4pRLWmZuTuLtC5qBuPaEupdkAj2K9csG1lRifP7lMBNhJfHvTVtWCJqxRHpl3kEoyYbRCcIPpEEMja6RpXBd7mYAmdtwH5uYF9I/Ny6EQUEVLCV1fMs5bkugxLjMzzPjbKp270FmCgUjDNCYRnvnhU9XLUWXrl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhmg8H7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhmg8H7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795CEC4CEF7;
	Mon, 23 Mar 2026 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279406;
	bh=2jV94pvHXSOuYCuL0dG1jhNApS3Izqa6yDKjYZUKFtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dhmg8H7yBG6d9F7kL8dX4fxy/+3Q4I3aGyuYxglQSS+gXPSF/sSVfxN+GA7zxMZGh
	 7Qhn8YPgYRlk35nQIh72DYbmEsboKSgO7/ULBWCdGw4Vb61DkDmdnLcHYlumx7waaI
	 8OeYJcor0AzMXSvFbPtKQMwjxbHqz8BgFTONhOH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>,
	Johan Hovold <johan@kernel.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 559/567] i2c: cp2615: fix serial string NULL-deref at probe
Date: Mon, 23 Mar 2026 14:47:59 +0100
Message-ID: <20260323134547.864243347@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit aa79f996eb41e95aed85a1bd7f56bcd6a3842008 ]

The cp2615 driver uses the USB device serial string as the i2c adapter
name but does not make sure that the string exists.

Verify that the device has a serial number before accessing it to avoid
triggering a NULL-pointer dereference (e.g. with malicious devices).

Fixes: 4a7695429ead ("i2c: cp2615: add i2c driver for Silicon Labs' CP2615 Digital Audio Bridge")
Cc: stable@vger.kernel.org	# 5.13
Cc: Bence Csókás <bence98@sch.bme.hu>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Bence Csókás <bence98@sch.bme.hu>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260309075016.25612-1-johan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-cp2615.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/i2c/busses/i2c-cp2615.c
+++ b/drivers/i2c/busses/i2c-cp2615.c
@@ -298,6 +298,9 @@ cp2615_i2c_probe(struct usb_interface *u
 	if (!adap)
 		return -ENOMEM;
 
+	if (!usbdev->serial)
+		return -EINVAL;
+
 	strscpy(adap->name, usbdev->serial, sizeof(adap->name));
 	adap->owner = THIS_MODULE;
 	adap->dev.parent = &usbif->dev;


