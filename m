Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFBC43B6EE;
	Tue, 21 Jul 2026 21:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670040; cv=none; b=jzOixz+2lcDGGlR5Bj212w4qHeIuP/iPoabWBa4G1SvqaYpDaptq5prHMY1QFuvYbrP9b6HtGDjNQnIpmYYB4AXdMNzt0R8Z/cyEHnZB1IX6s70DGlGRdenT5cCexrG8drRbV/15F4l6KEX1ElZQShUSjvRAXdOx10WYAFIBcVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670040; c=relaxed/simple;
	bh=1u11nKwo4guGb0RaWIE1IeI6piZHxaDd2WrP+IahmIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHaFIrv0xaprzxgt7UpPYEnOfMJKvQOG16yTF9vRGMxticvnelEoYyOCCCqvLnHahg5AAVQnV/OQlk4cDF+JkSh7SKGcgbYZ2CrcPqdtOYl9RIGxU7GsHyyxZncjpMfYfMMtvnHzzHVFD16wVbyWCWHTwWUU5eFrJMD1GRPGyS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUo1CozQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUo1CozQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE7C1F000E9;
	Tue, 21 Jul 2026 21:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670039;
	bh=Mvey9g3SCH185rvWGJYjfmcIY6hUkpE1a3Wyu00R/U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUo1CozQ/9h7AwBdWJpyH/FepcMlQ6bumE4paAAEuyrZtkc1RiDSg3paUFdBf6Tt5
	 zFBjQhRYVpvu9n1pw9elOHaIO2gj3zx+TM1htlDzkz00y1E+SCoeIHF/vUY67/GN+v
	 vpwcZLR+BII3JabweKIy4nYgu3BC/6Y/IT6f02Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0781/1067] MIPS: ip22-gio: fix gio device memory leak
Date: Tue, 21 Jul 2026 17:23:02 +0200
Message-ID: <20260721152442.040926658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


