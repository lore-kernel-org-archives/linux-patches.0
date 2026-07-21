Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F3C3B95E0;
	Tue, 21 Jul 2026 20:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667314; cv=none; b=Dn5msqRt+GvRORUGsZFA7XCGvLjixYKYjTOxAr24DtNPHO6R9IwDQ/WuI7qdZcB3pMuBAuDET1vj+r991bp/h1aH/9k2ir8p+kRZrObcY7Qqz+xKHRM4wByvQUOivvBDhH03EEyMv0wwQlF/ysOGFZUb0EdNzsvO/m0rNlUwm2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667314; c=relaxed/simple;
	bh=GZwIHKoDCRn3gRgv+TfVYA5nrz+nmdthSJu1cbdY2qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKMaUfu2LBYOM6MAyOFhQWp+9hp2h5V+6rs+Pdsu5rmzcVMeCvjm3xO0P7DwDzffOzQmKDOf4ASHIkEODOIhicC+Sdr17qax7kQ29pQf6r9VGreTvUaUOEZp04aTORhhxvHE2D3Q6nJRYPR9UiHzXwmVYJ0kdiNXp3naLa2vxVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsn2l/+q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsn2l/+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571381F000E9;
	Tue, 21 Jul 2026 20:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667312;
	bh=lHlu4fCvoxGx3BoGFJd8rFFoP8G6lQ12ldlrUY+i6M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsn2l/+qzozukFtQKk0VeTacFWP/kg9ctNT4WAx7z4tPT2KELa7tC/PjBI5qVDdOE
	 R26IIWoznQPu/NSkOpaUg4e3nLMZmcGATgKMmY81mtJiOkE8seBHQRWjLyhqhtkomo
	 oGROwmp5KcJCalsreZBCx6ORrliPzvEEVHgmP5lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 0970/1266] MIPS: ip22-gio: fix gio device memory leak
Date: Tue, 21 Jul 2026 17:23:27 +0200
Message-ID: <20260721152503.538820059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


