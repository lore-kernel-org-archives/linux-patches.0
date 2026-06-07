Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512B94071DD;
	Sun,  7 Jun 2026 10:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829472; cv=none; b=PLOFA45doTmo1Hs4EANELhttm+IVfnPYcukcgZ3jNijQ43UpVYHNjsz0pMUxEtVuAYJobkJIdQDAM8tZrVOb2SLolmqqnDE3ChmgOVAxlVZr0Tc8vdlPMUVVwlCuLUJpGNaTd23KzwyixyNv8ob95O2DNE+n6HWH+c2wNDUSlIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829472; c=relaxed/simple;
	bh=8CGu93ofH+IVKTq+DFWG2ddMQZBBXKNu28OmL0CuPUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQ67RHVJUnXfMdqEk7W2TtuOTTiPcivoWTx5LHyGSXGYAmzTAT26FwR+a69QIwTSDfj4JMrgmPH/a1xtk9LEXuxQtRZykI4FybC8gQdx/bBQoEWQHUmeezZF4NOivmUXcAseQ31XMOD5bU9FnyhO3Sb4FqVB+oMp5xYSuELCjqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZDRZWQM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZDRZWQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24DE1F00893;
	Sun,  7 Jun 2026 10:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829471;
	bh=SvSe193X69eJedBRn55dqALPKw4NfpbDiOaiKyifq7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZDRZWQMg4h7MeAqt+8FZ0cq7tALSOdlVAtvnSIYEqx9HqlHy1vagfCHDWZOMqls3
	 MfAewakLYNclAVPxmhgk8kFJBh0tWp5Z6Hddi9MmgR9W55cw/jeOA/7YT2SdeynsXA
	 D88f9/YorUUVJO4JKsdnDccGZo9mpn1hNVrNWG7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 227/307] USB: serial: keyspan: fix missing indat transfer sanity check
Date: Sun,  7 Jun 2026 12:00:24 +0200
Message-ID: <20260607095736.045962863@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

commit ab8336a7e414f018430aa1af3a46944032f7ff96 upstream.

Add the missing sanity check on the size of usa49wg indat transfers to
avoid parsing stale or uninitialised slab data.

Fixes: 0ca1268e109a ("USB Serial Keyspan: add support for USA-49WG & USA-28XG")
Cc: stable@vger.kernel.org	# 2.6.23
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1187,6 +1187,10 @@ static void usa49wg_indat_callback(struc
 	len = 0;
 
 	while (i < urb->actual_length) {
+		if (urb->actual_length - i < 3) {
+			dev_warn_ratelimited(&urb->dev->dev, "malformed indat packet\n");
+			break;
+		}
 
 		/* Check port number from message */
 		if (data[i] >= serial->num_ports) {


