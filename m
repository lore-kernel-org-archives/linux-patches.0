Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C37E4432EC;
	Tue, 21 Jul 2026 22:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672294; cv=none; b=qxVRICcA1ofIwM2YvdRXh9Eze4Tx9CSiDnf/+ikCFb4UvW6coZjG7U4qBcE2E38H/WFIddtxeeWocdxbsg0r2UyQp5cWrsU8AlXix9ZVW8/5O1VahyC+Go0hs3BfLxrMTp0R59ijeim+Ogwmv1+Fh36fyOqO6iF9wlbPJjDMxoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672294; c=relaxed/simple;
	bh=/V3EOPHJ349Nh8Tr0po5jE0smWD1h0VNYX7Vh+ExG04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2RgJwfXfdGfJf90Og+BW0eVBCoCjoVBUW1S2cEEab7XOdEuhQ/cLBA6brAqS2k3D26URXlt1TCaZA+9/h90RfG+ZySVVJUpgAH4zNTP+qj3+YrR77XSI5R/QXi4ypEaLWYODQXUS92reP9EqLAghGaXsLLBYNAtcZ/+hdxRPbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOyGADIQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOyGADIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5677A1F00ADB;
	Tue, 21 Jul 2026 22:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672290;
	bh=1i9zSKg5NuWDE1rU6chR5TAAnDkq4jzvMo1qIk/FZ7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOyGADIQRZ48vN8xrtm1xxYMfgP9NqlLz8Aj3W+XGAFAjeJNlgwsnU0dfhSzuMh3E
	 8HTbLfqIQQzcLst3Yl2dPRxAi19ZJ6rSRp/IGsza5ci+hP0yyS2HkXDh18I12DVEeb
	 /rCT6USCZHyh41xMsrboP1/xs3ny/Y1WHsRAhx48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 568/843] fbdev: tdfxfb: fix potential memory leak in tdfxfb_probe()
Date: Tue, 21 Jul 2026 17:23:23 +0200
Message-ID: <20260721152418.824385539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1546,6 +1546,7 @@ static int tdfxfb_probe(struct pci_dev *
 
 out_err_iobase:
 #ifdef CONFIG_FB_3DFX_I2C
+	fb_destroy_modelist(&info->modelist);
 	tdfxfb_delete_i2c_busses(default_par);
 #endif
 	arch_phys_wc_del(default_par->wc_cookie);


