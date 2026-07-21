Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA16C19049B;
	Tue, 21 Jul 2026 17:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654130; cv=none; b=MCMx02SOf1uHvma4nRW3FygGL0iO7Zg/Zi/Hdch8zQ7jeFYWZG6m4tPiromQmjCxStO7CoLEQp4rA1mK9n589kdhHpX4c2SU3TlrQtETYvMWplCzDGJcJUzDVenRrgmdTFIK0+KwYXLOjTY7VFnf9kwfAlluZo+GFzAWgI0FQS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654130; c=relaxed/simple;
	bh=Yn67U0tVV9iRGKjEHEGok2MgeyOcGICQro1J5FUmiSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNjUZqtdrXLEoOSYx6Tml+k0M5gs7spt5JHftP2OsDFRu/ck2JS2ty+uGgqG9Ux3yFTnya6CBANjQH2uqukuPbQFHFBkrPNqSgJLZH+ON+nWy6UNZ5K2IgHzbSGgU3kSQlFTWNUOAlLCTVx7qWKRB+WLJsgOIxemb/hJ9yLMS6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kdd+svYe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kdd+svYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9141F000E9;
	Tue, 21 Jul 2026 17:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654129;
	bh=HANlpYv86sKQ7rNp7drdjpsrXRyJmI8Oxd6adebxf+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kdd+svYeSZ/2cIE6Bn4WFMQeFr4BfMQuPiUjJA4Vb+ytMq+CT6YjyhLKMMVk2TwhH
	 PWJ4iPym7E7HlFiXNchQzOf7ndWHH4pbPIdwyOQSM0ZiKM4ehoV6xzm+i29YAFjaLj
	 hVEaOZRp0e2N1XK7H/zl0HWCmsbstEEuz4jExUDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 1588/2077] fbdev: tdfxfb: fix potential memory leak in tdfxfb_probe()
Date: Tue, 21 Jul 2026 17:21:01 +0200
Message-ID: <20260721152630.228089982@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit bb019d755366cc3e777a12d4bf457ff289837370 upstream.

In tdfxfb_probe(), the memory allocated for modelist using
fb_videomode_to_modelist() when CONFIG_FB_3DFX_I2C is defined, is not
freed in the subsequent error paths.
Fix that by calling fb_destroy_modelist().

Fixes: 215059d2421f ("tdfxfb: make use of DDC information about connected monitor")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/tdfxfb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -1551,6 +1551,7 @@ static int tdfxfb_probe(struct pci_dev *
 
 out_err_iobase:
 #ifdef CONFIG_FB_3DFX_I2C
+	fb_destroy_modelist(&info->modelist);
 	tdfxfb_delete_i2c_busses(default_par);
 #endif
 	arch_phys_wc_del(default_par->wc_cookie);


