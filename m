Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890502F37;
	Tue,  8 Jul 2025 16:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993647; cv=none; b=VtPyKOJFcfrQ41ZHs7uXe/A/Huh+W+HV1gUIp1VhLmEriMN/vHShJdcH2+23feUdHsvUF9MdapPxpzSrRlcNuKOk4QOPoEoIU8dhSgiTzOn7xkYxGGvRJ4TPUDdvwWeazSNU84pbiEJhrFcqa8ARSLx3TwqD1L40sCdKTsf2AFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993647; c=relaxed/simple;
	bh=doRDC2s0lEWH0P2lAHpIo1gNeEmZQ12wNnsGgYQFMG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eubP9/JGhk/08t1aMc8f7POeRaSj+gctwSavyE22XLN2jx2dwkJMdZbb5XspDEdaQaMSl1IeGADt/uuIpo2dT/GY7nEMQaveJ8kKEc6Miha36N3oAv+mn23NtSurdhgadfpbsCpdAFOVsJUok71Z7hAEJuZHPopDvt4NhOInT/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYPy4A8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYPy4A8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A989C4CEED;
	Tue,  8 Jul 2025 16:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993647;
	bh=doRDC2s0lEWH0P2lAHpIo1gNeEmZQ12wNnsGgYQFMG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYPy4A8VZTVIhUlTpH7Ldq1ueenT0JTgLpOhvKgYtAknkrHPktrvdhwStnYbZj2z5
	 gOqNYKlGHrkV3A2oBnfOwrJFQmgyTJX2bod4mhoJQ8l0W4RUsO3RnriKH0bliE5CH0
	 uGtRi9BgVpMf6dR62fe6jC2YNiqiGi6wSj8h1RSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hongyu Xie <xiehongyu1@kylinos.cn>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.15 146/178] xhci: Disable stream for xHC controller with XHCI_BROKEN_STREAMS
Date: Tue,  8 Jul 2025 18:23:03 +0200
Message-ID: <20250708162240.340958887@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyu Xie <xiehongyu1@kylinos.cn>

commit cd65ee81240e8bc3c3119b46db7f60c80864b90b upstream.

Disable stream for platform xHC controller with broken stream.

Fixes: 14aec589327a6 ("storage: accept some UAS devices if streams are unavailable")
Cc: stable <stable@kernel.org>
Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250627144127.3889714-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -326,7 +326,8 @@ int xhci_plat_probe(struct platform_devi
 	}
 
 	usb3_hcd = xhci_get_usb3_hcd(xhci);
-	if (usb3_hcd && HCC_MAX_PSA(xhci->hcc_params) >= 4)
+	if (usb3_hcd && HCC_MAX_PSA(xhci->hcc_params) >= 4 &&
+	    !(xhci->quirks & XHCI_BROKEN_STREAMS))
 		usb3_hcd->can_do_streams = 1;
 
 	if (xhci->shared_hcd) {


