Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1A1403E88;
	Tue, 21 Jul 2026 17:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654346; cv=none; b=ZbSagfWxWYyjhUb4TnKEnEqfWHZOUz6JEcq9fbT9/21e2EB6SGjraR4MHukUrt00pvqA5xp1nZHtVtpwIZ8kksQpRHoOBcMGt6mccwdu27vFI1wO+CG+XwJj2ZhIsNCbeifk+NakhlHq9Ow1QFTkKEDBpa48xc5seuZIAcrAaZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654346; c=relaxed/simple;
	bh=S8np4x8do1pL5hC9r+TRZH+TswDJaIxUYMYrpQVU49s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaLMUcRsn58dOL0NgnmlUlmlsM3+NZuEe86e3lakgxxrtGKaNE0JTbqdsQeIy+zDc5NSljFbkHkYqt0Vta6ElCYpHovAm3zDIZdN9gTZEE8X+gST/kBCj8GCpoTD72ERZzxOTADUiZ+/KM0JVRHvX9aNeBBWKk9HNKVVvcLosJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeI9OS8r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeI9OS8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BA61F000E9;
	Tue, 21 Jul 2026 17:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654343;
	bh=d4qXHLsJW0Gcjl3b1wW3rdPEZlS8FFSObXwdRwsgu8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IeI9OS8r55GzhEBGtyGOvaDw73tmQT3+aOZfsp15RrtYNI5fNowoXTQZ/DPJB6mbR
	 WWHZucWGcS7AwSEBCyrBIxl7KlDvDZLhsVv9BRC2pbIMiiSkAKPCC1yYaNiCPrZnQr
	 wkGVkZrpg85FN2ObdXPH3fzTkHIpZAG/5acOz/Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.1 1670/2077] MIPS: ip22-gio: fix gio device memory leak
Date: Tue, 21 Jul 2026 17:22:23 +0200
Message-ID: <20260721152632.132815722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


