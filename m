Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372471E98F8;
	Wed, 15 Jan 2025 10:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938758; cv=none; b=dZZNG7JTSnwIrLnfMPbMdgCF5npXCD5A/W1LA+d0wSHP3Q9p7AFFhUecJZapqKiaeIHFYEq+8jgzMaYj8ljty8Lg6KLKe9hgqKIcugAfJJWxrtUpEmwvmoFwoEp6FrMnkPvoKy5uRc9Rf7fZLQp41UeoMsqqK2Ks9HAU8wteFCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938758; c=relaxed/simple;
	bh=MmBxG3HpwjxfKYmyXjJyZqB0Dfu9Uezme+uRWnX8mwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MGhId91M1tGlVDkmDSbSQ0lI/q3oWFWXDcpZmcfb2KIarqq5EQqJFnFGvofeBU7HLHUjv63mXnFAZeeAMIhQUmA6+sLrbnNhg3Hj6in5H40EYNw/Ct5CGF56kbxoBQn9lq3f+hbMEyTJlyyGdtG+4X/qgpNhhhQ6TSHK5oVgIaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QliqUipV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QliqUipV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D51BC4CEDF;
	Wed, 15 Jan 2025 10:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938757;
	bh=MmBxG3HpwjxfKYmyXjJyZqB0Dfu9Uezme+uRWnX8mwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QliqUipVUHDHwtE9be2eM73mowmdO34MrdFIv2+O/NVXfifn1ihBhCZG2iiC3muhn
	 +VPt1USkXYAU9BCA5H1qS1MCSh5UdS4artor/TtqhO17Dzu1s1h7+gBc0ujIVWxWCT
	 TPZH9aF6hVaIcaK37lgOEVvP9O5pJ4kCH0LyamA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable <stable@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 089/129] tty: serial: 8250: Fix another runtime PM usage counter underflow
Date: Wed, 15 Jan 2025 11:37:44 +0100
Message-ID: <20250115103557.914512126@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit ed2761958ad77e54791802b07095786150eab844 upstream.

The commit f9b11229b79c ("serial: 8250: Fix PM usage_count for console
handover") fixed one runtime PM usage counter balance problem that
occurs because .dev is not set during univ8250 setup preventing call to
pm_runtime_get_sync(). Later, univ8250_console_exit() will trigger the
runtime PM usage counter underflow as .dev is already set at that time.

Call pm_runtime_get_sync() to balance the RPM usage counter also in
serial8250_register_8250_port() before trying to add the port.

Reported-by: Borislav Petkov (AMD) <bp@alien8.de>
Fixes: bedb404e91bb ("serial: 8250_port: Don't use power management for kernel console")
Cc: stable <stable@kernel.org>
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20241210170120.2231-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1131,6 +1131,9 @@ int serial8250_register_8250_port(const
 			uart->dl_write = up->dl_write;
 
 		if (uart->port.type != PORT_8250_CIR) {
+			if (uart_console_registered(&uart->port))
+				pm_runtime_get_sync(uart->port.dev);
+
 			if (serial8250_isa_config != NULL)
 				serial8250_isa_config(0, &uart->port,
 						&uart->capabilities);


