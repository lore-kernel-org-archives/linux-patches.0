Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A658943B490;
	Tue, 21 Jul 2026 22:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674264; cv=none; b=r4m++YhXDiyjZk76Y8hsA9he/EPKqQ3vz02oPKiGrzykDRuYghpuqezfr7vEoJj5kYdG1RdD3fQ4RX6WcuZ7DhWwPNJs/Wf0I2/tvejCvG3KCBga1agfgKFbEAqJFruC2l2VlMPPw/KtVXG58z7wTLyVwKZ20zogi+/lku5GZWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674264; c=relaxed/simple;
	bh=BOcTA2aBqVJVdc/8ZWyedsMKG0Ndu18lAqdhx60PFWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHWpUp8FFxxttGgE1d6sSvmlqP7R2upsiNXDNZMFHjfX2QL07S0JxwlROj9bS8RqyKZbRaShKjtGiB5AvK5NFwar31k4IGnw7UvjcJDKSrPEHaz3Guvxbc+bOVmG4ptob3QlIkwHKUlGbDdLporwJw2OrtOASYvYZNZ+2t/s4L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMkRRizW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMkRRizW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F8D1F000E9;
	Tue, 21 Jul 2026 22:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674263;
	bh=9LBbs0x8jK+fDyyrljKws1A06+1Ja/jjHQXAUp/uEnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMkRRizWCv8PTJmIQa1QEHJng71jhK/TVTAECyJAWCjKYsQIC1y+a/xAeS9tUAMpC
	 yLDsGHj9Pe6Q7umaFSOmf90Cb30Mke0OR9TGkqhZAJPUmeMzi0IjZQ8jQtjD+KfJSW
	 HqJP4TUhotZUrpUnRQOcBwymj/jnU50YWxtnymWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 475/699] MIPS: ip22-gio: fix gio device memory leak
Date: Tue, 21 Jul 2026 17:23:54 +0200
Message-ID: <20260721152406.413975040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 7de9a1b45f5a95b58145653c525c8fb80292d9ab upstream.

The gio device release callback was never wired up so gio devices are
not freed when the last reference is dropped.

Fixes: e84de0c61905 ("MIPS: GIO bus support for SGI IP22/28")
Cc: stable@vger.kernel.org	# 3.3
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/sgi-ip22/ip22-gio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mips/sgi-ip22/ip22-gio.c
+++ b/arch/mips/sgi-ip22/ip22-gio.c
@@ -101,6 +101,8 @@ int gio_device_register(struct gio_devic
 {
 	giodev->dev.bus = &gio_bus_type;
 	giodev->dev.parent = &gio_bus;
+	giodev->dev.release = gio_release_dev;
+
 	return device_register(&giodev->dev);
 }
 EXPORT_SYMBOL_GPL(gio_device_register);


