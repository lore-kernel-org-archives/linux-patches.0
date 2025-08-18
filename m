Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FC0335BA0;
	Mon, 18 Aug 2025 13:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524481; cv=none; b=JF1XU/g23RsQWYkpnrQUdKJaVCii497IvxRxEjENLcWZiXTCSgAgLMJ/iWHUeadlUFPNFRnBXVQcc0FF9DNTjORRQZyulYp8zjSMTccJQG2FmDqFSxW0hMFjNTdBDHJDoVtnBw+hBqJAYPEFuqhChA7+bjBnk0IiDqsi/h6ux8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524481; c=relaxed/simple;
	bh=trB9AkrcUEdNRbN97zhTZn8SczTpHwlLjWUsFjPMVj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gj7k+VM+clScf7ZCuM2mkqoXlQ4yglOHeCjtIReHfUEAnPI49GY380mYkjDo3wGC1O2zTHq7XyZ2pD2d+IcW59s4I4+RCzK4HbtOW4MRO5JQGfoaxx647vA2Um0m+9LvIDOGinrQ91OX+N1TLC0KjdSDP/bwfc5H1CM+t6GR5FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSsohK7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSsohK7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F61EC113D0;
	Mon, 18 Aug 2025 13:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524480;
	bh=trB9AkrcUEdNRbN97zhTZn8SczTpHwlLjWUsFjPMVj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSsohK7yRTJGUP26IgYaRyl28qTbMyTUCvrG64K7vrssVq6cto6EbkzYF418zIryp
	 zQyloesXKuaCO1IekMMVCrpBSOcVZ4j8jWPRniWGNXii11wBqg/OXdNaRvZ9wPqBuB
	 XQEcMySkPkSIUkIUWd5aB0Q9flLE4pSKRyuFdTSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Arnd Bergmann <arnd@kernel.org>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Antonino Daplas <adaplas@gmail.com>,
	Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.15 485/515] fbdev: nvidiafb: add depends on HAS_IOPORT
Date: Mon, 18 Aug 2025 14:47:51 +0200
Message-ID: <20250818124517.094676777@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

commit ecdd7df997fd992f0ec70b788e3b12258008a2bf upstream.

The nvidiafb driver uses inb()/outb() without depending on HAS_IOPORT,
which leads to build errors since kernel v6.13-rc1:
commit 6f043e757445 ("asm-generic/io.h: Remove I/O port accessors
for HAS_IOPORT=n")

Add the HAS_IOPORT dependency to prevent the build errors.

(Found in ARCH=um allmodconfig builds)

drivers/video/fbdev/nvidia/nv_accel.c: In function ‘NVDmaWait’:
include/asm-generic/io.h:596:15: error: call to ‘_outb’ declared with attribute error: outb() requires CONFIG_HAS_IOPORT
  596 | #define _outb _outb

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -660,7 +660,7 @@ config FB_ATMEL
 
 config FB_NVIDIA
 	tristate "nVidia Framebuffer Support"
-	depends on FB && PCI
+	depends on FB && PCI && HAS_IOPORT
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT


