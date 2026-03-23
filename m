Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0AA26D4F9;
	Mon, 23 Mar 2026 14:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277432; cv=none; b=NGWlfxn8TZiing4AHB1BEbXAWqB2I2UtXN+ZJS5lV62IGZX5mJvn0ymdFHZYpayRo4016QH4uubFVH2j2G8tsUF/pangiZN8+RbG5nduopw3og0yOwmtr8Ne+DYlZ/s6sq4SvDHQ0eCSTZoQQDKYQFhPuUOgkdt8TKFrFl3Z95w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277432; c=relaxed/simple;
	bh=jKET2WqP4bZQhftaSAJKmZ6yOkrx6jlO+b6Xe3yGla4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TpzgLhzypRJA/ziAc9On0XL/D8dUg6m/eOK20ZXQnjmkVyY9BXGSimhN3jhv79CNjzJuYg5ElC2Bk52Z27+6LDBNUPRxl7Q7owagL/AezZpjsGc2leZHcb+MUQGColhuJ3zkVcCMiiWQx7ipEnRTGIrTCJhbBzeD/tAGAWdkjFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUP89wJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUP89wJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EF0C4CEF7;
	Mon, 23 Mar 2026 14:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277432;
	bh=jKET2WqP4bZQhftaSAJKmZ6yOkrx6jlO+b6Xe3yGla4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUP89wJMln+4Y/AbZyTwANFeA+BslOQ9ayPR/4mqBF/YxVIhCf2qxUIGKGqxy2EAH
	 7UK7Dtpz0L0t1RdbIlpvcLT+ZCJ2WyS0CjDj/fy12EU3pr4PhTLxxd3I3iCzQn/riY
	 rqkW4xG/2N62cYmq2+4zJXwTbwYI3Uu4DR/zZhp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>,
	Johan Hovold <johan@kernel.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 438/460] i2c: cp2615: fix serial string NULL-deref at probe
Date: Mon, 23 Mar 2026 14:47:14 +0100
Message-ID: <20260323134537.329701034@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit aa79f996eb41e95aed85a1bd7f56bcd6a3842008 upstream.

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


