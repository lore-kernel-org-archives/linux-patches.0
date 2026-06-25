Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EE22D5412;
	Thu, 25 Jun 2026 13:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392871; cv=none; b=safspzcYBaY3uJiRjXH7IpvOOz0tKKew7aC/IyrMS5GnAfgMjCAcocFpjFTKxFJf8bxxxIVbXkYDYysgQ3D+oRdKdUN/Ck/NC3c6iu3I0JnCgW5hYaNvpPj/N1YINpE21WiQizRsKb85LZUBIYDaaqVnRi7UA3p9CXLC5/A5/2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392871; c=relaxed/simple;
	bh=YQ3CKcVMdN2/mOySCIGkTBMKmw08liwx7Yk3Htu7Z3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNPUr9XCjhDj6NpAyXAKPnfGeK2HXWA1Ib1OVLDIFzpd+/trDmqwx8z6vKjmYp7D4AL3lnJnkxCPnLJGO5UXoooxqRFxAaqUBv1EGkZHDZAV0xkD1m+eWOv4yHaxWa5bd41baozBVdt2C/HMO6aRJmfEJT+we4ynDiGnlRjmMPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NknSu0CM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NknSu0CM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8451F000E9;
	Thu, 25 Jun 2026 13:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392869;
	bh=Y674XSuCyucD5dvdzkNBRLuinSqhfcglgbeRwF+Whak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NknSu0CM2Ei+RHFQCsr5wL8CSWwRF3MnT+M2Jd7/o73oc05qC/lZMEncvRTl9uK15
	 cFwgUVvXMVqLm1/6/AEiGsuTK8LQakIgAJinzSxsJKuRoINNwvxoScUwYvbRe+Qz65
	 xPBrz0Ha0qDFo221nae4P+ZLLXkL7GE7jbiwNku8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 48/60] Input: rmi4 - fix type overflow in register counts
Date: Thu, 25 Jun 2026 14:03:33 +0100
Message-ID: <20260625125652.736851146@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit a0a87e441238e07c5f7e3de133ef77a9d4229f01 upstream.

The number of registers in the RMI4 register descriptor is populated
by counting the bits in the presence map using bitmap_weight(). Since
the presence map can contain up to 256 bits (RMI_REG_DESC_PRESENSE_BITS),
storing this count in a u8 can overflow to 0 if all 256 bits are set.

Change the num_registers field in struct rmi_register_descriptor
from u8 to u16 to prevent potential integer overflow and ensure safe
processing of devices reporting large descriptors.

Fixes: 2b6a321da9a2 ("Input: synaptics-rmi4 - add support for Synaptics RMI4 devices")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Link: https://patch.msgid.link/20260505045952.1570713-3-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_driver.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_driver.h
+++ b/drivers/input/rmi4/rmi_driver.h
@@ -65,7 +65,7 @@ struct rmi_register_desc_item {
 struct rmi_register_descriptor {
 	unsigned long struct_size;
 	unsigned long presense_map[BITS_TO_LONGS(RMI_REG_DESC_PRESENSE_BITS)];
-	u8 num_registers;
+	u16 num_registers;
 	struct rmi_register_desc_item *registers;
 };
 


