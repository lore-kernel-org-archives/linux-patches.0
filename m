Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAF32F8E96;
	Thu, 25 Jun 2026 13:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393080; cv=none; b=L4KMHsSeNGeEEWdRYkysiZh4e69AefTJxNFEOLAMqaCMg+9cVT8KN7SWkT8DIiuU4Nv/nzZeliU4KlNLFRYcdo+YUd52QraO/XOV1UypsAzL4kpdAA0X7EWaZ7Q7XxFsiK3IWCZT1S9YpzhOk5WXQ8As+o31hQtG+KlYxutM0r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393080; c=relaxed/simple;
	bh=q63a2afqpP8dA68aP2AhqqmrhqYoyvXoR1u2ziBSbNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMeyNPHg+0Gz7T8u4URCIza3RBk/WldT3CyIyA4rfXZXnk5VBmyBEG/rKKfkfbJVR+X861EIoosp4D3mk53h3NuAzwMHF9HRw4kAn1qvSeT+zKKs+T8+NOEoJtsSoSB/msQipDCm/ceLfvUdc50rXyTtituyFQn314I/hwKXcUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyw1z5BC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyw1z5BC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44E91F00A3E;
	Thu, 25 Jun 2026 13:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393077;
	bh=YCNC7gB1tYEfo8teq99H6LupZx/IRR55tTJY8F4K7jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xyw1z5BCRT00fqLWQXG1JywpSS4Dz1+mNC0Fg3qj2fudc5YOWHjbvsqOlx1a88ym8
	 cq/L03MF/t8kalCL+t3dvGxJEN0m0XRszVHqBKBWvIQNCNrDCyi0du0Gg4PFwKnVcC
	 CmjO4JA//2pF7fohGfMWcGYoQHShedRtejXeW4g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.0 37/49] Input: rmi4 - fix type overflow in register counts
Date: Thu, 25 Jun 2026 14:03:49 +0100
Message-ID: <20260625125642.739744392@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 


