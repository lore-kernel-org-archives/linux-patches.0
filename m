Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5CF30EF7E;
	Tue, 21 Jul 2026 19:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663667; cv=none; b=WdAKymvuYzTqvYxK/TF9KrJIYDLR1bKLgu/WVwy72ik/NmyOyM8O2zYeTeml8p3K2Ly8DyJrTSXrh7OUFwnALO5rhNb7Bl5/m0P/Yd72frQb5Dbofx84znrgAF1Y06p2TMqIFVt0DaSEEMIWM/5Lcp9L6Hnp1IXHt5KRzp4MS7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663667; c=relaxed/simple;
	bh=9btxYlRlLtKpDQD/QcnXlby/YM/SjlZjQVw4gwCc7QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UehdjzHGRq8Wonwm30rB0Vc5RrEp1Et4KqbybRDYXtSKG5jNPUC/gv2abQtaTd3scGQhRVSgCEBLDkiPJLnnx7hChPQn1+pbTz8V7bcSbC7rnPS1ksrnYmxZUbzsxgjxpRFIonutlDoB1N3+GALxx3i4lgVzj7ecJquI78ixfeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8Ij+MjQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8Ij+MjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D131F00A3D;
	Tue, 21 Jul 2026 19:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663666;
	bh=9q9LEkpKmHayA2PJL+/ZL13Cr8ezdj4WfHB2vpxPIME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8Ij+MjQ01r3Wz9349xUOxYs/GPlx/eEoqgWDNWR6Unqd2TVZVy91LmROFck/JcVT
	 8Ya0KG0uBncm+erEF5QxnHTSc0LjWA9qpF/mfnZk1llUBt0UBAIO2+BpWEH7/TTwGc
	 1P7t9vYsfAyo3V3TgOzVfbHzzw62kbzOxG7HlFkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 0908/1276] MIPS: ip22-gio: fix gio device memory leak
Date: Tue, 21 Jul 2026 17:22:31 +0200
Message-ID: <20260721152506.354143262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


